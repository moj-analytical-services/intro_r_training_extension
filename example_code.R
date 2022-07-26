# These variables determine whether or not exercise solutions are included
show_solution <- FALSE # This determines if the solutions are displayed in the readme
purl_solutions <- FALSE # This variable relates to code blocks that are exercise solutions
purl_example_code <- TRUE # This variable relates to code blocks that aren't exercise solutions

# Change botor settings to avoid printing debugger messages to the console
logger::log_threshold('WARN', namespace = 'botor')


# Load packages
library(botor) # Used to help R interact with s3 cloud storage
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
offenders <- botor::s3_read(
  "s3://alpha-r-training/intro-r-training/Offenders_Chicago_Police_Dept_Main.csv", read.csv
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
files <- botor::s3_ls("s3://alpha-r-training/intro-r-extension")

# Get a list of csv file names
files <- files %>%
  dplyr::filter(grepl(".csv", uri)) %>%
  dplyr::pull(uri)

files

# First define an empty list to be filled by the loop
fruit_list <- vector("list", length(files))

# Loop over each file, and add the data to a list
for (i in seq_along(files)) {
  fruit_list[[i]] <- botor::s3_read(files[i], readr::read_csv, show_col_types = FALSE)
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

fruit_pence <- fruit %>% dplyr::mutate(across(where(is.numeric), ~ .x * 100))
fruit_pence

rounded_fruit <- fruit %>% dplyr::mutate(across(where(is.numeric), signif, 1))

rounded_fruit

dates <- c("2020-03-01", "2020-06-01", "2020-09-01", "2020-12-01")


x <- 7
is.na(x)

x <- c(7, 23, 5, 14, NA, 1, 11, NA)
is.na(x)

!is.na(x)

df <- tibble::tibble(
  "x" = c(0, 1, 2, NA, 4),
  "y" = c(18, NA, 45, 15, 2),
)

complete.cases(df)

x <- c(7, 23, 5, 14, NA, 1, 11, NA)
sum(x)

x <- c(7, 23, 5, 14, NA, 1, 11, NA)
sum(x, na.rm=TRUE)

x <- c(7, 23, 5, -14, 0, -1, 11, 0)
replace(x, x < 0, NA)

x <- c(7, 23, 5, -14, NA, -1, 11,NA)
replace(x, is.na(x), 0)

df <- tibble::data_frame(
  "x" = c(0, 1, 2, NA, 4),
  "y" = c(18, NA, 45, 15, 2),
)

df %>% replace(is.na(.), 0)

offenders_replacena <- offenders %>%
  dplyr::mutate(HEIGHT = as.character(HEIGHT)) %>%
  tidyr::replace_na(list(HEIGHT = "Unknown"))

# Display the dataframe in descending height order, so we can see the 'Unknown' values
offenders_replacena %>% dplyr::arrange(desc(HEIGHT)) %>% str()

event_dates <- tibble::tibble(
  "event_id" = c(0, 1, 2, 3, 4, 5),
  "date" = c("2016-04-13", "2015-12-29", "2016-06-02", "2017-01-27", "2015-10-21", "2018-03-15"),
  "new_date" = c("2016-08-16", NA, NA, "2017-03-02", NA, "2018-11-20")
)

event_dates

event_dates %>%
  dplyr::mutate(new_date = dplyr::coalesce(new_date, date))

# Construct the example dataframe
df <- tidyr::crossing(year = c("2017", "2018", "2019"),
                      quarter = c("Q1", "Q2", "Q3", "Q4")) %>%
      dplyr::mutate(count = sample(length(year)))

df$year[duplicated(df$year)] <- NA # This removes repeated row labels
df

df %>% tidyr::fill(year)

offenders_nona <- offenders %>% tidyr::drop_na()
str(offenders_nona)

offenders_nona <- offenders %>% tidyr::drop_na(HEIGHT, WEIGHT)
str(offenders_nona)

fruit <- tibble::tibble(
  "Item" = c("Orange", "Apple", "Banana", "Lemon", "Pear"),
  "Cost" = c(0.5, 0.4, 0.1, 0.3, NA),
  "Quantity" = c(23, NA, 15, 9, 11)
)

fruit <- tibble::tibble(
  "Item" = c("Orange", "Apple", "Banana", "Lemon", "Pear"),
  "Cost" = c("£0.50", "£0.40", "£0.10", "£0.30", NA),
  "Quantity" = c(23, NA, 15, 9, 11)
)


# for more infomation on the data set 
?billboard
# notice the dimensions of the data
#dim(billboard)

#to see the structure of the data
billboard %>% arrange(desc(date.entered)) %>% select(1:6) %>% head()



#starting by mapping a single month 
billboard %>% pivot_longer(cols = c(wk1,wk2, wk3, wk4), names_to = "month1", values_to = "rank") %>% 
  select(1:5, "month1", "rank") %>% head()
#and to see clearly the contents of the new variable
# billboard %>% pivot_longer(cols = c(wk1,wk2, wk3, wk4), names_to = "month1", values_to = "rank") %>%
# .$month1 %>% head()

#mapping all weeks to one varable called "weeks" 
billboard %>% pivot_longer(cols = starts_with("wk"), names_to = "weeks", values_to = "rank") %>% head()

#dataset
anscombe

# using ".value" and "everything()" to select common variables
anscombe %>% pivot_longer(everything(),
   names_to = c(".value", "set"),
   names_pattern = "(.)(.)" )

fish_encounters %>% head(10)

fish_encounters %>% pivot_wider(names_from = station, values_from = seen) %>% head()

fish_encounters %>% pivot_wider(names_from = station, values_from = seen,
  values_fill = list(seen = 0)) %>% head()

#converting into a tibble and rearranging the vars
warpbreaks %>% as_tibble() %>% select(wool,tension, breaks)

warpdata = warpbreaks %>% pivot_wider(names_from = wool, values_from = breaks)

warpbreaks %>%
  pivot_wider(
    names_from = wool,
    values_from = breaks,
    values_fn = list(breaks = mean)
  )

## #the table to use
## table4a
## table4a %>% pivot_longer(1999,2000, names_to = "year",values_to = "value")

## people = tribble(~name, ~key, ~value,
##                  #------------/------/-----,
##                  "Phil Woods", "age",45,
##                  "Phil Woods", "height",185,
##                  "Phil Woods", "age",50,
##                  "Jess Cordero", "age",45,
##                  "Jess Cordero", "height",156,)

## rcj = tribble(~judge, ~male, ~female,
##               "yes", NA, 10,
##               "no", 20, 12)









table3

# separate() automatically detects the separator
table3 %>% separate(rate, into = c("cases", "population"))

# separate() manually  detects the separator
table3 %>% separate(rate, into = c("cases", "population"), sep = "/")

# separate() manually detects the separator and convers the columns into the appropriate data type 
table3 %>% separate(rate, into = c("cases", "population"), sep = "/", convert = TRUE)

table3 %>% extract( col = year, into = c("century","years"), regex = "([0-9]{2})([0-9]{2})")

table3 %>% extract( col = year, into = c("century","decade","year" ), regex = "([0-9]{2})([0-9])([0-9])")

#the reshaped dataset
tab3 = table3 %>% 
  extract( col = year, into = c("century","decade","year" ), regex = "([0-9]{2})([0-9])([0-9])")
#going back to the original dataset - with separator
tab3 %>% unite(new ,century, decade, year)

#going back to the original dataset - with no separators
tab3 %>% unite(new ,century, decade, year, sep = "")

## tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
##   separate(x, c("one", "two", "three"))
## tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
##   separate(x, c("one", "two", "three"))


string1 = "a string using double quotes"
is.character(string1)

string2 = 'another string using single quotes'
is.character(string2)

# a string containing quotes
string3 = "this is a 'string' within a string"

# notice how the output changes when implementing the following code
string4 = 'this is a "string" within a string'



string5 = "escaping a reserved character like \" quotes "
# to see how the result would apear in text
writeLines(string5)
string6 = "escaping a backslash \\ "
# to see how the result would apear in text
writeLines(string6)

# outputting non-English characters
string7 = "\u00b5" 
string7

s8 = c("a", "vector", "of", "strings")
s8

# finding out how many characters in a char vector
str_length(c(s8, NA))

# using custom separator
str_c("an", "str_c vector", "with", "space", "character", "separating each entry", sep = " ")
# the colapse option
str_c("an", "str_c vector", "with", "space", "character", "separating each entry", collapse = T)

# vectorized form - translating a shorter vectror to match the longer one
str_c("a", c("b", "c", "d"), "c", sep = " " )
# simpler vectorizing 
str_c("a", c("b", "c", "d"))
# c() comparison
c("a", c("b", "c", "d"))

x <- c("OneValue", "SecondValue", "ThirdValue")
str_sub(x, 1, 3)
# negative numbers count backwards from end
str_sub(x, -4, -1)
# The function will not fail in the example below
str_sub("a", 1,5)

str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x

#initial string
x = c("y", "i", "k")
#sort function in English
str_sort(x)
#sort function in Lithuanian
str_sort(x,locale = "lt")







x <- c("apple", "banana", "pear")
str_detect(x, "e")

# How many common words start with t?
sum(str_detect(words, "^t"))

# What proportion of common words end with a vowel?
mean(str_detect(words, "[aeiou]$"))

x <- c("apple", "banana", "pear")
str_count(x, "a")

# On average, how many vowels per word?
mean(str_count(words, "[aeiou]"))

length(sentences)

head(sentences)

colours <- c("red", "orange", "yellow", "green", "blue", "purple")
colour_match <- str_c(colours, collapse = "|")
colour_match

has_colour <- str_subset(sentences, colour_match)
matches <- str_extract(has_colour, colour_match)
head(matches)

more <- sentences[str_count(sentences, colour_match) > 1]

str_extract(more, colour_match)

x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")
str_replace_all(x, "[aeiou]", "-")

x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))

sentences %>% 
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>% 
  head(5)





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
prosecutions_and_convictions <- botor::s3_read(
  "s3://alpha-r-training/writing-functions-in-r/prosecutions-and-convictions-2018.csv", read.csv)

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


x <- c("apple", "banana", "pear")
# str_view(x, "an")

# str_view(x, ".a.")

# To create the regular expression, we need \\
dot <- "\\."
# But the expression itself only contains one:
writeLines(dot)
# And this tells R to look for an explicit .
# str_view(c("abc", "a.c", "bef"), "a\\.c")

#to see this in a string
x <- "a\\b"
writeLines(x)
# to view the result in a RegEx
# str_view(x, "\\\\")

x <- c("apple", "banana", "pear")
# str_view(x, "^a")
# str_view(x, "a$")

# this will output all possible matches
x <- c("apple pie", "apple", "apple cake")
# str_view(x, "apple")
# notice the difference in the result here
# str_view(x, "^apple$")

# Look for a literal character that normally has special meaning in a regex
# str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")
# str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")
# str_view(c("abc", "a.c", "a*c", "a c"), "a[ ]")

# str_view(c("grey", "gray"), "gr(e|a)y")

x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
# str_view(x, "CC?")
# str_view(x, "CC+")
# str_view(x, 'C[LX]+')

# str_view(x, "C{2}")
# str_view(x, "C{2,}")
# str_view(x, "C{2,3}")

# str_view(x, 'C{2,3}?')
# str_view(x, 'C[LX]+?')
