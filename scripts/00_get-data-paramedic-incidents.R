#### Preamble ####
# Purpose: Use opendatatoronto to get paramedic incident data
# Author: Jeremy Chu
# Contact: jeremychuj@gmail.com
# Date: 19 January 2021
# Pre-requisites: None
# TODOs: -

#### Workspace set-up ####
#install.packages("opendatatoronto")
library(opendatatoronto)
library(tidyverse)
library(here)

### Get data ###
paramedic_data <- 
  list_package_resources("https://open.toronto.ca/dataset/paramedic-services-incident-data/") %>% 
  filter(name == "paramedic-services-incident-data-2010-2020") %>% # This is the only dataset available, contains 2010-2020. Reupdate in later years. 
  get_resource()

#Saving only the relevant sheets for data analysis
paramedic2020 <- paramedic_data[["2020"]]
paramedic2019 <- paramedic_data[["2019"]]
paramedic2018 <- paramedic_data[["2018"]]
paramedic2017 <- paramedic_data[["2017"]]
paramedic2016 <- paramedic_data[["2016"]]
paramedic2015 <- paramedic_data[["2015"]]
paramedic2014 <- paramedic_data[["2014"]]
paramedic2013 <- paramedic_data[["2013"]]
paramedic2012 <- paramedic_data[["2012"]]
paramedic2011 <- paramedic_data[["2011"]]
paramedic2010 <- paramedic_data[["2010"]]

### Save Data ###
write_csv(paramedic2020, here("inputs", "data", "2020_paramedic-incidents_raw.csv"))
write_csv(paramedic2019, here("inputs", "data", "2019_paramedic-incidents_raw.csv"))
write_csv(paramedic2018, here("inputs", "data", "2018_paramedic-incidents_raw.csv"))
write_csv(paramedic2017, here("inputs", "data", "2017_paramedic-incidents_raw.csv"))
write_csv(paramedic2016, here("inputs", "data", "2016_paramedic-incidents_raw.csv"))
write_csv(paramedic2015, here("inputs", "data", "2015_paramedic-incidents_raw.csv"))
write_csv(paramedic2014, here("inputs", "data", "2014_paramedic-incidents_raw.csv"))
write_csv(paramedic2013, here("inputs", "data", "2013_paramedic-incidents_raw.csv"))
write_csv(paramedic2012, here("inputs", "data", "2012_paramedic-incidents_raw.csv"))
write_csv(paramedic2011, here("inputs", "data", "2011_paramedic-incidents_raw.csv"))
write_csv(paramedic2010, here("inputs", "data", "2010_paramedic-incidents_raw.csv"))
