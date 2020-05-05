########################################################################
# FILENAME: plot6.R
# AUTHOR: Anne Strader
# LAST REVISED: 5. May 2020
# 
# OBJECTIVE:
# Answer question 6: Compare emissions from motor vehicle sources in 
# Baltimore City with emissions from motor vehicle sources in Los 
# Angeles County, California (fips == "06037"). Which city has seen 
# greater changes over time in motor vehicle emissions?
# 
# OUTPUT:
# plot6.png
########################################################################

########################################################################
# source necessary libraries
########################################################################

library(ggplot2)

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
# subset emission data in Baltimore City or Los Angeles County  with 
# type "ON-ROAD"
########################################################################

PM25OnRoad <- subset(PM25all, (fips == "24510" | fips == "06037") 
                       & type == "ON-ROAD")

########################################################################
# calculate total motor vehicle PM2.5 emissions for Baltimore City and
# Los Angeles County for each of the following years: 1999, 2002, 2005 
# and 2008
########################################################################

# aggregate emissions by year and fips
PM25OnRoadByYear <- aggregate(Emissions ~ year + fips, 
                                data=PM25OnRoad, FUN=sum)

# change fips label to city/county names to be more informative
PM25OnRoadByYear$fips[PM25OnRoadByYear$fips == "24510"] <- "Baltimore City"
PM25OnRoadByYear$fips[PM25OnRoadByYear$fips == "06037"] <- "Los Angeles County"

########################################################################
# create two barplots (in same file) showing motor vehicle PM2.5 
# emissions per year in Baltimore City and Los Angeles County per year
########################################################################

# open png graphics device
png("plot6.png")

# initialize plots
plotPM25 <- ggplot(data=PM25OnRoadByYear, aes(x=factor(year), y=Emissions))

# add two plots in the same row with differing fips
plotPM25 <- plotPM25 + facet_grid(. ~ fips)

# create barplots for Baltimore City and Los Angeles County PM2.5 
# emissions (motor vehicle) per year
plotPM25 <- plotPM25 + geom_bar(stat="identity") 

# add title and label axes
plotPM25 <- plotPM25 + labs(title="Total Motor Vehicle PM2.5 Emissions Per Year", 
                            subtitle="Baltimore City vs. Los Angeles County")
plotPM25 <- plotPM25 + xlab("years") + ylab("total PM2.5 emissions (tons)")

# print plot to png graphics device
print(plotPM25)

# close graphics device
dev.off()
