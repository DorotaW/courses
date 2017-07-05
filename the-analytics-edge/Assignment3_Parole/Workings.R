data <- read.csv("parole.csv", header = TRUE)

str(data)
summary(data)
data$crime<-as.factor(data$crime)
data$state<-as.factor(data$state)

set.seed(144)
library(caTools)
split = sample.split(data$violator, SplitRatio = 0.7)
train = subset(data, split == TRUE)
test = subset(data, split == FALSE)

Log1 = glm(violator ~ ., data=train, family=binomial)
summary(Log1)
male, of white race, aged 50 years at prison release, from the state of Maryland, served 3 months, had a maximum sentence of 12 months

newdata<-as.data.frame(cbind(male=1,race=1,age=50,state=1,time.served=3,max.sentence=12,multiple.offenses=0,crime=2,violator=1))
a<-rbind(test,newdata)
a<-a[203,]

predict(Log1,a,type='response')
predict(Log1,a,type='response')/(1-predict(Log1,a,type='response'))
max(predict(Log1,test,type='response'))

library(memisc)
library(caret)
pred<-cases(
  "1"=(predict(Log1,test,type='response')>=0.5),
  "0"=TRUE)
confusionMatrix(pred,test$violator)

library(ROCR)
pred2<-prediction(predict(Log1,test,type='response'),test$violator)
performance(pred2,"auc")
