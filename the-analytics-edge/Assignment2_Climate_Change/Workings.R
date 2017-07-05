data <- read.csv("climate_change.csv", header = TRUE)
training<-subset(data,Year<=2006)
testing<-subset(data,Year>2006)

model<-lm(Temp ~ MEI + CO2 + CH4 + N2O + CFC.11 + CFC.12 + TSI + Aerosols, data=training) 
summary(model)

corMatrix<-cor(training)
corMatrix[which(corMatrix[,6] > 0.7,  arr.ind=TRUE),6]
corMatrix[which(corMatrix[,7] > 0.7,  arr.ind=TRUE),7]

model2<-lm(Temp ~ MEI + N2O +  + TSI + Aerosols, data=training) 
summary(model2)

model3<-step(model)
summary(model3)

prediction<-predict(model3,testing)
SSE <- sum((prediction - testing$Temp)^2)
SST <- sum( (mean(training$Temp) - testing$Temp)^2)
R2 <- 1 - SSE/SST