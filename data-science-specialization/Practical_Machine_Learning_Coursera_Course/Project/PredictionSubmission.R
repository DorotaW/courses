library(caret)
library(parallel)
library(doParallel)

#load raw data
data <- read.csv("pml-training.csv", header = TRUE)
assignment  <- read.csv('pml-testing.csv')

#store classe as factor
data$classe <- factor(data$classe)
data<-data[,-c(1,3,4,5,6,7)]

table(data$user_name)
table(assignment$user_name)

#split data in 60% training and 40% test
set.seed(9876)
trainIndex <- createDataPartition(y = data$classe, p=0.6,list=FALSE)
training <- data[trainIndex,]
testing<- data[-trainIndex,]

#Pre processing
NAColumn<- apply(training,2,function(x) {sum(is.na(x))})
preProcValues<-preProcess(training[,NAColumn>0], method="medianImpute")
trainProc <- predict(preProcValues, training)
testProc <- predict(preProcValues, testing)
nzv <- nearZeroVar(trainProc)
trainProc<- trainProc[, -nzv]
testProc<- testProc[, -nzv]
dummy<-dummyVars(~user_name, data=trainProc)
trainProc<-cbind(predict(dummy,trainProc),trainProc[-1])
testProc<-cbind(predict(dummy,testProc),testProc[-1])

#fitting model
registerDoParallel(makeCluster(detectCores()))
set.seed(9876)
ctrl<- trainControl(method = "repeatedcv", number = 2, repeats = 5)
model1<-train(classe ~ ., method = 'lda', data =trainProc, trControl=ctrl)
model2<-train(classe ~ ., method = 'rpart', data =trainProc, trControl=ctrl)
model3<-train(classe ~ ., method = 'rf', data =trainProc, trControl=ctrl)

#prediction accuracy info for model3 
prediction<- predict(model3, testProc)
confusionMatrix(prediction, testProc$classe)[2:3]

# transform case studies for assigment
assignProc <- predict(preProcValues, assignment)
assignProc<-cbind(predict(dummy,assignProc),assignProc[-1])

#function to generate submission files
pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}

#prediction assignment submission
  prediction <- predict(model3, assignProc)
  print(prediction)
  answers <- as.vector(prediction)
  pml_write_files(answers)
