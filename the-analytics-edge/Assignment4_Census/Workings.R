census<- read.csv("census.csv", header = TRUE)

set.seed(2000)
library(caTools)
split = sample.split(census$over50k, SplitRatio = 0.6)
train = subset(census, split == TRUE)
test = subset(census, split == FALSE)

LogModel<-glm(over50k ~ . , data=train,family="binomial")
summary(LogModel)

library(memisc)
library(caret)
pred<-cases(
  " <=50K"=(predict(LogModel,test,type='response')<0.5),
  " >50K"=TRUE)
confusionMatrix(pred,test$over50k)

max(table(test$over50k))/nrow(test)

library(ROCR)
pred2<-prediction(predict(LogModel,test,type='response'),test$over50k)
performance(pred2,"auc")

library(rpart)
CART = rpart(over50k ~ . , data=train, method="class")
plot(CART)
text(CART)

predc<-predict(CART,test,type='class')
confusionMatrix(predc,test$over50k)

pred2c<-prediction(predict(CART,test,type='prob')[,2],test$over50k)
performance(pred2c,"auc")

#roc curve
perfc <- performance(pred2c,"tpr","fpr")
plot(perfc)
perf <- performance(pred2,"tpr","fpr")
plot(perf)

set.seed(1)
trainSmall = train[sample(nrow(train), 2000), ]

library(randomForest)
set.seed(1)
RF<-randomForest(over50k ~ . ,data=trainSmall,method="rf")

predf<-predict(RF,test)
confusionMatrix(predf,test$over50k)

#importance of variables
vu = varUsed(RF, count=TRUE)
vusorted = sort(vu, decreasing = FALSE, index.return = TRUE)
dotchart(vusorted$x, names(RF$forest$xlevels[vusorted$ix]))

varImpPlot(RF)

set.seed(2)
cartControl <- trainControl(method="cv", number=10)
cartGrid = expand.grid( .cp = seq(0.002,0.1,0.002))
CARTCV<-train( over50k ~ ., data = train,
              method = "rpart",
              trControl = cartControl,
              tuneGrid = cartGrid)

CART2 = rpart(over50k ~ . , data=train, method="class",cp=0.002)
plot(CART2)
text(CART2)
summary(CART2)

predc2<-predict(CART2,test,type='class')
confusionMatrix(predc2,test$over50k)