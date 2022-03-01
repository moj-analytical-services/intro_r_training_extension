# Render markdowns

# render readme.Rmd as GitHub markdown document
rmarkdown::render("coffee_and_coding/coffee_coding_1.Rmd", output_format = "github_document")
file.remove("coffee_and_coding/coffee_coding_1.html")

# render slides.Rmd as an ioslides presentation
rmarkdown::render("coffee_and_coding/coffee_coding_1.Rmd", output_format = "ioslides_presentation")
file.rename("coffee_and_coding/coffee_coding_1.html", "coffee_and_coding/coffee_coding_1_slides.html")

# extract R code from content.Rmd into separate script
# knitr::purl("rmd_files/README.Rmd")
# file.rename("content.R", "example_code.R")
