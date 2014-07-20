## check if files are in working directory, otherwise dowload and unzip it
if (!(file.exists("./test/X_test.txt") & file.exists("./train/X_train.txt"))) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip ", "file.zip",mode="wb")
  unzip('file.zip')  
}

## read and merge training and the test sets
xtest<-read.table("./test/X_test.txt")
xtrain<-read.table("./train/X_train.txt")
ytest<-read.table("./test/Y_test.txt")
ytrain<-read.table("./train/Y_train.txt")
strain<-read.table('./train/subject_train.txt')
stest<-read.table('./test/subject_test.txt')
data<-rbind(xtest,xtrain)

## extract only columns that are mean and standard deviation for each measurement
features<-read.table("features.txt")
col<-grepl('mean()',features[,2],fixed=TRUE)|grepl('std()',features[,2],fixed=TRUE)
data<-data[,col]

## add activities and named them 
activity<-read.table("activity_labels.txt")
data<-cbind(data,rbind(stest,strain),rbind(ytest,ytrain)) ## add activity adn subject, the same order as previous rbind
colnames(data)[(length(data)-1):length(data)]<-c('subject','activityID')
data<-merge(data,activity,by.x='activityID', by.y='V1',all.x=TRUE,sort=FALSE) 
data<-data[,2:length(data)] ## remove activityID

##label the data set with descriptive variable names
colnames(data)<-c(t(as.data.frame(features[col,2])),'subject','activity')

## tidy data set with the average of each variable for each activity and each subject
library(reshape)
df<-as.data.frame<-melt(data,id=c('subject','activity'))
library(plyr)
tidydata<-ddply(df,.(subject,activity,variable),summarize,mean=mean(value,na.rm=FALSE))
write.table(tidydata, 'tidydata.txt', quote=FALSE,sep='\t')

##codebook
library(memisc)

codebook<-data.set(subject=tidydata$subject,activity=tidydata$activity,variable=tidydata$variable,mean=tidydata$mean)
codebook <- within(codebook,{
  wording(subject) <- "Subject who performed the activity.
  30 volunteers within an age bracket of 19-48 years"
  wording(activity) <- 'One of six ativities performed wearing a smartphone'
  wording(variable) <- 'Mean and standard deviation of measured sensor signals.
  Features come from the accelerometer and gyroscope 3-axial raw signals. 
  XYZ is used to denote 3-axial signals in the X, Y and Z directions.'
  wording(mean) <- "Average of each variable for each activity and each subject"
  measurement(subject) <- "interval"
  measurement(activity) <- "nominal"
  measurement(variable) <- "nominal"
  measurement(mean) <- "interval"
  })
sink("Codebook.txt")
codebook(codebook)
dev.off( ) 
