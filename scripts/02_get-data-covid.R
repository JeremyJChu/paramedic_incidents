#### Preamble ####
# Purpose: Use opendatatoronto to get COVID-19 data
# Author: Jeremy Chu
# Contact: jeremychuj@gmail.com
# Date: 30 January 2021
# Pre-requisites: None
# TODOs: -

#### Workspace set-up ####
#install.packages("opendatatoronto")
library(opendatatoronto)
library(tidyverse)
library(here)

### Get data ###
covid_data <- 
  list_package_resources("https://open.toronto.ca/dataset/covid-19-cases-in-toronto/") %>% 
  get_resource()

### Save Data ###
write_csv(covid_data, here("inputs", "data", "covd-data_raw.csv"))