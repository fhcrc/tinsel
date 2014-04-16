library(shiny)
library(shinyAce)

shinyUI(fluidPage(
    fluidRow(
        column(6,
               selectInput("script", "Choose a script to load: ", c("None", "src/magpie-demo.Rmd")),
               actionButton("loadButton", "Load"),
               aceEditor("notebook", mode = "markdown", value = " ## welcome to magpie ##\n"),
               actionButton("knitButton", "Knit")
               ),
        column(5, offset = 1,
               uiOutput("knitDocument")
               )
        )
    ))
