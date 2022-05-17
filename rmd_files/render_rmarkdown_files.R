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
purl_solutions <- FALSE # This means solutions won't be included
purl_example_code <- TRUE # This means all code apart from solutions will be included
knitr::purl("rmd_files/README.Rmd", documentation=0)

# give it a more sensible name
file.rename("README.R", "example_code.R")

# extract solutions from content.Rmd into separate script
purl_solutions <- TRUE # This means solutions will be included
purl_example_code <- FALSE # This means code that isn't an exercise solution won't be included
knitr::purl("rmd_files/README.Rmd", documentation=0)
file.rename("README.R", "solutions.R")

# extract R code from content.Rmd into separate script
# knitr::purl("rmd_files/README.Rmd")
# file.rename("content.R", "example_code.R")
