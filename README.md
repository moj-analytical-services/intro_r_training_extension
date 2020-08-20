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
`if_else()`, we need to provide it with three arguments in the format
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
able to separate youths from adult offenders. We could add a column that
contains a ‘1’ if the offender is under the age of 18, and ‘0’
otherwise:

``` r
offenders <- offenders %>%
  dplyr::mutate(youth = dplyr::if_else(AGE < 18, 1, 0))

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
    ##  $ youth           : num  0 0 0 0 0 0 0 0 0 0 ...

### Exercise

(Placeholder)

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

    ## 'data.frame':    1413 obs. of  13 variables:
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
    ##  $ youth           : num  0 0 0 0 0 0 0 0 0 0 ...
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

(Placeholder)

# Handling missing data

It’s often the case that datasets will contain missing values, which are
usually denoted by `NA` (which stands for ‘Note Available’) in R. Care
needs to be taken to make sure these are handled in the most appropriate
way for a particular situation. This section introduces a few methods
for handling missing values in different situations.

## Identifying missing values

The function `is.na()` can be used to identify missing values in a
variable. It returns `TRUE` is a value is `NA`, and `FALSE` otherwise:

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
the `NA` values before continuing with the calculation:

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

### Replacing with a specified value

We can also use the `replace()` function to replace missing values with
a specific value. In this example we’re replacing missing values with
zero:

``` r
x <- c(7, 23, 5, -14, NA, -1, 11,NA)
replace(x, is.na(x), 0)
```

    ## [1]   7  23   5 -14   0  -1  11   0

The `replace_na()` function from tidyr also provides a convenient way to
replace missing values in a dataframe, and is especially useful if you
want to use different replacement values for different columns. Here’s
an example of its usage, where we’re replacing missing values in the
`HEIGHT` column withn ‘Unknown’, and missing values in the
`PREV_CONVICTIONS` column with zero:

``` r
offenders <- offenders %>% 
  tidyr::replace_na(list(HEIGHT = "Unknown",
                         PREV_CONVICTIONS = 0))
```

### Replacing with values from another column

The `coalesce()` function from dplyr can be used to fill in missing
values with values from another column. Before we jump into an example,
let’s first prepare a dataframe:

``` r
event_dates <- tibble::data_frame(
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

We can use `coalesce()` to fill in the missing dates in the `New date`
column with the equivalent date in the `Date` column:

``` r
event_dates <- event_dates %>%
  dplyr::mutate(new_date = dplyr::coalesce(new_date, date))

event_dates
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

### Filling missing values with the previous value

If we were to encounter a dataframe like the following, where each group
name in the `year` column appears only once, then we might want to fill
in the missing labels before beginning any analysis.

``` r
# Construct dataframe
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
    ##  2 <NA>  Q2          3
    ##  3 <NA>  Q3         13
    ##  4 <NA>  Q4         10
    ##  5 2016  Q1          5
    ##  6 <NA>  Q2          8
    ##  7 <NA>  Q3          1
    ##  8 <NA>  Q4          7
    ##  9 2017  Q1          9
    ## 10 <NA>  Q2          6
    ## 11 <NA>  Q3         18
    ## 12 <NA>  Q4          4
    ## 13 2018  Q1         12
    ## 14 <NA>  Q2          2
    ## 15 <NA>  Q3         20
    ## 16 <NA>  Q4         16
    ## 17 2019  Q1         11
    ## 18 <NA>  Q2         15
    ## 19 <NA>  Q3         17
    ## 20 <NA>  Q4         14

The `fill()` function from dplyr is a convenient way to do this, and can
be used like this:

``` r
# Construct dataframe
df <- df %>% fill(year)

df
```

    ## # A tibble: 20 x 3
    ##    year  quarter count
    ##    <chr> <chr>   <int>
    ##  1 2015  Q1         19
    ##  2 2015  Q2          3
    ##  3 2015  Q3         13
    ##  4 2015  Q4         10
    ##  5 2016  Q1          5
    ##  6 2016  Q2          8
    ##  7 2016  Q3          1
    ##  8 2016  Q4          7
    ##  9 2017  Q1          9
    ## 10 2017  Q2          6
    ## 11 2017  Q3         18
    ## 12 2017  Q4          4
    ## 13 2018  Q1         12
    ## 14 2018  Q2          2
    ## 15 2018  Q3         20
    ## 16 2018  Q4         16
    ## 17 2019  Q1         11
    ## 18 2019  Q2         15
    ## 19 2019  Q3         17
    ## 20 2019  Q4         14

# Iteration

# Reshaping data

The tidyr package can help us to reshape dataframes - this can be really
helpful when we need to transform between tables that are easier to read
and tables that are easier to analyse.

Let’s look at an example with some aggregate data based on the
`offenders` dataset:

``` r
offenders_summary <- offenders %>%
  group_by(REGION, SENTENCE) %>%
  summarise(offender_count = n())

offenders_summary
```

    ## # A tibble: 12 x 3
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

## Transforming from long to wide format

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

    ## # A tibble: 4 x 4
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

## Transforming from wide to long format

In order to reverse the reshaping that we’ve just done, and go back from
a wide format to a long format, we can use the `pivot_longer()`
function:

``` r
offenders_summary <- offenders_summary %>%
  tidyr::pivot_longer(cols = -REGION, names_to = "SENTENCE", values_to = "offender_count")

offenders_summary
```

    ## # A tibble: 12 x 3
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

### Exercise

(Placeholder)

# String manipulation

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
    ##    Offence.Type    Offence.Group         `2014` `2015` `2016` `2017` `2018`
    ##    <chr>           <chr>                  <int>  <int>  <int>  <int>  <int>
    ##  1 01 Indictable … 01 Violence against …   7447   6930   6724   7233   6602
    ##  2 <NA>            02 Sexual offences      5289   5743   5610   4941   2930
    ##  3 <NA>            03 Robbery              9049   7236   6024   5953   5713
    ##  4 <NA>            04 Theft Offences       1726   1465   1265   1345   1097
    ##  5 <NA>            05 Criminal damage a…    711    738    647    648    563
    ##  6 <NA>            06 Drug offences           0      0     42    211     75
    ##  7 <NA>            07 Possession of wea…    729    776    860    776    912
    ##  8 <NA>            08 Public order offe…     27     68    665    773    842
    ##  9 <NA>            09 Miscellaneous cri…   3648   3054   2930   2763   2277
    ## 10 <NA>            10 Fraud Offences        421    460    408    379    173
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
    ##    Offence.Type  Offence.Group     `2014` `2015` `2016` `2017` `2018` Total
    ##    <chr>         <chr>              <int>  <int>  <int>  <int>  <int> <int>
    ##  1 01 Indictabl… 01 Violence agai…   7447   6930   6724   7233   6602 34936
    ##  2 <NA>          02 Sexual offenc…   5289   5743   5610   4941   2930 24513
    ##  3 <NA>          03 Robbery          9049   7236   6024   5953   5713 33975
    ##  4 <NA>          04 Theft Offences   1726   1465   1265   1345   1097  6898
    ##  5 <NA>          05 Criminal dama…    711    738    647    648    563  3307
    ##  6 <NA>          06 Drug offences       0      0     42    211     75   328
    ##  7 <NA>          07 Possession of…    729    776    860    776    912  4053
    ##  8 <NA>          08 Public order …     27     68    665    773    842  2375
    ##  9 <NA>          09 Miscellaneous…   3648   3054   2930   2763   2277 14672
    ## 10 <NA>          10 Fraud Offences    421    460    408    379    173  1841
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
    ##    Offence.Type    Offence.Group         `2014` `2015` `2016` `2017` `2018`
    ##    <chr>           <chr>                  <int>  <int>  <int>  <int>  <int>
    ##  1 01 Indictable … 01 Violence against …   7447   6930   6724   7233   6602
    ##  2 01 Indictable … 02 Sexual offences      5289   5743   5610   4941   2930
    ##  3 01 Indictable … 03 Robbery              9049   7236   6024   5953   5713
    ##  4 01 Indictable … 04 Theft Offences       1726   1465   1265   1345   1097
    ##  5 01 Indictable … 05 Criminal damage a…    711    738    647    648    563
    ##  6 01 Indictable … 06 Drug offences           0      0     42    211     75
    ##  7 01 Indictable … 07 Possession of wea…    729    776    860    776    912
    ##  8 01 Indictable … 08 Public order offe…     27     68    665    773    842
    ##  9 01 Indictable … 09 Miscellaneous cri…   3648   3054   2930   2763   2277
    ## 10 01 Indictable … 10 Fraud Offences        421    460    408    379    173
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
    ##    Offence.Type  Offence.Group     `2014` `2015` `2016` `2017` `2018` Total
    ##    <chr>         <chr>              <int>  <int>  <int>  <int>  <int> <int>
    ##  1 01 Indictabl… 01 Violence agai…   7447   6930   6724   7233   6602 34936
    ##  2 01 Indictabl… 02 Sexual offenc…   5289   5743   5610   4941   2930 24513
    ##  3 01 Indictabl… 03 Robbery          9049   7236   6024   5953   5713 33975
    ##  4 01 Indictabl… 04 Theft Offences   1726   1465   1265   1345   1097  6898
    ##  5 01 Indictabl… 05 Criminal dama…    711    738    647    648    563  3307
    ##  6 01 Indictabl… 06 Drug offences       0      0     42    211     75   328
    ##  7 01 Indictabl… 07 Possession of…    729    776    860    776    912  4053
    ##  8 01 Indictabl… 08 Public order …     27     68    665    773    842  2375
    ##  9 01 Indictabl… 09 Miscellaneous…   3648   3054   2930   2763   2277 14672
    ## 10 01 Indictabl… 10 Fraud Offences    421    460    408    379    173  1841
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

## Further Reading
