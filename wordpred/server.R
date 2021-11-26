#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
source('PredFunction.R')

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$predWord <- renderText({
            
            words <- unlist(strsplit(input$input, " "))
            nwords <- length(words)
            
            if(nwords>0) 
                    PredFunction(dataTable=database, input=input$input)
            else return("No text to analyze, please enter some text.")
    })
    
    output$instruct <- renderUI({
            HTML("Welcome to the next-word prediction app build for the Data Science Specialization from Coursera.<br><br>
                  To use this app, input a phrase of your choice and click the <b>'Predict'</b> buttom. <br><br>
                  The app will return the three most probable words that could be used next.")})
    
    output$abt <- renderText("This app was build as part of the final project from the Data Science Specialization at Coursera. <br><br>
                             The goal of the project was to create a next-word prediction algorithm based on three text files provided by Swiftkey®. <br><br>
                             To create the app, the datasets were cleaned, transformed into corpus and tokenized. 
                             Next, a dataframe was created using the ngrams (2gram to 5gram) and their frequency. <br><br>
                             The dataframe contained 3 columns which were: <br>
                             1. ngrams - the last word, <br>
                             2. the last word of each ngram, <br>
                             3. the frequency of the respective ngram <br><br>
                             Following this step, the prediction function was created. The function used the backoff model, so it takes an input(phrase), parse it and search for it in the dataframe created. <br>
                             If the phrase was found in the dataframe, 3 words are returned, based on the frequency of the searched ngram. <br>
                             If the phrase is not found, the previous ngram is searched until some phrase or word is found in the dataframe. If no correspondence is detected,
                             the function return 3 random words from the most frequent found in the datasets.")
    

})
