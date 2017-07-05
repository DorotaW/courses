## dowload and unzip file and read data to R
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip", "file.zip")
unzip('file.zip')
data <- read.table('household_power_consumption.txt', header=TRUE ,sep=";", na.string="?",as.is = TRUE)

## limiting dataset to only observations from 2007-02-01 and 2007-02-02
data<-subset(data, Date %in% c('1/2/2007','2/2/2007'))

## convert the Date and Time variables to Date/Time classes)
library(plyr)
data<-mutate(data,DateTime=strptime(paste(data$Date,data$Time), "%d/%m/%Y %H:%M:%S"))

##Construct plot 1 and save it to a PNG file 
png('plot1.png',480,480)
hist(data$Global_active_power,col="red", main="Global Active Power",xlab="Global Active Power (kilowatts)")
dev.off()