library(here)
library(googledrive)
setwd(here())
drive_download("Bibliography/BibTeX_Library.bib", overwrite=TRUE, path='book.bib')
bookdown::render_book("index.Rmd", 
                      "bookdown::bs4_book",
                      output_dir="docs")