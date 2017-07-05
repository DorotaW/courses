FluTrain<- read.csv("FluTrain.csv", header = TRUE)
FluTest<- read.csv("FluTest.csv", header = TRUE)

library(ggplot2)

qplot(Week, ILI, data=FluTrain, geom="point")
FluTrain[which(FluTrain$ILI==max(FluTrain$ILI)),]

qplot(Week, Queries, data=FluTrain, geom="point")
FluTrain[which(FluTrain$Queries==max(FluTrain$Queries)),]

qplot(ILI, data=FluTrain, geom="histogram")
qplot(Queries, log(ILI), data=FluTrain, geom="line")

FluTrend1<-lm(log(ILI) ~ Queries, data = FluTrain)
summary(FluTrend1)
cor(log(FluTrain$ILI),FluTrain$Queries)^2

PredTest1 = exp(predict(FluTrend1, newdata=FluTest))
(PredTest1[grep('2012-03-11',FluTest$Week)]-FluTest[grep('2012-03-11',FluTest$Week),2])/FluTest[grep('2012-03-11',FluTest$Week),2]

# RMSE
sqrt( mean( (PredTest1-FluTest$ILI)^2 , na.rm = TRUE ) )

library(zoo)
ILILag2 = lag(zoo(FluTrain$ILI), -2, na.pad=TRUE)
FluTrain$ILILag2 = coredata(ILILag2)
sum(is.na(ILILag2))

qplot(log(ILILag2), log(ILI), data=FluTrain, geom="line")
FluTrend2<-lm(log(ILI) ~ Queries+log(ILILag2), data = FluTrain)
summary(FluTrend2)

ILILag2 = lag(zoo(FluTest$ILI), -2, na.pad=TRUE)
FluTest$ILILag2 = coredata(ILILag2)
sum(is.na(ILILag2))
FluTest$ILILag2[1] = FluTrain$ILI[416]
FluTest$ILILag2[2] = FluTrain$ILI[417]

PredTest2 = exp(predict(FluTrend2, newdata=FluTest))
# RMSE
sqrt( mean( (PredTest2-FluTest$ILI)^2 , na.rm = TRUE ) )

predTest<-predict(lmScore,pisaTest)
summary(predTest)[6]-summary(predTest)[1]

# SSE
sum((predTest- pisaTest$readingScore)^2)

# RMSE
sqrt( mean( (predTest-pisaTest$readingScore)^2 , na.rm = TRUE ) )

# SST
sum( (mean(pisaTrain$readingScore) - pisaTest$readingScore)^2)