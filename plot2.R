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

png(filename = "plot2.png", width = 480, height = 480)
plot(epc$datetime.d, epc$Global_active_power, type = "l", 
     ylab = "Global Active Power (kilowatts)", xlab = "")
dev.off()