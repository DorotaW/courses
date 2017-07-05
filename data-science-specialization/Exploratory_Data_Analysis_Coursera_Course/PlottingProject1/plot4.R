## dowload and unzip file and read data to R
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "file.zip")
unzip('file.zip')
data <- read.table('household_power_consumption.txt', header=TRUE ,sep=";", na.string="?",as.is = TRUE)

## limiting dataset to only observations from 2007-02-01 and 2007-02-02
data<-subset(data, Date %in% c('1/2/2007','2/2/2007'))

## convert the Date and Time variables to Date/Time classes)
library(plyr)
data<-mutate(data,DateTime=strptime(paste(data$Date,data$Time), "%d/%m/%Y %H:%M:%S"))

##Construct plot 4 and save it to a PNG file
png('plot4.png',480,480)

par(mfrow=c(2,2))

plot(data$DateTime,data$Global_active_power,type='l',ylab="Global Active Power",xlab="")

plot(data$DateTime,data$Voltage,type='l',ylab="Voltage",xlab="datetime")

plot(data$DateTime,data$Sub_metering_1,type='l',ylab="",xlab="",ylim=c(0,40))
par(new=TRUE)
plot(data$DateTime,data$Sub_metering_2,type='l',ylab="",xlab="",col="red",ylim=c(0,40))
par(new=TRUE)
plot(data$DateTime,data$Sub_metering_3,type='l',ylab="Energy submetering",xlab="",col="blue",ylim=c(0,40))
legend("topright",legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),col=c("black","red","blue"),lty = c(1, 1, 1))

plot(data$DateTime,data$Global_reactive_power,type='l',ylab="Global_reactive_power",xlab="datetime")

dev.off()