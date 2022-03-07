# Render markdowns

# render readme.Rmd as GitHub markdown document
show_solution <- FALSE # This determines if the solutions are displayed in the slides
purl_solutions <- FALSE # This variable relates to code blocks that are exercise solutions
purl_example_code <- TRUE # This variable relates to code blocks that aren't exercise solutions
rmarkdown::render("coffee_and_coding/coffee_coding_1.Rmd", output_format = "github_document")
file.remove("coffee_and_coding/coffee_coding_1.html")

# render slides.Rmd as an ioslides presentation
show_solution <- TRUE
purl_solutions <- FALSE
purl_example_code <- TRUE
rmarkdown::render("coffee_and_coding/coffee_coding_1.Rmd", output_format = "ioslides_presentation")
file.rename("coffee_and_coding/coffee_coding_1.html", "coffee_and_coding/coffee_coding_1_slides.html")

# extract R code from content.Rmd into separate script
purl_solutions <- FALSE # This means solutions won't be included
purl_example_code <- TRUE # This means all code apart from solutions will be included
knitr::purl("coffee_and_coding/coffee_coding_1.Rmd", documentation=0)
file.rename("coffee_coding_1.R", "coffee_and_coding/example_code.R")

purl_solutions <- TRUE # This means solutions will be included
purl_example_code <- FALSE # This means code that isn't an exercise solution won't be included
knitr::purl("coffee_and_coding/coffee_coding_1.Rmd", documentation=0)
file.rename("coffee_coding_1.R", "coffee_and_coding/solutions.R")
