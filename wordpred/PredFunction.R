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

