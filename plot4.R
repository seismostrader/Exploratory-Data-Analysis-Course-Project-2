########################################################################
# FILENAME: plot4.R
# AUTHOR: Anne Strader
# LAST REVISED: 5. May 2020
# 
# OBJECTIVE:
# Answer question 4: Across the United States, how have emissions from 
# coal combustion-related sources changed from 1999-2008?
#
# OUTPUT:
# plot4.png
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
# identify source classification codes related to coal combustion
########################################################################

# identify indices of SCCs involving coal combustion
coalSCCindices <- grep("[Cc]oal", SCC$Short.Name)

# identify SCCs involving coal combustion
coalSCCs <- SCC$SCC[coalSCCindices]

########################################################################
# subset coal-combustion-related emissions data
########################################################################
PM25coal <- subset(PM25all, PM25all$SCC %in% coalSCCs)

########################################################################
# calculate total coal-combustion-related emissions from PM2.5 across
# the US for each of the following years: 1999, 2002, 2005 and 2008
########################################################################

PM25coalByYear <- aggregate(Emissions ~ year, data=PM25coal, FUN=sum)

########################################################################
# plot total coal-combustion-related PM2.5 emissions across the US by 
# year, save to .png file
########################################################################

# open png graphics device
png("plot4.png")

# create a barplot of total coal-combustion-related emissions per year
barplot(height=PM25coalByYear$Emissions,
        names.arg=PM25coalByYear$year, xlab="years",
        ylab="total PM2.5 emissions (tons)", col="Light Blue",
        main="Coal-Combustion-Related PM2.5 Emissions Per Year")

# close graphics device
dev.off()
