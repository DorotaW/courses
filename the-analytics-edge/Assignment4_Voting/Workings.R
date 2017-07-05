data <- read.csv("gerber.csv", h,eader = TRUE)

1.0*table(data$voting)[2]/(table(data$voting)[2]+table(data$voting)[1])
table(data$hawthorne,data$voting)[2,2]/(table(data$hawthorne)[2])
table(data$civicduty,data$voting)[2,2]/(table(data$civicduty)[2])
table(data$neighbors,data$voting)[2,2]/(table(data$neighbors)[2])
table(data$self,data$voting)[2,2]/(table(data$self)[2])
table(data$control,data$voting)[2,2]/(table(data$control)[2])

Log1 = glm(voting ~ hawthorne+civicduty+neighbors+self, data=data, family=binomial)
summary(Log1)

library(memisc)
library(caret)
pred<-cases(
  "1"=(predict(Log1,type='response')>=0.5),
  "0"=TRUE)
confusionMatrix(pred,data$voting)

library(ROCR)
pred2<-prediction(predict(Log1,type='response'),data$voting)
performance(pred2,"auc")

library(rpart)
CARTmodel = rpart(voting ~ civicduty + hawthorne + self + neighbors, data=data)
CARTmodel2 = rpart(voting ~ civicduty + hawthorne + self + neighbors, data=data, cp=0.0)
plot(CARTmodel2)
text(CARTmodel2)
CARTmodel3 = rpart(voting ~ civicduty + hawthorne + self + neighbors + sex, data=data, cp=0.0)
plot(CARTmodel3)
text(CARTmodel3)
CARTmodel4 = rpart(voting ~ control + sex, data=data, cp=0.0)
plot(CARTmodel4)
text(CARTmodel4)

Log2 = glm(voting ~ control + sex, data=data, family=binomial)
summary(Log2)
Possibilities = data.frame(sex=c(0,0,1,1),control=c(0,1,0,1))
predict(Log2, newdata=Possibilities, type="response")

Log3= glm(voting ~ sex + control + sex:control, data=data, family="binomial")
summary(Log3)
predict(Log3, newdata=Possibilities, type="response")

