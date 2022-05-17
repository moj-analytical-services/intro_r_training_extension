# These variables determine whether or not exercise solutions are included
show_solution <- FALSE # This determines if the solutions are displayed in the readme
purl_solutions <- FALSE # This variable relates to code blocks that are exercise solutions
purl_example_code <- TRUE # This variable relates to code blocks that aren't exercise solutions

# Change botor settings to avoid printing debugger messages to the console
logger::log_threshold('WARN', namespace = 'botor')





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

# Solution
for (date in dates) {

  if (date == "2020-06-01") {
    next
  }

  print(paste("The current date is", date))
}


# Solution
fruit %>% dplyr::filter(!complete.cases(.))



# Solution
fruit %>% tidyr::replace_na(list(Cost = "Unknown",
                                 Quantity = 0))


## people = tribble(~name, ~key, ~value,
##                  #------------/------/-----,
##                  "Phil Woods", "age",45,
##                  "Phil Woods", "height",185,
##                  "Phil Woods", "age",50,
##                  "Jess Cordero", "age",45,
##                  "Jess Cordero", "height",156,)

rcj = tribble( ~judge, ~male, ~female,
                    "yes", NA, 10, 
                    "no", 20, 12)

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"))
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"))

## table4a %>% pivot_longer(cols = !country, names_to = "year",values_to = "value")

## #withough changing anything on the dataset
## people = tribble(~name, ~key, ~value,
##                  #------------/------/-----,
##                  "Phil Woods", "age",45,
##                  "Phil Woods", "height",185,
##                  "Phil Woods", "age",50,
##                  "Jess Cordero", "age",45,
##                  "Jess Cordero", "height",156,)
## people %>% pivot_wider(names_from = name, values_from = value)
## # solution 1 - adding a new column
## people = tribble(~name, ~key, ~value, ~dkey,
##                  #------------/------/-----,
##                  "Phil Woods", "age",45,1,
##                  "Phil Woods", "height",185,1,
##                  "Phil Woods", "age",50,0,
##                  "Jess Cordero", "age",45,1,
##                  "Jess Cordero", "height",156,1)
## people %>% pivot_wider(names_from = name, values_from = value)
## #solution 2  - uniqueness
## people = tribble(~name, ~key, ~value,
##                  #------------/------/-----,
##                  "Phil Woods", "age",45,
##                  "Phil Woods", "height",185,
##                  # "Phil Woods", "age",50,
##                  "Jess Cordero", "age",45,
##                  "Jess Cordero", "height",156,)
## people %>% pivot_wider(names_from = name, values_from = value)

## rcj = tribble( ~judge, ~male, ~female,
##                     "yes", NA, 10,
##                     "no", 20, 12)
## #alternative table to try with no NAs
## # rcj = tribble( ~judge, ~male, ~female,
## #                     "yes", 4, 10,
## #                     "no", 20, 12)
## #use of pivot_longer
## rcj %>% pivot_longer(cols = c(male, female),   names_to = "gender", values_to = "count")
## # use of  pivot_wider
## rcj %>% pivot_wider(names_from = judge, values_from = c(male, female))

## tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
##   separate(x, c("one", "two", "three"))
## tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
##   separate(x, c("one", "two", "three"))











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
