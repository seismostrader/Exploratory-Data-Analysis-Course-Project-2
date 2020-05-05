########################################################################
# FILENAME: plot1.R
# AUTHOR: Anne Strader
# LAST REVISED: 5. May 2020
# 
# OBJECTIVE: 
# Answer question 1: Have total emissions from PM2.5 decreased in the 
# United States from 1999 to 2008? Using the base plotting system, make
# a plot showing the total PM2.5 emission from all sources for each of 
# the years 1999, 2002, 2005, and 2008.
# 
# OUTPUT:
# plot1.png
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
# calculate total emissions from PM2.5 for each of the following years:
# 1999, 2002, 2005 and 2008.
########################################################################

totalPM25byYear <- aggregate(Emissions ~ year, data=PM25all, FUN=sum)

########################################################################
# plot total PM2.5 emissions by year, save to .png file
########################################################################

# open png graphics device
png("plot1.png")

# create barplot of total emissions per year
barplot(height = totalPM25byYear$Emissions, 
        names.arg = totalPM25byYear$year, xlab="years", 
        ylab="total PM2.5 emissions (tons)", col="Light Blue",
        main="PM2.5 Emissions Per Year")

# close graphics device
dev.off()
