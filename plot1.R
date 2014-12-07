## Exploratory Data Analysis by Roger D. Peng, Jeff Leek, Brian Caffo
## Course Project 1 - plot1 creation
## Course ID:  exdata-016
## Submitted by Chuck Thompson

# Load the data.table library for the fread function
library(data.table)

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

# Open the PNG file to save the plot to, specifying the width and height
# required for the assignment.  Also request a transparent background.
png(file="plot1.png",width=480,height=480,bg="transparent")

# Match exactly the color from the sample PNG on the website.  Yes, I realize
# this isn't really necessary :)
plot1_color <- rgb(251,0,7,max=255)

# Create the required histogram by:
#   Coercing the Global_active_power from character to numeric as data to plot
#   Setting the column color for the histogram bars
#   Labeling the X axis.  The Y axis uses the default histogram label
#   Label the overall plot
hist(as.numeric(data_subset$Global_active_power), col=plot1_color,
     xlab="Global Active Power (kilowatts)", main="Global Active Power")

# Close the PNG device to finish saving the image.
dev.off()