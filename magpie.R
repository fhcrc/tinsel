#!/usr/bin/env Rscript

library(shiny)
library(knitr)

## THIS IS LITERALLY ALL THAT WE NEED TO DO
shiny::runApp(system.file("shiny", package="knitr"), host="0.0.0.0", port=sample(1024:49151, 1))

## TODO add arguments for importing data into R
##
##      This might look something like:
##
##      $ magpie.R --csv hyperfreq.calls:/path/to/hyperfreq_calls.csv --fasta reference.seqs:/path/to/sequences.fasta
##
##      Then in R you'd have a data frame named hyperfreq.calls and a
##      $some_library sequence object named reference.seqs available.

## TODO combine this with grabcpu to fire up a shiny server on gizmo for interactive use
