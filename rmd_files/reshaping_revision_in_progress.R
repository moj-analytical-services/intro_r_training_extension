# Script to generate fake offence code distributions
library('magrittr')

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


# Start with long format data

annual_offences <- 
  
  Rs3tools::s3_path_to_full_df(
    s3_path = "s3://alpha-r-training/intro-r-extension/annual_offences_fake.csv", 
    colClasses = c("integer", "character", "integer"))

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
      rowSums(dplyr::across(starts_with("count"))))

wide_annual_offences_doubled_2 <- annual_offences %>%
  tidyr::pivot_wider(
    names_from = 'year',
    values_from = 'count',
    names_prefix = 'count_',
    values_fill = 0,
    values_fn = ~ .x * 2
  )

### Now onto 


