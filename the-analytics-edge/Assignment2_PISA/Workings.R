pisaTrain<- read.csv("pisa2009train.csv", header = TRUE)
pisaTest<- read.csv("pisa2009test.csv", header = TRUE)

tapply(pisaTrain$readingScore,pisaTrain$male,mean) 
colSums(!is.na(pisaTrain) == 0)

pisaTrain = na.omit(pisaTrain)
pisaTest = na.omit(pisaTest)

pisaTrain$raceeth = relevel(pisaTrain$raceeth, "White")
pisaTest$raceeth = relevel(pisaTest$raceeth, "White")

lmScore<-lm(readingScore ~ ., data = pisaTrain)
summary(lmScore)
RMSE=sqrt( mean( (lmScore$fitted.values-pisaTrain$readingScore)^2 , na.rm = TRUE ) )
RMSE

predTest<-predict(lmScore,pisaTest)
summary(predTest)[6]-summary(predTest)[1]

# SSE
sum((predTest- pisaTest$readingScore)^2)

# RMSE
sqrt( mean( (predTest-pisaTest$readingScore)^2 , na.rm = TRUE ) )

# SST
sum( (mean(pisaTrain$readingScore) - pisaTest$readingScore)^2)