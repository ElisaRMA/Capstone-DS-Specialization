
WordPred: Next Word prediction algorithm in collaboration of Swiftkey®
========================================================
author: Elisa R. M. Antunes
date: 11/11/2021
autosize: true
transition: fade

Introduction to WordPred
========================================================

WordPred is a web app built as part of the Capstone Project of the Data Science Especialization at Coursera.

The app was created using R language and the shiny package with the goal of predicting the next word in a phrase submitted by the user

<div align="center">
<img src="./figures/app.png">
</div>

How WordPred works
========================================================

<small> After the user inputs a phrase and press the "Predict" buttom, three words are returned as possible next words. </small>

<small> To return these predictions the phrase submitted by the user is parsed and searched in WordPred's database. </small> 

<small>If a match is found, the three most frequent last words are returned. If no match is found, three of the most frequent words are returned</small>

<div align="center">
<img src="./figures/predicted.jpg" >
</div>

How WordPred was created
========================================================
<small> The text data used to create WordPred was extracted from news, twitter and blogs sources. First, the data was transformed into corpus, tokenized and ngrams of 2 to 5 words were generated. </small>

<small> Next, a dataframe was created using the ngrams, its last words and their frequencies, alongside with a function. Given an input, the function uses a Back-Off strategy, therefore, it extracts the last words up to 4, searches the data frame on the 'input' column and returns the words from the 'prediction' column, based on the  'frequency' column. If no match is found, this process is repeated with a smaller ngram each time. </small> 

<div align="center">
<img src="./figures/table2.png" width=300 height=300>
</div>


How to use WordPred
========================================================

To use WordPred, acess the link https://mirandeli.shinyapps.io/wordpred/ 

On the left side of the page, input a phrase of your choice and press the buttom "Submit".

A few seconds later the app will return three words below the buttom as possible next words for the phrase you typed. 

On the right side of the page Instructions and further information can be found 

