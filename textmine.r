library(methods)
library(Rcpp)
library(RColorBrewer)
library(tm)
library(SnowballC)
library(wordcloud)


# pass username as argv using $ Rscript twitter_timeline.r 'argv <- "username"'
eval(parse(text = rev(commandArgs())[1]))
# argv <- "ReutersScience" # debug line

# import csv to data frame (using argv)
fileStub  <- paste( c(argv, "_timeline"), collapse = "")
tweets    <- read.csv( paste( c(fileStub, ".csv"), collapse = ""), header=FALSE, sep=",")
tweets_df <- do.call("cbind", lapply(tweets, as.data.frame))

# create text corpus and clean
tCorpus <- Corpus(VectorSource(tweets_df))
tCorpus <- tm_map(tCorpus, tolower)
# remove @mentions
removeAtMentions <- function(x) gsub("@[[:alnum:]]*", "", x)
tCorpus <- tm_map(tCorpus, removeAtMentions)
tCorpus <- tm_map(tCorpus, removePunctuation)
tCorpus <- tm_map(tCorpus, removeNumbers)
# remove URLs
removeURL <- function(x) gsub("http[[:alnum:]]*", "", x)
tCorpus   <- tm_map(tCorpus, removeURL)

# add extra stop words: 
twitterStopwords <- c(stopwords('english'), "rt", "via")
tCorpus <- tm_map(tCorpus, removeWords, twitterStopwords)

# stem and complete with dictionary 
tCorpusCopy <- tCorpus
tCorpus <- tm_map(tCorpus, stemDocument, language="english")
tCorpus <- tm_map(tCorpus, stemCompletion, dictionary=tCorpusCopy)

# build term document matrix
tdm <- TermDocumentMatrix(tCorpus) 

# calculate the frequency of words and sort them
termFrequency <- rowSums(as.matrix(tdm))
termFrequency <- subset(termFrequency, termFrequency>=10)
m <- as.matrix(tdm)
wordFreq <- sort(rowSums(m), decreasing=TRUE)

# create a word cloud
set.seed(375) # to make it reproducible
grayLevels <- gray( (wordFreq+10) / (max(wordFreq)+10) )
pdf( paste( c(fileStub, ".pdf"), collapse = ""))
wordcloud(words=names(wordFreq), freq=wordFreq, scale=c(4,.5), min.freq=3, random.order=F, colors=grayLevels)



