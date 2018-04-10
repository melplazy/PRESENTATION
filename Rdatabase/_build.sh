#!/bin/sh

R --slave --silent <<RSCRIPT
options("width" = 82)
rmarkdown::render(
  input = 'Rdatabase.Rmd', 
  encoding = 'UTF-8'
)

RSCRIPT
