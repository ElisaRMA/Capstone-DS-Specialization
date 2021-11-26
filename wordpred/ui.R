#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
        theme = shinytheme("slate"),

    
    # Application title
        titlePanel("WordPred: Next Word Prediction"),

    # Sidebar with a slider input for number of bins
        sidebarLayout(
                sidebarPanel(
                        width = 4,
                        textInput("input",
                                  "Type your text:",
                                  placeholder="Your text here"),
                        submitButton("Predict"),
                        br(),
                        h4('Predicted Word:'),
                        textOutput("predWord")
            ),

        # Show a plot of the generated distribution
        mainPanel(
                h2("Instructions"),
                hr(),
                htmlOutput('instruct'),
                h2("About"),
                hr(),
                htmlOutput('abt'),
                h2("Further Information"),
                hr(),
                HTML("<p>For futher informations or if you have any questions feel free to contact me at <a href='https://www.linkedin.com/in/elisarma/'> <b> LinkedIn </b> </a> </p> <br>
                     <p> The code for this app is available at my <a href='https://github.com/ElisaRMA'> <b>Github</b>! </a> </p>"),
                     
        )
    )
))
