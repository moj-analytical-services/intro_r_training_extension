Introduction to conditional statements and loops in R
================

## Setup

For those of you who’d like to ‘code along’ and attempt the exercises,
please make sure you’ve:

1.  Got access to the `alpha-r-training` s3 bucket
2.  Cloned the [C&C
    repo](https://github.com/moj-analytical-services/Coffee-and-Coding)
    (or copied example_code.R into your RStudio) - instructions on
    cloning from GitHub can be found
    [here](https://user-guidance.services.alpha.mojanalytics.xyz/github.html#r-studio)
3.  Installed the packages `tidyverse` and `botor` - see guidance on how
    to do this
    [here](https://user-guidance.services.alpha.mojanalytics.xyz/appendix/botor.html#installation)
4.  Opened `example_code.R` in RStudio
5.  Opened the [C&C
    repo](https://github.com/moj-analytical-services/Coffee-and-Coding/tree/master/2022-03-09%20Introduction%20to%20conditional%20statements%20and%20loops%20in%20R)
    on GitHub, so you can refer to the session material in the README

## Introduction

This Coffee and Coding session is trialling some new material that will
build on the original [Introduction to R training
course](https://github.com/moj-analytical-services/IntroRTraining),
therefore we appreciate any feedback.

In this session we’ll cover two fundamentals of programming in R:
conditional statements and loops. These two topics come under the
umbrella of ‘control flow’, which refers to how we can change the order
that pieces of code are run in. With conditional statements we can
introduce choices, where different pieces of code are run depending on
the input, and loops allow us to repeatedly run the same piece of code.

### By the end of this session you should know how to:

-   Change what the code does based on a condition
-   Classify values in a dataframe, based on a set of conditions
-   Read and combine data from multiple csv files
-   Easily apply a function to multiple columns in a dataframe

## Before we start

To follow along with the code and participate in the exercises, open the
script “example_code.R” in RStudio. All the code that we’ll show in this
session is stored in “example_code.R”, and you can edit this script to
write solutions to the exercises. You may also want to have the [session
material](https://github.com/moj-analytical-services/Coffee-and-Coding/tree/master/2022-03-09%20Introduction%20to%20conditional%20statements%20and%20loops%20in%20R)
open as a reference.

First, we need to load a few packages:

``` r
# Load packages
library(botor) # Used to help R interact with s3 cloud storage
library(dplyr) # Used for data manipulation
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
offenders <- botor::s3_read(
  "s3://alpha-r-training/intro-r-training/Offenders_Chicago_Police_Dept_Main.csv", read.csv
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

------------------------------------------------------------------------

### Exercise

Add a column called ‘COURT_ORDER’ to the `offenders` dataframe. The
column should contain a ‘1’ if the offender received a court order, or a
‘0’ otherwise, based on the categories in the ‘SENTENCE’ column.

**Hint:** you’ll need to apply the `if_else()` function with `mutate()`.

------------------------------------------------------------------------

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
the example above, if none of the conditions are met, then a value of
`"Unknown"` is assigned.

------------------------------------------------------------------------

### Exercise

Add a column called ‘PREV_CONVICTIONS_BAND’ to the `offenders`
dataframe. The column should contain the following categories: ‘0’,
‘1-5’, ‘6-10’, ‘\>10’, based on the number of convictions given in the
‘PREV_CONVICTIONS’ column.

**Hint:** you’ll need to use the `case_when()` function with `mutate()`.

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

------------------------------------------------------------------------

### Exercise

Write a for loop to print “The current date is …” for each date in the
following string vector:

``` r
dates <- c("2020-03-01", "2020-06-01", "2020-09-01", "2020-12-01")
```

**Hint:** You can use the `paste()` function to join strings together,
and the `print()` function to print the result in the Console.

------------------------------------------------------------------------

## More options with for loops

### Iterating over the index of a vector

If you wanted to get an index number for each element of the iterable,
you can use the `seq_along()` function. For example:

``` r
fruits <- c("strawberry", "apple", "pear", "orange")

# Iterating over the indices of a vector
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
files <- botor::s3_ls("s3://alpha-r-training/intro-r-extension")

# Get a list of csv file names
files <- files %>%
  dplyr::filter(grepl(".csv", uri)) %>%
  dplyr::pull(uri)

files
```

    ## [1] "s3://alpha-r-training/intro-r-extension/fruit1.csv"
    ## [2] "s3://alpha-r-training/intro-r-extension/fruit2.csv"
    ## [3] "s3://alpha-r-training/intro-r-extension/fruit3.csv"

------------------------------------------------------------------------

Now we can use a for loop to read in each file as a dataframe, and add
each dataframe to a list. After the for loop, the `bind_rows()` function
from dplyr can be used to combine the data into a single dataframe.

``` r
# First define an empty list to be filled by the loop
fruit_list <- vector("list", length(files))

# Loop over each file, and add the data to a list
for (i in seq_along(files)) {
  fruit_list[[i]] <- botor::s3_read(files[i], readr::read_csv, show_col_types = FALSE)
}

# Combine the list of dataframes into a single dataframe
fruit <- dplyr::bind_rows(fruit_list)
fruit
```

    ## # A tibble: 9 × 4
    ##   Item      `Cost-Jan` `Cost-Feb` `Cost-Mar`
    ##   <chr>          <dbl>      <dbl>      <dbl>
    ## 1 Orange          0.56       0.5        0.57
    ## 2 Apple           0.42       0.51       0.49
    ## 3 Banana          0.15       0.17       0.21
    ## 4 Lemon           0.3        0.32       0.35
    ## 5 Pear            0.41       0.39       0.44
    ## 6 Melon           1.1        1.15       1.11
    ## 7 Pineapple       1.18       1.19       1.24
    ## 8 Peach           0.55       0.53       0.58
    ## 9 Plum            0.38       0.41       0.41

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

    ## # A tibble: 9 × 4
    ##   Item      `Cost-Jan` `Cost-Feb` `Cost-Mar`
    ##   <chr>          <dbl>      <dbl>      <dbl>
    ## 1 ORANGE          0.56       0.5        0.57
    ## 2 APPLE           0.42       0.51       0.49
    ## 3 BANANA          0.15       0.17       0.21
    ## 4 LEMON           0.3        0.32       0.35
    ## 5 PEAR            0.41       0.39       0.44
    ## 6 MELON           1.1        1.15       1.11
    ## 7 PINEAPPLE       1.18       1.19       1.24
    ## 8 PEACH           0.55       0.53       0.58
    ## 9 PLUM            0.38       0.41       0.41

------------------------------------------------------------------------

We can also use `mutate()` to apply a function to multiple columns in
one go by combining it with the `across()` function from dplyr. This
example demonstrates how to multiply the values in all numeric columns
by 100:

``` r
fruit_pence <- fruit %>% dplyr::mutate(across(where(is.numeric), ~ .x * 100))
fruit_pence
```

    ## # A tibble: 9 × 4
    ##   Item      `Cost-Jan` `Cost-Feb` `Cost-Mar`
    ##   <chr>          <dbl>      <dbl>      <dbl>
    ## 1 ORANGE            56         50         57
    ## 2 APPLE             42         51         49
    ## 3 BANANA            15         17         21
    ## 4 LEMON             30         32         35
    ## 5 PEAR              41         39         44
    ## 6 MELON            110        115        111
    ## 7 PINEAPPLE        118        119        124
    ## 8 PEACH             55         53         58
    ## 9 PLUM              38         41         41

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
function to round values in all numeric columns to 1 decimal place:

``` r
rounded_fruit <- fruit %>% dplyr::mutate(across(where(is.numeric), signif, 1))

rounded_fruit
```

    ## # A tibble: 9 × 4
    ##   Item      `Cost-Jan` `Cost-Feb` `Cost-Mar`
    ##   <chr>          <dbl>      <dbl>      <dbl>
    ## 1 ORANGE           0.6        0.5        0.6
    ## 2 APPLE            0.4        0.5        0.5
    ## 3 BANANA           0.2        0.2        0.2
    ## 4 LEMON            0.3        0.3        0.4
    ## 5 PEAR             0.4        0.4        0.4
    ## 6 MELON            1          1          1  
    ## 7 PINEAPPLE        1          1          1  
    ## 8 PEACH            0.6        0.5        0.6
    ## 9 PLUM             0.4        0.4        0.4

Note: When the `signif()` function is passed as an argument to
`across()`, the brackets aren’t included (i.e. `signif` is passed rather
than `signif()`). This means that any arguments for `signif` need to be
included as extra arguments for `across()` instead (i.e. putting
`signif, 1` rather than `signif(1)` when using with `across()`).

# Further Reading

## Further Reading

### General

-   [Tidyverse website](https://www.tidyverse.org)
-   [MoJ Analytical Platform
    Guidance](https://user-guidance.services.alpha.mojanalytics.xyz)
-   [MoJ coding
    standards](https://moj-analytical-services.github.io/our-coding-standards/)

### Conditional statements

-   [Advanced R - choices
    section](https://adv-r.hadley.nz/control-flow.html#choices)

### Iteration

-   [R for Data Science - iteration
    chapter](https://r4ds.had.co.nz/iteration.html)
-   [Advanced R - loops
    section](https://adv-r.hadley.nz/control-flow.html#loops)

# Any questions?
