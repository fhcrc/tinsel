library(shiny)
library(knitr)

source.file <- list(name = "default", value = "\n## this is the default file")
makeReactiveBinding("source.file")

knitr.plugin <- function(input, output, session) {
    output$knitrDocument <- renderUI({
        on.exit(unlink("figure/", recursive = TRUE))

        if (is.null(source.file)) return("no source file available")
        src <- source.file$value

        if (length(src) == 0L || src == "") return("source file is empty")

        withMathJax(HTML(paste(knit2html(text = src, fragment.only = TRUE, quiet = TRUE), sep = "\n")))
    })
}

source.plugin <- function(input, output, session) {
    cdata <- session$clientData

    observe({
        query <- parseQueryString(cdata$url_search)

        if (is.null(query$src)) return()

        src <- paste(readLines(query$src), collapse = "\n")
        source.file <- list(name = query$src, value = src)

        print(source.file)
    })

    observe({
        source.file

        updateAceEditor(session, "sourceEditor", value = source.file$value)
    })

    observe({
        if (is.null(input$sourceEditor)) return()

        source.file <- list(name = "notebook save", value = input$sourceEditor)

        print(source.file)
    })
}

shinyServer(function(input, output, session) {
    source.plugin(input, output, session)
    knitr.plugin(input, output, session)
})
