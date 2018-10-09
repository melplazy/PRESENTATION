#!/bin/sh


R --slave --silent <<RSCRIPT
  rmarkdown::render(input = 'joint_model.Rmd', encoding = 'UTF-8')
RSCRIPT
