
# Solution
offenders <- offenders %>%
  dplyr::mutate(COURT_ORDER = dplyr::if_else(SENTENCE == "Court_order", 1, 0))

str(offenders)



# Solution
offenders <- offenders %>%
  dplyr::mutate(PREV_CONVICTIONS_BAND = dplyr::case_when(
    PREV_CONVICTIONS == 0 ~ "0",
    PREV_CONVICTIONS <= 5 ~ "1-5",
    PREV_CONVICTIONS <= 10 ~ "6-10",
    PREV_CONVICTIONS > 10 ~ ">10",
    TRUE ~ "Unknown"
  ))
str(offenders)


# Solution
for (date in dates) {
  print(paste("The current date is", date))
}
