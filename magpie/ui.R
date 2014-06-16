library(shiny)
library(shinyAce)

knitr.plugin <-
    list(name = "knitr",
         output = uiOutput("knitrDocument"))

source.plugin <-
    list(name = "source",
         output = list(
             aceEditor("sourceEditor", mode = "markdown", value = "\n# magpie", height = "640px"),
             submitButton("knit")))

shinyUI(navbarPage(
    img(src = "magpie-64x64.png", style = "height: 1em; vertical-align: top;"),
    tabPanel(knitr.plugin$name, knitr.plugin$output),
    tabPanel(source.plugin$name, source.plugin$output)
    ))
