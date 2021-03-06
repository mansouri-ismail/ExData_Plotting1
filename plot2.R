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

#plotting plo2.png
{
  png(filename = "plot2.png",width = 480 ,height = 480)
  with(data = elecdata,plot(x=Date.time,y=Global_active_power,type = "n",xlab = "",
                            ylab = "Global Active Power (kilowatts)"))
  lines(x=elecdata$Date.time,y=elecdata$Global_active_power)
  dev.off()
}
