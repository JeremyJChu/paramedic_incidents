#### Preamble ####
# Purpose: Add additional columns based on research on the Medical Dispatch Priority System
# Author: Jeremy Chu
# Contact: jeremychuj@gmail.com
# Date: 30 January 2021
# Pre-requisites: 02_get-data-covid, covid-data dataset in environment
# TODOs: Clean up and filter covid data

#### Workspace set-up ####
library(tidyverse)
library(here)

#### Read Data ####
covid_df <- read_csv(here("inputs","data","covd-data_raw.csv"))

# Filter for hospitalized because the study's mainly looking at medical emergencies

covid_hospitalized <- 
  covid_df %>% 
  filter(`Ever Hospitalized` == "Yes")

# Data cleaning (Hospitalized)

covid_hospitalized <- covid_hospitalized %>%
  mutate(Year = as.POSIXct(`Reported Date`, format = "%m/%d/%Y %H:%M:%S")) %>% #Change datetime to POSIXct 
  mutate(Month = as.POSIXct(`Reported Date`, format = "%m/%d/%Y %H:%M:%S")) #Change datetime to POSIXct 

covid_hospitalized$Year <- format(covid_hospitalized$Year, format = "%Y") #Extract only year
covid_hospitalized$Month <- format(covid_hospitalized$Month, format = "%m") #Extract only month

covid_hospitalized <- covid_hospitalized %>% #Decided to transform string numbers into month abbreviations for better visualization purposes
  mutate(Month = case_when(
    Month == "01" ~ "Jan",
    Month == "02" ~ "Feb",
    Month == "03" ~ "Mar",
    Month == "04" ~ "Apr",
    Month == "05" ~ "May",
    Month == "06" ~ "Jun",
    Month == "07" ~ "Jul",
    Month == "08" ~ "Aug",
    Month == "09" ~ "Sep",
    Month == "10" ~ "Oct",
    Month == "11" ~ "Nov",
    Month == "12" ~ "Dec")
  )

covid_hospitalized$Month <- factor(covid_hospitalized$Month, levels = month.abb) # Ordering the months for visualizations

# Creating another table that groups by month

covid_monthCount <-
  covid_hospitalized %>%
  filter(Year == 2020) %>%
  group_by(Month) %>%
  count() %>%
  ungroup()

covid_monthCount <- covid_monthCount %>%
  rename(case_number = n) # Renaming for sanity

# Data Cleaning (Full)

covid_df <- covid_df %>%
  mutate(Year = as.POSIXct(`Reported Date`, format = "%m/%d/%Y %H:%M:%S")) %>% #Change datetime to POSIXct 
  mutate(Month = as.POSIXct(`Reported Date`, format = "%m/%d/%Y %H:%M:%S")) #Change datetime to POSIXct 

covid_df$Year <- format(covid_df$Year, format = "%Y") #Extract only year
covid_df$Month <- format(covid_df$Month, format = "%m") #Extract only month

covid_df <- covid_df %>% #Decided to transform string numbers into month abbreviations for better visualization purposes
  mutate(Month = case_when(
    Month == "01" ~ "Jan",
    Month == "02" ~ "Feb",
    Month == "03" ~ "Mar",
    Month == "04" ~ "Apr",
    Month == "05" ~ "May",
    Month == "06" ~ "Jun",
    Month == "07" ~ "Jul",
    Month == "08" ~ "Aug",
    Month == "09" ~ "Sep",
    Month == "10" ~ "Oct",
    Month == "11" ~ "Nov",
    Month == "12" ~ "Dec")
  )

covid_df$Month <- factor(covid_df$Month, levels = month.abb)

# Creating another table that groups by month

covid_fullmonthCount <-
  covid_df %>%
  filter(Year == 2020) %>%
  group_by(Month) %>%
  count() %>%
  ungroup()

covid_fullmonthCount <- covid_fullmonthCount %>%
  rename(case_number = n) # Renaming for sanity

### Writing Data ###

write_csv(covid_monthCount, here("inputs", "data", "2020_covid-cases_cleaned.csv"))
write_csv(covid_hospitalized, here("inputs", "data", "2020_covid-cases-hospitalization_cleaned.csv"))
write_csv(covid_fullmonthCount, here("inputs", "data", "2020_covid-cases-full_cleaned.csv"))
