#!/usr/bin/env Rscript

library(shiny)
library(knitr)

## THIS IS LITERALLY ALL THAT WE NEED TO DO
shiny::runApp('magpie', host="0.0.0.0", port=13758)
