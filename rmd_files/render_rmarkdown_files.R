# Render markdowns

# render readme.Rmd as GitHub markdown document
rmarkdown::render("rmd_files/README.Rmd", output_format = "github_document")
file.remove("rmd_files/README.html")

# render slides.Rmd as an ioslides presentation
rmarkdown::render("rmd_files/slides.Rmd", output_format = "ioslides_presentation")

# move rendered files to main directory
file.rename("rmd_files/README.md", "README.md")
file.rename("rmd_files/slides.html", "slides.html")

# extract R code from content.Rmd into separate script
# knitr::purl("rmd_files/README.Rmd")
# file.rename("content.R", "example_code.R")
