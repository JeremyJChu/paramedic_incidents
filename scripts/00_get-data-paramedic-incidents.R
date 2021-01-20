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


### Save Data ###
write_csv(paramedic2020, here("inputs", "data", "2020_paramedic-incidents_raw.csv"))
write_csv(paramedic2019, here("inputs", "data", "2019_paramedic-incidents_raw.csv"))
