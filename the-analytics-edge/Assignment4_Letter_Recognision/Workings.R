letters <- read.csv("letters_ABPR.csv", header = TRUE)
letters$isB = as.factor(letters$letter == "B")

set.seed(1000)
library(caTools)
split = sample.split(letters$isB, SplitRatio = 0.5)
train = subset(letters, split == TRUE)
test = subset(letters, split == FALSE)

table(train$isB)

library(rpart)
CARTb = rpart(isB ~ . - letter, data=train, method="class")

library(caret)
pred<-predict(CARTb,test,type='class')
confusionMatrix(pred,test$isB)

set.seed(1000)
RFb<-train(isB ~ . - letter,data=train,method="rf")

pred2<-predict(RFb,test,type='raw')
confusionMatrix(pred2,test$isB)

letters <- read.csv("letters_ABPR.csv", header = TRUE)
letters$letter = as.factor( letters$letter) 

set.seed(2000)
split = sample.split(letters$letter, SplitRatio = 0.5)
train = subset(letters, split == TRUE)
test = subset(letters, split == FALSE)

CART = rpart(letter ~ . , data=train, method="class")
pred<-predict(CART,test,type='class')
confusionMatrix(pred,test$letter)

set.seed(1000)
RF<-train(letter ~ . - letter,data=train,method="rf")
pred2<-predict(RF,test,type='raw')
confusionMatrix(pred2,test$letter)
