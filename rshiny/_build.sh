#!/bin/sh

Rscript -e "rmarkdown::render('rshiny.R',  encoding = 'UTF-8')"

mv rshiny.md README.md
