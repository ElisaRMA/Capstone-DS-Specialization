#Text prediction

library(tidyverse)
library(quanteda)
library(stringr)
library(readr)

#check if the files are there 
list.files("./Coursera-SwiftKey/final/en_US")

#read
blogs <- read_lines("./Coursera-SwiftKey/final/en_US/en_US.blogs.txt",n_max=400000)
news <- read_lines("./Coursera-SwiftKey/final/en_US/en_US.news.txt", n_max=500000) 
twitter <- read_lines("./Coursera-SwiftKey/final/en_US/en_US.twitter.txt", n_max=1000000)

blogs <- read_lines(file.choose(),n_max=400000)
news <- read_lines(file.choose(), n_max=500000) 
twitter <- read_lines(file.choose(), n_max=1000000)

all_data <- c(blogs,news,twitter) # 394 MB

#train test split
library(caret)
<- CreateDataPartition
train <-
test <- 
        
        
        

bcorpus <- corpus(sblogs)
ncorpus <- corpus(snews)
tcorpus <- corpus(stwitter)

length(c(twitter,blogs,news))*0.3

all <- sample(c(twitter, blogs, news), 100000)

dataset:con <- file("en_US.twitter.txt", "r") 
readLines(con, 1) ## Read the first line of text readLines(con, 1) 
## Read the next line of text 
readLines(con, 5) ## Read in the next 5 lines of text 
close(con) ## It's important to close the connection when you are done. See the connections help page for more information.

#Quiz 1
str_length(blogs)
str_length(blogs[1])


max(str_length(blogs))
max(str_length(news))
max(str_length(twitter))


length(grep('love', twitter))/length(grep('hate', twitter))


twitter[grep('biostats', twitter)]
length(grep("A computer once beat me at chess, but it was no match for me at kickboxing", twitter))

