# Script to generate fake offence code distributions
library('magrittr')


##### DATA PREP - ONE TIME


# get offence codes
codes <- Rdbtools::read_sql("
  SELECT 
    ho_offence_code
  FROM 
    lookup_offence_v2.offence_group 
  WHERE 
    mojap_latest_record
  ")

codes <- sort(unique(codes$ho_offence_code))

# make a map for scrambling the codes
keymap <- data.frame(
  "offence_ho_code" = codes,
  "offence_ho_code_fake" = sample(codes))

# real offence distibution data
data <- botor::s3_read(
  uri = "s3://alpha-df-reoffending-proxy/pipeline-products/off-codes-for-CP-comparison/2023-07-05/courts-clust-2023-07-05.rds", 
  fun = readRDS)

aggregated <- data %>% 
  dplyr::mutate(outcome_year = lubridate::year(outcome_date)) %>%
  # aggregate and count within specified fields
  dplyr::group_by(outcome_year, offence_ho_code) %>%
  dplyr::summarise('cases' = dplyr::n(), .groups = 'drop')

# join in the new code and delete the old one
agg_cases_scrambled <- aggregated %>%
  dplyr::left_join(keymap) %>%
  dplyr::filter(outcome_year <= 2020, outcome_year >= 2016,
                complete.cases(.)) %>%
  dplyr::transmute(
    "year" = outcome_year,
    "offence_code" = as.character(offence_ho_code_fake),
    "count" = cases) %>%
  dplyr::arrange(year, offence_code)

botor::s3_write(
  x = agg_cases_scrambled,
  fun = write.csv,
  uri = "s3://alpha-r-training/intro-r-extension/annual_offences_fake.csv",
  row.names = FALSE
)

reoffending_real <- 
  Rs3tools::s3_path_to_full_df(
    s3_path = "s3://alpha-r-training/intro-r-extension/adult_reoff_by_prev_off_number.csv") 

quarters <- colnames(reoffending_real)[-1]

new_quarters <- data.frame(quarters) %>%
  dplyr::mutate(year = substr(quarters, 9, 12),
                quarter = dplyr::case_when(
                  grepl("Jan_Mar", quarters) ~ "Q1",
                  grepl("Apr_Jun", quarters) ~ "Q2",
                  grepl("Jul_Sep", quarters) ~ "Q3",
                  grepl("Oct_Dec", quarters) ~ "Q4"
                ),
                colname = paste0("total_", year, "_", quarter)) %>%
  dplyr::pull(colname)

new_colnames <- c("prev_conv_n", new_quarters)

colnames(reoffending_real) <- new_colnames

botor::s3_write(
  x = reoffending_real,
  fun = write.csv,
  uri = "s3://alpha-r-training/intro-r-extension/adult_reoff_by_prev_off_number_2.csv",
  row.names = FALSE
)




##############################################################################





##### pivot_wider




# Start with long format data

annual_offences <- 
  Rs3tools::s3_path_to_full_df(
    s3_path = "s3://alpha-r-training/intro-r-extension/annual_offences_fake.csv", 
    colClasses = c("integer", "character", "integer"))

annual_offences <- tibble::tibble(annual_offences)


head(annual_offences)

# First we do a basic pivot_wider
wide_annual_offences <- annual_offences %>%
  tidyr::pivot_wider(
    names_from = 'year',
    values_from = 'count'
  )

# Any issues?
# 1. column names are not ideal
wide_annual_offences <- annual_offences %>%
  tidyr::pivot_wider(
    names_from = 'year',
    values_from = 'count',
    names_prefix = 'count_'
  )


# 2. missing values would more usefully be zero
wide_annual_offences <- annual_offences %>%
  tidyr::pivot_wider(
    names_from = 'year',
    values_from = 'count',
    names_prefix = 'count_',
    values_fill = 0
  )

# Can do useful mutations easily now
wide_annual_offences_with_totals <- wide_annual_offences %>%
  dplyr::mutate(
    count_2016_2020 =
      rowSums(dplyr::across(dplyr::starts_with("count"))))

wide_annual_offences_rounded <- annual_offences %>%
  tidyr::pivot_wider(
    names_from = 'year',
    values_from = 'count',
    names_prefix = 'count_',
    values_fill = 0,
    values_fn = ~ round(.x, -1)
  )

### pivot_longer

# Sometimes you will need to put data in long format for plotting
# A common situation is when you want to plot using ggplot2

# can we find an example to show why ggplot wants this?

# we use wide_annual_offences from above

long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('count')
  )


# is this the same as what we started with?
identical(long_annual_offences, annual_offences)


# let's compare with original and see what we need to do to get it back to as it was
# 1. It's assigned a default column name of 'value'

long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('count'),
    values_to = 'count'
  )

identical(long_annual_offences, annual_offences)
# 2. It's called year 'name'
long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('count'),
    values_to = 'count',
    names_to = 'year'
  )

identical(long_annual_offences, annual_offences)
# 3. We've got those prefixes to remove
long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('count'),
    values_to = 'count',
    names_to = 'year',
    names_prefix = 'count_'
  )

identical(long_annual_offences, annual_offences)
# 4. We've got zeros
long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('count'),
    values_to = 'count',
    names_to = 'year',
    names_prefix = 'count_'
  ) %>%
  dplyr::filter(count > 0)

identical(long_annual_offences, annual_offences)
# 5. A couple of other things - reorder columns, sort data type, order rows
long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('count'),
    values_to = 'count',
    names_to = 'year',
    names_prefix = 'count_'
  ) %>%
  dplyr::filter(count > 0) %>%
  dplyr::transmute(
    year = as.integer(year),
    offence_code,
    count
  ) %>%
  dplyr::arrange(year, offence_code)

# Success!
identical(long_annual_offences, annual_offences)




#### Exercises

reoffending_real <- 
  Rs3tools::s3_path_to_full_df(
    s3_path = "s3://alpha-r-training/intro-r-extension/adult_reoff_by_prev_off_number_2.csv") 


# pivot_wider

# Put these data in long format
# remove prefixes
# pass the labels 'quarter' and 'count' to the appropriate arguments

reoffending_real_long <- reoffending_real %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('total'),
    values_to = 'count',
    names_to = 'quarter',
    names_prefix = 'total_'
  )



# pivot_wider

# Now, put that table back into wide format
# Add a prefix of your choice to the new columns you create
# round to the nearest thousand

reoffending_real_wide <- reoffending_real_long %>%
  tidyr::pivot_wider(
    names_from = 'quarter',
    values_from = 'count',
    names_prefix = 'count_',
    values_fn = ~ round(.x, -3)
  )
