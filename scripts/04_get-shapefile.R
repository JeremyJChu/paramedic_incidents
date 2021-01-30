#### Preamble ####
# Purpose: Read in Shapefile from Statistics Canada for Analysis
# Author: Jeremy Chu
# Contact: jeremychuj@gmail.com
# Date: 30 January 2021
# Pre-requisites: Run 00-03 R scripts. Have covid_hospitalized & paramedic20192020_cleaned data in Global Environment.
#                 Note that the shapefile can be downloaded from Statistics Canada: https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2016-eng.cfm
#                   Choose Forward Sortation Areas, check English, and download and unzip to your directory of choice.
#                 For reproducibility's sake, the following code will download the shapefile in line through tempfiles. 
#                 Locally, the files are also located in here("inputs/shapefiles/lfsa000b16a_e.shp") from the GitHub repo if cloned.
#TODOs: - 

#### Setup Workspace ####

#install.packages("rgdal")
#install.packages("maptools")
library(rgdal)
library(maptools)
library(here)

## Creation of Tempfiles to unzip and read shapefiles comes from https://stackoverflow.com/questions/59740419/unzipping-and-reading-shape-file-in-r-without-rgdal-installed ##

### Download and Unzip Shapefile from Statistics Canada ###
temp <- tempfile()
temp2 <- tempfile()
download.file("https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/files-fichiers/2016/lfsa000b16a_e.zip", temp)
unzip(zipfile = temp, exdir = temp2)
Toronto_SHP_file<-list.files(temp2, pattern = ".shp$",full.names=TRUE)

### Read Shapefile ###
fsas <-  readOGR(dsn = Toronto_SHP_file, layer = "lfsa000b16a_e")
