#!/usr/bin/env Rscript

library(shiny)
library(knitr)

## THIS IS LITERALLY ALL THAT WE NEED TO DO
shiny::runApp('shiny', host="0.0.0.0", port=sample(1024:49151, 1))
