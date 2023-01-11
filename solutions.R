
# Conditional statements - solution to exercise 1
offenders <- offenders %>%
  dplyr::mutate(COURT_ORDER = dplyr::if_else(SENTENCE == "Court_order", 1, 0))

str(offenders)

# Conditional statements - solution to exercise 2
offenders <- offenders %>%
  dplyr::mutate(PREV_CONVICTIONS_BAND = dplyr::case_when(
    PREV_CONVICTIONS < 5 ~ "Low",
    PREV_CONVICTIONS <= 10 ~ "Medium",
    PREV_CONVICTIONS > 10 ~ "High",
    TRUE ~ "Unknown"
  ))
str(offenders)


# Iteration - solution to exercise 1
dates <- c("2020-03-01", "2020-06-01", "2020-09-01", "2020-12-01")

for (date in dates) {
  print(paste("The current date is", date))
}

# Iteration - solution to exercise 2
for (date in dates) {

  if (date == "2020-06-01") {
    next
  }

  print(paste("The current date is", date))
}


# Missing data - solution to exercise 1
fruit %>% dplyr::filter(!complete.cases(.))

# Missing data - solution to exercise 2
fruit %>% tidyr::replace_na(list(Cost = "Unknown",
                                 Quantity = 0))


## people = tibble::tribble(~name, ~key, ~value,
##                  #------------/------/-----,
##                  "Phil Woods", "age",45,
##                  "Phil Woods", "height",185,
##                  "Phil Woods", "age",50,
##                  "Jess Cordero", "age",45,
##                  "Jess Cordero", "height",156,)

## rcj = tibble::tribble(~judge, ~male, ~female,
##                       "yes", NA, 10,
##                       "no", 20, 12)

table4a %>% tidyr::pivot_longer(cols = !country, names_to = "year",values_to = "value")

#without changing anything on the dataset
people = tibble::tribble(~name, ~key, ~value,
                 #------------/------/-----,
                 "Phil Woods", "age",45,
                 "Phil Woods", "height",185,
                 "Phil Woods", "age",50,
                 "Jess Cordero", "age",45,
                 "Jess Cordero", "height",156,)
people %>% tidyr::pivot_wider(names_from = name, values_from = value)
# solution 1 - adding a new column
people = tibble::tribble(~name, ~key, ~value, ~dkey,
                 #------------/------/-----,
                 "Phil Woods", "age",45,1,
                 "Phil Woods", "height",185,1,
                 "Phil Woods", "age",50,0,
                 "Jess Cordero", "age",45,1,
                 "Jess Cordero", "height",156,1)
people %>% tidyr::pivot_wider(names_from = name, values_from = value)
#solution 2  - uniqueness
people = tibble::tribble(~name, ~key, ~value,
                 #------------/------/-----,
                 "Phil Woods", "age",45,
                 "Phil Woods", "height",185,
                 # "Phil Woods", "age",50,
                 "Jess Cordero", "age",45,
                 "Jess Cordero", "height",156,)
people %>% tidyr::pivot_wider(names_from = name, values_from = value)

rcj = tibble::tribble( ~judge, ~male, ~female,
                    "yes", NA, 10, 
                    "no", 20, 12)
#alternative table to try with no NAs
# rcj = tribble( ~judge, ~male, ~female,
#                     "yes", 4, 10, 
#                     "no", 20, 12)
#use of pivot_longer
rcj %>% tidyr::pivot_longer(cols = c(male, female),   names_to = "gender", values_to = "count")

# use of  pivot_wider 
rcj %>% tidyr::pivot_wider(names_from = judge, values_from = c(male, female))

















## tibble::tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
##   tidyr::separate(x, c("one", "two", "three"))
## tibble::tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
##   tidyr::separate(x, c("one", "two", "three"))

# Typing `?separate()` shows all the options and their meanings.
# Try experimenting with them to discover more about what they do.

tibble::tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  tidyr::separate(x, c("one", "two", "three"))
tibble::tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  tidyr::separate(x, c("one", "two", "three"))

# Solution: typing `?separate()` in the command line shows all the information needed here.
# The `remove` option is there to remove the input columns from the output. 

# Solution: one suggestion is that there is only one way to unite the multiple strings but
# a number of different ways to split them apart. 


x <- c("a", "abc", "abcd", "abcde", "abcdef")
L <- stringr::str_length(x)
m <- ceiling(L / 2)
stringr::str_sub(x, m, m)
#> [1] "a" "b" "b" "c" "c"

str_commasep <- function(x, delim = ",") {
  n <- length(x)
  if (n == 0) {
    ""
  } else if (n == 1) {
    x
  } else if (n == 2) {
    # no comma before and when n == 2
    stringr::str_c(x[[1]], "and", x[[2]], sep = " ")
  } else {
    # commas after all n - 1 elements
    not_last <- stringr::str_c(x[seq_len(n - 1)], delim)
    # prepend "and" to the last element
    last <- stringr::str_c("and", x[[n]], sep = " ")
    # combine parts with spaces
    stringr::str_c(c(not_last, last), collapse = " ")
  }
}


## # And if all goes well the output would be the following:
## str_commasep("")
## #> [1] ""
## str_commasep("a")
## #> [1] "a"
## str_commasep(c("a", "b"))
## #> [1] "a and b"
## str_commasep(c("a", "b", "c"))
## #> [1] "a, b, and c"
## str_commasep(c("a", "b", "c", "d"))
## #> [1] "a, b, c, and d"























# one regex
words[stringr::str_detect(words, "^d|d$")] %>% head(5)
#> [1] "add" "afford" "and" "around" "attend"
# split regex into parts
start_with_x <- stringr::str_detect(words, "^d")
end_with_x <- stringr::str_detect(words, "d$")
words[start_with_x | end_with_x] %>% head(5)
#> [1] "add" "afford" "and" "around" "attend"

stringr::str_subset(words, "^[aeiou].*[^aeiou]$") %>% head()
#> [1] "about"   "accept"  "account" "across"  "act"     "actual"
start_with_vowel <- stringr::str_detect(words, "^[aeiou]")
end_with_consonant <- stringr::str_detect(words, "[^aeiou]$")
words[start_with_vowel & end_with_consonant] %>% head()
#> [1] "about"   "accept"  "account" "across"  "act"     "actual"



library(purrr)

pattern <-
  cross(rerun(5, c("a", "e", "i", "o", "u")),
    .filter = function(...) {
      x <- as.character(unlist(list(...)))
      length(x) != length(unique(x))
    }
  ) %>%
  purrr::map_chr(~stringr::str_c(unlist(.x), collapse = ".*")) %>%
  stringr::str_c(collapse = "|")


stringr::str_extract(sentences, "[A-ZAa-z]+") %>% head()
#> [1] "The"   "Glue"  "It"    "These" "Rice"  "The"


stringr::str_extract(sentences, "[A-Za-z][A-Za-z']*") %>% head()
#> [1] "The"   "Glue"  "It's"  "These" "Rice"  "The"


pattern <- "\\b[A-Za-z]+ing\\b"
sentences_with_ing <- stringr::str_detect(sentences, pattern)
unique(unlist(stringr::str_extract_all(sentences[sentences_with_ing], pattern))) %>%
  head()
#> [1] "spring"  "evening" "morning" "winding" "living"  "king"



unique(unlist(stringr::str_extract_all(sentences, "\\b[A-Za-z]{3,}s\\b"))) %>%
  head()
#> [1] "planks" "days"   "bowls"  "lemons" "makes"  "hogs"


stringr::str_replace_all("past/present/future", "/", "\\\\")
#> [1] "past\\present\\future"


replacements <- c("A" = "a", "B" = "b", "C" = "c", "D" = "d", "E" = "e",
                  "F" = "f", "G" = "g", "H" = "h", "I" = "i", "J" = "j", 
                  "K" = "k", "L" = "l", "M" = "m", "N" = "n", "O" = "o", 
                  "P" = "p", "Q" = "q", "R" = "r", "S" = "s", "T" = "t", 
                  "U" = "u", "V" = "v", "W" = "w", "X" = "x", "Y" = "y", 
                  "Z" = "z")
lower_words <- stringr::str_replace_all(words, pattern = replacements)
head(lower_words)
#> [1] "a"        "able"     "about"    "absolute" "accept"   "account"

swapped <- stringr::str_replace_all(words, "^([A-Za-z])(.*)([A-Za-z])$", "\\3\\2\\1")

intersect(swapped, words)

swapped2 <- stringr::str_replace_all(words, "^([[:alpha:]])(.*)([[:alpha:]])$", "\\3\\2\\1")
intersect(swapped2, words)








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
