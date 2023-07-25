
# Conditional statements - solution to exercise 1
offenders <- offenders %>%
  dplyr::mutate(COURT_ORDER = dplyr::if_else(SENTENCE == "Court_order", 1, 0))

str(offenders)

# Conditional statements - solution to exercise 2
offenders <- offenders %>%
  dplyr::mutate(PREV_CONVICTIONS_BAND = dplyr::case_when(
    PREV_CONVICTIONS < 5 ~ "Low",
    PREV_CONVICTIONS <= 10 ~ "Medium",
    PREV_CONVICTIONS > 10 ~ "High",
    TRUE ~ "Unknown"
  ))
str(offenders)


# Iteration - solution to exercise 1
dates <- c("2020-03-01", "2020-06-01", "2020-09-01", "2020-12-01")

for (date in dates) {
  print(paste("The current date is", date))
}

# Iteration - solution to exercise 2
for (date in dates) {

  if (date == "2020-06-01") {
    next
  }

  print(paste("The current date is", date))
}


# Missing data - solution to exercise 1
fruit %>% dplyr::filter(!complete.cases(.))

# Missing data - solution to exercise 2
fruit %>% tidyr::replace_na(list(Cost = "Unknown",
                                 Quantity = 0))


# Reshaping - solution to exercise 1

# 1.1 The data table is in wide format
# 1.2 It is more 'human readable'
# 1.3 Convert it to long format

# Reshaping - solution to exercise 2
reoffending_real_long <- reoffending_real %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('total'),
    values_to = 'count',
    names_to = 'quarter',
    names_prefix = 'total_'
  )

head(reoffending_real_long)

# Reshaping - solution to exercise 3
reoffending_real_wide <- reoffending_real_long %>%
  tidyr::pivot_wider(
    names_from = 'quarter',
    values_from = 'count',
    names_prefix = 'count_',
    values_fn = ~ round(.x, -3)
  )

head(reoffending_real_wide)


# Strings - solution to exercise 1
colname_vector <- c("offence_code", stringr::str_c("count_20", c("16", "17", "18", "19", "20")))
colname_vector
colname_string <- stringr::str_c(colname_vector, collapse=", ")
colname_string

# Strings - solution to exercise 2
sum(
  stringr::str_detect(
    string = colnames(tidyr::billboard),
    pattern = "wk"))

# or, breaking it down:
bb_colnames <- colnames(tidyr::billboard)
wk_col <- stringr::str_detect(
  string = bb_colnames,
  pattern = "wk")
sum(wk_col)


# Strings - solution to exercise 3
string <- stringr::str_replace_all(string, " ", "")
string

