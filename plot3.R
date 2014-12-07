## Exploratory Data Analysis by Roger D. Peng, Jeff Leek, Brian Caffo
## Course Project 1 - plot3 creation
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
png(file="plot3.png",width=480,height=480,bg="transparent")

# Create the first third of the required plot by:
#   Setting the X axis data to be the just generated datetime column
#   Setting the Y axis data to be the Sub_metering_1 column
#   Change the plot type from points to lines
#   Set the line color to black
#   Remove the label on the X axis and set the label on the Y axis
with(data_subset, plot(datetime, Sub_metering_1, type="l", col="black",
                       xlab="", ylab="Energy sub metering"))

# Add the remaining two datasets to the plot, both with datetime as the X axis.
# Sub_metering_2 is the first additional Y axis value, displayed in red and
# Sub_metering_3 is added displayed in blue.
with(data_subset, points(datetime, Sub_metering_2, type="l", col="red"))
with(data_subset, points(datetime, Sub_metering_3, type="l", col="blue"))

# Add a legend in the upper right corner that documents the color each of
# the three sub metering values is displayed in.
legend("topright", lwd=1, col = c("black","red","blue"),
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Close the PNG device to finish saving the image.
dev.off()