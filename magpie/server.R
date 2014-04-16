library(shiny)
library(knitr)

shinyServer(function(input, output, session) {
    cdata = session$clientData
    observe({
        query <- parseQueryString(cdata$url_search)

        isolate({
            if (!is.null(query$url)) {
                updateAceEditor(session, "notebook", value = paste(readLines(query$url), collapse = "\n"))
            }
        })
    })

    observe({
        input$loadButton
        isolate({
            if (input$script == "None") {
                updateAceEditor(session, "notebook", value = "## welcome to magpie ##\n")
            } else {
                updateAceEditor(session, "notebook", value = paste(readLines(input$script), collapse = "\n"))
            }
        })
    })

    output$knitDocument <- renderUI({
        input$knitButton
        on.exit(unlink("figure/", recursive = TRUE))

        isolate({
            src <- input$notebook
            if (length(src) == 0L || src == "") return("Nothing to show yet...")

            withMathJax(HTML(paste(knit2html(text = src, fragment.only = TRUE, quiet = TRUE), sep = "\n")))
        })
    })
})
