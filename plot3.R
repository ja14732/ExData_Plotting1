#household_power_consumption <- read.csv("household_power_consumption.txt", header=TRUE, sep=";", na.strings="?")

##Load dpylr, will need later
##install.packages("dplyr")
library(dplyr)

####Format table to work with####

##Set date column to date format
household_power_consumption$Date <- as.Date(household_power_consumption$Date, format = "%d/%m/%Y")

##Subset the data from 2/1/2007 to 2/2/2007
household_power_consumption<- subset(household_power_consumption, Date >= as.Date("2007-2-1") 
                                     & Date <= as.Date("2007-2-2"))

##Check for incomplete cases and remove any that are incomplete
household_power_consumption<- household_power_consumption[complete.cases(household_power_consumption),]

##Combine the date and time column to create a new column, paste into data set
##This will make it easier to plot later
dateTime <- paste(household_power_consumption$Date, household_power_consumption$Time)
household_power_consumption_dateTime <- mutate(household_power_consumption, dateTime = dateTime, .before = 1)

##Rename table to save time
new_table <- household_power_consumption_dateTime

##Remove Date and Time columns
new_table <- new_table[,!(names(new_table) %in% c("Date", "Time"))]

##Reformat dateTime column
new_table$dateTime <- as.character(new_table$dateTime)
new_table$dateTime <- as.POSIXct(dateTime)

#Plot 3?
with(new_table, {
  plot(Sub_metering_1~dateTime, type='l',
       ylab="Global Active Power (kilowatts)", xlab="")
  lines(Sub_metering_2~dateTime, col='red')
  lines(Sub_metering_3~dateTime, col='blue')
})
legend("topright", col=c('black', 'red', 'blue'), lwd=c(1,1,1),
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
dev.copy(png, "plot3.png", width=480, height=480)
dev.off()