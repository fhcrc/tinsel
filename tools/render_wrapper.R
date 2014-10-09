#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)

input.dataset <- args[1]
output.file <- args[2]

## Create an output directory. We'll be copying the source document
## here so that it will serve as rmarkdown::render's working
## directory, since it defaults to using the directory of its input
## file for intermediates and output.
output.dir <- file.path(getwd(), 'output')
dir.create(output.dir)

## Copy the input dataset to the output directory.
source.file <- file.path(output.dir, 'source.Rmd')
file.copy(input.dataset, source.file)

## Render the document.
rmarkdown::render(source.file, 'html_document', output_file = output.file, quiet = TRUE)

## Remove source.Rmd so it doesn't get discovered as an additional output.
unlink(source.file)
