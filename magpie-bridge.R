#!/usr/bin/env Rscript

## TODO register format handlers somehow

function read.dataset(format, file) {
    dataset <- NULL
    ## TODO this should be a lookup in a registry
    if (format == "csv") {
        dataset <- read.dataset.csv(file)
    }

    return(dataset)
}

function read.dataset.csv(file) {
    return(read.csv(file, as.is=TRUE))
}

## TODO compile a regex to parse the arguments, FORMAT:R_NAME:FILE
## ([^:]+):([^:]+):(.+)

args <- commandArgs(trailingOnly=TRUE)

for (s in args) {
    ## TODO assign(...)
}
