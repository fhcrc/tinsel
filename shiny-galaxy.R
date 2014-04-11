#!/usr/bin/env Rscript

require(shiny)
require(knitr)

## THIS IS LITERALLY ALL THAT WE NEED TO DO
shiny::runApp(system.file("shiny", package="knitr"))

## TODO combine this with grabcpu to fire up a shiny server on gizmo for interactive use
