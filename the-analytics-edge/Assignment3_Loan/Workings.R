loans <- read.csv("loans.csv", header = TRUE)

table(loans$not.fully.paid)
summary(loans)
colSums(!is.na(loans) == 0)

library(mice)
set.seed(144)
vars.for.imputation = setdiff(names(loans), "not.fully.paid")
imputed = complete(mice(loans[vars.for.imputation]))
loans[vars.for.imputation] = imputed

set.seed(144)
library(caTools)
split = sample.split(loans$not.fully.paid, SplitRatio = 0.7)
train = subset(loans, split == TRUE)
test = subset(loans, split == FALSE)

Log1 = glm(not.fully.paid ~ ., data=loans, family=binomial)
summary(Log1)

a<-predict(Log1,test,type='response')

library(memisc)
library(caret)
pred<-as.numeric(as.character(cases(
  "1"=(a>=0.5),
  "0"=TRUE)))
confusionMatrix(pred,test$not.fully.paid)
(2402+11)/(2873)

library(ROCR)
pred2<-prediction(a,test$not.fully.paid)
performance(pred2,"auc")

Log2 = glm(not.fully.paid ~ int.rate, data=loans, family=binomial)
summary(Log2)

test$risk<-predict(Log2,test,type='response')
max(test$risk)


library(ROCR)
pred2<-prediction(test$risk,test$not.fully.paid)
performance(pred2,"auc")

test$profit = exp(test$int.rate*3) - 1
test$profit[test$not.fully.paid == 1] = -1
10*max(test$profit)

highInterest<-subset(test,int.rate>=0.15)
p
highInterest<-highInterest[order(highInterest$risk),]
mean(highInterest[1:100,15])
summary(highInterest)
