library(shiny)
library(knitr)

shinyServer(function(input, output, session) {
    cdata <- session$clientData

    knitr.pre <- ""
    knitr.post <- ""

    observe({
        query <- parseQueryString(cdata$url_search)

        ## TODO these conditionals could be much more elegant

        src <- ""

        if (!is.null(query$pre)) {
            knitr.pre <- paste(readLines(query$pre), collapse = "\n")
        } else {
            knitr.pre <- ""
        }

        if (!is.null(query$src)) {
            src <- paste(readLines(query$src), collapse = "\n")
        }

        if (!is.null(query$post)) {
            knitr.post <- paste(readLines(query$post), collapse = "\n")
        } else {
            knitr.post <- "\n"
        }

        updateAceEditor(session, "notebook", value = src)
    })

    output$knitDocument <- renderUI({
        on.exit(unlink("figure/", recursive = TRUE))

        src <- paste(knitr.pre, input$notebook, knitr.post)

        if (length(src) == 0L || src == "") return("Nothing to show yet...")
        withMathJax(HTML(paste(knit2html(text = src, fragment.only = TRUE, quiet = TRUE), sep = "\n")))
    })
})
