########################################################################
# FILENAME: plot3.R
# AUTHOR: Anne Strader
# LAST REVISED: 5. May 2020
# 
# OBJECTIVE:
# Answer question 3: Of the four types of sources indicated by the type 
# (point, nonpoint, onroad, nonroad) variable, which of these four 
# sources have seen decreases in emissions from 1999-2008 for Baltimore
# City? Which have seen increases in emissions from 1999-2008? Use the 
# ggplot2 plotting system to make a plot to answer this question.
#
# OUTPUT:
# plot3.png
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
# subset emissions data for Baltimore City, Maryland
########################################################################

PM25bc = subset(PM25all, PM25all$fips == "24510")

########################################################################
# calculate total emissions from PM2.5 in Baltimore City for each of 
# the following years: 1999, 2002, 2005 and 2008 and each emission
# type 
########################################################################

totalPM25BCbyYear <- aggregate(Emissions ~ year + type, data=PM25bc, FUN=sum)

########################################################################
# plot total emissions from PM2.5 in Baltimore City by type for each 
# of the following years: 1999, 2002, 2005 and 2008
########################################################################

# open png graphics device
png("plot3.png")

# initialize plot 
plotPM25bcByType <- ggplot(totalPM25BCbyYear, aes(x=year, y=Emissions, 
                           color=type)) 

# add lines showing changes in emissions per year per type for Baltimore 
# City
plotPM25bcByType <- plotPM25bcByType + geom_line(size=1.4)

# add axis labels and title
plotPM25bcByType <- plotPM25bcByType + labs(title="PM2.5 Emissions Per Year In Baltimore City") + 
                  xlab("year") + 
                  ylab("PM2.5 Emissions (tons)") +
                  theme(plot.title = element_text(hjust = 0.5))

# print plot to graphics device
print(plotPM25bcByType)

# close graphics device
dev.off()



