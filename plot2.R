## Exploratory Data Analysis by Roger D. Peng, Jeff Leek, Brian Caffo
## Course Project 1 - plot2 creation
## Course ID:  exdata-016
## Submitted by Chuck Thompson

# Load the data.table library for the fread function
library(data.table)

# Load the plyr library for the mutate function
library(plyr)

# Check if the data file has already been downloaded.  If not, download the
# zip file containing it from the web and extract the data file from it.
dataURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dataFile <- "household_power_consumption.txt"

if (!file.exists(dataFile)) {
    suppressWarnings(setInternet2(TRUE))  # may be needed for https
    temp <- tempfile()
    download.file(dataURL,temp,mode="wb")
    unzip(temp,dataFile)
    file.remove(temp)
}

# Read in the full data file, converting an "?" values to NA.
data <- suppressWarnings(
    fread(dataFile, showProgress=FALSE, na.strings=c("?")))

# Select just the entries for February 1, 2007 and February 2, 2007.
# Note that dates in the data file are stored as "dd/mm/yyyy".
data_subset <- subset(data,Date == "1/2/2007" | Date == "2/2/2007")

# Add a column to the data table that combines the Date and Time columns
# into a single POSIX formated date/time entry.
data_subset <- mutate(data_subset,
                      datetime = as.POSIXct(paste(Date,Time),
                                            format="%d/%m/%Y %H:%M:%S"))

# Open the PNG file to save the plot to, specifying the width and height
# required for the assignment.  Also request a transparent background.
png(file="plot2.png",width=480,height=480,bg="transparent")

# Create the required plot by:
#   Setting the X axis data to be the just generated datetime column
#   Setting the Y axis data to be the Global_active_power column
#   Change the plot type from points to lines
#   Remove the label on the X axis and add a label to the Y axis
with(data_subset,plot(datetime, Global_active_power, type="l", xlab="",
                      ylab="Global Active Power (kilowatts)"))

# Close the PNG device to finish saving the image.
dev.off()