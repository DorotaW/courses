data <- read.csv("songs.csv", header = TRUE)

data[which(data$artistname=='Michael Jackson' & data$Top10==1),2]
table(data$timesignature)
dataord<-data[order(-data$tempo),c(2,9)]
dataord[1,]

SongsTrain<-subset(data,year<=2009)
SongsTest<-subset(data,year>2009)
nonvars = c("year", "songtitle", "artistname", "songID", "artistID")
SongsTrain = SongsTrain[ , !(names(SongsTrain) %in% nonvars) ]
SongsTest = SongsTest[ , !(names(SongsTest) %in% nonvars) ]

SongsLog1 = glm(Top10 ~ ., data=SongsTrain, family=binomial)
summary(SongsLog1)

cor(data$loudness,data$energy)
SongsLog2 = glm(Top10 ~ . - loudness, data=SongsTrain, family=binomial)
summary(SongsLog2)
SongsLog3 = glm(Top10 ~ . - energy, data=SongsTrain, family=binomial)
summary(SongsLog3)

library(caret)
library(memisc)
predTop10<-cases(
  "1"=(predict(SongsLog3,SongsTest,type="response")>=0.45),
  "0"=TRUE)
predTop10<-as.numeric(as.character(predTop10))
confusionMatrix(predTop10,SongsTest$Top10)
