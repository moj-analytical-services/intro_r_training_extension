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
  - [Iteration](#iteration)
  - [Reshaping data](#reshaping-data)
  - [String manipulation](#string-manipulation)

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
library(tidyverse)
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
x <- 10

if (x < 10) {
  print("x is less than 10")
} else if (x == 10) {
  print("x is equal to 10")
} else if (x > 10) {
  print("x is greater than 10")
} else {
  print("x is not a number")
}
```

    ## [1] "x is equal to 10"

For the conditions themselves, we can make use of any of R’s relational
and logical operators. For a list of common operators, see the
[appendix](#table-of-operators).

# Iteration

# Reshaping data

# String manipulation

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
|    \\\|     | Or                            |
|    &     | And                           |
|    \!    | Not                           |
|   %in%   | The subject appears in a list |
| is.na()  | The subject is NA             |

## Further Reading
