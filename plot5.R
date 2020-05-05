########################################################################
# FILENAME: plot5.R
# AUTHOR: Anne Strader
# LAST REVISED: 5. May 2020
# 
# OBJECTIVE:
# Answer question 5: How have emissions from motor vehicle sources 
# changed from 1999-2008 in Baltimore City?
#
# OUTPUT:
# plot5.png
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
# subset emission data in Baltimore City with type "ON-ROAD"
########################################################################

PM25bcOnRoad <- subset(PM25all, fips == "24510" & type == "ON-ROAD")

########################################################################
# calculate total motor vehicle PM2.5 emissions for Baltimore City
# for each of the following years: 1999, 2002, 2005 and 2008
########################################################################

PM25bcOnRoadByYear <- aggregate(Emissions ~ year, data=PM25bcOnRoad, 
                                FUN=sum)

########################################################################
# plot total motor vehicle PM2.5 emissions per year in Baltimore City, 
# save to .png file
########################################################################

# open png graphics device
png("plot5.png")

# create a barplot of total motor vehicle PM2.5 emissions in Baltimore 
# City
barplot(height=PM25bcOnRoadByYear$Emissions, 
        names.arg=PM25bcOnRoadByYear$year, xlab="years",
        ylab="total PM2.5 emissions (tons)", col="Light Blue",
        main="Motor Vehicle PM2.5 Emissions in Baltimore City Per Year")

# close graphics device
dev.off()
