library(shiny)
library(knitr)

knitr.plugin <- function(input, output, session) {
    output$knitrDocument <- renderUI({
        on.exit(unlink("figure/", recursive = TRUE))

        ## TODO make this unaware of the source plugin
        src <- input$sourceEditor

        if (length(src) == 0L || src == "") return("Nothing to show yet...")
        withMathJax(HTML(paste(knit2html(text = src, fragment.only = TRUE, quiet = TRUE), sep = "\n")))
    })
}

source.plugin <- function(input, output, session) {
    cdata <- session$clientData

    observe({
        query <- parseQueryString(cdata$url_search)

        src <- ""
        if (!is.null(query$src)) {
            src <- paste(readLines(query$src), collapse = "\n")
        }

        updateAceEditor(session, "sourceEditor", value = src)
    })
}

shinyServer(function(input, output, session) {
    source.plugin(input, output, session)
    knitr.plugin(input, output, session)
})
