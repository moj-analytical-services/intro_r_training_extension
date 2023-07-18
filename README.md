Introduction to R extension
================

This repository is for the Introduction to R+ course offered by the Data
& Analysis R Training Group.

The session is intended to be accessible to anyone who is familiar with
the content of the [Introduction to
R](https://github.com/moj-analytical-services/IntroRTraining) training
session.

If you have any feedback on the content, please get in touch!

## Contents

-   [Pre-material](#pre-material)
-   [Learning outcomes](#learning-outcomes)
-   [Conditional statements](#conditional-statements)
-   [Handling missing data](#handling-missing-data)
-   [Iteration](#iteration)
-   [Reshaping data](#reshaping-data)
-   [String manipulation](#string-manipulation)
-   [Further reading](#further-reading)
-   [Bonus examples](#bonus-examples)
-   [Appendix](#appendix)

## Pre-material

Before the session, please make sure that -

1.  You have access to RStudio on the Analytical Platform
2.  You have access to the [alpha-r-training s3
    bucket](https://controlpanel.services.analytical-platform.service.justice.gov.uk/datasources/607/)
3.  You have followed the steps in the [Configure Git and Github section
    of the Platform User
    Guidance](https://user-guidance.services.alpha.mojanalytics.xyz/github.html#setup-github-keys-to-access-it-from-r-studio-and-jupyter)
    to configure Git and GitHub (this only needs doing once)
4.  You have cloned this repository (instructions are in the Analytical
    Platform User Guidance if you follow step 1
    [here](https://user-guidance.services.alpha.mojanalytics.xyz/github.html#r-studio))
5.  You have installed the required packages by entering the following
    commands in the Console window in RStudio (after following step 4,
    above): `install.packages("renv")` followed by `renv::restore()`

If you have any problems with the above please get in touch with the
course organisers or ask for help on either the
\#analytical-platform-support or \#intro_r channel on [ASD
slack](https://asdslack.slack.com).

All the examples in the presentation and README are available in the R
script example_code.R.

# Introduction

## Introduction

This course builds on the original [Introduction to R training
course](https://github.com/moj-analytical-services/IntroRTraining), and
covers additional programming concepts. It provides examples that
demonstrate how the Tidyverse packages can assist with tasks typically
encountered in MoJ Data & Analysis.

Development of the Tidyverse suite of packages was led by Hadley
Wickham, and more information about these packages can be found on the
[Tidyverse website](https://www.tidyverse.org/) as well as in the book
[R for Data Science](https://r4ds.had.co.nz/).

The first two chapters of this course cover two fundamentals of
programming in R: conditional statements and loops. These two topics
come under the umbrella of ‘control flow’, which refers to how we can
change the order that pieces of code are run in. With conditional
statements we can introduce choices, where different pieces of code are
run depending on the input, and loops allow us to repeatedly run the
same piece of code.

## Learning outcomes

### By the end of this session you should know how to:

-   Change what the code does based on a condition
-   Classify values in a dataframe, based on a set of conditions
-   Read and combine data from multiple csv files
-   Easily apply a function to multiple columns in a dataframe
-   Deal with missing values in a dataframe
-   Reshape dataframes
-   Search for a string pattern in a dataframe

## Before we start

To follow along with the code and participate in the exercises, open the
script “example_code.R” in RStudio. All the code that we’ll show in this
session is stored in “example_code.R”, and you can edit this script to
write solutions to the exercises. You may also want to have the course
[README](https://github.com/moj-analytical-services/intro_r_training_extension)
open as a reference.

First, we need to load a few packages:

``` r
# Load packages
library(Rs3tools) # Used to help R interact with s3 cloud storage
library(dplyr) # Used for data manipulation
library(tidyr) # Used to help reshape and deal with missing data
library(stringr) # Used for string manipulation
library(readr) # Used to help read in data
```

# Conditional statements

## if statements

Conditional statements can be used when you want a piece of code to be
executed only if a particular condition is met. The most basic form of
these are ‘if’ statements. As a simple example, let’s say we wanted to
check if a variable `x` is less than 10. We can write something like:

``` r
x <- 9

# A basic if statement
if (x < 10) {
  print("x is less than 10")
}
```

    ## [1] "x is less than 10"

``` r
x <- 11

if (x < 10) {
  print("x is less than 10")
}
```

## if…else statements

We can also specify if we want something different to happen if the
condition is not met, using an ‘if…else’ statement:

``` r
x <- 11

# A basic if...else statement
if (x < 10) {
  print("x is less than 10")
} else {
  print("x is 10 or greater")
}
```

    ## [1] "x is 10 or greater"

------------------------------------------------------------------------

Or if there are multiple conditions where we want different things to
happen, we can add ‘else if’ commands:

``` r
x <- 5

if (x < 10) {
  print("x is less than 10")
} else if (x == 10) {
  print("x is equal to 10")
} else {
  print("x is greater than 10")
}
```

    ## [1] "x is less than 10"

------------------------------------------------------------------------

For the conditions themselves, we can make use of R’s relational and
logical operators:

| Operator | Definition                      |
|:--------:|:--------------------------------|
|    ==    | Equal to                        |
|    !=    | Not equal to                    |
|    \>    | Greater than                    |
|    \<    | Less than                       |
|   \>=    | Greater than or equal to        |
|   \<=    | Less than or equal to           |
|    ǀ     | Or                              |
|    &     | And                             |
|    !     | Not                             |
|   %in%   | The subject appears in a vector |
| is.na()  | The subject is NA               |

## Vectorising an if…else statement

Dplyr’s `if_else()` function is useful if we want to apply an ‘if…else’
statement to a vector, rather than a single value. When we use
`if_else()` we need to provide it with three arguments, like this:
`if_else(condition, true, false)`, where `condition` is the condition we
want to test, `true` is the value to use if the condition evaluates to
`TRUE`, and `false` is the value to use if the condition evaluates to
`FALSE`.

For example, if we had a vector containing a set of numbers, and we
wanted to create an equivalent vector containing a ‘1’ if the number is
greater than zero, or a ‘0’ if the number is less than or equal to zero,
then we could do:

``` r
x <- c(0, 74, 0, 8, 23, 15, 3, 0, -1, 9)

# Vectorised if...else
dplyr::if_else(x > 0, 1, 0)
```

    ##  [1] 0 1 0 1 1 1 1 0 0 1

------------------------------------------------------------------------

When we’re manipulating dataframes, it can be useful to combine
`if_else()` with the `mutate()` function from dplyr. Let’s take a look
at the `offenders` dataframe, which is also used in the [Introduction to
R](https://github.com/moj-analytical-services/IntroRTraining) course:

``` r
# First read and preview the data
offenders <- Rs3tools::s3_path_to_full_df(
  "alpha-r-training/intro-r-training/Offenders_Chicago_Police_Dept_Main.csv"
)
str(offenders)
```

    ## 'data.frame':    1413 obs. of  11 variables:
    ##  $ LAST            : chr  "RODRIGUEZ" "MARTINEZ" "GARCIA" "RODRIGUEZ" ...
    ##  $ FIRST           : chr  "JUAN" "MOISES" "ELLIOTT" "JOSE" ...
    ##  $ BLOCK           : chr  "009XX W CUYLER AVE" "011XX N KILBOURN AVE" "011XX W 18TH ST" "012XX W RACE AVE" ...
    ##  $ GENDER          : chr  "MALE" "MALE" "MALE" "MALE" ...
    ##  $ REGION          : chr  "West" "East" "South" "North" ...
    ##  $ BIRTH_DATE      : chr  "06/22/1955" "02/07/1954" "08/11/1970" "02/10/1959" ...
    ##  $ HEIGHT          : int  198 198 201 237 201 199 201 236 198 199 ...
    ##  $ WEIGHT          : int  190 180 200 195 220 130 200 235 140 130 ...
    ##  $ PREV_CONVICTIONS: num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ SENTENCE        : chr  "Court_order" "Prison_<12m" "Court_order" "Court_order" ...
    ##  $ AGE             : int  58 59 43 54 34 50 32 43 34 18 ...

------------------------------------------------------------------------

Let’s say we wanted a simple way to be able to separate youths from
adult offenders. We can add a column that contains ‘Youth’ if the
offender is under the age of 18, and ‘Adult’ otherwise:

``` r
# Now use mutate to add the new column
offenders <- offenders %>%
  dplyr::mutate(YOUTH_OR_ADULT = dplyr::if_else(AGE < 18, "Youth", "Adult"))

str(offenders)
```

    ## 'data.frame':    1413 obs. of  12 variables:
    ##  $ LAST            : chr  "RODRIGUEZ" "MARTINEZ" "GARCIA" "RODRIGUEZ" ...
    ##  $ FIRST           : chr  "JUAN" "MOISES" "ELLIOTT" "JOSE" ...
    ##  $ BLOCK           : chr  "009XX W CUYLER AVE" "011XX N KILBOURN AVE" "011XX W 18TH ST" "012XX W RACE AVE" ...
    ##  $ GENDER          : chr  "MALE" "MALE" "MALE" "MALE" ...
    ##  $ REGION          : chr  "West" "East" "South" "North" ...
    ##  $ BIRTH_DATE      : chr  "06/22/1955" "02/07/1954" "08/11/1970" "02/10/1959" ...
    ##  $ HEIGHT          : int  198 198 201 237 201 199 201 236 198 199 ...
    ##  $ WEIGHT          : int  190 180 200 195 220 130 200 235 140 130 ...
    ##  $ PREV_CONVICTIONS: num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ SENTENCE        : chr  "Court_order" "Prison_<12m" "Court_order" "Court_order" ...
    ##  $ AGE             : int  58 59 43 54 34 50 32 43 34 18 ...
    ##  $ YOUTH_OR_ADULT  : chr  "Adult" "Adult" "Adult" "Adult" ...

## Vectorising multiple if…else statements

In the previous section we saw how we can apply a single condition to a
vector, but what if we want to apply several conditions, each with a
different outcome, at the same time? We can use the `case_when()`
function from dplyr to do this. Let’s say that we wanted to add a column
to the `offenders` dataframe with an age band for each offender. We can
do something like this:

``` r
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
```

    ## 'data.frame':    1413 obs. of  3 variables:
    ##  $ BIRTH_DATE: chr  "06/22/1955" "02/07/1954" "08/11/1970" "02/10/1959" "04/16/1979" "11/19/1963" ...
    ##  $ AGE       : int  58 59 43 54 34 50 32 43 34 18 42 38 41 22 45 ...
    ##  $ AGE_BAND  : chr  "50-59" "50-59" "40-49" "50-59" "30-39" "50-59" ...

------------------------------------------------------------------------

In the `case_when()` function, each argument should be a two-sided
formula. For each formula, the condition appears to the left of a ‘`~`’
symbol, and on the right is the value to assign if the condition
evaluates to `TRUE`.

Note that the order of conditional statements in the `case_when()`
function is important if there are overlapping conditions. The
conditions will be evaluated in the order that they appear in, so in the
above example, the `case_when()` will first check if the person is under
18, then if they are under 30 (but over 18), and so on.

A default value can be assigned in the event that none of the conditions
are met. This is done by putting `TRUE` in the place of a condition. In
the example above, if none of the conditions are met then a value of
`"Unknown"` is assigned.

------------------------------------------------------------------------

### Exercise 1

Add a column called ‘COURT_ORDER’ to the `offenders` dataframe. The
column should contain a ‘1’ if the offender received a court order, or a
‘0’ otherwise, based on the categories in the ‘SENTENCE’ column.

**Hint:** you’ll need to apply the `if_else()` function with `mutate()`.

### Exercise 2

Add a column called ‘PREV_CONVICTIONS_BAND’ to the `offenders`
dataframe. The column should contain the following categories: ‘Low’,
‘Medium’, ‘High’, based on the number of convictions given in the
‘PREV_CONVICTIONS’ column. For example, you can consider less than 5
PREV_CONVICTIONS to be ‘Low’, 5 to 10 to be ‘Medium’, and over 10 to be
‘High’.

**Hint:** you’ll need to use the `case_when()` function with `mutate()`.

------------------------------------------------------------------------

------------------------------------------------------------------------

# Iteration

## Introduction

‘For’ and ‘while’ loops are used to repeatedly execute a piece of code,
and are a fundamental part of most programming languages. This chapter
introduces how to use them in R, as well as showing how we can iterate
over the columns of a dataframe without needing to write a loop.

A general rule of thumb in programming is to avoid copying and pasting a
piece of code more than once; if you find that you are repeating similar
pieces of code over and over again, this is a sign that either a loop or
a
[function](https://github.com/moj-analytical-services/writing_functions_in_r)
(or both) are required. Keeping your code concise will help make it more
readable and easier to understand.

## For loop basics

Let’s start with a very basic example to illustrate what a for loop
does. Say we wanted to print the numbers 1 to 5; without a for loop we’d
need to write something like this:

``` r
# Example of repeating the same piece of code for a set of values
print(1)
## [1] 1
print(2)
## [1] 2
print(3)
## [1] 3
print(4)
## [1] 4
print(5)
## [1] 5
```

------------------------------------------------------------------------

Clearly there is some code repetition here, so we can achieve the same
result using a for loop:

``` r
# A basic for loop
for (i in 1:5) {
  print(i)
}
```

    ## [1] 1
    ## [1] 2
    ## [1] 3
    ## [1] 4
    ## [1] 5

Inside the brackets of the for loop you define a variable - in this case
called `i` - along with what you want to iterate over, referred to as
the iterable. In this case the iterable is a sequence of the numbers 1
to 5, denoted `1:5` in R. For each iteration, the variable `i` will take
on a value equal to the next element of the iterable. The loop body goes
inside the curly brackets, which is where you define what you want to
happen for each iteration (in this case printing the value of `i`).

------------------------------------------------------------------------

In the previous example we iterated over a sequence of numbers, but in R
you can iterate over anything you like. Here’s a similar example, but
iterating over a vector of strings instead of a sequence of numbers:

``` r
fruits <- c("strawberry", "apple", "pear", "orange")

# Iterating over a vector
for (fruit in fruits) {
  print(fruit)
}
```

    ## [1] "strawberry"
    ## [1] "apple"
    ## [1] "pear"
    ## [1] "orange"

------------------------------------------------------------------------

You can also use for loops to populate or modify a vector or dataframe.
The following example shows how we can add the first ten numbers of the
Fibonacci sequence to a vector:

``` r
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
```

    ##  [1]  0  1  1  2  3  5  8 13 21 34

When writing a for loop you must define something to iterate over a
fixed number of times in advance. It is also possible to iterate
indefinitely using a different kind of loop - this is covered later on
in the section on while loops.

## More options with for loops

### Iterating over the index of a vector

If you wanted to get an index number for each element of the iterable,
you can use the `seq_along()` function. For example:

``` r
# Iterating over the indices of a vector

fruits <- c("strawberry", "apple", "pear", "orange")

for (i in seq_along(fruits)) {
  # Use paste() to combine two strings together
  print(paste(i, fruits[i]))
}
```

    ## [1] "1 strawberry"
    ## [1] "2 apple"
    ## [1] "3 pear"
    ## [1] "4 orange"

------------------------------------------------------------------------

### Conditionally exiting a loop

You might want to stop a loop iterating under a certain condition. In
this case you can use a `break` statement in combination with an ‘if’ or
‘if…else’ statement, like so:

``` r
for (i in 1:10) {
  
  # Exit the for loop if i is greater than 5
  if (i > 5) {
    break
  }
  
  print(i)
}
```

    ## [1] 1
    ## [1] 2
    ## [1] 3
    ## [1] 4
    ## [1] 5

------------------------------------------------------------------------

### Conditionally skip to the next iteration

The `next` statement can be use to skip to the next iteration of the
loop under a certain condition. For example, we can skip to the next
iteration if the iterable is NA (not available):

``` r
data <- c(56, 92, NA, 40, 11)

for (i in data) {
  
  # Skip this iteration if i is NA
  if (is.na(i)) {
    next
  }
  
  print(i)
}
```

    ## [1] 56
    ## [1] 92
    ## [1] 40
    ## [1] 11

------------------------------------------------------------------------

### Handling outputs of unknown length

There are cases where the size of an output from a loop is not known
beforehand. For example, this might be because different iterations
result in outputs of different lengths.

Let’s say we want to combine segments of a dataset, and we don’t know in
advance how many segments there are or how many rows they have. There is
a shared folder prepared in the alpha-r-training s3 bucket, which
contains some data for us to read in and combine together. First we need
to get a list of files to read in, which we can do using the `s3_ls()`
function from botor:

``` r
# Get dataframe with all available files/folders from an s3 path
files <- Rs3tools::list_files_in_buckets("alpha-r-training", prefix="intro-r-extension/fruit")

# Get a list of csv file names
files <- files %>%
  dplyr::filter(grepl(".csv", path)) %>%
  dplyr::pull(path)

files
```

    ## alpha-r-training/intro-r-extension/fruit/fruit1.csv
    ## alpha-r-training/intro-r-extension/fruit/fruit2.csv
    ## alpha-r-training/intro-r-extension/fruit/fruit3.csv

------------------------------------------------------------------------

Now we can use a for loop to read in each file as a dataframe, and add
each dataframe to a list. After the for loop, the `bind_rows()` function
from dplyr can be used to combine the data into a single dataframe.

``` r
# First define an empty list to be filled by the loop
fruit_list <- vector("list", length(files))

# Loop over each file, and add the data to a list
for (i in seq_along(files)) {
  fruit_list[[i]] <- Rs3tools::s3_path_to_full_df(files[i])
}

# Combine the list of dataframes into a single dataframe
fruit <- dplyr::bind_rows(fruit_list)
fruit
```

    ##        Item Cost.Jan Cost.Feb Cost.Mar
    ## 1    Orange     0.56     0.50     0.57
    ## 2     Apple     0.42     0.51     0.49
    ## 3    Banana     0.15     0.17     0.21
    ## 4     Lemon     0.30     0.32     0.35
    ## 5      Pear     0.41     0.39     0.44
    ## 6     Melon     1.10     1.15     1.11
    ## 7 Pineapple     1.18     1.19     1.24
    ## 8     Peach     0.55     0.53     0.58
    ## 9      Plum     0.38     0.41     0.41

------------------------------------------------------------------------

By doing this we’ve combined together various segments of a dataset,
without needing to know how many segments there are or how many rows are
in each segment beforehand.

Note: We’ve introduced a type of R object called a list in this example.
Lists are type of vector that allow us to put a whole dataframe as an
element in the list. Compare this to the vectors we’ve met before, known
as ‘atomic vectors’, where the elements can only contain a single value
and they all need to be the same type (numeric, character, etc). The
reason for doing it this way is because it’s more memory efficient to
add the dataframes to a list and use `bind_rows()` afterwards compared
to appending the dataframes in each loop iteration.

## While loops

There may be cases where we want to keep looping over a piece of code
until a certain condition is met, rather than having to specify in
advance how many times a loop should run. In these cases a while loop
can be used, which can be thought of as a repeating if statement.

For example, we can use a while loop to achieve a similar result to the
first for loop example above:

``` r
# First specify an initial value for the variable used in the while loop
i <- 1

# Now define a while loop
while (i <= 5) { # The loop will continue until the condition i<=5 is met
  print(i)
  i = i + 1 # Set the value of the variable for the next loop iteration
}
```

    ## [1] 1
    ## [1] 2
    ## [1] 3
    ## [1] 4
    ## [1] 5

------------------------------------------------------------------------

The syntax for a while loop is similar to that of a for loop, but in the
brackets a condition is specified instead of an iterable. Prior to
writing the while loop you’ll also need to specify an initial value for
the variable used in the loop, and there should be something in the body
of the loop to change the variable during each iteration - otherwise the
condition can never be met!

Generally a while loop should only be used in circumstances where it
isn’t possible to achieve the desired result using a for loop. The
reason for this is that it can be easy to accidentally set up an
infinite loop, where a bug in the code means that the condition is never
met for a while loop to end.

## Iterating over columns of a dataframe

Although loops are an essential programming tool, there are cases where
the same outcome can be achieved in a more efficient way by using a
built-in function. For example, the tidyverse packages include functions
that allow us to apply operations across all (or a subset) of the
columns in a dataframe at the same time. The advantages of using these
built-in functions are that they can make the code more concise and
easier to read, plus they’re often faster to run than the loop
equivalent.

------------------------------------------------------------------------

We’ve already met the `mutate()` function from dplyr in the
[Introduction to
R](https://github.com/moj-analytical-services/IntroRTraining) course,
which is a convenient way to apply an operation to all values in a
column of a dataframe. For example, going back to the `fruit` dataset
that we combined together earlier, here’s how we can make all characters
in the `Item` column uppercase, using the `toupper()` function:

``` r
# Convert Item column to uppercase
fruit <- fruit %>% dplyr::mutate(Item = toupper(Item))
fruit
```

    ##        Item Cost.Jan Cost.Feb Cost.Mar
    ## 1    ORANGE     0.56     0.50     0.57
    ## 2     APPLE     0.42     0.51     0.49
    ## 3    BANANA     0.15     0.17     0.21
    ## 4     LEMON     0.30     0.32     0.35
    ## 5      PEAR     0.41     0.39     0.44
    ## 6     MELON     1.10     1.15     1.11
    ## 7 PINEAPPLE     1.18     1.19     1.24
    ## 8     PEACH     0.55     0.53     0.58
    ## 9      PLUM     0.38     0.41     0.41

------------------------------------------------------------------------

We can also use `mutate()` to apply a function to multiple columns in
one go by combining it with the `across()` function from dplyr. This
example demonstrates how to multiply the values in all numeric columns
by 100:

``` r
fruit_pence <- fruit %>% dplyr::mutate(dplyr::across(where(is.numeric), ~ .x * 100))
fruit_pence
```

    ##        Item Cost.Jan Cost.Feb Cost.Mar
    ## 1    ORANGE       56       50       57
    ## 2     APPLE       42       51       49
    ## 3    BANANA       15       17       21
    ## 4     LEMON       30       32       35
    ## 5      PEAR       41       39       44
    ## 6     MELON      110      115      111
    ## 7 PINEAPPLE      118      119      124
    ## 8     PEACH       55       53       58
    ## 9      PLUM       38       41       41

Here we’re using `mutate()` with `across()` to apply a function to all
numeric columns. The `~ .x * 100` part is what’s called a lambda or
anonymous function, and this is what tells `mutate()` and `across()` to
multiply by 100. The lambda function is a function with no name -
they’re generally used in combination with another function (in this
case `across()`) to apply a simple operation without needing to define a
dedicated function elsewhere in the code.

------------------------------------------------------------------------

Of course `across()` can also be used to apply a named function to
multiple columns of a dataframe. Here’s how we can apply the `signif()`
function to round values in all numeric columns to 1 significant figure:

``` r
rounded_fruit <- fruit %>% dplyr::mutate(dplyr::across(where(is.numeric), signif, 1))

rounded_fruit
```

    ##        Item Cost.Jan Cost.Feb Cost.Mar
    ## 1    ORANGE      0.6      0.5      0.6
    ## 2     APPLE      0.4      0.5      0.5
    ## 3    BANANA      0.2      0.2      0.2
    ## 4     LEMON      0.3      0.3      0.4
    ## 5      PEAR      0.4      0.4      0.4
    ## 6     MELON      1.0      1.0      1.0
    ## 7 PINEAPPLE      1.0      1.0      1.0
    ## 8     PEACH      0.6      0.5      0.6
    ## 9      PLUM      0.4      0.4      0.4

Note: When the `signif()` function is passed as an argument to
`across()`, the brackets aren’t included (i.e. `signif` is passed rather
than `signif()`). This means that any arguments for `signif` need to be
included as extra arguments for `across()` instead (i.e. putting
`signif, 1` rather than `signif(1)` when using with `across()`).

------------------------------------------------------------------------

### Exercise 1

Write a for loop to print “The current date is …” for each date in the
following string vector:

``` r
# Set up a vector for Iteration - exercise 1
dates <- c("2020-03-01", "2020-06-01", "2020-09-01", "2020-12-01")
```

**Hint:** You can use the `paste()` function to join strings together,
and the `print()` function to print the result in the Console.

### Exercise 2

Modify your solution to the previous exercise to skip to the next loop
iteration if `date` is equal to ‘2020-06-01’.

------------------------------------------------------------------------

# Handling missing data

## Introduction

It’s often the case that datasets will contain missing values, which are
usually denoted by `NA` in R. ‘NA’ stands for ‘not available’, while
other programming languages might use ‘NaN’ (not a number) or ‘null’
instead. Care needs to be taken to make sure these missing values are
handled in the most appropriate way for a particular situation. This
section introduces a few methods for handling missing values in
different situations.

## Identifying missing values

The function `is.na()` can be used to identify missing values, and it
can be applied to a single value or a vector. It returns `TRUE` if a
value is `NA`, and `FALSE` otherwise:

``` r
# Check whether or not a single value is missing
x <- 7
is.na(x)
```

    ## [1] FALSE

``` r
# Check whether or not each element of a vector is missing
x <- c(7, 23, 5, 14, NA, 1, 11, NA)
is.na(x)
```

    ## [1] FALSE FALSE FALSE FALSE  TRUE FALSE FALSE  TRUE

------------------------------------------------------------------------

If instead you wanted to identify values that are not missing, then you
can combine `is.na()` with the ‘not’ operator, `!`, like so:

``` r
# Check if values are NOT missing
!is.na(x)
```

    ## [1]  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE FALSE

When working with dataframes, the `complete.cases()` function is useful
to check which rows are complete (i.e. the row doesn’t contain any
missing values):

``` r
# Check which rows of a dataframe do not contain any missing values
df <- tibble::tibble(
  "x" = c(0, 1, 2, NA, 4),
  "y" = c(18, NA, 45, 15, 2),
)

complete.cases(df)
```

    ## [1]  TRUE FALSE  TRUE FALSE  TRUE

## Handling missing values using a function argument

Some functions have built-in arguments where you can specify what you
want to happen to missing values. For example, the `sum()` function has
an argument called `na.rm` that you can use to specify if you want the
`NA` values to be removed before the sum is calculated. By default
`na.rm` is set to `FALSE`:

``` r
# What happens if you sum a vector containing missing values
x <- c(7, 23, 5, 14, NA, 1, 11, NA)
sum(x)
```

    ## [1] NA

So if we try to sum over numeric vector that contains `NA` values, then
the result is `NA`. By setting `na.rm` to `TRUE`, however, we can remove
the `NA` values before continuing with the sum:

``` r
# We can use a function argument to ignore the missing values
x <- c(7, 23, 5, 14, NA, 1, 11, NA)
sum(x, na.rm=TRUE)
```

    ## [1] 61

## Converting values to NA

There might be occasions where we want to set some values to `NA`, for
example if they are invalid. The `replace()` function can be used to
replace values based on a particular condition. This example shows how
negative values in a vector can be replaced with `NA`:

``` r
# Setting values to NA under a certain condition
x <- c(7, 23, 5, -14, 0, -1, 11, 0)
replace(x, x < 0, NA)
```

    ## [1]  7 23  5 NA  0 NA 11  0

## Replacing missing values

Sometimes it’s necessary to replace missing values; for example, when
displaying data in a table or chart, or when the missing values would
cause problems for a particular calculation. There are a few different
options that we’ll visit in this section.

### Replacing with a specific value

We can also use the `replace()` function to replace missing values with
a specific value. In this example we’re replacing missing values with
zero:

``` r
# Replacing NA values with 0 in a vector
x <- c(7, 23, 5, -14, NA, -1, 11,NA)
replace(x, is.na(x), 0)
```

    ## [1]   7  23   5 -14   0  -1  11   0

------------------------------------------------------------------------

The `replace()` function can also be applied to a whole dataframe, like
so:

``` r
# Replacing NA values with 0 over a whole dataframe
df <- tibble::tibble(
  "x" = c(0, 1, 2, NA, 4),
  "y" = c(18, NA, 45, 15, 2),
)

df %>% replace(is.na(.), 0)
```

    ## # A tibble: 5 × 2
    ##       x     y
    ##   <dbl> <dbl>
    ## 1     0    18
    ## 2     1     0
    ## 3     2    45
    ## 4     0    15
    ## 5     4     2

------------------------------------------------------------------------

The `replace_na()` function from tidyr also provides a convenient way to
replace missing values in a dataframe, and is especially useful if you
want to use different replacement values for different columns.

Here’s an example of how to use `replace_na()` with the `offenders`
dataframe, where we’re replacing missing values in the `HEIGHT` column
with ‘Unknown’:

``` r
# Replace NAs in a specific column of a dataframe
offenders_replacena <- offenders %>%
  dplyr::mutate(HEIGHT = as.character(HEIGHT)) %>%
  tidyr::replace_na(list(HEIGHT = "Unknown"))

# Display the dataframe in descending height order, so we can see the 'Unknown' values
offenders_replacena %>% dplyr::arrange(desc(HEIGHT)) %>% str()
```

    ## 'data.frame':    1413 obs. of  15 variables:
    ##  $ LAST                 : chr  "FERNANDEZ" "GARCIA" "FIGUEROA" "BURKHART" ...
    ##  $ FIRST                : chr  "FRANCISCO" "KEMICH" "JOSE" "RONALD" ...
    ##  $ BLOCK                : chr  "028XX S CHRISTIANA AVE" "033XX W 38TH ST" "054XX N ASHLAND AVE" "007XX N TRUMBULL AVE" ...
    ##  $ GENDER               : chr  "MALE" "MALE" "MALE" "MALE" ...
    ##  $ REGION               : chr  "West" "East" "South" "East" ...
    ##  $ BIRTH_DATE           : chr  "08/06/1981" "06/03/1971" "07/13/1985" "06/15/1963" ...
    ##  $ HEIGHT               : chr  "Unknown" "Unknown" "Unknown" "Unknown" ...
    ##  $ WEIGHT               : int  180 170 220 225 180 125 200 185 240 170 ...
    ##  $ PREV_CONVICTIONS     : num  0 0 0 0 0 0 0 0 1.4 1.4 ...
    ##  $ SENTENCE             : chr  "Court_order" "Prison_<12m" "Prison_<12m" "Court_order" ...
    ##  $ AGE                  : int  32 42 28 50 48 61 45 32 43 41 ...
    ##  $ YOUTH_OR_ADULT       : chr  "Adult" "Adult" "Adult" "Adult" ...
    ##  $ AGE_BAND             : chr  "30-39" "40-49" "18-29" "50-59" ...
    ##  $ COURT_ORDER          : num  1 0 0 1 1 0 1 1 1 0 ...
    ##  $ PREV_CONVICTIONS_BAND: chr  "Low" "Low" "Low" "Low" ...

------------------------------------------------------------------------

### Replacing with values from another column

The `coalesce()` function from dplyr can be used to fill in missing
values with values from another column. Before we jump into an example,
let’s first prepare a dataframe:

``` r
# Set up a dataframe to use in the next example
event_dates <- tibble::tibble(
  "event_id" = c(0, 1, 2, 3, 4, 5),
  "date" = c("2016-04-13", "2015-12-29", "2016-06-02", "2017-01-27", "2015-10-21", "2018-03-15"),
  "new_date" = c("2016-08-16", NA, NA, "2017-03-02", NA, "2018-11-20")
)

event_dates
```

    ## # A tibble: 6 × 3
    ##   event_id date       new_date  
    ##      <dbl> <chr>      <chr>     
    ## 1        0 2016-04-13 2016-08-16
    ## 2        1 2015-12-29 <NA>      
    ## 3        2 2016-06-02 <NA>      
    ## 4        3 2017-01-27 2017-03-02
    ## 5        4 2015-10-21 <NA>      
    ## 6        5 2018-03-15 2018-11-20

------------------------------------------------------------------------

We can use `coalesce()` to fill in the missing dates in the `new_date`
column with the equivalent date in the `date` column:

``` r
# Fill missing values in one column using corresponding values in another column
event_dates %>%
  dplyr::mutate(new_date = dplyr::coalesce(new_date, date))
```

    ## # A tibble: 6 × 3
    ##   event_id date       new_date  
    ##      <dbl> <chr>      <chr>     
    ## 1        0 2016-04-13 2016-08-16
    ## 2        1 2015-12-29 2015-12-29
    ## 3        2 2016-06-02 2016-06-02
    ## 4        3 2017-01-27 2017-03-02
    ## 5        4 2015-10-21 2015-10-21
    ## 6        5 2018-03-15 2018-11-20

------------------------------------------------------------------------

### Replacing with the previous value in a column

If we were to encounter a dataframe like the following, where each group
name in the `year` column appears only once, then we might want to fill
in the missing labels before beginning any analysis.

``` r
# Construct the example dataframe
df <- tidyr::crossing(year = c("2017", "2018", "2019"),
                      quarter = c("Q1", "Q2", "Q3", "Q4")) %>%
      dplyr::mutate(count = sample(length(year)))

df$year[duplicated(df$year)] <- NA # This removes repeated row labels
df
```

    ## # A tibble: 12 × 3
    ##    year  quarter count
    ##    <chr> <chr>   <int>
    ##  1 2017  Q1         10
    ##  2 <NA>  Q2          5
    ##  3 <NA>  Q3          1
    ##  4 <NA>  Q4          4
    ##  5 2018  Q1          7
    ##  6 <NA>  Q2          3
    ##  7 <NA>  Q3          8
    ##  8 <NA>  Q4          6
    ##  9 2019  Q1         12
    ## 10 <NA>  Q2         11
    ## 11 <NA>  Q3          9
    ## 12 <NA>  Q4          2

------------------------------------------------------------------------

The `fill()` function from tidyr is a convenient way to do this, and can
be used like this:

``` r
# Fill missing values in a column using the nearest previous non-NA value from the same column
df %>% tidyr::fill(year)
```

    ## # A tibble: 12 × 3
    ##    year  quarter count
    ##    <chr> <chr>   <int>
    ##  1 2017  Q1         10
    ##  2 2017  Q2          5
    ##  3 2017  Q3          1
    ##  4 2017  Q4          4
    ##  5 2018  Q1          7
    ##  6 2018  Q2          3
    ##  7 2018  Q3          8
    ##  8 2018  Q4          6
    ##  9 2019  Q1         12
    ## 10 2019  Q2         11
    ## 11 2019  Q3          9
    ## 12 2019  Q4          2

## Removing rows with missing values from a dataframe

The `drop_na()` function from tidyr allows us to easily remove rows
containing `NA` values from a dataframe. Let’s say we wanted to remove
all incomplete rows from the `offenders` dataset. We can either do this:

``` r
# Remove entire row if it contains a missing value
offenders_nona <- offenders %>% tidyr::drop_na()
str(offenders_nona)
```

    ## 'data.frame':    1389 obs. of  15 variables:
    ##  $ LAST                 : chr  "RODRIGUEZ" "MARTINEZ" "GARCIA" "RODRIGUEZ" ...
    ##  $ FIRST                : chr  "JUAN" "MOISES" "ELLIOTT" "JOSE" ...
    ##  $ BLOCK                : chr  "009XX W CUYLER AVE" "011XX N KILBOURN AVE" "011XX W 18TH ST" "012XX W RACE AVE" ...
    ##  $ GENDER               : chr  "MALE" "MALE" "MALE" "MALE" ...
    ##  $ REGION               : chr  "West" "East" "South" "North" ...
    ##  $ BIRTH_DATE           : chr  "06/22/1955" "02/07/1954" "08/11/1970" "02/10/1959" ...
    ##  $ HEIGHT               : int  198 198 201 237 201 199 201 236 198 199 ...
    ##  $ WEIGHT               : int  190 180 200 195 220 130 200 235 140 130 ...
    ##  $ PREV_CONVICTIONS     : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ SENTENCE             : chr  "Court_order" "Prison_<12m" "Court_order" "Court_order" ...
    ##  $ AGE                  : int  58 59 43 54 34 50 32 43 34 18 ...
    ##  $ YOUTH_OR_ADULT       : chr  "Adult" "Adult" "Adult" "Adult" ...
    ##  $ AGE_BAND             : chr  "50-59" "50-59" "40-49" "50-59" ...
    ##  $ COURT_ORDER          : num  1 0 1 1 0 0 0 1 1 0 ...
    ##  $ PREV_CONVICTIONS_BAND: chr  "Low" "Low" "Low" "Low" ...

------------------------------------------------------------------------

Or alternatively you can remove rows that contain `NA` values in
specific columns:

``` r
# Remove entire row if it contains missing values in specific columns
offenders_nona <- offenders %>% tidyr::drop_na(HEIGHT, WEIGHT)
str(offenders_nona)
```

    ## 'data.frame':    1389 obs. of  15 variables:
    ##  $ LAST                 : chr  "RODRIGUEZ" "MARTINEZ" "GARCIA" "RODRIGUEZ" ...
    ##  $ FIRST                : chr  "JUAN" "MOISES" "ELLIOTT" "JOSE" ...
    ##  $ BLOCK                : chr  "009XX W CUYLER AVE" "011XX N KILBOURN AVE" "011XX W 18TH ST" "012XX W RACE AVE" ...
    ##  $ GENDER               : chr  "MALE" "MALE" "MALE" "MALE" ...
    ##  $ REGION               : chr  "West" "East" "South" "North" ...
    ##  $ BIRTH_DATE           : chr  "06/22/1955" "02/07/1954" "08/11/1970" "02/10/1959" ...
    ##  $ HEIGHT               : int  198 198 201 237 201 199 201 236 198 199 ...
    ##  $ WEIGHT               : int  190 180 200 195 220 130 200 235 140 130 ...
    ##  $ PREV_CONVICTIONS     : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ SENTENCE             : chr  "Court_order" "Prison_<12m" "Court_order" "Court_order" ...
    ##  $ AGE                  : int  58 59 43 54 34 50 32 43 34 18 ...
    ##  $ YOUTH_OR_ADULT       : chr  "Adult" "Adult" "Adult" "Adult" ...
    ##  $ AGE_BAND             : chr  "50-59" "50-59" "40-49" "50-59" ...
    ##  $ COURT_ORDER          : num  1 0 1 1 0 0 0 1 1 0 ...
    ##  $ PREV_CONVICTIONS_BAND: chr  "Low" "Low" "Low" "Low" ...

------------------------------------------------------------------------

### Exercise 1

For the following dataframe, use the `filter()` function from dplyr with
`complete.cases()` to extract the rows **with** missing values:

``` r
# Set up example dataframe for Missing data - exercise 1
fruit <- tibble::tibble(
  "Item" = c("Orange", "Apple", "Banana", "Lemon", "Pear"),
  "Cost" = c(0.5, 0.4, 0.1, 0.3, NA),
  "Quantity" = c(23, NA, 15, 9, 11)
)
```

**Hint:** you can use a `.` inside the `complete.cases()` function to
apply it to all columns of the dataframe.

------------------------------------------------------------------------

### Exercise 2

For the following dataframe, use the `replace_na()` function from tidyr
to replace missing values in the `Cost` column with “Unknown” and the
`Quantity` column with 0.

``` r
# Set up example dataframe for Missing data - exercise 2
fruit <- tibble::tibble(
  "Item" = c("Orange", "Apple", "Banana", "Lemon", "Pear"),
  "Cost" = c("£0.50", "£0.40", "£0.10", "£0.30", NA),
  "Quantity" = c(23, NA, 15, 9, 11)
)
```

**Hint:** you can add multiple arguments to `replace_na(list(...))`,
with one argument for each column where NA values need replacing.

------------------------------------------------------------------------

# Reshaping data

## Introduction

The exact same data can be represented in different orientations,
depending on the purpose.

A dataframe that is in long format has a single column for each
variable. The number of columns is minimised, at the expense of having
many rows.

A dataframe that is in wide format spreads a variable across several
columns. The number of rows is minimised, at the expense of many
columns.

There are advantages and disadvantages of each depending on context, and
it is useful to know how to switch between these. It is very easy with
the `tidyverse` functions (package `tidyr`) `pivot_wider()` and
`pivot_longer()`.

## Widening data

We read in a data table.

``` r
# read in the fake annual offences data
annual_offences <- 
  Rs3tools::s3_path_to_full_df(
    s3_path = "s3://alpha-r-training/intro-r-extension/annual_offences_fake.csv", 
    colClasses = c("integer", "character", "integer")) %>%
  tibble::tibble()

head(annual_offences)
```

    ## # A tibble: 6 × 3
    ##    year offence_code count
    ##   <int> <chr>        <int>
    ## 1  2016 00101          219
    ## 2  2016 00304         4730
    ## 3  2016 00305           28
    ## 4  2016 00399         6405
    ## 5  2016 00405            9
    ## 6  2016 00406            3

------------------------------------------------------------------------

``` r
n_rows <- dim(annual_offences)[1]
n_cols <- dim(annual_offences)[2]
print(paste("The table is", n_rows, "rows by", n_cols, "cols, making", n_rows * n_cols, "cells", sep = " "))
```

    ## [1] "The table is 3563 rows by 3 cols, making 10689 cells"

The data represent fake frequencies of offences from 2016 to 2020,
represented by real Home Office offence codes. If an offence was
prosecuted in a year, there is a corresponding line in this data table,
with the offence code indicated by the `offence_code` column, the year
indicated by the `year` column, and the `count` column representing the
number of times the offence was prosecuted. If an offence was not
prosecuted in a year, the corresponding combination of `year` and
`offence` does not exist. The table has been sorted by year and offence
code.

------------------------------------------------------------------------

The long format may be a good way to store data like these for some
purposes, but what if we want to put it into wide format, e.g. to make
it easier for a human to read? We use the `tidyr` function
`pivot_wider()`:

``` r
# basic implementation of pivot_wider()
wide_annual_offences <- annual_offences %>%
  tidyr::pivot_wider(
    names_from = 'year',
    values_from = 'count'
  )

head(wide_annual_offences)
```

    ## # A tibble: 6 × 6
    ##   offence_code `2016` `2017` `2018` `2019` `2020`
    ##   <chr>         <int>  <int>  <int>  <int>  <int>
    ## 1 00101           219    188    177    154    122
    ## 2 00304          4730   4953   4954   5613   4485
    ## 3 00305            28     20     17     10      6
    ## 4 00399          6405   5879   5149   4538   3415
    ## 5 00405             9      3      4      4     NA
    ## 6 00406             3     NA      1     NA     NA

------------------------------------------------------------------------

``` r
n_rows <- dim(wide_annual_offences)[1]
n_cols <- dim(wide_annual_offences)[2]
print(paste("The table is", n_rows, "rows by", n_cols, "cols, making", n_rows * n_cols, "cells", sep = " "))
```

    ## [1] "The table is 978 rows by 6 cols, making 5868 cells"

What’s happened? We passed `count` to the argument `values_from` and
`year` to the argument `names_from`. This tells the function that we
want to make new columns based on `year`, and populate it with the
values from `count`.

Remember that the data are sorted first by year, and then by offence? If
we imagine each year as a stack of data, and the table containing one
stack for each year, then what we’re effectively doing here is taking
the count data for each stack and putting them in their own column. We
end up with a table that has one row per offence code, and one column
for each year. There are fewer cells in total, although the same data
are represented in both tables.

------------------------------------------------------------------------

There are a couple of ways we could get more useful results from this
function, though.

First, it’s generally not a good idea to have column names that begin
with numbers. Fortunately, `pivot_wider()` has the useful argument
`names_prefix` to remedy this:

``` r
# adding a prefix to new columns
wide_annual_offences <- annual_offences %>%
  tidyr::pivot_wider(
    names_from = 'year',
    values_from = 'count',
    names_prefix = 'count_'
  )
head(wide_annual_offences)
```

    ## # A tibble: 6 × 6
    ##   offence_code count_2016 count_2017 count_2018 count_2019 count_2020
    ##   <chr>             <int>      <int>      <int>      <int>      <int>
    ## 1 00101               219        188        177        154        122
    ## 2 00304              4730       4953       4954       5613       4485
    ## 3 00305                28         20         17         10          6
    ## 4 00399              6405       5879       5149       4538       3415
    ## 5 00405                 9          3          4          4         NA
    ## 6 00406                 3         NA          1         NA         NA

------------------------------------------------------------------------

When transforming count data like this we may have legitimate good
reason to replace our NAs with 0s, which we can do with `values_fill()`:

``` r
# replacing NAs with 0s
wide_annual_offences <- annual_offences %>%
  tidyr::pivot_wider(
    names_from = 'year',
    values_from = 'count',
    names_prefix = 'count_',
    values_fill = 0
  )
head(wide_annual_offences)
```

    ## # A tibble: 6 × 6
    ##   offence_code count_2016 count_2017 count_2018 count_2019 count_2020
    ##   <chr>             <int>      <int>      <int>      <int>      <int>
    ## 1 00101               219        188        177        154        122
    ## 2 00304              4730       4953       4954       5613       4485
    ## 3 00305                28         20         17         10          6
    ## 4 00399              6405       5879       5149       4538       3415
    ## 5 00405                 9          3          4          4          0
    ## 6 00406                 3          0          1          0          0

------------------------------------------------------------------------

Once our table is in wide format, and clean, we can easily do
transformations like this. Here we use `dplyr` functions to create a new
column that adds up yearly totals across each column that has count
data:

``` r
# Creating a new column from the ones we've created
wide_annual_offences_with_totals <- wide_annual_offences %>%
  dplyr::mutate(
    count_2016_2020 =
      rowSums(dplyr::across(c('count_2016', 'count_2017','count_2018','count_2019','count_2020')))
    )
head(wide_annual_offences_with_totals)
```

    ## # A tibble: 6 × 7
    ##   offence_code count_2016 count_2017 count_2018 count_2019 count_2020 count_2016_2020
    ##   <chr>             <int>      <int>      <int>      <int>      <int>           <dbl>
    ## 1 00101               219        188        177        154        122             860
    ## 2 00304              4730       4953       4954       5613       4485           24735
    ## 3 00305                28         20         17         10          6              81
    ## 4 00399              6405       5879       5149       4538       3415           25386
    ## 5 00405                 9          3          4          4          0              20
    ## 6 00406                 3          0          1          0          0               4

------------------------------------------------------------------------

The final and most advanced thing we will do with `pivot_wider()` is to
pass it an auxiliary function to transform the values that it places in
its new columns.

Here we are passing an anonymous function which itself calls the
`round()` function to round our counts. Setting the `digits` argument of
`round()` to -1 means that the values get rounded to the nearest 10,
rather than the default behaviour of rounding to the nearest whole
number.

``` r
# passing an auxiliary function to `pivot_wider()`
wide_annual_offences_rounded <- annual_offences %>%
  tidyr::pivot_wider(
    names_from = 'year',
    values_from = 'count',
    names_prefix = 'count_',
    values_fill = 0,
    values_fn = ~ round(.x, digits = -1)
  )
head(wide_annual_offences_rounded)
```

    ## # A tibble: 6 × 6
    ##   offence_code count_2016 count_2017 count_2018 count_2019 count_2020
    ##   <chr>             <dbl>      <dbl>      <dbl>      <dbl>      <dbl>
    ## 1 00101               220        190        180        150        120
    ## 2 00304              4730       4950       4950       5610       4480
    ## 3 00305                30         20         20         10         10
    ## 4 00399              6400       5880       5150       4540       3420
    ## 5 00405                10          0          0          0          0
    ## 6 00406                 0          0          0          0          0

## Lengthening data

Let’s consider our earlier widened table, with original counts, columns
with prefixes and NAs replaced with 0s.

What if we want to go from our widened table back to our original one,
here?

``` r
head(wide_annual_offences, 3)
```

    ## # A tibble: 3 × 6
    ##   offence_code count_2016 count_2017 count_2018 count_2019 count_2020
    ##   <chr>             <int>      <int>      <int>      <int>      <int>
    ## 1 00101               219        188        177        154        122
    ## 2 00304              4730       4953       4954       5613       4485
    ## 3 00305                28         20         17         10          6

``` r
head(annual_offences, 3)
```

    ## # A tibble: 3 × 3
    ##    year offence_code count
    ##   <int> <chr>        <int>
    ## 1  2016 00101          219
    ## 2  2016 00304         4730
    ## 3  2016 00305           28

------------------------------------------------------------------------

We use the function `pivot_longer()` for this. You can pass column names
to it like this:

``` r
# basic transformation of a table into long format
long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = c('count_2016', 'count_2017', 'count_2018', 'count_2019', 'count_2020')
  )
head(long_annual_offences)
```

    ## # A tibble: 6 × 3
    ##   offence_code name       value
    ##   <chr>        <chr>      <int>
    ## 1 00101        count_2016   219
    ## 2 00101        count_2017   188
    ## 3 00101        count_2018   177
    ## 4 00101        count_2019   154
    ## 5 00101        count_2020   122
    ## 6 00304        count_2016  4730

------------------------------------------------------------------------

Or, as our column names are conveniently named with a prefix, we can use
`starts_with()` from `dplyr`:

``` r
# identifying columns using `starts_with()`
long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('count')
  )
head(long_annual_offences)
```

    ## # A tibble: 6 × 3
    ##   offence_code name       value
    ##   <chr>        <chr>      <int>
    ## 1 00101        count_2016   219
    ## 2 00101        count_2017   188
    ## 3 00101        count_2018   177
    ## 4 00101        count_2019   154
    ## 5 00101        count_2020   122
    ## 6 00304        count_2016  4730

------------------------------------------------------------------------

Essentially, these data are the same as what we started with, but there
are some differences.

``` r
# checking if the original table and working table are identical
identical(long_annual_offences, annual_offences)
```

    ## [1] FALSE

``` r
head(annual_offences, 3)
```

    ## # A tibble: 3 × 3
    ##    year offence_code count
    ##   <int> <chr>        <int>
    ## 1  2016 00101          219
    ## 2  2016 00304         4730
    ## 3  2016 00305           28

``` r
head(long_annual_offences, 3)
```

    ## # A tibble: 3 × 3
    ##   offence_code name       value
    ##   <chr>        <chr>      <int>
    ## 1 00101        count_2016   219
    ## 2 00101        count_2017   188
    ## 3 00101        count_2018   177

------------------------------------------------------------------------

In fact, there are *six* differences between these tables. Have a look
yourself, and put suggestions in the chat as to what these might be.
Then we’ll cover how to correct these differences and make our working
table identical to the original table.

Thankfully we can iron out these differences through a combination of
amending our call to `pivot_wider()` and passing the result to some
`dplyr` functions.

------------------------------------------------------------------------

First, the default column name `value` has been assigned to our count,
which we correct with the argument `values_to`, giving it the label we
see in the original table:

``` r
# specifying a name for the `values` column
long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('count'),
    values_to = 'count'
  )
head(long_annual_offences)
```

    ## # A tibble: 6 × 3
    ##   offence_code name       count
    ##   <chr>        <chr>      <int>
    ## 1 00101        count_2016   219
    ## 2 00101        count_2017   188
    ## 3 00101        count_2018   177
    ## 4 00101        count_2019   154
    ## 5 00101        count_2020   122
    ## 6 00304        count_2016  4730

``` r
identical(long_annual_offences, annual_offences)
```

    ## [1] FALSE

------------------------------------------------------------------------

There’s another default name that it’s assigned too — it’s used `name`
when we want `year` to indicate the years. We correct this with an
equivalent argument:

``` r
# specifying a name for the `names` column
long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('count'),
    values_to = 'count',
    names_to = 'year'
  )
head(long_annual_offences)
```

    ## # A tibble: 6 × 3
    ##   offence_code year       count
    ##   <chr>        <chr>      <int>
    ## 1 00101        count_2016   219
    ## 2 00101        count_2017   188
    ## 3 00101        count_2018   177
    ## 4 00101        count_2019   154
    ## 5 00101        count_2020   122
    ## 6 00304        count_2016  4730

``` r
identical(long_annual_offences, annual_offences)
```

    ## [1] FALSE

------------------------------------------------------------------------

We also want to remove those prefixes:

``` r
# providing substring prefix to remove from column names before using them in our combined `names` column
long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('count'),
    values_to = 'count',
    names_to = 'year',
    names_prefix = 'count_'
  )
head(long_annual_offences)
```

    ## # A tibble: 6 × 3
    ##   offence_code year  count
    ##   <chr>        <chr> <int>
    ## 1 00101        2016    219
    ## 2 00101        2017    188
    ## 3 00101        2018    177
    ## 4 00101        2019    154
    ## 5 00101        2020    122
    ## 6 00304        2016   4730

``` r
identical(long_annual_offences, annual_offences)
```

    ## [1] FALSE

------------------------------------------------------------------------

Still more to do! We have the right number of columns in our new table,
but we have more rows than we should. That’s because of those
year/offence combinations where there are no incidences.

``` r
n_rows <- dim(annual_offences)[1]
n_cols <- dim(annual_offences)[2]
print(paste("The original table is", n_rows, "rows by", n_cols, "cols, making", n_rows * n_cols, "cells", sep = " "))
```

    ## [1] "The original table is 3563 rows by 3 cols, making 10689 cells"

``` r
n_rows <- dim(long_annual_offences)[1]
n_cols <- dim(long_annual_offences)[2]
print(paste("Our working table is", n_rows, "rows by", n_cols, "cols, making", n_rows * n_cols, "cells", sep = " "))
```

    ## [1] "Our working table is 4890 rows by 3 cols, making 14670 cells"

------------------------------------------------------------------------

Let’s get `dplyr` involved, and filter these out:

``` r
# Filtering out rows with no offences
long_annual_offences <- wide_annual_offences %>%
  tidyr::pivot_longer(
    cols = dplyr::starts_with('count'),
    values_to = 'count',
    names_to = 'year',
    names_prefix = 'count_'
  ) %>%
  dplyr::filter(count > 0)
```

We now have the same number of rows in original table and the one we’re
working on:

``` r
nrow(long_annual_offences) == nrow(annual_offences)
```

    ## [1] TRUE

------------------------------------------------------------------------

But we’re still not quite there…

``` r
identical(long_annual_offences, annual_offences)
```

    ## [1] FALSE

Finally, we use `dplyr` to: 1) fix data types and reorder columns with
`transmute()`, 2) order rows with `arrange()`:

``` r
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
```

------------------------------------------------------------------------

What do they both look like now?

``` r
head(annual_offences, 3)
```

    ## # A tibble: 3 × 3
    ##    year offence_code count
    ##   <int> <chr>        <int>
    ## 1  2016 00101          219
    ## 2  2016 00304         4730
    ## 3  2016 00305           28

``` r
head(long_annual_offences, 3)
```

    ## # A tibble: 3 × 3
    ##    year offence_code count
    ##   <int> <chr>        <int>
    ## 1  2016 00101          219
    ## 2  2016 00304         4730
    ## 3  2016 00305           28

------------------------------------------------------------------------

Success!

``` r
identical(long_annual_offences, annual_offences)
```

    ## [1] TRUE

There are many additional arguments that can be passed to
`pivot_wider()` and `pivot_longer()`, which are explained in the
function help files, e.g. `?pivot_wider`. We’ve just covered some of the
more basic ones to show how we can easily go between between wide and
long format data. Now you can have a go yourself in the exercises below!

------------------------------------------------------------------------

### Exercise 1

You have received a summary table showing quarterly totals of adult
reoffenders in England and Wales, beginning in the second quarter of
2010. The data are split by number of previous offences of the offender
prior to their current offence.

Read in the data:

``` r
reoffending_real <- Rs3tools::s3_path_to_full_df(
    s3_path = "s3://alpha-r-training/intro-r-extension/adult_reoff_by_prev_off_number_2.csv")
```

1)  Examine this data table. Would you describe it as being in wide or
    long format?
2)  Is it more ‘machine readable’ or ‘human readable’?
3)  What, if anything, would you need to do to the data before passing
    it to be read for plotting by functions from a package like
    `ggplot2`?

Note, these are real data on reoffending, publicly available, derived
from the table
[here](https://www.gov.uk/government/statistics/proven-reoffending-statistics-april-to-june-2021).

------------------------------------------------------------------------

Here’s a preview of the data table:

``` r
head(reoffending_real)
```

    ##                    prev_conv_n total_2010_Q2 total_2010_Q3 total_2010_Q4 total_2011_Q1 total_2011_Q2
    ## 1         No previous offences         42165         42427         41106         40870         39092
    ## 2     1 to 2 previous offences         26905         27522         26239         26455         25318
    ## 3     3 to 6 previous offences         24549         25467         24309         24864         24264
    ## 4    7 to 10 previous offences         13217         13985         13230         13443         13198
    ## 5 11 or more previous offences         51428         53846         52304         52659         52213
    ##   total_2011_Q3 total_2011_Q4 total_2012_Q1 total_2012_Q2 total_2012_Q3 total_2012_Q4 total_2013_Q1
    ## 1         39411         37792         36869         34897         35939         34615         33332
    ## 2         25696         24729         24527         22546         23663         22255         21621
    ## 3         24586         23181         23817         21886         22625         21319         21230
    ## 4         13472         12770         13387         12269         12563         11859         11813
    ## 5         54824         51638         53484         50015         51921         49219         48893
    ##   total_2013_Q2 total_2013_Q3 total_2013_Q4 total_2014_Q1 total_2014_Q2 total_2014_Q3 total_2014_Q4
    ## 1         32526         32955         33405         33268         31098         31313         30775
    ## 2         21157         21776         21151         21265         19631         20082         19357
    ## 3         20683         21248         20598         20778         19459         19785         18704
    ## 4         11753         12094         11633         11744         11062         11204         10731
    ## 5         49361         50603         49040         49920         47523         48618         46296
    ##   total_2015_Q1 total_2015_Q2 total_2015_Q3 total_2015_Q4 total_2016_Q1 total_2016_Q2 total_2016_Q3
    ## 1         30587         29624         29254         28663         27813         26888         25753
    ## 2         19732         18582         18661         18108         17741         16802         16022
    ## 3         18981         18425         18394         17966         17514         17006         16161
    ## 4         11105         10838         10580         10357         10262          9962          9546
    ## 5         46641         45963         45455         45593         45249         44399         42993
    ##   total_2016_Q4 total_2017_Q1 total_2017_Q2 total_2017_Q3 total_2017_Q4 total_2018_Q1 total_2018_Q2
    ## 1         24828         25662         23376         22952         23332         23436         21982
    ## 2         15170         15678         14319         14005         13689         13796         13519
    ## 3         15470         16004         15123         14499         13986         14359         13846
    ## 4          9069          9453          8903          8677          8222          8392          8300
    ## 5         41271         43572         41272         41006         39503         40151         38786
    ##   total_2018_Q3 total_2018_Q4 total_2019_Q1 total_2019_Q2 total_2019_Q3 total_2019_Q4 total_2020_Q1
    ## 1         21524         21433         22358         21407         21423         21049         20309
    ## 2         12868         12680         13370         12685         12644         11886         12057
    ## 3         13474         13145         13635         12932         12937         12366         12229
    ## 4          7925          7901          8107          7764          7733          7542          7170
    ## 5         38290         37297         37433         36497         36135         34274         33492
    ##   total_2020_Q2 total_2020_Q3 total_2020_Q4 total_2021_Q1 total_2021_Q2
    ## 1          8067         18382         19566         17481         17700
    ## 2          4992         11783         12637         11599         11323
    ## 3          5363         12258         13129         12279         12257
    ## 4          3209          7301          7865          7217          7245
    ## 5         18066         32028         33953         31702         31657

------------------------------------------------------------------------

### Exercise 2

1)  Put the data into long format using the appropriate function.
2)  Remove relevant prefixes.
3)  Pass the labels ‘quarter’ and ‘count’ to the appropriate arguments
    to name the columns in your long format table.

------------------------------------------------------------------------

### Exercise 3

Your project manager likes the resulting plot, but wants to be able to
see trends in counts over time more easily. Going from the long format
table:

1)  Put the data back into wide format.
2)  Add a prefix of your choice to the new columns you create.
3)  Round the values to the nearest thousand.

------------------------------------------------------------------------

------------------------------------------------------------------------

# String manipulation

## Introduction

In this chapter we’ll look at strings and some techniques to help work
with them, mainly making use of the `stringr` package from Tidyverse.

There are two ways to create a string in R, by using either single or
double quotes. There is no practical difference in behaviour for the two
options, but the convention is to use double quotes (`"`).

``` r
# Two options to define a string
string1 <- "a string using double quotes"
string2 <- 'another string using single quotes'

string1
```

    ## [1] "a string using double quotes"

``` r
string2
```

    ## [1] "another string using single quotes"

------------------------------------------------------------------------

There is an advantage to having two ways to define a string, which is
that the two types of quotation marks can be combined for cases when the
string itself needs to contain a quotation mark. Here are some examples
of how to define a string in R:

``` r
# Some strings containing quotation marks
string3 <- "here is a 'quote' within a string"
string4 <- 'here is a "quote" within a string'

string3
```

    ## [1] "here is a 'quote' within a string"

``` r
string4
```

    ## [1] "here is a \"quote\" within a string"

Notice the difference in how `string4` is displayed - R has added escape
characters (`\`) before the double quote marks. These escape characters
change the behaviour of the following character. In this case it stops
the following double quote mark from defining the end of the string, and
instead allows it to be a part of the string.

------------------------------------------------------------------------

Often it’s necessary to work with a set of strings in a character
vector, and in the following sections we’ll look at how various
`stringr` functions can help us work with character vectors. A new
character vector can be constructed using the `c()` function that we’ve
met before:

``` r
# Example of a character vector
string_vector <- c("a", "vector", "of", "strings")
string_vector
```

    ## [1] "a"       "vector"  "of"      "strings"

## String Length

The first `stringr` function we’ll look at is `str_length()`, which
simply returns the length of each string in a character vector:

``` r
# Find out how many characters are in each string
stringr::str_length(string_vector)
```

    ## [1] 1 6 2 7

## Combining Strings

The `str_c()` function is used to combine multiple strings together,
where each string is included as a separate argument, like so:

``` r
# Combining several strings into one
stringr::str_c("some", "strings", "to", "combine")
```

    ## [1] "somestringstocombine"

There are two optional arguments, `sep` and `collapse` that can be used
to modify the behaviour of `str_c()`. The `sep` argument allows us to
define a separator to put between the strings when they’re combined:

``` r
# Using custom separator
stringr::str_c("some", "space", "separated", "strings", sep = " ")
```

    ## [1] "some space separated strings"

------------------------------------------------------------------------

The `str_c()` is especially useful because it is vectorised, and when
applying it to character vectors the `collapse` argument can be used to
combine a vector of strings into a single string:

``` r
# Collapsing a character vector into a single string
vector_to_collapse <- c("some", "strings", "to", "combine")
stringr::str_c(vector_to_collapse, collapse="")
```

    ## [1] "somestringstocombine"

The value of `collapse` will determine how the collapsed strings are
separated.

------------------------------------------------------------------------

You can input multiple character vectors to `str_c()` and it will
combine them together. You can either output another character vector:

``` r
# Combining two character vectors
string_vector1 <- c("A", "B", "C", "D")
string_vector2 <- c("1", "2", "3", "4")
stringr::str_c(string_vector1, string_vector2, sep=" - ")
```

    ## [1] "A - 1" "B - 2" "C - 3" "D - 4"

Or collapse the vectors into a single string:

``` r
# Combining and collapsing two character vectors
string_vector1 <- c("A", "B", "C", "D")
string_vector2 <- c("1", "2", "3", "4")
stringr::str_c(string_vector1, string_vector2, sep=" - ", collapse=" ")
```

    ## [1] "A - 1 B - 2 C - 3 D - 4"

------------------------------------------------------------------------

It can also combine a single string with a vector of strings, like so:

``` r
# The single string will be 'recycled' to match the length of the vector
stringr::str_c("a", c("b", "c", "d"), sep = " ")
```

    ## [1] "a b" "a c" "a d"

Compare this with what happens when we combine these strings with `c()`
:

``` r
# Combining strings into a single vector with c() 
c("a", c("b", "c", "d"))
```

    ## [1] "a" "b" "c" "d"

------------------------------------------------------------------------

It’s worth noting what happens if you pass vectors of different lengths
to `str_c()`:

``` r
# Combining vectors of different lengths
string_vector1 <- c("A", "B", "C")
string_vector2 <- c("1", "2", "3", "4", "5")
stringr::str_c(string_vector1, string_vector2, sep=" - ")
```

    ## Warning in stri_c(..., sep = sep, collapse = collapse, ignore_null = TRUE): longer object length is not a
    ## multiple of shorter object length

    ## [1] "A - 1" "B - 2" "C - 3" "A - 4" "B - 5"

The code produces a warning but otherwise runs. In the output, you can
see that the elements of the shorter vector have been repeated when
combined with the additional elements of the longer vector.

## Extracting and replacing substrings

Selecting part of a string can be done using the `str_sub()` function.
The `start` and `end` arguments are used to define the position of the
substring you want to extract.

``` r
# Extracting substrings based on the position within the string
x <- c("First value", "Second value", "Third value")
stringr::str_sub(x, start=1, end=3)
```

    ## [1] "Fir" "Sec" "Thi"

``` r
# Negative values for the start and end count backwards from the end of the string
stringr::str_sub(x, start=-5, end=-1)
```

    ## [1] "value" "value" "value"

------------------------------------------------------------------------

You can also use `str_sub()` to help replace substrings:

``` r
# Replacing a substring based on the position within the string
stringr::str_sub(x, start=-5, end=-1) <- "item"
x
```

    ## [1] "First item"  "Second item" "Third item"

## Detecting a matched pattern

The `str_detect()` function can be used to check if part of a string
matches a particular pattern. For example, let’s say we wanted to check
if any strings in a character vector contain “blue”:

``` r
# Detecting the presence of the word 'blue' in a character vector
colours <- c("scarlet red", "ultramarine blue", "cadmium red", "cobalt blue", "cerulean blue")
stringr::str_detect(colours, "blue")
```

    ## [1] FALSE  TRUE FALSE  TRUE  TRUE

Because booleans (`TRUE` or `FALSE`) can be represented as numbers (1 or
0), you can apply some functions typically used for numbers to boolean
vectors:

``` r
# Count how many strings contain 'blue'
sum(stringr::str_detect(colours, "blue"))
```

    ## [1] 3

------------------------------------------------------------------------

There can be unintended consequences for pattern matching, let’s say we
wanted to find strings containing the colour “red” in another character
vector:

``` r
# Detecting the presence of the word 'red' in a character vector, with an unintended consequence
colours <- c("scarlet red", "ultramarine blue", "cadmium red", "cobalt blue", "weathered")
stringr::str_detect(colours, "red")
```

    ## [1]  TRUE FALSE  TRUE FALSE  TRUE

There are options to help deal with cases like this that we’ll visit
later on.

------------------------------------------------------------------------

### Regular expressions

Regular expressions (regex) are extremely helpful for pattern matching.
Since regex could be an entire course by itself, here we only introduce
a few basics to get started. See the [further reading](#further-reading)
section if you’re interested in learning more about regex.

There’s a common syntax for defining the patterns to match that can be
used across multiple programming languages. Here are a few patterns to
get started with:

-   `[A-Za-z]` — All uppercase and lowercase letters
-   `[0-9]` — All numbers
-   `[A-Za-z0-9]` — All letters and all numbers
-   `\\s` — A single space
-   `^a` — Begins with ‘a’
-   `a$` — Ends with ‘a’
-   `[^a]` — Anything other than ‘a’
-   `\\b` — A word boundary (e.g. a space, punctuation mark or the
    start/end of a string)

R also contains some pre-built regex classes that you might also
encounter, for example `[:alpha:]` to match any letters and `[:digit:]`
to match any numbers.

------------------------------------------------------------------------

We can use regex to help extract a more general pattern, such as only
strings that contain letters:

``` r
# Detect strings containing any letters using regex
colours <- c("1.", "ultramarine blue", "2. cadmium red", "cobalt blue", "-")
stringr::str_detect(colours, "[A-Za-z]")
```

    ## [1] FALSE  TRUE  TRUE  TRUE FALSE

Or only strings that contain letters or numbers:

``` r
stringr::str_detect(colours, "[A-Za-z0-9]")
```

    ## [1]  TRUE  TRUE  TRUE  TRUE FALSE

Or only strings that contain something other than letters, numbers, and
spaces:

``` r
stringr::str_detect(colours, "[^[A-Za-z0-9\\s]]")
```

    ## [1]  TRUE FALSE  TRUE FALSE  TRUE

------------------------------------------------------------------------

We can revisit the example from earlier, where we wanted to identify
strings containing the colour “red”:

``` r
# Detecting the presence of the word 'red' in a character vector, with help from regex
colours <- c("scarlet red", "ultramarine blue", "cadmium red", "cobalt blue", "weathered")
stringr::str_detect(colours, "\\bred\\b")
```

    ## [1]  TRUE FALSE  TRUE FALSE FALSE

The word boundary regex allows us to exclude words like “weathered” when
looking for the word “red”.

## Extracting a matched pattern

We can use the `str_extract()` function to extract strings that match a
particular pattern:

``` r
# Extracting substrings based on a matched pattern
colours <- c("scarlet red", "ultramarine blue", "cadmium red", "cobalt blue", "cerulean blue")
stringr::str_extract(colours, "blue")
```

    ## [1] NA     "blue" NA     "blue" "blue"

## Replacing a matched pattern

You can use the `str_replace()` and `str_replace_all()` functions to
find and replace parts of a string. `str_replace()` replaces the first
instance of the pattern, whereas `str_replace_all()` replaces all
instances of the pattern. Here’s an alternative version of an example we
saw earlier, using a different approach to replace “value” with “item”:

``` r
x <- c("First value", "Second value", "Third value")
# Replace 'value' with 'item'
stringr::str_replace(x, "value", "item")
```

    ## [1] "First item"  "Second item" "Third item"

------------------------------------------------------------------------

Regular expressions are also useful for string replacement. Here’s a
example that replaces characters that aren’t letters or numbers with an
underscore:

``` r
colours <- c("scarlet...red", "ultramarine.blue", "cadmium_red", "cobalt blue", "cerulean-blue")

# Replace the first character that isn't a letter or number with an underscore
stringr::str_replace(colours, "[^[A-Za-z0-9]]", "_")
```

    ## [1] "scarlet_..red"    "ultramarine_blue" "cadmium_red"      "cobalt_blue"      "cerulean_blue"

``` r
# Replace all characters that aren't a letter or number with an underscore
stringr::str_replace_all(colours, "[^[A-Za-z0-9]]", "_")
```

    ## [1] "scarlet___red"    "ultramarine_blue" "cadmium_red"      "cobalt_blue"      "cerulean_blue"

In the first example only the first match in each string has been
replaced with an underscore, whereas in the second example all matches
have been replaced.

------------------------------------------------------------------------

### Exercise 1

Remove all spaces from the following string:

``` r
string <- "The quick brown fox jumps over the lazy dog."
```

**Hint:** You can remove a matched pattern by replacing it with an empty
string (`""`).

------------------------------------------------------------------------

# Further Reading

## Further Reading

### General

-   [Bonus
    examples](https://github.com/moj-analytical-services/intro_r_training_extension#bonus-examples)
-   [R for Data Science](https://r4ds.had.co.nz)
-   [Advanced R](https://adv-r.hadley.nz)
-   [Tidyverse website](https://www.tidyverse.org)
-   [Tidyverse style guide](https://style.tidyverse.org/) (has some
    guidance on choosing function and argument names)
-   [MoJ Analytical Platform
    Guidance](https://user-guidance.services.alpha.mojanalytics.xyz)
-   [MoJ coding
    standards](https://moj-analytical-services.github.io/our-coding-standards/)

------------------------------------------------------------------------

### Conditional statements

-   [Advanced R - choices
    section](https://adv-r.hadley.nz/control-flow.html#choices)

### Iteration

-   [R for Data Science - iteration
    chapter](https://r4ds.had.co.nz/iteration.html)
-   [Advanced R - loops
    section](https://adv-r.hadley.nz/control-flow.html#loops)

### Reshaping data

-   [Tidyverse website - pivoting
    section](https://tidyr.tidyverse.org/dev/articles/pivot.html)
-   [R for Data Science - pivoting
    chapter](https://r4ds.had.co.nz/tidy-data.html#pivoting)

### Strings and regex

-   [R for Data Science - strings
    chapter](https://r4ds.had.co.nz/strings.html)
-   [stringr and regex
    cheatsheet](https://evoldyn.gitlab.io/evomics-2018/ref-sheets/R_strings.pdf)
-   [Regex Coffee & Coding
    session](https://github.com/moj-analytical-services/Coffee-and-Coding/tree/master/2019-03-13%20Regex)

# Bonus examples

Let’s take a look at a few more examples and tackle some problems that
we might encounter as an analyst in MoJ.

## Example 1 - reshaping

Let’s look at an example with some aggregate data based on the
`offenders` dataset:

``` r
offenders_summary <- offenders %>%
  group_by(REGION, SENTENCE) %>%
  summarise(offender_count = n())
```

    ## `summarise()` has grouped output by 'REGION'. You can override using the `.groups` argument.

``` r
offenders_summary
```

    ## # A tibble: 12 × 3
    ## # Groups:   REGION [4]
    ##    REGION SENTENCE    offender_count
    ##    <chr>  <chr>                <int>
    ##  1 East   Court_order            211
    ##  2 East   Prison_<12m            108
    ##  3 East   Prison_12m+             33
    ##  4 North  Court_order            219
    ##  5 North  Prison_<12m             94
    ##  6 North  Prison_12m+             45
    ##  7 South  Court_order            235
    ##  8 South  Prison_<12m            115
    ##  9 South  Prison_12m+             28
    ## 10 West   Court_order            191
    ## 11 West   Prison_<12m            100
    ## 12 West   Prison_12m+             34

### Transforming from long to wide format

The above summary dataframe could be described as being in a ‘long’
format - where there are minimal columns and lots of rows. This format
tends not to be used for presenting data, as it is more difficult to
look at and interpret. Therefore wider formats are often used to display
data, where there are more columns but fewer rows. We can use the
`pivot_wider()` function from tidyr to help us transform from a long
format to a wide format, like so:

``` r
offenders_summary <- offenders_summary %>%
  tidyr::pivot_wider(names_from = "SENTENCE", values_from = "offender_count")

offenders_summary
```

    ## # A tibble: 4 × 4
    ## # Groups:   REGION [4]
    ##   REGION Court_order `Prison_<12m` `Prison_12m+`
    ##   <chr>        <int>         <int>         <int>
    ## 1 East           211           108            33
    ## 2 North          219            94            45
    ## 3 South          235           115            28
    ## 4 West           191           100            34

In the `names_from` argument of `pivot_wider()`, we’ve specifed that we
want to create new columns based on the different categories in the
`SENTENCE` column - so there will be one new column for each of the
three categories that appear in `SENTENCE`. Then we use the
`values_from` argument to specify that we want values from the
`offender_count` column to go into those new columns.

### Transforming from wide to long format

In order to reverse the reshaping that we’ve just done, and go back from
a wide format to a long format, we can use the `pivot_longer()`
function:

``` r
offenders_summary <- offenders_summary %>%
  tidyr::pivot_longer(cols = -REGION, names_to = "SENTENCE", values_to = "offender_count")

offenders_summary
```

    ## # A tibble: 12 × 3
    ## # Groups:   REGION [4]
    ##    REGION SENTENCE    offender_count
    ##    <chr>  <chr>                <int>
    ##  1 East   Court_order            211
    ##  2 East   Prison_<12m            108
    ##  3 East   Prison_12m+             33
    ##  4 North  Court_order            219
    ##  5 North  Prison_<12m             94
    ##  6 North  Prison_12m+             45
    ##  7 South  Court_order            235
    ##  8 South  Prison_<12m            115
    ##  9 South  Prison_12m+             28
    ## 10 West   Court_order            191
    ## 11 West   Prison_<12m            100
    ## 12 West   Prison_12m+             34

The `cols` argument of `pivot_longer()` has been set to `-REGION`, which
means that all columns apart from `REGION` will be reshaped. Then the
`names_to` argument is used to specify that we want the names of those
columns to go into a new column called `SENTENCE`, and the `values_to`
argument is used to specify that we want the values in those column to
go into a new column called `offender_count`.

## Example 2

``` r
# Read data
prosecutions_and_convictions <- Rs3tools::s3_path_to_full_df(
  s3_path = "alpha-r-training/writing-functions-in-r/prosecutions-and-convictions-2018.csv"
)

# Filter for Magistrates Court to extract the prosecutions
prosecutions <- prosecutions_and_convictions %>%
  filter(`Court.Type` == "Magistrates Court")
```

The following code is used to prepare a table that will form the basis
of this example. This table will show the number of prosecutions over
time for each offence group.

``` r
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
```

    ## `summarise()` has grouped output by 'Year', 'Offence.Type'. You can override using the `.groups` argument.

``` r
# This removes repeated row labels, to replicate how this data might be displayed in Excel
time_series$Offence.Type[duplicated(time_series$Offence.Type)] <- NA

time_series
```

    ## # A tibble: 22 × 7
    ##    Offence.Type       Offence.Group                           `2014` `2015` `2016` `2017` `2018`
    ##    <chr>              <chr>                                    <int>  <int>  <int>  <int>  <int>
    ##  1 01 Indictable only 01 Violence against the person            7447   6930   6724   7233   6602
    ##  2 <NA>               02 Sexual offences                        5289   5743   5610   4941   2930
    ##  3 <NA>               03 Robbery                                9049   7236   6024   5953   5713
    ##  4 <NA>               04 Theft Offences                         1726   1465   1265   1345   1097
    ##  5 <NA>               05 Criminal damage and arson               711    738    647    648    563
    ##  6 <NA>               06 Drug offences                             0      0     42    211     75
    ##  7 <NA>               07 Possession of weapons                   729    776    860    776    912
    ##  8 <NA>               08 Public order offences                    27     68    665    773    842
    ##  9 <NA>               09 Miscellaneous crimes against society   3648   3054   2930   2763   2277
    ## 10 <NA>               10 Fraud Offences                          421    460    408    379    173
    ## # … with 12 more rows

Let’s imagine we received a dataset in the above format, and we wanted
to calculate the total number of prosecutions over the past 5 years for
each offence type and group. In the current format, we’d need to sum the
values in the columns `2013` - `2018`. We could do something like this:

``` r
total <- (time_series$`2014` + time_series$`2015` + time_series$`2016` +
          time_series$`2017` + time_series$`2018`)

time_series_with_total <- time_series
time_series_with_total$Total <- total

time_series_with_total
```

    ## # A tibble: 22 × 8
    ##    Offence.Type       Offence.Group                           `2014` `2015` `2016` `2017` `2018` Total
    ##    <chr>              <chr>                                    <int>  <int>  <int>  <int>  <int> <int>
    ##  1 01 Indictable only 01 Violence against the person            7447   6930   6724   7233   6602 34936
    ##  2 <NA>               02 Sexual offences                        5289   5743   5610   4941   2930 24513
    ##  3 <NA>               03 Robbery                                9049   7236   6024   5953   5713 33975
    ##  4 <NA>               04 Theft Offences                         1726   1465   1265   1345   1097  6898
    ##  5 <NA>               05 Criminal damage and arson               711    738    647    648    563  3307
    ##  6 <NA>               06 Drug offences                             0      0     42    211     75   328
    ##  7 <NA>               07 Possession of weapons                   729    776    860    776    912  4053
    ##  8 <NA>               08 Public order offences                    27     68    665    773    842  2375
    ##  9 <NA>               09 Miscellaneous crimes against society   3648   3054   2930   2763   2277 14672
    ## 10 <NA>               10 Fraud Offences                          421    460    408    379    173  1841
    ## # … with 12 more rows

But what if we want to re-use the code in the future? We’d need to
generalise it for different years or a different number of years.
Fortunately we can restructure the data to help with this problem.

First let’s deal with the empty row labels in the `Offence.Type` column.
Although avoiding repeated row labels looks neater in an Excel table, it
can be problematic for analysis. Fortunately we can easily fill the row
labels in using the `fill()` function from tidyr:

``` r
time_series <- time_series %>% tidyr::fill(Offence.Type)
time_series
```

    ## # A tibble: 22 × 7
    ##    Offence.Type       Offence.Group                           `2014` `2015` `2016` `2017` `2018`
    ##    <chr>              <chr>                                    <int>  <int>  <int>  <int>  <int>
    ##  1 01 Indictable only 01 Violence against the person            7447   6930   6724   7233   6602
    ##  2 01 Indictable only 02 Sexual offences                        5289   5743   5610   4941   2930
    ##  3 01 Indictable only 03 Robbery                                9049   7236   6024   5953   5713
    ##  4 01 Indictable only 04 Theft Offences                         1726   1465   1265   1345   1097
    ##  5 01 Indictable only 05 Criminal damage and arson               711    738    647    648    563
    ##  6 01 Indictable only 06 Drug offences                             0      0     42    211     75
    ##  7 01 Indictable only 07 Possession of weapons                   729    776    860    776    912
    ##  8 01 Indictable only 08 Public order offences                    27     68    665    773    842
    ##  9 01 Indictable only 09 Miscellaneous crimes against society   3648   3054   2930   2763   2277
    ## 10 01 Indictable only 10 Fraud Offences                          421    460    408    379    173
    ## # … with 12 more rows

Now we need to transform this dataframe into a long format, using
`pivot_longer()`:

``` r
time_series_long <- time_series %>%
  tidyr::pivot_longer(cols = -c("Offence.Type", "Offence.Group"), names_to = "year", values_to = "count")

time_series_long
```

    ## # A tibble: 110 × 4
    ##    Offence.Type       Offence.Group                  year  count
    ##    <chr>              <chr>                          <chr> <int>
    ##  1 01 Indictable only 01 Violence against the person 2014   7447
    ##  2 01 Indictable only 01 Violence against the person 2015   6930
    ##  3 01 Indictable only 01 Violence against the person 2016   6724
    ##  4 01 Indictable only 01 Violence against the person 2017   7233
    ##  5 01 Indictable only 01 Violence against the person 2018   6602
    ##  6 01 Indictable only 02 Sexual offences             2014   5289
    ##  7 01 Indictable only 02 Sexual offences             2015   5743
    ##  8 01 Indictable only 02 Sexual offences             2016   5610
    ##  9 01 Indictable only 02 Sexual offences             2017   4941
    ## 10 01 Indictable only 02 Sexual offences             2018   2930
    ## # … with 100 more rows

Now we’re ready to find the total for each offence group using
`group_by()` and `summarise()` from dplyr:

``` r
totals <- time_series_long %>%
  group_by(Offence.Type, Offence.Group) %>%
  summarise(Total = sum(count))
```

    ## `summarise()` has grouped output by 'Offence.Type'. You can override using the `.groups` argument.

``` r
totals
```

    ## # A tibble: 22 × 3
    ## # Groups:   Offence.Type [5]
    ##    Offence.Type       Offence.Group                           Total
    ##    <chr>              <chr>                                   <int>
    ##  1 01 Indictable only 01 Violence against the person          34936
    ##  2 01 Indictable only 02 Sexual offences                      24513
    ##  3 01 Indictable only 03 Robbery                              33975
    ##  4 01 Indictable only 04 Theft Offences                        6898
    ##  5 01 Indictable only 05 Criminal damage and arson             3307
    ##  6 01 Indictable only 06 Drug offences                          328
    ##  7 01 Indictable only 07 Possession of weapons                 4053
    ##  8 01 Indictable only 08 Public order offences                 2375
    ##  9 01 Indictable only 09 Miscellaneous crimes against society 14672
    ## 10 01 Indictable only 10 Fraud Offences                        1841
    ## # … with 12 more rows

If we wanted to add these totals to our original dataframe, we can use
`left_join()` from dplyr:

``` r
time_series <- dplyr::left_join(time_series, totals, by=c("Offence.Type", "Offence.Group"))

time_series
```

    ## # A tibble: 22 × 8
    ##    Offence.Type       Offence.Group                           `2014` `2015` `2016` `2017` `2018` Total
    ##    <chr>              <chr>                                    <int>  <int>  <int>  <int>  <int> <int>
    ##  1 01 Indictable only 01 Violence against the person            7447   6930   6724   7233   6602 34936
    ##  2 01 Indictable only 02 Sexual offences                        5289   5743   5610   4941   2930 24513
    ##  3 01 Indictable only 03 Robbery                                9049   7236   6024   5953   5713 33975
    ##  4 01 Indictable only 04 Theft Offences                         1726   1465   1265   1345   1097  6898
    ##  5 01 Indictable only 05 Criminal damage and arson               711    738    647    648    563  3307
    ##  6 01 Indictable only 06 Drug offences                             0      0     42    211     75   328
    ##  7 01 Indictable only 07 Possession of weapons                   729    776    860    776    912  4053
    ##  8 01 Indictable only 08 Public order offences                    27     68    665    773    842  2375
    ##  9 01 Indictable only 09 Miscellaneous crimes against society   3648   3054   2930   2763   2277 14672
    ## 10 01 Indictable only 10 Fraud Offences                          421    460    408    379    173  1841
    ## # … with 12 more rows

Now we’ve managed to calculate the total number of prosecutions over the
past 5 years, without needing to hard-code the names of those years.
This means that the code can be re-used in future years without needing
to be edited.

# Appendix

## Table of operators

| Operator | Definition                    |
|:--------:|:------------------------------|
|    ==    | Equal to                      |
|    !=    | Not equal to                  |
|    \>    | Greater than                  |
|    \<    | Less than                     |
|   \>=    | Greater than or equal to      |
|   \<=    | Less than or equal to         |
|    ǀ     | Or                            |
|    &     | And                           |
|    !     | Not                           |
|   %in%   | The subject appears in a list |
| is.na()  | The subject is NA             |

## Regex patterns

`[A-Za-z]` or `[:alpha:]` \| All uppercase and lowercase letters  
`[0-9]` or `[:digit:]` \| All numbers  
`[A-Za-z0-9]` or `[:alnum:]` \| All letters and all numbers  
`\\s` or `[:space:]` \| A single space  
`^a` \| Begins with ‘a’  
`a$` \| Ends with ‘a’  
`[^a]` \| Anything other than ‘a’  
`\\b` \| A word boundary (e.g. a space, punctuation mark or the
start/end of a string)
