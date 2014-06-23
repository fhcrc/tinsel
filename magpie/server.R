library(knitr)
library(shinyAce)

## TODO move "plugin" code to new files

## tinsel is a plugin that reads a JSON file and sets up... something.
## this could range from something as small as a bit of boilerplate
## code to include before knitting an Rmd file (as in this prototype),
## or it could be responsible for setting up an entire pipeline.

## TODO beware excessive soft-coding
tinsel.server <- quote({
    ## tinsel's only server responsibility here is to watch the session
    ## variable and parse the supplied magpie JSON configuration if the
    ## 'url' query parameter is present.

    observe({
        query <- parseQueryString(session$clientData$url_search)
        url <- query$url

        ## TODO handle missing parameters or connection errors
        ## TODO tinsel shouldn't know about knitr; write to a pipe instead
        updateAceEditor(session, 'knitrNotebook', value = paste(readLines(con = url), collapse = '\n'))
    })
})

## the knitr plugin presents the user with an interactive R notebook
## that's already been set up for them to do fun things with their
## data.

knitr.server <- quote({
    ## knitr reacts when the notebook's action button is pressed by
    ## grabbing the notebook's contents and rendering it.
    ## TODO read the notebook's contents from a pipe instead
    output$knitrOut <- renderUI({
        input$knitrRefresh
        isolate(withMathJax(HTML(knit2html(text = input$knitrNotebook, fragment.only = TRUE, quiet = TRUE))))
    })

    ## knitr also switches the active tab in the UI when the
    ## notebook's action button is pressed.
    observe({
        input$knitrRefresh
        updateTabsetPanel(session, 'magpieTabs', selected = 'knitr')
    })
})

## Having most of the server logic offloaded to plugins makes for a
## terse call to shinyServer :)

shinyServer(function(input, output, session) {
    ## eval the plugins
    ## TODO we should lapply(server(plugins), eval) or something
    eval(tinsel.server)
    eval(knitr.server)
})
