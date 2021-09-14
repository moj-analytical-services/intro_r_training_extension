Introduction to R extension
================

This repository is for Introduction to R extension course offered by the
DASD R Training Group.

The session is intended to be accessible to anyone who is familiar with
the content of the [Introduction to
R](https://github.com/moj-analytical-services/IntroRTraining) training
session.

If you have any feedback on the content, please get in touch\!

## Contents

  - [Pre-material](#pre-material)
  - [Learning outcomes](#learning-outcomes)
  - [Conditional statements](#conditional-statements)
  - [Handling missing data](#handling-missing-data)
  - [Iteration](#iteration)
  - [Reshaping data](#reshaping-data)
  - [String manipulation](#string-manipulation)
  - [Further reading](#further-reading)
  - [Real world examples](#real-world-examples)
  - [Appendix](#appendix)

## Pre-material

A few days before the session, please make sure that -

1.  You have access to RStudio on the Analytical Platform
2.  You have access to the [alpha-r-training s3
    bucket](https://cpanel-master.services.alpha.mojanalytics.xyz/datasources/607/)
3.  You have followed the steps in the [Configure Git and Github section
    of the Platform User
    Guidance](https://user-guidance.services.alpha.mojanalytics.xyz/introduction.html#configure-git-and-github)
    to configure Git and GitHub (this only needs doing once)
4.  You have cloned this repository (instructions are in the Analytical
    Platform User Guidance
    [here](https://user-guidance.services.alpha.mojanalytics.xyz/github.html#creating-your-project-repo-on-github))

If you have any problems with the above please get in touch with the
course organisers or ask for help on either the \#analytical\_platform
or \#intro\_r channel on [ASD slack](https://asdslack.slack.com).

All the examples in the presentation/README are available in the R
script example\_code.R.

# Introduction

This course builds on the original Introduction to R training course,
and covers additional programming concepts. It provides examples that
demonstrate how the Tidyverse packages can assist with tasks typically
encountered in DASD.

## Learning outcomes

### By the end of this session you should know how to:

  - Classify a variable in a dataframe, based on a set of conditions
  - Apply a function to multiple columns in a dataframe
  - Search for a string pattern in a dataframe
  - Reshape dataframes
  - Deal with missing values in a dataframe

## Before we start

To follow along with the code run during this session and participate in
the exercises, open the script “example\_code.R” in RStudio. All the
code that we’ll show in this session is stored in “example\_code.R”, and
you can edit this script to write solutions to the exercises. You may
also want to have the course [read
me](https://github.com/moj-analytical-services/intro_r_training_extension)
open as a reference.

First, we need to load a few packages and an example dataset.

``` r
# Load packages
library(s3tools)
library(dplyr)
library(tidyr)
library(stringr)
```

``` r
# Read data
offenders <- s3tools::s3_path_to_full_df("alpha-r-training/intro-r-training/Offenders_Chicago_Police_Dept_Main.csv")
```

# Conditional statements

## if…else statements

Conditional statements can be used when you want a piece of code to be
executed only if a particular condition is met. The most basic form of
these are ‘if…else’ statements. As a simple example, let’s say we wanted
to check if a variable `x` is less than 10. We can write something like:

``` r
x <- 9

if (x < 10) {
  print("x is less than 10")
}
```

    ## [1] "x is less than 10"

We can also specify if we want something different to happen if the
condition is not met:

``` r
x <- 11

if (x < 10) {
  print("x is less than 10")
} else {
  print("x is 10 or greater")
}
```

    ## [1] "x is 10 or greater"

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

For the conditions themselves, we can make use of any of R’s relational
and logical operators. For a list of common operators, see the
[appendix](#table-of-operators).

## Vectorising an if…else statement

Dplyr’s `if_else()` function is useful if we want to apply an ‘if…else’
statement to a vector, rather than a single variable. When we use
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
x <- c(0, 74, 0, 8, 23, 15, 3, 0, 0, 9)

dplyr::if_else(x > 0, 1, 0)
```

    ##  [1] 0 1 0 1 1 1 1 0 0 1

When we’re manipulating dataframes, it can be useful to combine
`if_else()` with the `mutate()` function from dplyr. If we take a look
at the `offenders` dataframe, let’s say we wanted a simple way to be
able to separate youths from adult offenders. We can add a column that
contains ‘Youth’ if the offender is under the age of 18, and ‘Adult’
otherwise:

``` r
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

### Exercise

Add a column called ‘PRISON\_SENTENCE’ to the `offenders` dataframe. The
column should contain a ‘1’ if the offender received a prison sentence,
or a ‘0’ if the offender received a court order.

**Hint:** you’ll need to apply the `dplyr::if_else()` function to the
‘SENTENCE’ column.

-----

## Vectorising multiple if…else statements

In the previous section we saw how we can apply a single condition to a
vector, but what if we want to apply several conditions, each with a
different outcome, at the same time? We can use the `case_when()`
function from dplyr to do this.

Let’s say that we wanted to add a column to the `offenders` dataframe
with an age band for each offender. We could do something like this:

``` r
offenders <- offenders %>%
  dplyr::mutate(age_band = dplyr::case_when(
    AGE < 18 ~ "<18",
    AGE < 25 ~ "18-24",
    AGE < 35 ~ "25-34",
    AGE < 45 ~ "35-44",
    AGE < 55 ~ "45-54",
    AGE < 65 ~ "55-64",
    AGE >= 65 ~ "65+",
    TRUE ~ "Unknown"
  ))

str(offenders)
```

    ## 'data.frame':    1413 obs. of  14 variables:
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
    ##  $ PRISON_SENTENCE : num  0 1 0 0 1 1 1 0 0 1 ...
    ##  $ age_band        : chr  "55-64" "55-64" "35-44" "45-54" ...

In the `case_when()` function, each argument should be a two-sided
formula. For each formula, the condition appears to the left of a ‘\~’
symbol, and on the right is the value to assign if the condition
evaluates to `TRUE`.

Note that the order of conditional statements in the `case_when()`
function is important if there are overlapping conditions. The
conditions will be evaluated in the order that they appear in, so in the
above example, the `case_when()` will first check if the person is under
18, then if they are under 25 (but 18 or over), and so on.

A default value can be assigned in the event that none of the conditions
are met. This is done by putting `TRUE` in the place of a condition. In
the example above, if none of the conditions are met, then a value of
`"Unknown"` is assigned.

### Exercise

Add a column called ‘PREV\_CONVICTIONS\_BAND’ to the `offenders`
dataframe. The column should contain the following categories: “0-1”,
“1-5”, “5-10”, “10+”, based on the number of convictions given in the
‘PREV\_CONVICTIONS’ column.

**Hint:** you’ll need to use the `dplyr::case_when()` function.

-----

# Handling missing data

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
x <- 7
is.na(x)
```

    ## [1] FALSE

``` r
x <- c(7, 23, 5, 14, NA, 1, 11, NA)
is.na(x)
```

    ## [1] FALSE FALSE FALSE FALSE  TRUE FALSE FALSE  TRUE

If instead you wanted to identify values that are not missing, then you
can combine `is.na()` with the ‘not’ operator, `!`, like so:

``` r
x <- c(7, 23, 5, 14, NA, 1, 11, NA)
!is.na(x)
```

    ## [1]  TRUE  TRUE  TRUE  TRUE FALSE  TRUE  TRUE FALSE

When working with dataframes, the `complete.cases()` function is useful
to check which rows are complete (i.e. the row doesn’t contain any
missing values):

``` r
df <- tibble::tibble(
  "x" = c(0, 1, 2, NA, 4),
  "y" = c(18, NA, 45, 15, 2),
)

complete.cases(df)
```

    ## [1]  TRUE FALSE  TRUE FALSE  TRUE

### Exercise

For the following dataframe, use the `filter()` function from dplyr with
`complete.cases()` to extract the rows **with** missing values:

``` r
fruit <- tibble::tibble(
  "Item" = c("Orange", "Apple", "Banana", "Lemon", "Pear"),
  "Cost" = c(0.5, 0.4, 0.1, 0.3, NA),
  "Quantity" = c(23, NA, 15, 9, 11)
)
```

**Hint:** you can use a `.` inside the `complete.cases()` function to
apply it to all columns of the dataframe.

-----

## Handling missing values using a function argument

Some functions have built-in arguments where you can specify what you
want to happen to missing values. For example, the `sum()` function has
an argument called `na.rm` that you can use to specify if you want the
`NA` values to be removed before the sum is calculated. By default
`na.rm` is set to `FALSE`:

``` r
x <- c(7, 23, 5, 14, NA, 1, 11, NA)
sum(x)
```

    ## [1] NA

So if we try to sum over numeric vector that contains `NA` values, then
the result is `NA`. By setting `na.rm` to `TRUE`, however, we can remove
the `NA` values before continuing with the sum:

``` r
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
x <- c(7, 23, 5, -14, NA, -1, 11,NA)
replace(x, is.na(x), 0)
```

    ## [1]   7  23   5 -14   0  -1  11   0

The `replace()` function can also be applied to a whole dataframe, like
so:

``` r
df <- tibble::tibble(
  "x" = c(0, 1, 2, NA, 4),
  "y" = c(18, NA, 45, 15, 2),
)

df %>% replace(is.na(.), 0)
```

    ## # A tibble: 5 x 2
    ##       x     y
    ##   <dbl> <dbl>
    ## 1     0    18
    ## 2     1     0
    ## 3     2    45
    ## 4     0    15
    ## 5     4     2

The `replace_na()` function from tidyr also provides a convenient way to
replace missing values in a dataframe, and is especially useful if you
want to use different replacement values for different columns.

Here’s an example of how to use `replace_na()` with the `offenders`
dataframe, where we’re replacing missing values in the `HEIGHT` column
with ‘Unknown’:

``` r
offenders_replacena <- offenders %>%
  tidyr::replace_na(list(HEIGHT = "Unknown"))

offenders_replacena %>% arrange(desc(HEIGHT)) %>% str()
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
    ##  $ PRISON_SENTENCE      : num  0 1 1 0 0 1 0 0 0 1 ...
    ##  $ age_band             : chr  "25-34" "35-44" "25-34" "45-54" ...
    ##  $ PREV_CONVICTIONS_BAND: chr  "0-1" "0-1" "0-1" "0-1" ...

### Exercise

For the following dataframe, use the `replace_na()` function from tidyr
to replace missing values in the `Cost` column with “Unknown” and the
`Quantity` column with 0.

``` r
fruit <- tibble::tibble(
  "Item" = c("Orange", "Apple", "Banana", "Lemon", "Pear"),
  "Cost" = c(0.5, 0.4, 0.1, 0.3, NA),
  "Quantity" = c(23, NA, 15, 9, 11)
)
```

**Hint:** you add multiple arguments to `replace_na(list(...))`, with
one argument for each column where NA values need replacing.

-----

-----

### Replacing with values from another column

The `coalesce()` function from dplyr can be used to fill in missing
values with values from another column. Before we jump into an example,
let’s first prepare a dataframe:

``` r
event_dates <- tibble::tibble(
  "event_id" = c(0, 1, 2, 3, 4, 5),
  "date" = c("2016-04-13", "2015-12-29", "2016-06-02", "2017-01-27", "2015-10-21", "2018-03-15"),
  "new_date" = c("2016-08-16", NA, NA, "2017-03-02", NA, "2018-11-20")
)

event_dates
```

    ## # A tibble: 6 x 3
    ##   event_id date       new_date  
    ##      <dbl> <chr>      <chr>     
    ## 1        0 2016-04-13 2016-08-16
    ## 2        1 2015-12-29 <NA>      
    ## 3        2 2016-06-02 <NA>      
    ## 4        3 2017-01-27 2017-03-02
    ## 5        4 2015-10-21 <NA>      
    ## 6        5 2018-03-15 2018-11-20

We can use `coalesce()` to fill in the missing dates in the `new_date`
column with the equivalent date in the `date` column:

``` r
event_dates %>%
  dplyr::mutate(new_date = dplyr::coalesce(new_date, date))
```

    ## # A tibble: 6 x 3
    ##   event_id date       new_date  
    ##      <dbl> <chr>      <chr>     
    ## 1        0 2016-04-13 2016-08-16
    ## 2        1 2015-12-29 2015-12-29
    ## 3        2 2016-06-02 2016-06-02
    ## 4        3 2017-01-27 2017-03-02
    ## 5        4 2015-10-21 2015-10-21
    ## 6        5 2018-03-15 2018-11-20

### Replacing with the previous value in a column

If we were to encounter a dataframe like the following, where each group
name in the `year` column appears only once, then we might want to fill
in the missing labels before beginning any analysis.

``` r
# Construct the example dataframe
df <- tidyr::crossing(year = c("2015", "2016", "2017", "2018", "2019"),
                      quarter = c("Q1", "Q2", "Q3", "Q4")) %>%
      dplyr::mutate(count = sample(length(year)))

# This removes repeated row labels
df$year[duplicated(df$year)] <- NA

df
```

    ## # A tibble: 20 x 3
    ##    year  quarter count
    ##    <chr> <chr>   <int>
    ##  1 2015  Q1         19
    ##  2 <NA>  Q2          2
    ##  3 <NA>  Q3         10
    ##  4 <NA>  Q4         11
    ##  5 2016  Q1         15
    ##  6 <NA>  Q2          3
    ##  7 <NA>  Q3          7
    ##  8 <NA>  Q4         17
    ##  9 2017  Q1         12
    ## 10 <NA>  Q2          5
    ## 11 <NA>  Q3          8
    ## 12 <NA>  Q4          9
    ## 13 2018  Q1          4
    ## 14 <NA>  Q2         13
    ## 15 <NA>  Q3          6
    ## 16 <NA>  Q4         18
    ## 17 2019  Q1         14
    ## 18 <NA>  Q2         20
    ## 19 <NA>  Q3         16
    ## 20 <NA>  Q4          1

The `fill()` function from tidyr is a convenient way to do this, and can
be used like this:

``` r
df %>% tidyr::fill(year)
```

    ## # A tibble: 20 x 3
    ##    year  quarter count
    ##    <chr> <chr>   <int>
    ##  1 2015  Q1         19
    ##  2 2015  Q2          2
    ##  3 2015  Q3         10
    ##  4 2015  Q4         11
    ##  5 2016  Q1         15
    ##  6 2016  Q2          3
    ##  7 2016  Q3          7
    ##  8 2016  Q4         17
    ##  9 2017  Q1         12
    ## 10 2017  Q2          5
    ## 11 2017  Q3          8
    ## 12 2017  Q4          9
    ## 13 2018  Q1          4
    ## 14 2018  Q2         13
    ## 15 2018  Q3          6
    ## 16 2018  Q4         18
    ## 17 2019  Q1         14
    ## 18 2019  Q2         20
    ## 19 2019  Q3         16
    ## 20 2019  Q4          1

## Removing rows with missing values from a dataframe

The `drop_na()` function from tidyr allows us to easily remove rows
containing `NA` values from a dataframe. Let’s say we wanted to remove
all incomplete rows from the `offenders` dataset. We can either do this:

``` r
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
    ##  $ PRISON_SENTENCE      : num  0 1 0 0 1 1 1 0 0 1 ...
    ##  $ age_band             : chr  "55-64" "55-64" "35-44" "45-54" ...
    ##  $ PREV_CONVICTIONS_BAND: chr  "0-1" "0-1" "0-1" "0-1" ...

Or alternatively you can remove rows that contain `NA` values in
specific columns:

``` r
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
    ##  $ PRISON_SENTENCE      : num  0 1 0 0 1 1 1 0 0 1 ...
    ##  $ age_band             : chr  "55-64" "55-64" "35-44" "45-54" ...
    ##  $ PREV_CONVICTIONS_BAND: chr  "0-1" "0-1" "0-1" "0-1" ...

# Iteration and Loops

## Introduction

As part of any good coding practice is to reduce the number of
repetitive tasks as much as possible. To help with this concept any
programming language comes with a set of **control structures** to help
reduce clutter in the code and make it more readable and easier to
understand.

A general rule in programming is to never copy an paste code more than
twice; if you find that you are using repeated statements over and over
again, this is a good sign that either a loop or a function or both are
needed to make the code more compact and efficient.

Loops form part of the core of any programming platform and R is no
different here. In the section to follow we will cover the for loos and
its variants and explain a few things about `purrr` and how we can
iterate through lists using a variety of *maps*.

A note here similar to what was mentioned in previous chapters, the
content in this section can also be found in Hadley Wickham’s and
Garrett Grolemund’s book [R For Data Science](https://r4ds.had.co.nz)

## For Loops

The basics of how a for loop works can be understood best by using an
example. Consider the following tibble:

``` r
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
```

the task now is to calculate, for example, the mean or the median:

``` r
median(df$a)
```

    ## [1] -0.2400778

``` r
#> [1] -0.2457625
median(df$b)
```

    ## [1] -0.4167184

``` r
#> [1] -0.2873072
median(df$c)
```

    ## [1] 0.1073201

``` r
#> [1] -0.05669771
median(df$d)
```

    ## [1] 0.4126003

``` r
#> [1] 0.1442633
```

one way of doing this is by copying and pasting the same code over and
over again; inefficient, but possible at this stage. A much better way
is to construct a for loop and iterate through the code that is repeated
as above.

``` r
output <- vector("double", ncol(df))  # 1. output
for (i in seq_along(df)) {            # 2. sequence
  output[[i]] <- median(df[[i]])      # 3. body
}
output
```

    ## [1] -0.2400778 -0.4167184  0.1073201  0.4126003

``` r
#> [1] -0.24576245 -0.28730721 -0.05669771  0.14426335
```

In the example above the For loop has three primary components, the
*output*, the *sequence* and the *body*. The output is usually a list or
a vector where the result of the loop is to be stored. the sequence is a
vector or a list containing the collection of items to cycle through
while running. The iterator `i` is used as a place holder variable,
changing each time the loop runs to the corresponding value ion the
given sequence. As the loop runs `i` runs through all the values in the
`sequence` in the order they appear.

The body of the loop contains the code to run at each iteration. The
iterator `i` will be take the value of each element in the sequence on
each run.

### Exercises

1.  Write for loops to:

2.  Compute the mean of every column in mtcars.

3.  Determine the type of each column in nycflights13::flights.

4.  Compute the number of unique values in each column of iris.

5.  Generate 10 random normals from distributions with means of -10, 0,
    10, and 100.

Think about the output, sequence, and body before you start writing the
loop.

## For loop variants

Now that you know the basics of the for loop, it is time to see a few of
its variants and how they can be used in very common programming tasks.

There are 4 variants to consider here:

1.  Modifying an existing object on the spot.
2.  Looping over a list of names or values.
3.  Handling outputs of unknown length.
4.  Handling sequences of unknown length.

and we will cover each in the sections below.

### Modifying an existing object

In many cases there will be a need to modify a given object based on the
current data analysis task. In the example below the task is to scale
the data frame for further processing. On way to achieve this is by
manually change each column in the data; this could be fine for small
dataframes but for larger ones this will very quickly become a problem.

``` r
df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

df$a <- rescale01(df$a)
df$b <- rescale01(df$b)
df$c <- rescale01(df$c)
df$d <- rescale01(df$d)
```

A for loop in this case would be recommended as you will notice that the
same one line of code is repeated throughout. The code below illustrated
this concept.

More specifically the components of the for loop are:

  - The**output** - in this case we don’t output to a different object
    we just update the input. The output is the same as the input

  - The **sequence** - This will be the number of columns in `df` we
    want to run the code to. As previously the `seq_along` function will
    help us with this as it will count the number of columns and turn
    this into a sequence we can use in the for loop

  - The body of the loop is just the re scale one line of code running
    the defined `rescale01` function. It can be anything that will take
    the column as an argument to work with. Further restrictions would
    normally apply but we will not cover this here

The code below simplifies what we want to do and as you can see,
overall, we now have a much better structured and easier to read two
lines of code\!

``` r
for (i in seq_along(df)) {
  df[[i]] <- rescale01(df[[i]])
}
```

### Looping patterns

There are a couple of ways we can use to access the sequence part of the
**for** loop depending on the coding style and the needs of the project.
For example, in the code shown below, one could choose to loop over the
list of indices of a vector using `for(i in se_along(x)` or
alternatively iterate through the contents of the `results` vector using
`for(i in vowel)`. Both formulations are valid with the first one
allowing for more flexibility when it comes to accessing the resources
of the vector.

``` r
x = letters # vector of letters
vowel <- c('a', 'e', 'i', 'o', 'u')

results <- rnorm(length(x)) #create a random vector
names(results) <- x # name the elements of the vector 

## loop thourgh indices of a vector
## 
for(i in seq_along(x)){
  x1[i] = paste(x[i],"23")
}
```

    ## Error in eval(expr, envir, enclos): object 'x1' not found

``` r
## loop through contents of a vector
## 
for(i in vowel){
  print(results[i])
  }
```

    ##     a 
    ## 1.978 
    ##          e 
    ## -0.8572724 
    ##         i 
    ## -0.461322 
    ##          o 
    ## -0.1941412 
    ##         u 
    ## 0.6576127

### Handling outputs of unknown length

There are cases where the output from a loop is not known beforehand. In
these cases, certain precautions need to be taken as it may result in
clogging up the memory with vectors going out of control expanding
indefinitely.

``` r
a = 0 # initialize number

# run a sequence of random length vectros to be appended
for(i in seq_len(10)){
  n = sample(20,1)
  a = c(a,rnorm(n))
}
```

A better way to achieving the above result would be to create a list and
capture the results within each cell at each corresponding iteration.
The result would be a list with a predictable index length.

``` r
a = list() # initilise a list

# populate the contents of each cell of a list with a random size vector created in each iteration 
for(i in seq_len(10)){
  n = sample(20,1)
  a[[i]] = rnorm(n)
}
```

### Handling sequences of unknown length

In general, unknown sequence length translates to cases where we want to
check for certain condition in order to stop the execution of a block of
code. In these cases the use of the `while` loop is preferable as in the
example below.

``` r
## while loop definition

while (condition) {
  # body
}
```

Notice that the `while` loop execution differs that the `for` loop in
that the body of code is executed first before the condition is checked
and this is by design. One needs to first check the contents before
accessing the validity of the condition to terminate the loop.

``` r
# The loop will first execute the body of code and then check if the condition is satisfied. If this is the case the loop will stop its iteration.
while(mean(numbers) < 0.5){
  numbers = rnorm(20)
  print(mean(numbers))
}
```

    ## Error in mean(numbers): object 'numbers' not found

\#\#Exercises

1.  Imagine you have a directory full of files that you want to read in.
    You have the file names in the vector `files`, and now want to read
    each one. Write the for loop that will simulate reading them into a
    single data frame.

<!-- end list -->

``` r
# the following code will create a random colelction of file names

files = paste0(str_extract(sentences[1:5], "^[:alpha:]+"), sample(c(".csv",".xlsx")))
```

2.  What happens if you use `for (nm in names(x))` and x has no names?
    What if only some of the elements are named? What if the names are
    not unique?

<!-- end list -->

``` r
# try using the folling list of files 

files2 = paste0(str_extract(sentences[1:10], "^[:alpha:]+"), ".xlsx") 
files2[5] = NA
```

# Reshaping data

The tidyr package can help us to reshape dataframes - this can be really
helpful when we need to transform between tables that are easier to read
and tables that are easier to analyse. The aim here is to structure the
resulting datasets so that they could be manipulated easier in further
stages of the processing.

I should mention at this point that the source for the material
presented in this chapter can be found in this [pivoting
vignette](https://tidyr.tidyverse.org/dev/articles/pivot.html#generate-column-name-from-multiple-variables-1)
as well as in the book by the same author, Hadley Wickam, titled [R For
Data Sciecne](https://r4ds.had.co.nz/).

In many scenarios, although the data could be complete in the sense of
it containing the desired variables, it is not quite in the right format
requiring additional manipulation to bring it in line.

This is usually the case when the variables needed are originally
created as subcategories within a current variable. The process to
extract them results to **lengthening** or **widening** the original
dataset and this is commonly referred to as **pivoting**. It should also
be mentioned that pivoting (as a collection of tools) was created to
replace the existing `gather()` and `spread()` functions. This is not to
say that the old versions cannot be used anymore, its just that they
will no longer receive any updates from the developer given their more
advance counterparts.

As a general artifact of the reshaping process, the resulting data set
has either an increased number of rows or columns respectively.
Interpretation largely deepens on the project at hand where the current
stage of the system determines the optimal structure of the data to be
supplied.

## Lengthening the dataset

Consider the `billboard` dataset supplied with tidyr (should be in you
workspace when you load the package) containing the rank of songs for
the year 2000. Inspecting the dataset shows that there are in total 79
columns, one for each week (starting from Oct 1999) and also including a
few additional identifiers.

The aim now is to create a single variable to house the different weeks
in order to create a different representation of for the data. First we
start by the mapping the first month into a single variable.

``` r
?billboard

# notice the dimensions of the data
dim(billboard)
```

    ## [1] 317  79

``` r
#to see the structure of the data
billboard %>% arrange(desc(date.entered)) %>% tail()
```

    ## # A tibble: 6 x 79
    ##   artist track date.entered   wk1   wk2   wk3   wk4   wk5   wk6   wk7   wk8   wk9  wk10  wk11  wk12  wk13
    ##   <chr>  <chr> <date>       <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    ## 1 IMx    Stay… 1999-10-09      84    61    45    43    40    38    36    31    34    34    40    36    36
    ## 2 Train  Meet… 1999-10-09      76    67    59    54    48    45    40    32    26    24    22    21    21
    ## 3 Creed  High… 1999-09-11      81    77    73    63    61    58    56    52    56    57    57    57    57
    ## 4 Houst… My L… 1999-09-04      81    68    44    16    11     9     8     7     8     7     8     8     6
    ## 5 Amber  Sexu… 1999-07-17      99    99    96    96   100    93    93    96    NA    NA    99    NA    96
    ## 6 Lones… Amaz… 1999-06-05      81    54    44    39    38    33    29    29    32    27    26    24    27
    ## # … with 63 more variables: wk14 <dbl>, wk15 <dbl>, wk16 <dbl>, wk17 <dbl>, wk18 <dbl>, wk19 <dbl>,
    ## #   wk20 <dbl>, wk21 <dbl>, wk22 <dbl>, wk23 <dbl>, wk24 <dbl>, wk25 <dbl>, wk26 <dbl>, wk27 <dbl>,
    ## #   wk28 <dbl>, wk29 <dbl>, wk30 <dbl>, wk31 <dbl>, wk32 <dbl>, wk33 <dbl>, wk34 <dbl>, wk35 <dbl>,
    ## #   wk36 <dbl>, wk37 <dbl>, wk38 <dbl>, wk39 <dbl>, wk40 <dbl>, wk41 <dbl>, wk42 <dbl>, wk43 <dbl>,
    ## #   wk44 <dbl>, wk45 <dbl>, wk46 <dbl>, wk47 <dbl>, wk48 <dbl>, wk49 <dbl>, wk50 <dbl>, wk51 <dbl>,
    ## #   wk52 <dbl>, wk53 <dbl>, wk54 <dbl>, wk55 <dbl>, wk56 <dbl>, wk57 <dbl>, wk58 <dbl>, wk59 <dbl>,
    ## #   wk60 <dbl>, wk61 <dbl>, wk62 <dbl>, wk63 <dbl>, wk64 <dbl>, wk65 <dbl>, wk66 <lgl>, wk67 <lgl>,
    ## #   wk68 <lgl>, wk69 <lgl>, wk70 <lgl>, wk71 <lgl>, wk72 <lgl>, wk73 <lgl>, wk74 <lgl>, wk75 <lgl>,
    ## #   wk76 <lgl>

``` r
#starting by mapping a single month 
billboard %>% pivot_longer(cols = c(wk1,wk2, wk3, wk4), names_to = "month1", values_to = "rank") %>% head()
```

    ## # A tibble: 6 x 77
    ##   artist track date.entered   wk5   wk6   wk7   wk8   wk9  wk10  wk11  wk12  wk13  wk14  wk15  wk16  wk17
    ##   <chr>  <chr> <date>       <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>
    ## 1 2 Pac  Baby… 2000-02-26      87    94    99    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
    ## 2 2 Pac  Baby… 2000-02-26      87    94    99    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
    ## 3 2 Pac  Baby… 2000-02-26      87    94    99    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
    ## 4 2 Pac  Baby… 2000-02-26      87    94    99    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
    ## 5 2Ge+h… The … 2000-09-02      NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
    ## 6 2Ge+h… The … 2000-09-02      NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA    NA
    ## # … with 61 more variables: wk18 <dbl>, wk19 <dbl>, wk20 <dbl>, wk21 <dbl>, wk22 <dbl>, wk23 <dbl>,
    ## #   wk24 <dbl>, wk25 <dbl>, wk26 <dbl>, wk27 <dbl>, wk28 <dbl>, wk29 <dbl>, wk30 <dbl>, wk31 <dbl>,
    ## #   wk32 <dbl>, wk33 <dbl>, wk34 <dbl>, wk35 <dbl>, wk36 <dbl>, wk37 <dbl>, wk38 <dbl>, wk39 <dbl>,
    ## #   wk40 <dbl>, wk41 <dbl>, wk42 <dbl>, wk43 <dbl>, wk44 <dbl>, wk45 <dbl>, wk46 <dbl>, wk47 <dbl>,
    ## #   wk48 <dbl>, wk49 <dbl>, wk50 <dbl>, wk51 <dbl>, wk52 <dbl>, wk53 <dbl>, wk54 <dbl>, wk55 <dbl>,
    ## #   wk56 <dbl>, wk57 <dbl>, wk58 <dbl>, wk59 <dbl>, wk60 <dbl>, wk61 <dbl>, wk62 <dbl>, wk63 <dbl>,
    ## #   wk64 <dbl>, wk65 <dbl>, wk66 <lgl>, wk67 <lgl>, wk68 <lgl>, wk69 <lgl>, wk70 <lgl>, wk71 <lgl>,
    ## #   wk72 <lgl>, wk73 <lgl>, wk74 <lgl>, wk75 <lgl>, wk76 <lgl>, month1 <chr>, rank <dbl>

``` r
# and to see clearly the contents of the new variable
billboard %>% pivot_longer(cols = c(wk1,wk2, wk3, wk4), names_to = "month1", values_to = "rank") %>% .$month1 %>% head()
```

    ## [1] "wk1" "wk2" "wk3" "wk4" "wk1" "wk2"

The way the `pivot_longer` function works is, you specify the columns to
be **gathered** followed by defining the resultant new variables to
store their names and corresponding values.

### Working with multiple columns

As it is evident, the problem now is that we have too many columns to
pass them individually. What happens if we want all of the weeks to be
transferred as subcategories to a new variable called *weeks*?

In that case, the following structure comes into play where regular
expressions are used to pick all the variables to be mapped.

``` r
#mapping all weeks to one varable called "weeks" 
billboard %>% pivot_longer(cols = starts_with("wk"), names_to = "weeks", values_to = "rank") %>% head()
```

    ## # A tibble: 6 x 5
    ##   artist track                   date.entered weeks  rank
    ##   <chr>  <chr>                   <date>       <chr> <dbl>
    ## 1 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk1      87
    ## 2 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk2      82
    ## 3 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk3      72
    ## 4 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk4      77
    ## 5 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk5      87
    ## 6 2 Pac  Baby Don't Cry (Keep... 2000-02-26   wk6      94

And so with this neat little trick, we’ve managed to bring the dataset
into a better looking structure making further manipulation easier. Of
courser, this is not all we can do with the data, there is a wide range
of tools at our disposal to allow us not only to pick the variables we
need but also to split the contents of them into new columns, with more
on that in the following sections.

### Working with similar columns

In some circumstances pivoting can also be used to construct a more
robust for ease of use in later stages of the analysis. In these cases
the dataset contains variables that are similar in their structure with
the aim being to gather them in to one, cleaner, format. Consider the
`asncombe` dataset that comes with basic R as shown below:

``` r
#dataset
anscombe
```

    ##    x1 x2 x3 x4    y1   y2    y3    y4
    ## 1  10 10 10  8  8.04 9.14  7.46  6.58
    ## 2   8  8  8  8  6.95 8.14  6.77  5.76
    ## 3  13 13 13  8  7.58 8.74 12.74  7.71
    ## 4   9  9  9  8  8.81 8.77  7.11  8.84
    ## 5  11 11 11  8  8.33 9.26  7.81  8.47
    ## 6  14 14 14  8  9.96 8.10  8.84  7.04
    ## 7   6  6  6  8  7.24 6.13  6.08  5.25
    ## 8   4  4  4 19  4.26 3.10  5.39 12.50
    ## 9  12 12 12  8 10.84 9.13  8.15  5.56
    ## 10  7  7  7  8  4.82 7.26  6.42  7.91
    ## 11  5  5  5  8  5.68 4.74  5.73  6.89

As it is apparent, the basis for each variable is the same (x1,x2, y1,y2
etc) and so it would make sense to simply create pair `x` and `y` and
depict their corresponding identifier `1,2,3,4` in a separate variable.

In such cases, `pivot_longer` offers an elegant solution to the problem
by automatically selecting the common patterns and using them as the new
variables.

``` r
# using ".value" and "everything()" to select common variables
anscombe %>% pivot_longer(everything(),
   names_to = c(".value", "set"),
   names_pattern = "(.)(.)" )
```

    ## # A tibble: 44 x 3
    ##    set       x     y
    ##    <chr> <dbl> <dbl>
    ##  1 1        10  8.04
    ##  2 2        10  9.14
    ##  3 3        10  7.46
    ##  4 4         8  6.58
    ##  5 1         8  6.95
    ##  6 2         8  8.14
    ##  7 3         8  6.77
    ##  8 4         8  5.76
    ##  9 1        13  7.58
    ## 10 2        13  8.74
    ## # … with 34 more rows

In the example above, the `.value` identifier enables selection of the
common elements between `x1,x2,etc` and `y1,y2,etc` and then uses the
findings as separate variables.

The `everything()` argument, as the name would suggest, picks the entire
variable set in the dataset.

Notice also the use of the `names_pattern = "(.)(.)"` option. This is a
special kind of regex use where the values within the brackets are used
to detect the kind of pattern to be used.

The `names_pattern` or `name_sep()` options make explicit use of the
`extract()` and `separete()` tools respectively (discussed in more
detail in the next sections) utilizing regular expressions to detect the
variable to pivot. In the former expression, the regex contained in the
matching groups depicted within the brackets in the above expression, is
what distinguishes one part of the variable from the other.

## Widening the dataset

`pivot_wider()` is the opposite `pivot_longer()` transforming a dataset
to a **wider** format. It is not used as often but has still some value
in presenting a dataset in a different light should the situation calls
for it.

Consider the `fish_encounters` dataset, contributed by **Myfanwy
Johnston** depicted below. It describes whether fish swimming down a
river are detected or not by automatic monitoring stations.

``` r
fish_encounters
```

    ## # A tibble: 114 x 3
    ##    fish  station  seen
    ##    <fct> <fct>   <int>
    ##  1 4842  Release     1
    ##  2 4842  I80_1       1
    ##  3 4842  Lisbon      1
    ##  4 4842  Rstr        1
    ##  5 4842  Base_TD     1
    ##  6 4842  BCE         1
    ##  7 4842  BCW         1
    ##  8 4842  BCE2        1
    ##  9 4842  BCW2        1
    ## 10 4842  MAE         1
    ## # … with 104 more rows

``` r
#> # A tibble: 114 x 3
#>    fish  station  seen
#>    <fct> <fct>   <int>
#>  1 4842  Release     1
#>  2 4842  I80_1       1
#>  3 4842  Lisbon      1
#>  4 4842  Rstr        1
#>  5 4842  Base_TD     1
#>  6 4842  BCE         1
#>  7 4842  BCW         1
#>  8 4842  BCE2        1
#>  9 4842  BCW2        1
#> 10 4842  MAE         1
#> # … with 104 more rows
```

A simple use of the function can provide a better understanding of what
the data contains and also make it more useful for potential use in
later stages of a processing system where specific input from each
station can be utilized.

``` r
fish_encounters %>% pivot_wider(names_from = station, values_from = seen)
```

    ## # A tibble: 19 x 12
    ##    fish  Release I80_1 Lisbon  Rstr Base_TD   BCE   BCW  BCE2  BCW2   MAE   MAW
    ##    <fct>   <int> <int>  <int> <int>   <int> <int> <int> <int> <int> <int> <int>
    ##  1 4842        1     1      1     1       1     1     1     1     1     1     1
    ##  2 4843        1     1      1     1       1     1     1     1     1     1     1
    ##  3 4844        1     1      1     1       1     1     1     1     1     1     1
    ##  4 4845        1     1      1     1       1    NA    NA    NA    NA    NA    NA
    ##  5 4847        1     1      1    NA      NA    NA    NA    NA    NA    NA    NA
    ##  6 4848        1     1      1     1      NA    NA    NA    NA    NA    NA    NA
    ##  7 4849        1     1     NA    NA      NA    NA    NA    NA    NA    NA    NA
    ##  8 4850        1     1     NA     1       1     1     1    NA    NA    NA    NA
    ##  9 4851        1     1     NA    NA      NA    NA    NA    NA    NA    NA    NA
    ## 10 4854        1     1     NA    NA      NA    NA    NA    NA    NA    NA    NA
    ## 11 4855        1     1      1     1       1    NA    NA    NA    NA    NA    NA
    ## 12 4857        1     1      1     1       1     1     1     1     1    NA    NA
    ## 13 4858        1     1      1     1       1     1     1     1     1     1     1
    ## 14 4859        1     1      1     1       1    NA    NA    NA    NA    NA    NA
    ## 15 4861        1     1      1     1       1     1     1     1     1     1     1
    ## 16 4862        1     1      1     1       1     1     1     1     1    NA    NA
    ## 17 4863        1     1     NA    NA      NA    NA    NA    NA    NA    NA    NA
    ## 18 4864        1     1     NA    NA      NA    NA    NA    NA    NA    NA    NA
    ## 19 4865        1     1      1    NA      NA    NA    NA    NA    NA    NA    NA

``` r
#> # A tibble: 19 x 12
#>    fish  Release I80_1 Lisbon  Rstr Base_TD   BCE   BCW  BCE2  BCW2   MAE   MAW
#>    <fct>   <int> <int>  <int> <int>   <int> <int> <int> <int> <int> <int> <int>
#>  1 4842        1     1      1     1       1     1     1     1     1     1     1
#>  2 4843        1     1      1     1       1     1     1     1     1     1     1
#>  3 4844        1     1      1     1       1     1     1     1     1     1     1
#>  4 4845        1     1      1     1       1    NA    NA    NA    NA    NA    NA
#>  5 4847        1     1      1    NA      NA    NA    NA    NA    NA    NA    NA
#>  6 4848        1     1      1     1      NA    NA    NA    NA    NA    NA    NA
#>  7 4849        1     1     NA    NA      NA    NA    NA    NA    NA    NA    NA
#>  8 4850        1     1     NA     1       1     1     1    NA    NA    NA    NA
#>  9 4851        1     1     NA    NA      NA    NA    NA    NA    NA    NA    NA
#> 10 4854        1     1     NA    NA      NA    NA    NA    NA    NA    NA    NA
#> # … with 9 more rows
```

The general use is very similar to that presented in \``pivot_longer()`
with `names_from` targeting the column containing the subcategories to
split from and `values_from` the corresponding values associated with
each category.

Notice that there will be cases where there is no match and these will
initially be filled with `NA`. Simply setting the option `values_fill`
to a value of your choice will replaced the `NA` values to something
more meaningful.

``` r
fish_encounters %>% pivot_wider(names_from = station, values_from = seen,
  values_fill = list(seen = 0))
```

    ## # A tibble: 19 x 12
    ##    fish  Release I80_1 Lisbon  Rstr Base_TD   BCE   BCW  BCE2  BCW2   MAE   MAW
    ##    <fct>   <int> <int>  <int> <int>   <int> <int> <int> <int> <int> <int> <int>
    ##  1 4842        1     1      1     1       1     1     1     1     1     1     1
    ##  2 4843        1     1      1     1       1     1     1     1     1     1     1
    ##  3 4844        1     1      1     1       1     1     1     1     1     1     1
    ##  4 4845        1     1      1     1       1     0     0     0     0     0     0
    ##  5 4847        1     1      1     0       0     0     0     0     0     0     0
    ##  6 4848        1     1      1     1       0     0     0     0     0     0     0
    ##  7 4849        1     1      0     0       0     0     0     0     0     0     0
    ##  8 4850        1     1      0     1       1     1     1     0     0     0     0
    ##  9 4851        1     1      0     0       0     0     0     0     0     0     0
    ## 10 4854        1     1      0     0       0     0     0     0     0     0     0
    ## 11 4855        1     1      1     1       1     0     0     0     0     0     0
    ## 12 4857        1     1      1     1       1     1     1     1     1     0     0
    ## 13 4858        1     1      1     1       1     1     1     1     1     1     1
    ## 14 4859        1     1      1     1       1     0     0     0     0     0     0
    ## 15 4861        1     1      1     1       1     1     1     1     1     1     1
    ## 16 4862        1     1      1     1       1     1     1     1     1     0     0
    ## 17 4863        1     1      0     0       0     0     0     0     0     0     0
    ## 18 4864        1     1      0     0       0     0     0     0     0     0     0
    ## 19 4865        1     1      1     0       0     0     0     0     0     0     0

``` r
#> # A tibble: 19 x 12
#>    fish  Release I80_1 Lisbon  Rstr Base_TD   BCE   BCW  BCE2  BCW2   MAE   MAW
#>    <fct>   <int> <int>  <int> <int>   <int> <int> <int> <int> <int> <int> <int>
#>  1 4842        1     1      1     1       1     1     1     1     1     1     1
#>  2 4843        1     1      1     1       1     1     1     1     1     1     1
#>  3 4844        1     1      1     1       1     1     1     1     1     1     1
#>  4 4845        1     1      1     1       1     0     0     0     0     0     0
#>  5 4847        1     1      1     0       0     0     0     0     0     0     0
#>  6 4848        1     1      1     1       0     0     0     0     0     0     0
#>  7 4849        1     1      0     0       0     0     0     0     0     0     0
#>  8 4850        1     1      0     1       1     1     1     0     0     0     0
#>  9 4851        1     1      0     0       0     0     0     0     0     0     0
#> 10 4854        1     1      0     0       0     0     0     0     0     0     0
#> # … with 9 more rows
```

### Aggregating with with `pivot_wider`

Consider the `warpbreaks` dataset that comes with basic R, it describes
the results of a designed experiment with nine replicates for every
combination of wool (A and B) and tension (L, M, H).

``` r
#converting into a tibble and rearranging the vars
warpbreaks %>% as_tibble() %>% select(wool,tension, breaks)
```

    ## # A tibble: 54 x 3
    ##    wool  tension breaks
    ##    <fct> <fct>    <dbl>
    ##  1 A     L           26
    ##  2 A     L           30
    ##  3 A     L           54
    ##  4 A     L           25
    ##  5 A     L           70
    ##  6 A     L           52
    ##  7 A     L           51
    ##  8 A     L           26
    ##  9 A     L           67
    ## 10 A     M           18
    ## # … with 44 more rows

``` r
# the code above aims attempts to instil clarity in the output
```

Notice the problem that appears when trying to widen this dataset.
Uniqueness is not maintained since this is a repeated experiment with
the same value of breaks for each tension value.

``` r
warpdata = warpbreaks %>% pivot_wider(names_from = wool, values_from = breaks)
```

    ## Warning: Values in `breaks` are not uniquely identified; output will contain list-cols.
    ## * Use `values_fn = list(breaks = list)` to suppress this warning.
    ## * Use `values_fn = list(breaks = length)` to identify where the duplicates arise
    ## * Use `values_fn = list(breaks = summary_fun)` to summarise duplicates

``` r
#> Warning: Values are not uniquely identified; output will contain list-cols.
#> * Use `values_fn = list` to suppress this warning.
#> * Use `values_fn = length` to identify where the duplicates arise
#> * Use `values_fn = {summary_fun}` to summarise duplicates
#> # A tibble: 3 x 3
#>   tension A         B        
#>   <fct>   <list>    <list>   
#> 1 L       <dbl [9]> <dbl [9]>
#> 2 M       <dbl [9]> <dbl [9]>
#> 3 H       <dbl [9]> <dbl [9]>
```

The default output here is a list containing all the associated
**break** values. One other, and perhaps more informative, approach
would be to include a statistic to describe the contents in that list.

For that purpose, `pivot _wider()` offers the `values_fn` option where a
suitable function is defined to describe the list with t single value.

``` r
warpbreaks %>%
  pivot_wider(
    names_from = wool,
    values_from = breaks,
    values_fn = list(breaks = mean)
  )
```

    ## # A tibble: 3 x 3
    ##   tension     A     B
    ##   <fct>   <dbl> <dbl>
    ## 1 L        44.6  28.2
    ## 2 M        24    28.8
    ## 3 H        24.6  18.8

``` r
#> # A tibble: 3 x 3
#>   tension     A     B
#>   <fct>   <dbl> <dbl>
#> 1 L        44.6  28.2
#> 2 M        24    28.8
#> 3 H        24.6  18.8
```

## Separating and extracting column contents

An Important aspect of every data shaping mechanism is to be able to
pick multiple columns or data entries within a variable with a certain
precision and without having to manually type them each time.

The functions `separate()` and `extract()` were created for this purpose
where regex is used to describe the pattern to pick and reshape.

Consider `table3` for example that comes with the `tidyr` package. One
look at the table illustrates the problem that we are facing where the
variable `rate` could be split into two different ones if somehow we
could detect and pull out the values on either side of the separator.

``` r
table3
```

    ## # A tibble: 6 x 3
    ##   country      year rate             
    ## * <chr>       <int> <chr>            
    ## 1 Afghanistan  1999 745/19987071     
    ## 2 Afghanistan  2000 2666/20595360    
    ## 3 Brazil       1999 37737/172006362  
    ## 4 Brazil       2000 80488/174504898  
    ## 5 China        1999 212258/1272915272
    ## 6 China        2000 213766/1280428583

### Separate

The `separate()` function is build to help in cases where values in a
column could be split based on a separator in place. On the above
example in `table3` the following code splits the `rate` variable into
`cases` and `population` accordingly

``` r
# separate() automatically detects the separator
table3 %>% separate(rate, into = c("cases", "population"))
```

    ## # A tibble: 6 x 4
    ##   country      year cases  population
    ##   <chr>       <int> <chr>  <chr>     
    ## 1 Afghanistan  1999 745    19987071  
    ## 2 Afghanistan  2000 2666   20595360  
    ## 3 Brazil       1999 37737  172006362 
    ## 4 Brazil       2000 80488  174504898 
    ## 5 China        1999 212258 1272915272
    ## 6 China        2000 213766 1280428583

By default, the function will automatically detect any non-alphanumeric
character and use that as a separator but its not limited to that. One
can specify the separator manually using the `sep` option.

``` r
# separate() manually  detects the separator
table3 %>% separate(rate, into = c("cases", "population"), sep = "/")
```

    ## # A tibble: 6 x 4
    ##   country      year cases  population
    ##   <chr>       <int> <chr>  <chr>     
    ## 1 Afghanistan  1999 745    19987071  
    ## 2 Afghanistan  2000 2666   20595360  
    ## 3 Brazil       1999 37737  172006362 
    ## 4 Brazil       2000 80488  174504898 
    ## 5 China        1999 212258 1272915272
    ## 6 China        2000 213766 1280428583

At its heart, `separate()` uses regular expressions to detect and pull
the corresponding characters. As a result the new columns are now of
`char` type, something that can be changed by altering the state of the
`convert` flag as shown below:

``` r
# separate() manually detects the separator and convers the columns into the appropriate data type 
table3 %>% separate(rate, into = c("cases", "population"), sep = "/", convert = TRUE)
```

    ## # A tibble: 6 x 4
    ##   country      year  cases population
    ##   <chr>       <int>  <int>      <int>
    ## 1 Afghanistan  1999    745   19987071
    ## 2 Afghanistan  2000   2666   20595360
    ## 3 Brazil       1999  37737  172006362
    ## 4 Brazil       2000  80488  174504898
    ## 5 China        1999 212258 1272915272
    ## 6 China        2000 213766 1280428583

### Extract

The `extract()` function lets you go a step further and allows you to
define your own regex to be used for pattern patching. Using the same
example as above, lets see how to split the `year` variable to `century`
and `years`.

``` r
#
table3 %>% extract( col = year, into = c("century","years"), regex = "([0-9]{2})([0-9]{2})")
```

    ## # A tibble: 6 x 4
    ##   country     century years rate             
    ##   <chr>       <chr>   <chr> <chr>            
    ## 1 Afghanistan 19      99    745/19987071     
    ## 2 Afghanistan 20      00    2666/20595360    
    ## 3 Brazil      19      99    37737/172006362  
    ## 4 Brazil      20      00    80488/174504898  
    ## 5 China       19      99    212258/1272915272
    ## 6 China       20      00    213766/1280428583

The `regex` option shown above uses the same syntax as described earlier
in the chapter, in fact, it is possible to split the target variable
into several others by expanding the bracket list as shown in the
following block of code. The year variable is now split into three
variables to depict the `century`, `decade` and `year`.

``` r
table3 %>% extract( col = year, into = c("century","decade","year" ), regex = "([0-9]{2})([0-9])([0-9])")
```

    ## # A tibble: 6 x 5
    ##   country     century decade year  rate             
    ##   <chr>       <chr>   <chr>  <chr> <chr>            
    ## 1 Afghanistan 19      9      9     745/19987071     
    ## 2 Afghanistan 20      0      0     2666/20595360    
    ## 3 Brazil      19      9      9     37737/172006362  
    ## 4 Brazil      20      0      0     80488/174504898  
    ## 5 China       19      9      9     212258/1272915272
    ## 6 China       20      0      0     213766/1280428583

In addition, internally the pivot functions make explicit use of
`seaprate()` and `extract()` whenever a split or a regular expression is
need to capture patterns present in name or within the content of a
variable in the dataset.

### Unite

Of course, extracting and creating new variables would not be complete
without a function to revert back to the original target variable. In
this case, the `unite()` function provides the means to do exactly that
as shown in the example below.

``` r
#the reshaped dataset
tab3 = table3 %>% extract( col = year, into = c("century","decade","year" ), regex = "([0-9]{2})([0-9])([0-9])")

#going back to the original dataset - with separator
tab3 %>% unite(new ,century, decade, year)
```

    ## # A tibble: 6 x 3
    ##   country     new    rate             
    ##   <chr>       <chr>  <chr>            
    ## 1 Afghanistan 19_9_9 745/19987071     
    ## 2 Afghanistan 20_0_0 2666/20595360    
    ## 3 Brazil      19_9_9 37737/172006362  
    ## 4 Brazil      20_0_0 80488/174504898  
    ## 5 China       19_9_9 212258/1272915272
    ## 6 China       20_0_0 213766/1280428583

By default, the `_` separator is used after each component of the
composite variable but as always, there are option in place to customize
this behavior. In the following block of code the separator is removed
giving the original variable before any alteration takes place.

``` r
#going back to the original dataset - with no separators
tab3 %>% unite(new ,century, decade, year, sep = "")
```

    ## # A tibble: 6 x 3
    ##   country     new   rate             
    ##   <chr>       <chr> <chr>            
    ## 1 Afghanistan 1999  745/19987071     
    ## 2 Afghanistan 2000  2666/20595360    
    ## 3 Brazil      1999  37737/172006362  
    ## 4 Brazil      2000  80488/174504898  
    ## 5 China       1999  212258/1272915272
    ## 6 China       2000  213766/1280428583

## Exercises

### Pivoting

#### Exercise 1

Why does the following code fail?

``` r
#the table to use
table4a


table4a %>% pivot_longer(1999,2000, names_to = "year",values_to = "value")
```

#### Exercise 2

Consider the following dataset and apply `pivot_wider()` to **spread**
the values in `name`, do you agree with the results after pivoting?

Hint. Could a new column solve the problem, what other solution could we
apply?

``` r
people = tribble(~name, ~key, ~value,
                 #------------/------/-----,
                 "Phil Woods", "age",45,
                 "Phil Woods", "height",185,
                 "Phil Woods", "age",50,
                 "Jess Cordero", "age",45,
                 "Jess Cordero", "height",156,)
```

#### Exercise 3

Consider the followign simple tibble, what kind of pivoting would you
use, `pivot_longer()` or `pivot_wider()` ?

``` r
rcj = tribble( ~judge, ~male, ~female,
                    "yes", NA, 10, 
                    "no", 20, 12)
```

### Separating and Extracting

#### Exercise 1

What to the additional arguments `extra` and `fill` do in `separate()`?

Experiment with the various option in using the following datasets.

``` r
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"))
```

    ## Warning: Expected 3 pieces. Additional pieces discarded in 1 rows [2].

    ## # A tibble: 3 x 3
    ##   one   two   three
    ##   <chr> <chr> <chr>
    ## 1 a     b     c    
    ## 2 d     e     f    
    ## 3 h     i     j

``` r
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"))
```

    ## Warning: Expected 3 pieces. Missing pieces filled with `NA` in 1 rows [2].

    ## # A tibble: 3 x 3
    ##   one   two   three
    ##   <chr> <chr> <chr>
    ## 1 a     b     c    
    ## 2 d     e     <NA> 
    ## 3 f     g     i

#### Exercise 2

Both `unite()` and `separate()` have a remove option. What does in to
and how can it be utilized

#### Exercise 3

Compare `separate()` and `extract()`, why are there so many option to
separate but only one `unite()`?

## Solutions

### Pivoting

#### Exercise 1

``` r
table4a %>% pivot_longer(cols = !country, names_to = "year",values_to = "value")
```

#### Exercise 2

``` r
#withough changing anything on the dataset
people = tribble(~name, ~key, ~value,
                 #------------/------/-----,
                 "Phil Woods", "age",45,
                 "Phil Woods", "height",185,
                 "Phil Woods", "age",50,
                 "Jess Cordero", "age",45,
                 "Jess Cordero", "height",156,)
people %>% pivot_wider(names_from = name, values_from = value)



# solution 1 - adding a new column
people = tribble(~name, ~key, ~value, ~dkey,
                 #------------/------/-----,
                 "Phil Woods", "age",45,1,
                 "Phil Woods", "height",185,1,
                 "Phil Woods", "age",50,0,
                 "Jess Cordero", "age",45,1,
                 "Jess Cordero", "height",156,1)

people %>% pivot_wider(names_from = name, values_from = value)



#solution 2  - uniqueness
people = tribble(~name, ~key, ~value,
                 #------------/------/-----,
                 "Phil Woods", "age",45,
                 "Phil Woods", "height",185,
                 # "Phil Woods", "age",50,
                 "Jess Cordero", "age",45,
                 "Jess Cordero", "height",156,)


people %>% pivot_wider(names_from = name, values_from = value)
```

### Exercise 3

``` r
rcj = tribble( ~judge, ~male, ~female,
                    "yes", NA, 10, 
                    "no", 20, 12)

#alternative table to try with no NAs
# rcj = tribble( ~judge, ~male, ~female,
#                     "yes", 4, 10, 
#                     "no", 20, 12)


#use of pivot_longer
rcj %>% pivot_longer(cols = c(male, female),   names_to = "gender", values_to = "count")


# use of  pivot_wider 
rcj %>% pivot_wider(names_from = judge, values_from = c(male, female))
```

### Separating and Extracting

#### Exercise 1

typing `?separate()` shows all the options and their meaning. Try
experimenting with them to discover more of what they do.

``` r
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"))

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"))
```

#### Exercise 2

# Solution: typing `?separate()` in the command line shows all the information needed here. The `remove` option is there to remove the input columns from the output.

#### Exercise 3

Solution: one suggestion is that there is only one way to unite the
multiple strings but a number of different ways to split them apart.

# String manipulation

### Introduction

In this part we will introduce strings and how to manipulate them to
suit the needs of a particular project. The packages needed (listed
above) are mostly the `stringr` and `tidyverse` package where the former
contains a great number of functions to manipulate and work with strings
and the latter is the base for most of the things we do in R.

Base R has a a number of functions to manipulate and work with strings
but they can be inconsistent at times, the above package was created in
an effort to standardize character vector manipulation and make it
easier to follow and replicate.

It should also be mentioned that the majority of the content that
follows is contained in the book `R for Data Science` by `Hadley Wickam`
and `Garrett Grolemund` that can be found in this
[link](https://r4ds.had.co.nz/index.html).

### String Basics

There are two ways with which you can create a string in R, at the very
basic level, by either using single of double quotes. There is no
difference in the behavior but it is recommended to stick with `"` as it
is more widely understood that this is a string and others will be able
to follow your code easier.

To note here that one of the advantages of having two ways to define a
string is that you can combine them when quotes within a string if
needed as showcased in the example below.

``` r
string1 = "a string using double quotes"

is.character(string1)

string2 = 'another string using single quotes'

is.character(string2)

# a string containing quotes
string3 = "this is a 'string' within a string"

# notice how the output changes when implementing the following code
string4 = 'this is a "string" within a string'
```

Notice the difference in `string4`. This happens because the compiler
cannot place two double quotes within the same string and so we need to
`escape` it. To achieve that a `\` is used before the corresponding
character. This can be used not only for `"` but for any other reserved
character as well.

If you need to `escape` a backslash then use a double backslash as in
`\\` and to see what the output would look like when used in text you
can use the `writeLines()` function to simulate that effect.

``` r
string5 = "escaping a reserved character like \" quotes "

# to see how the result would apear in text
writeLines(string5)

string6 = "escaping a backslash \\ "

# to see how the result would apear in text
writeLines(string6)
```

Furthermore, additional control in the form of newlines or tabs is
provided by using `\n` and `\t` for example along with a plethora of
available special characters that can be found by typing `?"'"` or
`?'"'` in you command line.

Introducing non-English characters in your text strings is also possible
using special characters of the form `\u00b5` for example for the Greek
letter mu.

``` r
# outputting non-English characters
string7 = "\u00b5" 
```

Adding strings into a character vector is very common and is usually
done with the use of the `c()` function.

``` r
s8 = c("a", "vector", "of", "strings")
```

### String Length

At times it is necessary to determine the length of a character string.
A useful function to use in these cases is the `str_length()` function
which helps with that.

``` r
# finding out how many characters in a char vector
str_length(c(s8, NA))
```

Notice that an `NA` character is translated as is and we will see other
options on how to deal with this in the sections to follow.

### Combining Strings

We already seen one way to combine strings in the previous section but
with the `stringer` package we have an additional, more powerful tool at
our disposal.

Using `str_c()` can be beneficial in many cases since it allows for
additional flexibility in the form of parameters for separators to be
used or the option to collapse individual entries into one composite
character string.

``` r
# using custom separator
str_c("an", "str_c vector", "with", "space", "character", "separating each entry", sep = " ")

# the colapse option
str_c("an", "str_c vector", "with", "space", "character", "separating each entry", collapse = T)
```

What is more important however is that `str_c` is vectorised and in this
way can help in cases where an action has to be applied to each element
of an input vector instead of individual character strings.

In addition, it can also work to recycle shorter vectors to mach the
longer ones as in the following example.

``` r
# vectorized form - translating a shorter vectror to match the longer one
str_c("a", c("b", "c", "d"), "c", sep = " " )

# simpler vectorizing 
str_c("a", c("b", "c", "d"))

# c() comparison
c("a", c("b", "c", "d"))
```

### Subsisting strings

Extracting parts of a string can be done using the `str_sub` function
and by specifying the `start` and `end` limits of the string to retain.

It is also important to note that the function will not fail if the end
point is outside of the index limit of the string.

``` r
x <- c("OneValue", "SecondValue", "ThirdValue")
str_sub(x, 1, 3)

# negative numbers count backwards from end
str_sub(x, -4, -1)


# The function will not fail in teh example below
str_sub("a", 1,5)
```

An additional use of the of the `str_sub` function is to assign values
to a given range on the target string

``` r
str_sub(x, 1, 1) <- str_to_lower(str_sub(x, 1, 1))
x
```

### Customizing text for different language locales

In some cases the string manipulation functions have a `locale` argument
where adjustments for certain languages can be made. Notice for example
how the sort order changes if the locale changes from English to
Lithuanian in the example below.

``` r
#initial string
x = c("y", "i", "k")

#sort function in English
str_sort(x)

#sort function in Lithuanian
str_sort(x,locale = "lt")
```

### Exercises

  - In code that doesn’t use stringr, you’ll often see paste() and
    paste0(). What’s the difference between the two functions? What
    stringr function are they equivalent to? How do the functions differ
    in their handling of NA?

  - In your own words, describe the difference between the sep and
    collapse arguments to str\_c().

  - Use str\_length() and str\_sub() to extract the middle character
    from a string. What will you do if the string has an even number of
    characters?

  - What does str\_wrap() do? When might you want to use it?

  - What does str\_trim() do? What’s the opposite of str\_trim()?

  - Write a function that turns (e.g.) a vector c(“a”, “b”, “c”) into
    the string a, b, and c. Think carefully about what it should do if
    given a vector of length 0, 1, or 2.

NOTE: The content in this section as well as a more in depth analysis on
each of the previous sections can be found in this book [R For Data
Science](https://r4ds.had.co.nz/strings.html#exercises-32)

## Regular Expressions

Matching patterns with regular expressions is usually covered in a very
large topic and one that arguably should be covered on its own course,
however here we will consider it as part of the general string
manipulation section and will include a flavor of what can be achieved.

### Normal Pattern Matching

Simple pattern matching can be achieved by using the `str_view` function
and specifying the `string` and `pattern` arguments as shown below:

``` r
x <- c("apple", "banana", "pear")
str_view(x, "an")
```

![](README_files/figure-gfm/unnamed-chunk-81-1.png)<!-- -->

The complexity of the match can be adjusted and wildcards can be used as
well in the form of `.` as in

``` r
str_view(x, ".a.")
```

![](README_files/figure-gfm/unnamed-chunk-82-1.png)<!-- -->

An important thing to remember here is that you are looking for given
pattern in a string or a vector of strings. Specifying the pattern to
look for can be sometimes tricky and therefore is recommended to take a
look at the accompanied information sheet for the `stringr` package
located
[here](https://evoldyn.gitlab.io/evomics-2018/ref-sheets/R_strings.pdf).

The most common functions for regular expressions as well as ways to
structure your pattern can be found in the above link.

### Escaping characters

We saw previously that the wildcard is represented by `.`, what happens
if your pattern needs to include the dot `.`?

For cases such as these there is a need to “escape” a character using
the backlash `\`. So for example the dot (`.`) as stated previously
would be normally used as `\.` in a regular expression. However, a
problem arises since strings are used to represent regular expressions,
they also use the backlash to represent an escaped character. The
solution is to use the double backlash as in `\\.` to signify that we
want to “escape” the dot (`.`) in a regular expression pattern.

``` r
# To create the regular expression, we need \\
dot <- "\\."

# But the expression itself only contains one:
writeLines(dot)


# And this tells R to look for an explicit .
str_view(c("abc", "a.c", "bef"), "a\\.c")
```

![](README_files/figure-gfm/unnamed-chunk-83-1.png)<!-- -->

If there is a need to match the `\` character itself then you will need
to use the double version `\\` for regular expressions and since this is
a string you will need to add one more `\` followed by the actual
character. So four backlash characters will need to be used\!

``` r
#to see this in a string
x <- "a\\b"
writeLines(x)
```

    ## a\b

``` r
# to view the result in a RegEx
str_view(x, "\\\\")
```

![](README_files/figure-gfm/unnamed-chunk-84-1.png)<!-- -->

throughout this section the pattern for a RegEx will be presented as
`\.` whereas the actual string as `\\.`.

#### Exercises

1.  Explain why each of these strings don’t match a : “",”\\“,”\\".

2.  How would you match the sequence "’?

3.  What patterns will the regular expression ...... match? How would
    you represent it as a string?

### Anchors

It is sometimes useful to match a pattern starting from the beginning or
the end of a string. In these cases an anchor is used to notify the
engine that we are using a point of origin.

More specifically, the start of the string is denoted by `^` and the end
by `$`

``` r
x <- c("apple", "banana", "pear")
str_view(x, "^a")
```

![](README_files/figure-gfm/unnamed-chunk-85-1.png)<!-- -->

``` r
str_view(x, "a$")
```

![](README_files/figure-gfm/unnamed-chunk-85-2.png)<!-- -->

You can also use both in one pattern and this is useful when the entire
string is to be matched

``` r
# this will output all possible matches
x <- c("apple pie", "apple", "apple cake")
str_view(x, "apple")
```

![](README_files/figure-gfm/unnamed-chunk-86-1.png)<!-- -->

``` r
# notice the difference in the result here
str_view(x, "^apple$")
```

![](README_files/figure-gfm/unnamed-chunk-86-2.png)<!-- -->

#### Exercises

1.  How would you match the literal string “\(^\)”?

2.  Given the corpus of common words in stringr::words, create regular
    expressions that find all words that:
    
    \+Start with “y”. +End with “x” +Are exactly three letters long.
    (Don’t cheat by using str\_length()\!) +Have seven letters or more.
    Hint: Since this list is long, you might want to use the match
    argument to str\_view() to show only the matching or non-matching
    words.

### Character Classes

Similar to the wildcard you saw previously, there are other reserved
patters that serve a similar purpose for example:

  - `\d`: matches any digit.
  - `\s`: matches any whitespace (e.g. space, tab, newline).
  - `[abc]`: matches a, b, or c.
  - `[^abc]`: matches anything except a, b, or c.

A reminder here that if you want to use the above to pattern then you
will need to escape them as we learned earlier. So the `\d` string would
be used as `\\d` in a pattern.

In addition, there is an alternative to the backlash way of escaping a
character that involves creating a class for a single character as in
`[.]` for example. In many cases this is considered more intuitive that
using the backlash.

A character class containing a single character is a nice alternative to
backslash escapes when you want to include a single meta-character in a
regex. Many people find this more readable.

``` r
# Look for a literal character that normally has special meaning in a regex
str_view(c("abc", "a.c", "a*c", "a c"), "a[.]c")
```

![](README_files/figure-gfm/unnamed-chunk-87-1.png)<!-- -->

``` r
str_view(c("abc", "a.c", "a*c", "a c"), ".[*]c")
```

![](README_files/figure-gfm/unnamed-chunk-87-2.png)<!-- -->

``` r
str_view(c("abc", "a.c", "a*c", "a c"), "a[ ]")
```

![](README_files/figure-gfm/unnamed-chunk-87-3.png)<!-- -->

However, some characters will have a certain meaning even inside
brackets and so the backslash for escaping them is still necessary,
these are `] \ ^ -`.

Alternation is used to pick between patterns, for example `abc|d..f`
will pick a pattern with either `c` or `d` in the definition. Note how
the `|` is used, it will only pick between the immediate characters and
not between the entire patterns on either side. If it gets to a point
where it becomes confusing remember to use parenthesis to clear things
up.

``` r
str_view(c("grey", "gray"), "gr(e|a)y")
```

![](README_files/figure-gfm/unnamed-chunk-88-1.png)<!-- -->

#### Exercises

1.  Create regular expressions to find all words that: +Start with a
    vowel. +That only contain consonants. (Hint: thinking about matching
    “not”-vowels.) +End with`ed`, but not with `eed`. +End with `ing`
    or`ise`.
2.  Empirically verify the rule “i before e except after c”.
3.  Is “q” always followed by a “u”?
4.  Write a regular expression that matches a word if it’s probably
    written in British English, not American English.
5.  Create a regular expression that will match telephone numbers as
    commonly written in your country.

### Repetition

It is sometimes necessary for a certain pattern to appear multiple time
within a string, in such cases these repetitions can be coded with
regular expressions to automate the search process.

for example:

  - `?`: 0 or 1
  - `+`: 1 or more
  - `*`: 0 or more

<!-- end list -->

``` r
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
```

![](README_files/figure-gfm/unnamed-chunk-89-1.png)<!-- -->

``` r
str_view(x, "CC+")
```

![](README_files/figure-gfm/unnamed-chunk-89-2.png)<!-- -->

``` r
str_view(x, 'C[LX]+')
```

![](README_files/figure-gfm/unnamed-chunk-89-3.png)<!-- -->

Another key aspect of the above code is that the number or precedence
here dictates that the character just before the operator will be
affected. This means that parenthesis will need to be used as in
`bana(na)+` to capture more than one character.

It is also possible to specify the number of repetitions explicitly by
using:

  - `{n}`: exactly n
  - `{n,}`: n or more
  - `{,m}`: at most m
  - `{n,m}`: between n and m

<!-- end list -->

``` r
str_view(x, "C{2}")
```

![](README_files/figure-gfm/unnamed-chunk-90-1.png)<!-- -->

``` r
str_view(x, "C{2,}")
```

![](README_files/figure-gfm/unnamed-chunk-90-2.png)<!-- -->

``` r
str_view(x, "C{2,3}")
```

![](README_files/figure-gfm/unnamed-chunk-90-3.png)<!-- -->

To also note here that the system will match as many of the characters
that it can find. To switch this behavior off and use what is called
“lazy” matching (instead of “greedy” as specified earlier) the `?`
operator can be used as follows:

``` r
str_view(x, 'C{2,3}?')
```

![](README_files/figure-gfm/unnamed-chunk-91-1.png)<!-- -->

``` r
str_view(x, 'C[LX]+?')
```

![](README_files/figure-gfm/unnamed-chunk-91-2.png)<!-- -->

#### Exercises

1.  Describe the equivalents of `?`, `+`,`*` in `{m,n}` form.

2.  Describe in words what these regular expressions match: (read
    carefully to see if I’m using a regular expression or a string that
    defines a regular expression.)
    
      - `^.*$`
      - `"\\{.+\\}"`
      - `\d{4}-\d{2}-\d{2}`
      - `"\\\\{4}"`

3.  Create regular expressions to find all words that:
    
      - Start with three consonants.
      - Have three or more vowels in a row.
      - Have two or more vowel-consonant pairs in a row.

4.  Solve the beginner regexp crosswords at
    \[<https://regexcrossword.com/challenges/beginner>\].

### Additional Functions

The `stringr` package comes with additional function wrappers that make
the most common string operations somewhat easier. For example the
following matching behavior can be conducted using the premade
functions:

  - Determine which strings match a pattern.
  - Find the positions of matches.
  - Extract the content of matches.
  - Replace matches with new values.

The list is actually a lot longer so here we will briefly discuss how
the most popular string matching operations can be performed using the
tools supplied by the `stringr` package.

#### Detect Strings

Detecting strings is a very important aspect in many Data Analysis
applications and `str_detect` was created with ease of use in mind. It
returns a logical vector depending whether there was a match in the
corresponding location and based on the supplied pattern, as the example
below illustrates.

``` r
x <- c("apple", "banana", "pear")
str_detect(x, "e")
```

    ## [1]  TRUE FALSE  TRUE

``` r
#> [1]  TRUE FALSE  TRUE
```

A very handy way of using it, is by taking advantage of how `R`
translates `TRUE` (evaluated as `1`) and `FALSE` (evaluated as `0`)
responses. In the example below using the `sum` and `mean` functions
makes counting instances of a pattern being detected much easier.

``` r
# How many common words start with t?
sum(str_detect(words, "^t"))
```

    ## [1] 65

``` r
#> [1] 65
# What proportion of common words end with a vowel?
mean(str_detect(words, "[aeiou]$"))
```

    ## [1] 0.2765306

``` r
#> [1] 0.2765306
```

A variation of `str_detect` is `str_count` and as the name suggests the
function will count the instances of a pattern appearing in the target
vector.

``` r
x <- c("apple", "banana", "pear")
str_count(x, "a")
```

    ## [1] 1 3 1

``` r
#> [1] 1 3 1

# On average, how many vowels per word?
mean(str_count(words, "[aeiou]"))
```

    ## [1] 1.991837

``` r
#> [1] 1.991837
```

#### Extract Strings

To extract strings we use the `str_extract` function that takes the
input source vector and the pattern to match as arguments. In this case
we will need a more complex set of examples and so the [Harvard
Sentences](https://en.wikipedia.org/wiki/Harvard_sentences) collection
of sentences is used. Although originally created to test VOIP systems,
it can also be used for regex examples as well.

``` r
length(sentences)
```

    ## [1] 720

``` r
#> [1] 720
head(sentences)
```

    ## [1] "The birch canoe slid on the smooth planks."  "Glue the sheet to the dark blue background."
    ## [3] "It's easy to tell the depth of a well."      "These days a chicken leg is a rare dish."   
    ## [5] "Rice is often served in round bowls."        "The juice of lemons makes fine punch."

``` r
#> [1] "The birch canoe slid on the smooth planks." 
#> [2] "Glue the sheet to the dark blue background."
#> [3] "It's easy to tell the depth of a well."     
#> [4] "These days a chicken leg is a rare dish."   
#> [5] "Rice is often served in round bowls."       
#> [6] "The juice of lemons makes fine punch."
```

A good way to start using regex in bulk is to see if we can construct a
pattern to match that contains all the relevant information. In the
example below the pattern contains a set of colours combined into a
string to be used as the pattern.

``` r
colours <- c("red", "orange", "yellow", "green", "blue", "purple")
colour_match <- str_c(colours, collapse = "|")
colour_match
```

    ## [1] "red|orange|yellow|green|blue|purple"

``` r
#> [1] "red|orange|yellow|green|blue|purple"
```

The next stage is to select the relevant examples from the collection of
`sentences` and then proceed in matching based on the pattern we
created.

``` r
has_colour <- str_subset(sentences, colour_match)
matches <- str_extract(has_colour, colour_match)
head(matches)
```

    ## [1] "blue" "blue" "red"  "red"  "red"  "blue"

``` r
#> [1] "blue" "blue" "red"  "red"  "red"  "blue"
```

To better understand the mechanics behind the matching process it helps
to know that `str_extract` only finds and extracts the first match in
each row of a vector. To better illustrate this, the code below selects
the phrases from the `sentences` collection where there are more than
one match.

``` r
more <- sentences[str_count(sentences, colour_match) > 1]
str_view_all(more, colour_match)
```

![](README_files/figure-gfm/unnamed-chunk-98-1.png)<!-- -->

Notice how `str_extract` works with these source vectors.

``` r
str_extract(more, colour_match)
```

    ## [1] "blue"   "green"  "orange"

``` r
#> [1] "blue"   "green"  "orange"
```

#### Replace Strings

`str_replace` and `str_replace_all`allow you to replace parts of a
string that match a pattern with a new replacement string.

``` r
x <- c("apple", "pear", "banana")
str_replace(x, "[aeiou]", "-")
```

    ## [1] "-pple"  "p-ar"   "b-nana"

``` r
#> [1] "-pple"  "p-ar"   "b-nana"
str_replace_all(x, "[aeiou]", "-")
```

    ## [1] "-ppl-"  "p--r"   "b-n-n-"

``` r
#> [1] "-ppl-"  "p--r"   "b-n-n-"
```

And with `str_replace_all` we can apply the same functionality as above
in all the elements of a character vector.

``` r
x <- c("1 house", "2 cars", "3 people")
str_replace_all(x, c("1" = "one", "2" = "two", "3" = "three"))
```

    ## [1] "one house"    "two cars"     "three people"

``` r
#> [1] "one house"    "two cars"     "three people"
```

In addition, one can also use backrefferences and recycle elements of
the same string as replacements

``` r
sentences %>% 
  str_replace("([^ ]+) ([^ ]+) ([^ ]+)", "\\1 \\3 \\2") %>% 
  head(5)
```

    ## [1] "The canoe birch slid on the smooth planks."  "Glue sheet the to the dark blue background."
    ## [3] "It's to easy tell the depth of a well."      "These a days chicken leg is a rare dish."   
    ## [5] "Rice often is served in round bowls."

``` r
#> [1] "The canoe birch slid on the smooth planks." 
#> [2] "Glue sheet the to the dark blue background."
#> [3] "It's to easy tell the depth of a well."     
#> [4] "These a days chicken leg is a rare dish."   
#> [5] "Rice often is served in round bowls."
```

#### Exercises

##### On detecting strings

1.  For each of the following challenges, try solving it by using both a
    single regular expression, and a combination of multiple
    str\_detect() calls.
    
    1.  Find all words that start or end with x.
    
    2.  Find all words that start with a vowel and end with a consonant.
    
    3.  Are there any words that contain at least one of each different
        vowel?

2.  What word has the highest number of vowels? What word has the
    highest proportion of vowels? (Hint: what is the denominator?)

##### On extracting strings

1.  In the example in section [Extracting Strings](#extr_str) section,
    you might have noticed that the regular expression matched
    “flickered”, which is not a colour. Modify the regex to fix the
    problem.

2.  From the Harvard sentences data, extract:
    
    1.  The first word from each sentence.
    2.  All words ending in ing.
    3.  All plurals.

##### On Replacing Strings

1.  Replace all forward slashes in a string with backslashes.

2.  Implement a simple version of str\_to\_lower() using replace\_all().

3.  Switch the first and last letters in words. Which of those strings
    are still words?

# Further reading

### General

  - [Tidyverse website](https://www.tidyverse.org)
  - [R for Data Science](https://r4ds.had.co.nz)
  - [Advanced R](https://adv-r.hadley.nz)
  - [Tidyverse style guide](https://style.tidyverse.org/) (has some
    guidance on choosing function and argument names)
  - [MoJ coding
    standards](https://moj-analytical-services.github.io/our-coding-standards/)

### Conditional statements

  - [Advanced R - choices
    section](https://adv-r.hadley.nz/control-flow.html#choices)

### Iteration

  - [R for Data Science - iteration
    chapter](https://r4ds.had.co.nz/iteration.html)
  - [Advanced R - loops
    section](https://adv-r.hadley.nz/control-flow.html#loops)

### Strings and regex

  - [R for Data Science - strings
    chapter](https://r4ds.had.co.nz/strings.html)
  - [stringr and regex
    cheatsheet](https://evoldyn.gitlab.io/evomics-2018/ref-sheets/R_strings.pdf)
  - [Regex Coffee & Coding
    session](https://github.com/moj-analytical-services/Coffee-and-Coding/tree/master/2019-03-13%20Regex)

### Reshaping data

  - [Tidyverse website - pivoting
    section](https://tidyr.tidyverse.org/dev/articles/pivot.html)
  - [R for Data Science - pivoting
    chapter](https://r4ds.had.co.nz/tidy-data.html#pivoting)

# ‘Real world’ examples

Let’s take a look at a few more examples and tackle some problems that
we might encounter as an analyst in DASD.

``` r
# Read data
prosecutions_and_convictions <- s3tools::s3_path_to_full_df(
  "alpha-r-training/writing-functions-in-r/prosecutions-and-convictions-2018.csv")
```

    ## using csv (or similar) method, reading directly to R supported

``` r
# Filter for Magistrates Court to extract the prosecutions
prosecutions <- prosecutions_and_convictions %>%
  filter(`Court.Type` == "Magistrates Court")
```

## Example 1

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

# This removes repeated row labels, to replicate how this data might be displayed in Excel
time_series$Offence.Type[duplicated(time_series$Offence.Type)] <- NA

time_series
```

    ## # A tibble: 22 x 7
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

    ## # A tibble: 22 x 8
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

    ## # A tibble: 22 x 7
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

    ## # A tibble: 110 x 4
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

totals
```

    ## # A tibble: 22 x 3
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

    ## # A tibble: 22 x 8
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
| :------: | :---------------------------- |
|   \==    | Equal to                      |
|   \!=    | Not equal to                  |
|    \>    | Greater than                  |
|    \<    | Less than                     |
|   \>=    | Greater than or equal to      |
|   \<=    | Less than or equal to         |
|    ǀ     | Or                            |
|    &     | And                           |
|    \!    | Not                           |
|   %in%   | The subject appears in a list |
| is.na()  | The subject is NA             |
