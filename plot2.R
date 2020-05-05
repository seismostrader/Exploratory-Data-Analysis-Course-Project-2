########################################################################
# FILENAME: plot2.R
# AUTHOR: Anne Strader
# LAST REVISED: 5. May 2020
# 
# OBJECTIVE:
# Answer question 2: Have total emissions from PM2.5 decreased in the 
# Baltimore City, Maryland (fips == "24510") from 1999 to 2008? Use the 
# base plotting system to make a plot answering this question.
#
# OUTPUT:
# plot2.png
########################################################################

########################################################################
# download and extract dataset
########################################################################

# define URL where source data are stored
sourceURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"

# define source data zip file name
sourceDataZipFile <- "NEI_data.zip"

# check if dataset has already been downloaded in working directory, and download dataset if not
if (!file.exists(sourceDataZipFile)) {
  download.file(sourceURL, sourceDataZipFile)
}

# define source data directory name
sourceDataPath <- "NEI_data"

# if not already done, unzip source dataset to new data directory
if (!file.exists(sourceDataPath)) {
  unzip(sourceDataZipFile)
}


########################################################################
# read in emissions data and source classification code table
########################################################################

# emissions data
PM25all <- readRDS("summarySCC_PM25.rds")

# source classification code table
SCC <- readRDS("Source_Classification_Code.rds")

########################################################################
# subset emissions data for Baltimore City, Maryland
########################################################################
PM25bc = subset(PM25all, PM25all$fips == "24510")

########################################################################
# calculate total emissions from PM2.5 in Baltimore City for each of 
# the following years: 1999, 2002, 2005 and 2008
########################################################################

totalPM25BCbyYear <- aggregate(Emissions ~ year, data=PM25bc, FUN=sum)

########################################################################
# plot total PM2.5 emissions in Baltimore City by year, save to .png
# file
########################################################################

# open png graphics device
png("plot2.png")

# create barplot of total emissions per year
barplot(height = totalPM25BCbyYear$Emissions, 
        names.arg = totalPM25BCbyYear$year, xlab="years", 
        ylab="total PM2.5 emissions (tons)", col="Light Blue",
        main="PM2.5 Emissions Per Year in Baltimore City")

# close graphics device
dev.off()
