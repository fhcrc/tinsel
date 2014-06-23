#!/usr/bin/env Rscript

library(shiny)
options(shiny.reactlog=TRUE)

## THIS IS LITERALLY ALL THAT WE NEED TO DO
shiny::runApp('magpie', host="0.0.0.0", port=13758)
