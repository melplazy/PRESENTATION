#!/bin/sh

Rscript -e "rmarkdown::render(input = 'joint_model.Rmd', encoding = 'UTF-8')"
