library(shinyAce)

## tinsel creates no tabs! all its work is done in server.R.

## the knitr plugin creates two tabs, one for the source notebook and
## one for the rendered output.

## TODO figure out how to get multiple tabPanels out of one expression

knitr.ui.notebook <- quote({
    tabPanel('notebook',
             aceEditor('knitrNotebook', mode = 'markdown', value = 'Nothing yet...'),
             actionButton('knitrRefresh', 'Re-knit', icon('refresh'))
             )
})

knitr.ui.output <- quote({
    tabPanel('knitr', uiOutput('knitrOut'))
})

## Set up magpie boilerplate and inject plugins where appropriate.
## TODO plugins should include their own dependencies (js, css, etc)
shinyUI(fluidPage(
    tags$head(
        tags$title('magpie'),
        tags$script(src = 'http://ajaxorg.github.io/ace/build/src-min-noconflict/ace.js'),
        tags$script(src = 'js/magpie.js')
    ),
    tags$body(
        ## TODO the sidebar and plugin control stuff is probably excessive/unnecessary
        sidebarLayout(
            sidebarPanel(
                fluidRow(img(src = 'img/magpie-64x64.png', style = 'float: right;')),
                wellPanel(
                    h4('available plugins'),
                    p('(note: this is just a mock-up)'),
                    checkboxInput('tinselEnable', 'tinsel', TRUE),
                    checkboxInput('knitrEnable', 'knitr', TRUE)
                )
            ),
            mainPanel(
                tabsetPanel(id = 'magpieTabs',
                            ## TODO we should lapply(ui(plugins), eval) or something
                            eval(knitr.ui.output),
                            eval(knitr.ui.notebook)
                            )
            )
        )
    )
))
