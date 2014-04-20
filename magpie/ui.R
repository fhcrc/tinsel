library(shiny)
library(shinyAce)

shinyUI(navbarPage(
    img(src = "magpie-64x64.png", style = "height: 1em; vertical-align: top;"),
    tabPanel("Output",
             uiOutput("knitDocument")
             ),
    tabPanel("Source",
             aceEditor("notebook", mode = "markdown", value = "## magpie ##\n", height = "640px")
             ## submitButton("Knit")
             )
    ))
