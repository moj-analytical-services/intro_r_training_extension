# Load packages
library(botor) # Used to help R interact with s3 cloud storage
library(dplyr) # Used for data manipulation
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

dates <- c("2020-03-01", "2020-06-01", "2020-09-01", "2020-12-01")



fruits <- c("strawberry", "apple", "pear", "orange")

# Iterating over the indices of a vector
for (i in seq_along(fruits)) {
  # Use paste() to combine two strings together
  print(paste(i, fruits[i]))
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
