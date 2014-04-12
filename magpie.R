#!/usr/bin/env Rscript

library(shiny)
library(knitr)

## TODO loop over all the formats we support in some programmatic way

args <- commandArgs(trailingOnly=TRUE)

## TODO actually, I'm confusing myself. This is the *server*, not the Galaxy tool.

for (s in args) {
    ## arguments are of the form FORMAT:R_NAME:FILE

    ## TODO actually, compile a regex instead of this, it'll be faster and have captures.
    ## FIXME of course this won't work if there are :s in the file name
    dataset <- strsplit(dataset_str, ':', fixed=TRUE)
    ## ? dataset <- c(dataset[1], dataset[2], strjoin(dataset[3:], ':'))

    ## tidy up the variable name to make it valid
    r.name <- make.names(c(dataset[2]))

    ## TODO invoke an appropriate handler based on FORMAT
    ## TODO do we always assume no header?
    assign(r.name, read.csv(file=dataset[3], header=TRUE, as.is=TRUE))
}

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
