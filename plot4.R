#requirements:
if(!require("sqldf")){install.packages("sqldf")}
library(sqldf)

#getting the data :extract the zip file to the working directory 

query_string<-"select * from file where (Date =='1/2/2007') 
               OR (Date=='2/2/2007')"

elecdata<-read.csv.sql(file ="household_power_consumption.txt",
                       sql = query_string,header = TRUE,sep = ";",
                       colClasses = c("character","character",
                                      "numeric" ,"numeric",
                                      "numeric","numeric","numeric",
                                      "numeric","numeric"))                                                   
#changing values of "?" to NA 
elecdata[elecdata=="?"]<-NA
#checking for NA's 
lapply(elecdata,function(x){sum(is.na(x))})

#creating a new column Date.time by combining Date and Time columns 
#into one column of class= "POSIXlt"
elecdata$Date.time<-paste(elecdata$Date,elecdata$Time,sep = " ")
elecdata$Date.time<-strptime(elecdata$Date.time,format = "%d/%m/%Y %H:%M:%S")
elecdata<-subset(elecdata,select = -c(Date,Time))

#plotting plot4.png 
{
  png(filename = "plot4.png",width = 480 ,height = 480) 
  par(mfrow=c(2,2))
  with(elecdata,plot(x = Date.time,y=Global_active_power,type="n",xlab = "",ylab = "Global Active Power"))
  lines(x=elecdata$Date.time,y=elecdata$Global_active_power)
  with(elecdata,plot(x = Date.time,y=Voltage,type="n",xlab = "datetime",ylab = "Voltage"))
  lines(x=elecdata$Date.time,y=elecdata$Voltage)
  with(elecdata,plot(x=Date.time,
                     y=elecdata$Sub_metering_1,type = "n",xlab = "",
                     ylab = "Energy sub metering"))
  lines(x=elecdata$Date.time,y = elecdata$Sub_metering_1,col="black")
  lines(x=elecdata$Date.time,y = elecdata$Sub_metering_2,col="red")
  lines(x=elecdata$Date.time,y = elecdata$Sub_metering_3,col="blue")
  legend("topright",legend = c("Sub_metering_1","Sub_metering_2"
                               ,"Sub_metering_3"),
         col = c("black","red","blue"),lty = 1,box.lty = 0,bg="transparent",cex =0.98,y.intersp = 0.8,x.intersp = 0.5)
  with(elecdata,plot(x = Date.time,y=Global_reactive_power,type="n",xlab = "datetime",))
  lines(x=elecdata$Date.time,y=elecdata$Global_reactive_power)
  dev.off()
}

