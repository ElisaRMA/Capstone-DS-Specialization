library(readr) # to read .txt files
library(quanteda) # for NLP and Text Analysis 
library(quanteda.textplots)# for NLP and Text Analysis 
library(quanteda.textstats)# for NLP and Text Analysis 
library(stringi)# for searching strings 
library(data.table)
library(dplyr)

# The data was loaded separatly, each file at a time, divided in 5 parts to prevent memory problems during data processing

#################### TWITTER ####################

# Setting wd to load data #
setwd("./Coursera-SwiftKey/final/en_US")

# Loading and creating the corpus + tokens from twitter data #
for(i in 0:4) {
        assign(paste0("twitter",i), read_lines('en_US.twitter.txt', n_max = 472029, skip = 472029*i ))
}

# 100 expressions separated from twitter to use as test.
twitter_test <- twitter4[1:100]
# the expressions were deleted from twitter dataset that was used to 'train' the model.
twitter4 <- twitter4[-(1:100)]


saveRDS(twitter_test, "twitter_test.rds")
rm(twitter_test)

rm(i)
gc()

# Corpus and tokens # 
corpus_twitter <- eapply(.GlobalEnv, FUN=corpus, all.names = TRUE)

rm(twitter0, twitter1, twitter2, twitter3, twitter4)
gc()

tokens_twitter <- lapply(X=corpus_twitter, FUN = tokens, 
                         what="word", 
                         remove_punct = TRUE,
                         remove_numbers = TRUE, 
                         remove_separators = TRUE,
                         remove_url = TRUE,
                         remove_symbols=TRUE)

rm(corpus_twitter)
gc()

#Remove symbols
tokens_twitter_nosym <-lapply(tokens_twitter, tokens_remove,
                              pattern = c('[#$]+'),
                              valuetype = "regex",
                              verbose=TRUE) #removed 28,430 features of each

rm(tokens_twitter)
gc()

# everything to lowercase # 
clean_twitter_tokens <- lapply(tokens_twitter_nosym, tokens_tolower)

# N-gram # 
ngram_twitter <- lapply(clean_twitter_tokens, tokens_ngrams, n=2:5)

rm(tokens_twitter_nosym, clean_twitter_tokens)
gc()

# DFM #
dfm_twitter <- lapply(ngram_twitter, dfm, tolower=FALSE) 
saveRDS(dfm_twitter, 'dfm_twitter.rds')

rm(ngram_twitter)
gc()

# Frequency #
freq_twitter <- lapply(dfm_twitter, textstat_frequency)

# frequency tables to data table # 

library(data.table)

for (i in 1:5){
        assign(paste0('freq_twitter', i), as.data.table(freq_twitter[i]))
        
}


# removing unnecessary columns and renaming the ones that were kept# 
freq_twitter1 <- freq_twitter1[,c(3:5):=NULL]
names(freq_twitter1) <- c('feature', 'frequency')

freq_twitter2 <- freq_twitter2[,c(3:5):=NULL]
names(freq_twitter2) <- c('feature', 'frequency')

freq_twitter3 <- freq_twitter3[,c(3:5):=NULL]
names(freq_twitter3) <- c('feature', 'frequency')

freq_twitter4 <- freq_twitter4[,c(3:5):=NULL]
names(freq_twitter4) <- c('feature', 'frequency')

freq_twitter5 <- freq_twitter5[,c(3:5):=NULL]
names(freq_twitter5) <- c('feature', 'frequency')

rm(freq_twitter, dfm_twitter)
gc()

# combining = bind the rows and sum the same expressions - need to be done before. Also filter by frequency
library(dplyr)

data_twitter <- bind_rows(freq_twitter1, freq_twitter2, freq_twitter3, freq_twitter4, freq_twitter5)
saveRDS(data_twitter, 'data_twitterraw.rds')

data_twitter2 <- data_twitter[,list(frequency=sum(frequency)),by=feature]

data_twitter3 <- data_twitter2[frequency>2,]

rm(freq_twitter1, freq_twitter2, freq_twitter3, freq_twitter4, freq_twitter5, i)
gc()

# delete _ and remove the last word to place into a prediction column

library(stringi)

data_twitter3$feature <- stri_replace_all_regex(data_twitter3$feature, '_', ' ')

data_twitter3$prediction <- stri_extract_last_words(data_twitter3$feature)

data_twitter3$feature <- stri_replace_last(data_twitter3$feature, replacement = " ", 
                                             regex = stri_extract_last_words(data_twitter3$feature))

object.size(data_twitter3) #122078240 bytes

setcolorder(data_twitter3, c('feature', 'prediction', 'frequency'))

saveRDS(data_twitter3, 'twitterdb.rds')

#################### NEWS ####################

# Setting wd to load data #
setwd("./Coursera-SwiftKey/final/en_US")

# Loading and creating the corpus + tokens from news data #
for(i in 0:4) {
        assign(paste0("news",i), read_lines('en_US.news.txt', n_max = 202048, skip = 202048*i ))
}

# 100 expressions separated from news to use as test.
news_test <- news4[1:100]
# the expressions were deleted from news dataset that was used to 'train' the model.
news4 <- news4[-(1:100)]


saveRDS(news_test, "news_test.rds")
rm(news_test)

rm(i)
gc()

# Corpus and tokens # 
corpus_news <- eapply(.GlobalEnv, FUN=corpus, all.names = TRUE)


tokens_news <- lapply(X=corpus_news, FUN = tokens, 
                         what="word", 
                         remove_punct = TRUE,
                         remove_numbers = TRUE, 
                         remove_separators = TRUE,
                         remove_url = TRUE,
                         remove_symbols=TRUE)

rm(news0, news1, news2, news3, news4)
gc()

#Remove symbols
tokens_news_nosym <-lapply(tokens_news, tokens_remove,
                              pattern = c('[#$]+'),
                              valuetype = "regex",
                              verbose=TRUE) #removed around 120 features of each

rm(corpus_news, tokens_news)
gc()

# everything to lowercase # 
clean_news_tokens <- lapply(tokens_news_nosym, tokens_tolower)
saveRDS(clean_news_tokens, 'clean_news_tokens.rds')
# N-gram # 
ngram_news <- lapply(clean_news_tokens, tokens_ngrams, n=2:5)

rm(tokens_news_nosym, clean_news_tokens)
gc()

# DFM #
dfm_news <- lapply(ngram_news, dfm, tolower=FALSE) 
saveRDS(dfm_news, 'dfm_news.rds')
rm(ngram_news)
gc()

# Frequency #
freq_news <- lapply(dfm_news, textstat_frequency)

# frequency tables to data table # 

library(data.table)

for (i in 1:5){
        assign(paste0('freq_news', i), as.data.table(freq_news[i]))
        
}

freq_news5 <- as.data.table(freq_news[4])


# removing unnecessary columns and renaming the ones that were kept# 
freq_news1 <- freq_news1[,c(3:5):=NULL]
names(freq_news1) <- c('feature', 'frequency')

freq_news2 <- freq_news2[,c(3:5):=NULL]
names(freq_news2) <- c('feature', 'frequency')

freq_news3 <- freq_news3[,c(3:5):=NULL]
names(freq_news3) <- c('feature', 'frequency')

freq_news4 <- freq_news4[,c(3:5):=NULL]
names(freq_news4) <- c('feature', 'frequency')

freq_news5 <- freq_news5[,c(3:5):=NULL]
names(freq_news5) <- c('feature', 'frequency')

rm(freq_news, dfm_news)
gc()

# combining = bind the rows and sum the same expressions - need to be done before. Also filter by frequency
library(dplyr)

data_news <- bind_rows(freq_news1, freq_news2, freq_news3, freq_news4, freq_news5)
saveRDS(data_news, 'data_newsraw.rds')

data_news2 <- data_news[,list(frequency=sum(frequency)),by=feature]

data_news3 <- data_news2[frequency>2,]

rm(freq_news1, freq_news2, freq_news3, freq_news4, freq_news5, i)
gc()

# delete _ and remove the last word to place into a prediction column

library(stringi)

data_news3$feature <- stri_replace_all_regex(data_news3$feature, '_', ' ')

data_news3$prediction <- stri_extract_last_words(data_news3$feature)

data_news3$feature <- stri_replace_last(data_news3$feature, replacement = " ", 
                                           regex = stri_extract_last_words(data_news3$feature))

object.size(data_news3) #220717384 bytes

setcolorder(data_news3, c('feature', 'prediction', 'frequency'))

saveRDS(data_news3, 'newsdb.rds')

#################### BLOGS ####################

# Setting wd to load data #
setwd("./Coursera-SwiftKey/final/en_US")

# Loading and creating the corpus + tokens from blogs data #
for(i in 0:4) {
        assign(paste0("blogs",i), read_lines('en_US.blogs.txt', n_max = 179857, skip = 179857*i ))
}

# 100 expressions separated from blogs to use as test.
blogs_test <- blogs4[1:100]
# the expressions were deleted from blogs dataset that was used to 'train' the model.
blogs4 <- blogs4[-(1:100)]


saveRDS(blogs_test, "blogs_test.rds")
rm(blogs_test)

rm(i)
gc()

# Corpus and tokens # 
corpus_blogs <- eapply(.GlobalEnv, FUN=corpus, all.names = TRUE)


tokens_blogs <- lapply(X=corpus_blogs, FUN = tokens, 
                         what="word", 
                         remove_punct = TRUE,
                         remove_numbers = TRUE, 
                         remove_separators = TRUE,
                         remove_url = TRUE,
                         remove_symbols=TRUE)

rm(blogs0, blogs1, blogs2, blogs3, blogs4, corpus_blogs)
gc()

#Remove symbols
tokens_blogs_nosym <-lapply(tokens_blogs, tokens_remove,
                              pattern = c('[#$]+'),
                              valuetype = "regex",
                              verbose=TRUE) #removed around 300 features of each

rm(corpus_blogs, tokens_blogs)
gc()

# everything to lowercase # 
clean_blogs_tokens <- lapply(tokens_blogs_nosym, tokens_tolower)
saveRDS(clean_blogs_tokens, 'clean_blogs_tokens.rds')

rm(tokens_blogs_nosym)
gc()

# N-gram # 
ngram_blogs <- lapply(clean_blogs_tokens, tokens_ngrams, n=2:5)

rm(tokens_blogs_nosym, clean_blogs_tokens)
gc()

# DFM #
dfm_blogs <- lapply(ngram_blogs, dfm, tolower=FALSE) 
saveRDS(dfm_blogs, 'dfm_blogs.rds' )

rm(ngram_blogs)
gc()

# Frequency #
freq_blogs <- lapply(dfm_blogs, textstat_frequency)
saveRDS(freq_blogs, 'freq_blogs.rds')

# frequency tables to data table # 

library(data.table)

for (i in 1:5){
        assign(paste0('freq_blogs', i), as.data.table(freq_blogs[i]))
        
}


# removing unnecessary columns and renaming the ones that were kept# 
freq_blogs1 <- freq_blogs1[,c(3:5):=NULL]
names(freq_blogs1) <- c('feature', 'frequency')

freq_blogs2 <- freq_blogs2[,c(3:5):=NULL]
names(freq_blogs2) <- c('feature', 'frequency')

freq_blogs3 <- freq_blogs3[,c(3:5):=NULL]
names(freq_blogs3) <- c('feature', 'frequency')

freq_blogs4 <- freq_blogs4[,c(3:5):=NULL]
names(freq_blogs4) <- c('feature', 'frequency')

freq_blogs5 <- freq_blogs5[,c(3:5):=NULL]
names(freq_blogs5) <- c('feature', 'frequency')

rm(freq_blogs, dfm_blogs)
gc()

# combining = bind the rows and sum the same expressions - need to be done before. Also filter by frequency
library(dplyr)

data_blogs <- bind_rows(freq_blogs1, freq_blogs2, freq_blogs3, freq_blogs4, freq_blogs5)
saveRDS(data_blogs, 'data_blogsraw.rds')

data_blogs2 <- data_blogs[,list(frequency=sum(frequency)),by=feature]

data_blogs3 <- data_blogs2[frequency>2,]

rm(freq_blogs1, freq_blogs2, freq_blogs3, freq_blogs4, freq_blogs5, i)
gc()

# delete _ and remove the last word to place into a prediction column

library(stringi)

data_blogs3$feature <- stri_replace_all_regex(data_blogs3$feature, '_', ' ')

data_blogs3$prediction <- stri_extract_last_words(data_blogs3$feature)

data_blogs3$feature <- stri_replace_last(data_blogs3$feature, replacement = " ", 
                                         regex = stri_extract_last_words(data_blogs3$feature))

object.size(data_blogs3) #157445400 bytes

setcolorder(data_blogs3, c('feature', 'prediction', 'frequency'))

saveRDS(data_blogs3, 'blogsdb.rds')


# After loading each text file and its subparts were processed, all data was united into one data table to create the database for the app

########### Uniting all ###########

blogsdb <- readRDS("~/./blogsdb.rds")
newsdb <- readRDS("~/./newsdb.rds")
twitterdb <- readRDS("~/./twitterdb.rds")

library(dplyr)
database <- bind_rows(twitterdb, newsdb, blogsdb)

# sum the frequencies 
database <- aggregate(.~feature+prediction, data=database, FUN=sum)

# Checking the size - max of 1Gb so shiny can load it
dbsize <- object.size(database)
print(dbsize, units="Gb", standard='legacy', digits=3L)#0.356 Gb
        

#changing column names to be easier during the app creation
names(database)  <- c('input', 'prediction', 'frequency')

#empty characters deletion
library(stringr)
database <- database %>% 
        mutate(across(where(is.character), str_trim))

saveRDS(database, 'database.rds')

########### prediction function ###########

# V1- took too long to return the next possible words 
########## FUNCTION ##############

# Wordpred <- function(dataTable=database, phrase ="I love New") {
#         options(warn = -1)
#         print('calculating...')
#         library(data.table)
#         library(stringr)
#         
#         # separate words on the phrase and count them
#         words <- unlist(strsplit(phrase, " "))
#         wordcount <- length(words)
#         
#         # extract the ngrams of the phrase
# 
#         
#         #top most common words
#         top10 <- c("of ","in","to","for","on","to","at","and","in","with")
#         
#         #if phrase has more than 4 words, 
#         if(wordcount >= 4){
#                 
#                 fourgram <- tolower(words[(length(words)-3):length(words)])
#                 trigram <- tolower(words[(length(words)-2):length(words)])
#                 bigram <- tolower(words[(length(words)-1):length(words)])
#                 unigram <- tolower(words[length(words)])
#                 
#                 # search 4gram ans return 3 most common
#                 search <- str_detect(database$feature, paste(fourgram, collapse=" "))
#                 predwords <-database[search==TRUE,c(2,3)]
#                 if(nrow(predwords) > 0){
#                         predwords <- aggregate(.~prediction, data=database[search==TRUE,c(2,3)], FUN = sum)
#                         return(predwords[order(-predwords$frequency),][1:3,1])}
#                 
#                  #### aggregate AFTER
#                 
#                 # search 3grams and return 3 most common if there is
#                 search <- str_detect(database$feature, paste(trigram, collapse=" "))
#                 predwords <-database[search==TRUE,c(2,3)]
#                 if(nrow(predwords) > 0){ 
#                         predwords <- aggregate(.~prediction, data=database[search==TRUE,c(2,3)], FUN = sum)
#                         return(predwords[order(-predwords$frequency),][1:3,1])}
#                 
#                 # search 2grams and return 3 most common if there is
#                 search <- str_detect(database$feature, paste(bigram, collapse=" "))
#                 predwords <-database[search==TRUE,c(2,3)]
#                 if(nrow(predwords) > 0){
#                         predwords <- aggregate(.~prediction, data=database[search==TRUE,c(2,3)], FUN = sum)
#                         return(predwords[order(-predwords$frequency),][1:3,1])}
#                 
#                 # search 1grams and return 3 most common if there is
#                 search <- str_detect(database$feature, paste(unigram, collapse=" "))
#                 predwords <-database[search==TRUE,c(2,3)]
#                 if(nrow(predwords) > 0){
#                         predwords <- aggregate(.~prediction, data=database[search==TRUE,c(2,3)], FUN = sum)
#                         return(predwords[order(-predwords$frequency),][1:3,1])}
#                 
#                 #if nothing is found, return a random word from the 10 most frequent 
#                 return(sample(top10,1))
#                 
#         }
#         
# 
#         else if(wordcount == 3){
#                 
#                 trigram <- tolower(words[(length(words)-2):length(words)])
#                 bigram <- tolower(words[(length(words)-1):length(words)])
#                 unigram <- tolower(words[length(words)])
#                 
#                 # search 3grams and return 3 most common if there is
#                 search <- str_detect(database$feature, paste(trigram, collapse=" "))
#                 predwords <-database[search==TRUE,c(2,3)]
#                 if(nrow(predwords) > 0){
#                         predwords <- aggregate(.~prediction, data=database[search==TRUE,c(2,3)], FUN = sum)
#                         return (predwords[order(-predwords$frequency),][1:3,1])}
#                         
#                         
#                 
#                 # search 2grams and return 3 most common if there is
#                 search <- str_detect(database$feature, paste(bigram, collapse=" "))
#                 predwords <-database[search==TRUE,c(2,3)]
#                 if(nrow(predwords) > 0){
#                         predwords <- aggregate(.~prediction, data=database[search==TRUE,c(2,3)], FUN = sum)
#                         return (predwords[order(-predwords$frequency),][1:3,1])} 
#                 
#                 # search 1grams and return 3 most common if there is
#                 search <- str_detect(database$feature, paste(unigram, collapse=" "))
#                 predwords <-database[search==TRUE,c(2,3)]
#                 if(nrow(predwords) > 0){
#                         predwords <- aggregate(.~prediction, data=database[search==TRUE,c(2,3)], FUN = sum)
#                         return (predwords[order(-predwords$frequency),][1:3,1])}
#                 
#                 #if nothing is found, return a random word from the 10 most frequent 
#                 return(sample(top10,1))
#                 
#         }
#         
#         else if(wordcount == 2){
#                 
#                 bigram <- tolower(words[(length(words)-1):length(words)])
#                 unigram <- tolower(words[length(words)])
# 
#                 # search 2grams and return 3 most common if there is
#                 search <- str_detect(database$feature, paste(bigram, collapse=" "))
#                 predwords <-database[search==TRUE,c(2,3)]
#                 if(nrow(predwords) > 0){
#                         predwords <- aggregate(.~prediction, data=database[search==TRUE,c(2,3)], FUN = sum)
#                         return (predwords[order(-predwords$frequency),][1:3,1])}
#                 
#                 # search 1grams and return 3 most common if there is
#                 search <- str_detect(database$feature, paste(unigram, collapse=" "))
#                 predwords <-database[search==TRUE,c(2,3)]
#                 if(nrow(predwords) > 0){
#                         predwords <- aggregate(.~prediction, data=database[search==TRUE,c(2,3)], FUN = sum)
#                         return (predwords[order(-predwords$frequency),][1:3,1])}
#                 
#                 #if nothing is found, return a random word from the 10 most frequent 
#                 return(sample(top10,1))
#                 
#         }
#         
#         else {
#                 unigram <- tolower(words[length(words)])
#                 
#                 # search 1grams and return 3 most common if there is
#                 search <- str_detect(database$feature, paste(unigram, collapse=" "))
#                 predwords <-database[search==TRUE,c(2,3)]
#                 if(nrow(predwords) > 0){
#                         predwords <- aggregate(.~prediction, data=database[search==TRUE,c(2,3)], FUN = sum)
#                         return (predwords[order(-predwords$frequency),][1:3,1])}
#                 
#                 #if nothing is found, return a random word from the 10 most frequent 
#                 return(sample(top10,1))
#                 
#         }
#         
# 
#         #must return something
#         return(sample(top10,1))
#         
# }


########## FUNCTION2 ##############

PredFunction <- function(dataTable='dt', input='Lorem ipsum'){
        
        #setting up the function
        options(warn = -1)
        library(data.table)
        library(stringr)
        
        top10 <- c("of ","in","to","for",
                   "on","to","at","and",
                   "in","with")
        
        # parse the input, lowercase, separate words and count
        words <- tolower(unlist(strsplit(input, " ")))
        nwords <- length(words)
        
        if(nwords >= 4){
                
                #create 4gram and search
                fourgram <- paste(words[(nwords-3):nwords], collapse = " ")
                preds <- setorder(database[database$input==fourgram,], -frequency)
                if(nrow(preds)>0) return(preds[1,2])
                
                #create 3gram and search
                trigram <- paste(words[(nwords-2):nwords], collapse = " ")
                preds <- setorder(database[database$input==trigram,], -frequency)
                if(nrow(preds)>0) return(preds[1,2])
                
                #create 2gram and search
                bigram <- paste(words[(nwords-1):nwords], collapse = " ")
                preds <- setorder(database[database$input==bigram,], -frequency)
                if(nrow(preds)>0) return(preds[1,2])
                
                #create 1gram and search
                unigram <- paste(words[nwords], collapse = " ")
                preds <- setorder(database[database$input==unigram,], -frequency)
                if(nrow(preds)>0) return(preds[1,2])
                
                #if nothing is found, return random from top 10
                return(sample(top10, 3))
                
        }               
        
        else if (nwords==3){
                
                #create 3gram and search
                trigram <- paste(words[(nwords-2):nwords], collapse = " ")
                preds <- setorder(database[database$input==trigram,], -frequency)
                if(nrow(preds)>0) return(preds[1,2])
                
                
                #create 2gram and search
                bigram <- paste(words[(nwords-1):nwords], collapse = " ")
                preds <- setorder(database[database$input==bigram,], -frequency)
                if(nrow(preds)>0) return(preds[1,2])
                
                #create 1gram and search
                unigram <- paste(words[nwords], collapse = " ")
                preds <- setorder(database[database$input==unigram,], -frequency)
                if(nrow(preds)>0) return(preds[1,2])
                
                #if nothing is found, return random from top 10
                return(sample(top10, 3))
                
                
        }
        
        else if (nwords==2){
                
                #create 2gram and search
                bigram <- paste(words[(nwords-1):nwords], collapse = " ")
                preds <- setorder(database[database$input==bigram,], -frequency)
                if(nrow(preds)>0) return(preds[1,2])
                
                #create 1gram and search
                unigram <- paste(words[nwords], collapse = " ")
                preds <- setorder(database[database$input==unigram,], -frequency)
                if(nrow(preds)>0) return(preds[1,2])
                
                #if nothing is found, return random from top 10
                return(sample(top10, 3))
                
        }
        
        else {
                
                #create 1gram and search
                unigram <- paste(words[nwords], collapse = " ")
                preds <- setorder(database[database$input==unigram,], -frequency)
                if(nrow(preds)>0) return(preds[1,2])
                
                #if nothing is found, return random from top 10
                return(sample(top10, 3))
                
                
        }
        
        #if we get here, still need some prediction
        return(sample(top10, 3))
}


########## TEST ##############

# test set
blogs_test <- readRDS("./test data/blogs_test.rds")
news_test <- readRDS("./test data/news_test.rds")
twitter_test <- readRDS("./test data/twitter_test.rds")

testset <- c(blogs_test, news_test, twitter_test)

corpustest <- corpus(testset)
tokentest <- tokens(corpustest, what = 'sentence', 
                    remove_punct = TRUE,
                    remove_symbols = TRUE,
                    remove_numbers = TRUE,
                    remove_url = TRUE)

twitter_test <- readRDS("./wordpred/data/database.rds")

score <- 0 

for (i in 1:100) {
        samples <- unlist(sample(tokentest, 100))
        
        library(stringi)
        last_word <- stri_extract_last_words(samples[i])
        input <- stri_replace_last(samples[i], replacement = " ", 
                                   regex = paste0(last_word, "[:punct:]"))
        
        input <- str_trim(input, side='right')
        
        prediction <- unlist(PredFunction(database, input))
               
        if (prediction == last_word){
                score <- score + 1 
                
                
        }
        
        print(score) 
        
}

# Tests - scores x of 100 phrases
# 1 - 13
# 2 - 10
# 3 - 11
# 4 - 7 
# 5 - 14
# 6 - 17
# 7 - 13
# 8 - 9
# 9 - 11
# 10 - 11
# Média - 11% 