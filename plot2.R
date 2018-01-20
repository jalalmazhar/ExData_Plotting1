## File plot2.R
## Exploratory Data Analysis Course
## Week 1 Project

library(data.table)
library(dplyr)

###############################################################################
#
# Download the file if not in the working directory, and unzip it
#
###############################################################################

zipUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
zipFile <- "Electric Power Consumption.zip"
dataFile <- "household_power_consumption.txt"

if (!file.exists(zipFile)) download.file(zipUrl, zipFile, mode = "wb")
if (!file.exists(dataFile)) unzip(zipFile)

###############################################################################
#
# Load the needed data (1 & 2 Feb, 2007)
#
###############################################################################

## Read 1 column to get the column names
columnNames <- data.table(read.table(dataFile, nrows = 1,
                                     header = TRUE, sep = ";"))

## Read only the rows for the needed dates using columnNames
powerData <- data.table(read.table(dataFile,
                           skip = grep("31/1/2007",
                                       readLines(dataFile)) + 1439,
                           nrows = 2880, sep = ";",
                           col.names = names(columnNames),
                           stringsAsFactors = FALSE,
                           na.strings = "?"))

## Add DateTime column as POSIXct using strptime()
## Also convert all other columns to numeric
powerData <- data.table(mutate(powerData,
                        DateTime = as.POSIXct(strptime(paste(Date, Time),
                                              format = "%d/%m/%Y %H:%M:%S")),
                        Global_active_power = as.numeric(Global_active_power),
                        Global_reactive_power = as.numeric(Global_reactive_power),
                        Voltage = as.numeric(Voltage),
                        Global_intensity = as.numeric(Global_intensity),
                        Sub_metering_1 = as.numeric(Sub_metering_1),
                        Sub_metering_2 = as.numeric(Sub_metering_2),
                        Sub_metering_3 = as.numeric(Sub_metering_3)))

###############################################################################
#
# Create the plot and save it to PNG file
#
###############################################################################

## Create PNG file
png("plot2.png", width = 480, height = 480)

## Plot using plot()
plot(powerData$DateTime, powerData$Global_active_power,
     type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")

## Close the device
dev.off()