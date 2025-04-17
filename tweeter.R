library(knitr)

library(tidyr)

library(dplyr)

library(readr)

library(ggplot2)

library(tibble)

library(stringr)

library(gridExtra)

library(scales)

library(lubridate)

library(ggrepel)

library(reshape2)

library(kableExtra)

library(tm)

library(wordcloud)

library(tidytext)

library(broom)

library(topicmodels)

tweets <- read.csv("~/Chong IT-534/project/tweets.csv/tweets.csv", comment.char="#")
view(tweets)

kable(tweets %>% group_by(lang) %>% count() %>% rename(Language = lang, 'Number of Tweets' = n))
kable(head(tweets %>% filter(lang=="es" & original_author=="") %>% select(lang, is_retweet, handle, text) %>% rename(Language = lang),5), format="html")%>%
  kable_styling() %>%
  column_spec(1, bold = T, width = "2cm", border_right = T) %>%
  column_spec(2, bold = T, width = "2cm", border_right = T) %>%
  column_spec(3, bold = T, width = "2cm", border_right = T) %>%
  column_spec(4, width = "19cm")
tweets$handle <- sub("realDonaldTrump", "Trump", tweets$handle)
tweets$handle <- sub("HillaryClinton", "Clinton", tweets$handle)
tweets$is_retweet <- as.logical(tweets$is_retweet)

kable(tweets %>% filter(is_retweet==FALSE) %>% group_by(handle) %>% count())
p1 <- tweets %>% filter(original_author != "") %>% group_by(original_author) %>% count() %>% filter(n>=5) %>% arrange(desc(n)) %>% ungroup()
# Create a bubble chart
ggplot(p1, aes(x = reorder(original_author, n), y = n, size = n)) +
  geom_point(color = "darkgreen", alpha = 0.7) +
  coord_flip() +
  labs(x = "", y = "Number of tweets retweeted by either Trump or Clinton") +
  theme(legend.position = "none")
# Create a bubble chart
ggplot(p1, aes(x = reorder(original_author, n), y = n, size = n)) +
  geom_point(color = "steelblue", alpha = 0.7) +
  coord_flip() +
  labs(x = "", y = "Number of tweets retweeted by either Trump or Clinton") +
  theme(legend.position = "none")
tweets$author <- ifelse(tweets$original_author != "", tweets$original_author, tweets$handle)

kable(head(tweets %>% select(author, handle, text), 20), format = "html") %>%
  kable_styling() %>%
  column_spec(1, bold = T, width = "2cm", border_right = T) %>%
  column_spec(2, bold = T, width = "2cm", border_right = T) %>%
  column_spec(3, width = "19cm")
tweets$text <- str_replace_all(tweets$text, "[\n]" , "") #remove new lines
tweets$text <- str_replace_all(tweets$text, "&amp", "") # rm ampersand
tweets$text <- str_replace_all(tweets$text, "http.*" , "")

tweets$text <- iconv(tweets$text, "latin1", "ASCII", sub="")
tweets <- tweets %>% rename (doc_id = id)
ClintonTweets <- tweets %>% filter(is_retweet=="FALSE" & handle=="Clinton")
TrumpTweets <- tweets %>% filter(is_retweet=="FALSE" & handle=="Trump") 
TrumpCorpus <- DataframeSource(TrumpTweets)
TrumpCorpus <- VCorpus(TrumpCorpus)

ClintonCorpus <- DataframeSource(ClintonTweets)
ClintonCorpus <- VCorpus(ClintonCorpus)

TrumpCorpus
print(sort(stopwords("en")))
CleanCorpus <- function(x){
  x <- tm_map(x, content_transformer(tolower))
  x <- tm_map(x, removeNumbers) #remove numbers before removing words. Otherwise "trump2016" leaves "trump"
  x <- tm_map(x, removeWords, tidytext::stop_words$word)
  x <- tm_map(x, removePunctuation)
  x <- tm_map(x, stripWhitespace)
  return(x)
}

RemoveNames <- function(x) {
  x <- tm_map(x, removeWords, c("donald", "hillary", "clinton", "trump", "realdonaldtrump", "hillaryclinton"))
  return(x)
}

CreateTermsMatrix <- function(x) {
  x <- TermDocumentMatrix(x)
  x <- as.matrix(x)
  y <- rowSums(x)
  y <- sort(y, decreasing=TRUE)
  return(y)
}

TrumpCorpus <- CleanCorpus(TrumpCorpus)
TermFreqTrump <- CreateTermsMatrix(TrumpCorpus)

content(TrumpCorpus[[1]])
TrumpDF[1:20,] %>%
  ggplot(aes(x = reorder(word, count), y = count, group = 1)) +
  geom_line(color = "blue", size = 1) +
  geom_point(color = "blue", size = 3) +
  theme(legend.position = "none") +
  labs(y = "") +  # Label the y-axis
  coord_flip()
ClintonCorpus <- CleanCorpus(ClintonCorpus)
TermFreqClinton <- CreateTermsMatrix(ClintonCorpus)

ClintonDF <- data.frame(word=names(TermFreqClinton), count=TermFreqClinton)

ClintonDF[1:20,] %>%
  ggplot(aes(x = reorder(word, count), y = count, group = 1)) +
  geom_line(color = "red", size = 1) +
  geom_point(color = "red", size = 3) +
  theme(legend.position = "none") +
  labs(y = "") +  # Label the y-axis
  coord_flip()
set.seed(2018)

TrumpCorpus1 <- RemoveNames(TrumpCorpus)
TermFreqTrump <- CreateTermsMatrix(TrumpCorpus1)
TrumpDF <- data.frame(word=names(TermFreqTrump), count=TermFreqTrump)

wordcloud(TrumpDF$word, TrumpDF$count, max.words = 100, scale=c(2.5,.5), random.color = TRUE, colors=brewer.pal(9,"Set1"))


ClintonCorpus1 <- RemoveNames(ClintonCorpus)
TermFreqClinton <- CreateTermsMatrix(ClintonCorpus1)
ClintonDF <- data.frame(word=names(TermFreqClinton), count=TermFreqClinton)

wordcloud(ClintonDF$word, ClintonDF$count, max.words = 100, scale=c(2.5,.5), random.color = TRUE, colors=brewer.pal(9,"Set1"))

allClinton <- paste(ClintonTweets$text, collapse = " ")
allTrump <- paste(TrumpTweets$text, collapse = " ")
allClTr <- c(allClinton, allTrump)

allClTr <- VectorSource(allClTr)
allCorpus <- VCorpus(allClTr)
allCorpus <- CleanCorpus(allCorpus)
allCorpus <- RemoveNames(allCorpus)

TermsAll <- TermDocumentMatrix(allCorpus)
colnames(TermsAll) <- c("Clinton", "Trump")
MatrixAll <- as.matrix(TermsAll)

comparison.cloud(MatrixAll, colors = c("red", "blue"), scale=c(2.3,.3), max.words = 75)

get_sentiments("bing")

#adding the date of the Tweets from the document level meta data
DocMetaTrump1 <- meta(TrumpCorpus1)
DocMetaTrump1$date <- date(DocMetaTrump1$time)
TrumpTidy1$date <- DocMetaTrump1$date

DocMetaClinton1 <- meta(ClintonCorpus1)
DocMetaClinton1$date <- date(DocMetaClinton1$time)
ClintonTidy1$date <- DocMetaClinton1$date

NoNamesTidy <- bind_rows(trump=TrumpTidy1, clinton=ClintonTidy1, .id="candidate")
Words <- NoNamesTidy %>% unnest_tokens(word, text)

Bing <- Words %>% inner_join(get_sentiments("bing"), by="word")

Nrc <- Words %>% inner_join(get_sentiments("nrc"), by="word")

n1 <- Nrc %>% filter(candidate=="trump") %>% count(sentiment) %>%
  ggplot(aes(x=sentiment, y=n, fill=sentiment)) +
  geom_bar(stat="identity") + coord_polar() +
  theme(legend.position = "none", axis.text.x = element_blank()) +
  geom_text(aes(label=sentiment, y=2500)) +
  labs(x="", y="", title="Trump")
n2 <- Nrc %>% filter(candidate=="clinton") %>% count(sentiment) %>%
  ggplot(aes(x=sentiment, y=n, fill=sentiment)) +
  geom_bar(stat="identity") + coord_polar() +
  theme(legend.position = "none", axis.text.x = element_blank()) +
  geom_text(aes(label=sentiment, y=2500)) +
  labs(x="", y="", title="Clinton")
grid.arrange(n1, n2, nrow=1)

