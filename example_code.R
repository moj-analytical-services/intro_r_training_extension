
# Load packages
library(Rs3tools) # Used to help R interact with s3 cloud storage
library(dplyr) # Used for data manipulation
library(tidyr) # Used to help reshape and deal with missing data
library(stringr) # Used for string manipulation
library(readr) # Used to help read in data


x <- 9

# A basic if statement
if (x < 10) {
  print("x is less than 10")
}

x <- 11

if (x < 10) {
  print("x is less than 10")
}

x <- 11

# A basic if...else statement
if (x < 10) {
  print("x is less than 10")
} else {
  print("x is 10 or greater")
}

x <- 5

if (x < 10) {
  print("x is less than 10")
} else if (x == 10) {
  print("x is equal to 10")
} else {
  print("x is greater than 10")
}

x <- c(0, 74, 0, 8, 23, 15, 3, 0, -1, 9)

# Vectorised if...else
dplyr::if_else(x > 0, 1, 0)

# First read and preview the data
offenders <- Rs3tools::s3_path_to_full_df(
  "alpha-r-training/intro-r-training/Offenders_Chicago_Police_Dept_Main.csv"
)
str(offenders)

# Now use mutate to add the new column
offenders <- offenders %>%
  dplyr::mutate(YOUTH_OR_ADULT = dplyr::if_else(AGE < 18, "Youth", "Adult"))

str(offenders)

# Add an age band column
offenders <- offenders %>%
  dplyr::mutate(AGE_BAND = dplyr::case_when(
    AGE < 18 ~ "<18",
    AGE < 30 ~ "18-29",
    AGE < 40 ~ "30-39",
    AGE < 50 ~ "40-49",
    AGE < 60 ~ "50-59",
    AGE >= 60 ~ "60+",
    TRUE ~ "Unknown"
  ))
offenders %>% select(BIRTH_DATE, AGE, AGE_BAND) %>% str(vec.len=6)


# Example of repeating the same piece of code for a set of values
print(1)
print(2)
print(3)
print(4)
print(5)

# A basic for loop
for (i in 1:5) {
  print(i)
}

fruits <- c("strawberry", "apple", "pear", "orange")

# Iterating over a vector
for (fruit in fruits) {
  print(fruit)
}

# Fibonacci for loop example

n <- 10 # Specify what length we want our output vector to be
fibonacci <- vector("numeric", n) # Define an empty numeric vector of length n to populate using the loop

# Set up the first couple of numbers to get the sequence started
fibonacci[1] <- 0 
fibonacci[2] <- 1

# Add the rest of the sequence
for (i in 3:n) {
  fibonacci[i] <- fibonacci[i-1] + fibonacci[i-2]
}

print(fibonacci)

# Iterating over the indices of a vector

fruits <- c("strawberry", "apple", "pear", "orange")

for (i in seq_along(fruits)) {
  # Use paste() to combine two strings together
  print(paste(i, fruits[i]))
}


for (i in 1:10) {
  
  # Exit the for loop if i is greater than 5
  if (i > 5) {
    break
  }
  
  print(i)
}


data <- c(56, 92, NA, 40, 11)

for (i in data) {
  
  # Skip this iteration if i is NA
  if (is.na(i)) {
    next
  }
  
  print(i)
}

# Get dataframe with all available files/folders from an s3 path
files <- Rs3tools::list_files_in_buckets("alpha-r-training", prefix="intro-r-extension/fruit")

# Get a list of csv file names
files <- files %>%
  dplyr::filter(grepl(".csv", path)) %>%
  dplyr::pull(path)

files

# First define an empty list to be filled by the loop
fruit_list <- vector("list", length(files))

# Loop over each file, and add the data to a list
for (i in seq_along(files)) {
  fruit_list[[i]] <- Rs3tools::s3_path_to_full_df(files[i])
}

# Combine the list of dataframes into a single dataframe
fruit <- dplyr::bind_rows(fruit_list)
fruit

# First specify an initial value for the variable used in the while loop
i <- 1

# Now define a while loop
while (i <= 5) { # The loop will continue until the condition i<=5 is met
  print(i)
  i = i + 1 # Set the value of the variable for the next loop iteration
}

# Convert Item column to uppercase
fruit <- fruit %>% dplyr::mutate(Item = toupper(Item))
fruit

fruit_pence <- fruit %>% dplyr::mutate(dplyr::across(where(is.numeric), ~ .x * 100))
fruit_pence

rounded_fruit <- fruit %>% dplyr::mutate(dplyr::across(where(is.numeric), signif, 1))

rounded_fruit

# Set up a vector for Iteration - exercise 1
dates <- c("2020-03-01", "2020-06-01", "2020-09-01", "2020-12-01")


# Check whether or not a single value is missing
x <- 7
is.na(x)

# Check whether or not each element of a vector is missing
x <- c(7, 23, 5, 14, NA, 1, 11, NA)
is.na(x)

# Check if values are NOT missing
!is.na(x)

# Check which rows of a dataframe do not contain any missing values
df <- tibble::tibble(
  "x" = c(0, 1, 2, NA, 4),
  "y" = c(18, NA, 45, 15, 2),
)

complete.cases(df)

# What happens if you sum a vector containing missing values
x <- c(7, 23, 5, 14, NA, 1, 11, NA)
sum(x)

# We can use a function argument to ignore the missing values
x <- c(7, 23, 5, 14, NA, 1, 11, NA)
sum(x, na.rm=TRUE)

# Setting values to NA under a certain condition
x <- c(7, 23, 5, -14, 0, -1, 11, 0)
replace(x, x < 0, NA)

# Replacing NA values with 0 in a vector
x <- c(7, 23, 5, -14, NA, -1, 11,NA)
replace(x, is.na(x), 0)

# Replacing NA values with 0 over a whole dataframe
df <- tibble::tibble(
  "x" = c(0, 1, 2, NA, 4),
  "y" = c(18, NA, 45, 15, 2),
)

df %>% replace(is.na(.), 0)

# Replace NAs in a specific column of a dataframe
offenders_replacena <- offenders %>%
  dplyr::mutate(HEIGHT = as.character(HEIGHT)) %>%
  tidyr::replace_na(list(HEIGHT = "Unknown"))

# Display the dataframe in descending height order, so we can see the 'Unknown' values
offenders_replacena %>% dplyr::arrange(desc(HEIGHT)) %>% str()

# Set up a dataframe to use in the next example
event_dates <- tibble::tibble(
  "event_id" = c(0, 1, 2, 3, 4, 5),
  "date" = c("2016-04-13", "2015-12-29", "2016-06-02", "2017-01-27", "2015-10-21", "2018-03-15"),
  "new_date" = c("2016-08-16", NA, NA, "2017-03-02", NA, "2018-11-20")
)

event_dates

# Fill missing values in one column using corresponding values in another column
event_dates %>%
  dplyr::mutate(new_date = dplyr::coalesce(new_date, date))

# Construct the example dataframe
df <- tidyr::crossing(year = c("2017", "2018", "2019"),
                      quarter = c("Q1", "Q2", "Q3", "Q4")) %>%
      dplyr::mutate(count = sample(length(year)))

df$year[duplicated(df$year)] <- NA # This removes repeated row labels
df

# Fill missing values in a column using the nearest previous non-NA value from the same column
df %>% tidyr::fill(year)

# Remove entire row if it contains a missing value
offenders_nona <- offenders %>% tidyr::drop_na()
str(offenders_nona)

# Remove entire row if it contains missing values in specific columns
offenders_nona <- offenders %>% tidyr::drop_na(HEIGHT, WEIGHT)
str(offenders_nona)

# Set up example dataframe for Missing data - exercise 1
fruit <- tibble::tibble(
  "Item" = c("Orange", "Apple", "Banana", "Lemon", "Pear"),
  "Cost" = c(0.5, 0.4, 0.1, 0.3, NA),
  "Quantity" = c(23, NA, 15, 9, 11)
)

# Set up example dataframe for Missing data - exercise 2
fruit <- tibble::tibble(
  "Item" = c("Orange", "Apple", "Banana", "Lemon", "Pear"),
  "Cost" = c("£0.50", "£0.40", "£0.10", "£0.30", NA),
  "Quantity" = c(23, NA, 15, 9, 11)
)


# read in the fake annual offences data
annual_offences <- 
  Rs3tools::s3_path_to_full_df(
    s3_path = "s3://alpha-r-training/intro-r-extension/annual_offences_fake.csv", 
    colClasses = c("integer", "character", "integer")) %>%
  tibble::tibble()

head(annual_offences)

n_rows <- dim(annual_offences)[1]
n_cols <- dim(annual_offences)[2]
print(paste("The table is", n_rows, "rows by", n_cols, "cols, making", n_rows * n_cols, "cells", sep = " "))

# basic implementation of pivot_wider()
wide_annual_offences <- annual_offences %>%
  tidyr::pivot_wider(
    names_from = 'year',
    values_from = 'count'
  )

head(wide_annual_offences)

n_rows <- dim(wide_annual_offences)[1]
n_cols <- dim(wide_annual_offences)[2]
print(paste("The table is", n_rows, "rows by", n_cols, "cols, making", n_rows * n_cols, "cells", sep = " "))

# adding a prefix to new columns
wide_annual_offences <- annual_offences %>%
  tidyr::pivot_wider(
    names_from = 'year',
    values_from = 'count',
    names_prefix = 'count_'
  )
head(wide_annual_offences)

# replacing NAs with 0s
wide_annual_offences <- annual_offences %>%
  tidyr::pivot_wider(
    names_from = 'year',
    values_from = 'count',
    names_prefix = 'count_',
    values_fill = 0
  )
head(wide_annual_offences)

# Creating a new column from the ones we've created
wide_annual_offences_with_totals <- wide_annual_offences %>%
  dplyr::mutate(
    count_2016_2020 =
      rowSums(dplyr::across(c('count_2016', 'count_2017','count_2018','count_2019','count_2020')))
    )
head(wide_annual_offences_with_totals)

# passing an auxiliary function to `pivot_wider()`
wide_annual_offences_rounded <- annual_offences %>%
  tidyr::pivot_wider(
    names_from = 'year',
    values_from = 'count',
    names_prefix = 'count_',
    values_fill = 0,
    values_fn = list(count = ~round(.x, digits = -1))
  )
head(wide_annual_offences_rounded)

head(wide_annual_offences, 3)
head(annual_offences, 3)

# basic transformation of a table into long format
long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = c('count_2016', 'count_2017', 'count_2018', 'count_2019', 'count_2020')
  )
head(long_annual_offences)

# identifying columns using `starts_with()`
long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('count')
  )
head(long_annual_offences)

# checking if the original table and working table are identical
identical(long_annual_offences, annual_offences)

head(annual_offences, 3)
head(long_annual_offences, 3)

# specifying a name for the `values` column
long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('count'),
    values_to = 'count'
  )
head(long_annual_offences)

identical(long_annual_offences, annual_offences)

# specifying a name for the `names` column
long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('count'),
    values_to = 'count',
    names_to = 'year'
  )
head(long_annual_offences)

identical(long_annual_offences, annual_offences)

# providing substring prefix to remove from column names before using them in our combined `names` column
long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('count'),
    values_to = 'count',
    names_to = 'year',
    names_prefix = 'count_'
  )
head(long_annual_offences)

identical(long_annual_offences, annual_offences)

n_rows <- dim(annual_offences)[1]
n_cols <- dim(annual_offences)[2]
print(paste("The original table is", n_rows, "rows by", n_cols, "cols, making", n_rows * n_cols, "cells", sep = " "))

n_rows <- dim(long_annual_offences)[1]
n_cols <- dim(long_annual_offences)[2]
print(paste("Our working table is", n_rows, "rows by", n_cols, "cols, making", n_rows * n_cols, "cells", sep = " "))


# Filtering out rows with no offences
long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('count'),
    values_to = 'count',
    names_to = 'year',
    names_prefix = 'count_'
  ) %>%
  dplyr::filter(count > 0)

nrow(long_annual_offences) == nrow(annual_offences)

identical(long_annual_offences, annual_offences)

# Use `dplyr` functions to do some final tidying
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

head(annual_offences, 3)
head(long_annual_offences, 3)

identical(long_annual_offences, annual_offences)

# Example data for Reshaping exercises
reoffending_real <- Rs3tools::s3_path_to_full_df(
    s3_path = "s3://alpha-r-training/intro-r-extension/adult_reoff_by_prev_off_number_2.csv")

head(reoffending_real)


# Two options to define a string
string1 <- "a string using double quotes"
string2 <- 'another string using single quotes'

string1
string2

# Some strings containing quotation marks
string3 <- "here is a 'quote' within a string"
string4 <- 'here is a "quote" within a string'

string3
string4

# Example of a character vector
string_vector <- c("a", "vector", "of", "strings")
string_vector

# Find out how many characters are in each string
stringr::str_length(string_vector)

# Combining several strings into one
stringr::str_c("some", "strings", "to", "combine")

# Using custom separator
stringr::str_c("some", "space", "separated", "strings", sep=" ")

# Collapsing a character vector into a single string
vector_to_collapse <- c("some", "strings", "to", "combine")
stringr::str_c(vector_to_collapse, collapse="")

# Combining two character vectors
string_vector1 <- c("A", "B", "C", "D")
string_vector2 <- c("1", "2", "3", "4")
stringr::str_c(string_vector1, string_vector2, sep=" - ")

# Combining and collapsing two character vectors
string_vector1 <- c("A", "B", "C", "D")
string_vector2 <- c("1", "2", "3", "4")
stringr::str_c(string_vector1, string_vector2, sep=" - ", collapse=" ")

# The single string will be 'recycled' to match the length of the vector
stringr::str_c("a", c("b", "c", "d"), sep=" ")

# Combining strings into a single vector with c() 
c("a", c("b", "c", "d"))

try({
# Combining vectors of different lengths
string_vector1 <- c("A", "B", "C")
string_vector2 <- c("1", "2", "3", "4", "5")
stringr::str_c(string_vector1, string_vector2, sep=" - ")
})

# Extracting substrings based on the position within the string
x <- c("First value", "Second value", "Third value")
stringr::str_sub(x, start=1, end=3)

# Negative values for the start and end count backwards from the end of the string
stringr::str_sub(x, start=-5, end=-1)

# Replacing a substring based on the position within the string
stringr::str_sub(x, start=-5, end=-1) <- "item"
x

# Detecting the presence of the word 'blue' in a character vector
colours <- c("scarlet red", "ultramarine blue", "cadmium red", "cobalt blue", "cerulean blue")
stringr::str_detect(colours, "blue")

# Count how many strings contain 'blue'
sum(stringr::str_detect(colours, "blue"))

# Detecting the presence of the word 'red' in a character vector, with an unintended consequence
colours <- c("scarlet red", "ultramarine blue", "cadmium red", "cobalt blue", "weathered")
stringr::str_detect(colours, "red")

# Detect strings containing any letters using regex
colours <- c("1.", "ultramarine blue", "2. cadmium red", "cobalt blue", "-")
stringr::str_detect(colours, "[A-Za-z]")

stringr::str_detect(colours, "[A-Za-z0-9]")

stringr::str_detect(colours, "[^[A-Za-z0-9\\s]]")

# Detecting the presence of the word 'red' in a character vector, with help from regex
colours <- c("scarlet red", "ultramarine blue", "cadmium red", "cobalt blue", "weathered")
stringr::str_detect(colours, "\\bred\\b")

# Extracting substrings based on a matched pattern
colours <- c("scarlet red", "ultramarine blue", "cadmium red", "cobalt blue", "cerulean blue")
stringr::str_extract(colours, "blue")

x <- c("First value", "Second value", "Third value")
# Replace 'value' with 'item'
stringr::str_replace(x, "value", "item")

colours <- c("scarlet...red", "ultramarine.blue", "cadmium_red", "cobalt blue", "cerulean-blue")

# Replace the first character that isn't a letter or number with an underscore
stringr::str_replace(colours, "[^[A-Za-z0-9]]", "_")
# Replace all characters that aren't a letter or number with an underscore
stringr::str_replace_all(colours, "[^[A-Za-z0-9]]", "_")

string <- "The quick brown fox jumps over the lazy dog."





offenders_summary <- offenders %>%
  group_by(REGION, SENTENCE) %>%
  summarise(offender_count = n())
offenders_summary

offenders_summary <- offenders_summary %>%
  tidyr::pivot_wider(names_from = "SENTENCE", values_from = "offender_count")

offenders_summary

offenders_summary <- offenders_summary %>%
  tidyr::pivot_longer(cols = -REGION, names_to = "SENTENCE", values_to = "offender_count")

offenders_summary

# Read data
prosecutions_and_convictions <- Rs3tools::s3_path_to_full_df(
  s3_path = "alpha-r-training/writing-functions-in-r/prosecutions-and-convictions-2018.csv"
)

# Filter for Magistrates Court to extract the prosecutions
prosecutions <- prosecutions_and_convictions %>%
  filter(`Court.Type` == "Magistrates Court")

# Create a time series table
time_series <- prosecutions %>%
  group_by(Year, Offence.Type, Offence.Group) %>%
  summarise(Count = sum(Count)) %>%
  # Select the past 5 years (to avoid the table being too wide)
  filter(Year > max(prosecutions$Year) - 5) %>%
  # Convert from long format to wide format
  tidyr::pivot_wider(names_from = "Year", values_from = "Count", values_fill = c("Count" = 0)) %>%
  arrange(Offence.Type, Offence.Group) %>%
  ungroup()

# This removes repeated row labels, to replicate how this data might be displayed in Excel
time_series$Offence.Type[duplicated(time_series$Offence.Type)] <- NA

time_series

total <- (time_series$`2014` + time_series$`2015` + time_series$`2016` +
          time_series$`2017` + time_series$`2018`)

time_series_with_total <- time_series
time_series_with_total$Total <- total

time_series_with_total

time_series <- time_series %>% tidyr::fill(Offence.Type)
time_series

time_series_long <- time_series %>%
  tidyr::pivot_longer(cols = -c("Offence.Type", "Offence.Group"), names_to = "year", values_to = "count")

time_series_long

totals <- time_series_long %>%
  group_by(Offence.Type, Offence.Group) %>%
  summarise(Total = sum(count))

totals

time_series <- dplyr::left_join(time_series, totals, by=c("Offence.Type", "Offence.Group"))

time_series
