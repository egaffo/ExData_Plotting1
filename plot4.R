Sys.setlocale("LC_ALL", "en_US")
if(!file.exists("household_power_consumption.txt")){
  if(!file.exists("epc.zip")){
    ds1.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(ds1.url, destfile = "epc.zip", method = "curl")
  }
  unzip("epc.zip", overwrite = F)
}

library(dplyr)
epc <- read.table("household_power_consumption.txt", na.strings = "?", header = T,
                  stringsAsFactors = F, sep = ";", dec = ".") %>% 
  mutate(date = as.Date(Date, format = "%d/%m/%Y"), 
         datetime = paste(Date, Time, sep = " ")) %>% 
  filter(date >= as.Date("2007-02-01") & date <= as.Date("2007-02-02"))
epc$datetime.d <- strptime(epc$datetime, format = "%d/%m/%Y %H:%M:%S")

attach(epc)
png(filename = "plot4.png", width = 480, height = 480)
par(mfcol = c(2, 2))

plot(datetime.d, Global_active_power, type = "l", 
     ylab = "Global Active Power", xlab = "")

plot(datetime.d, Sub_metering_1, type = "l", 
     ylab = "Energy sub metering", xlab = "", col = "black")
lines(datetime.d, Sub_metering_2, col = "red")
lines(datetime.d, Sub_metering_3, col = "blue")
legend(x = "topright", legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"), lty = 1, box.lwd = 0)

plot(datetime.d, Voltage, type = "l", xlab = "datetime")

plot(datetime.d, Global_reactive_power, type = "l", xlab = "datetime")
dev.off() 
detach(epc)