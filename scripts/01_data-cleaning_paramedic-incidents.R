#### Preamble ####
# Purpose: Add additional columns based on research on the Medical Dispatch Priority System
# Author: Jeremy Chu
# Contact: jeremychuj@gmail.com
# Date: 30 January 2021
# Pre-requisites: 00_get-data-paramedic-incidents.R, dataframes paramedic2019 and paramedic2020 loaded in the environment
# TODOs: Add columns for priority codes, add columns for explanations to priority codes

#### Workspace set-up ####
library(tidyverse)
library(here)

#### Read Data ####
paramedic2020 <- read_csv(here("inputs","data","2020_paramedic-incidents_raw.csv"))
paramedic2019 <- read_csv(here("inputs","data","2019_paramedic-incidents_raw.csv"))
paramedic2018 <- read_csv(here("inputs","data","2018_paramedic-incidents_raw.csv"))
paramedic2017 <- read_csv(here("inputs","data","2017_paramedic-incidents_raw.csv"))
paramedic2016 <- read_csv(here("inputs","data","2016_paramedic-incidents_raw.csv"))
paramedic2015 <- read_csv(here("inputs","data","2015_paramedic-incidents_raw.csv"))
paramedic2014 <- read_csv(here("inputs","data","2014_paramedic-incidents_raw.csv"))
paramedic2013 <- read_csv(here("inputs","data","2013_paramedic-incidents_raw.csv"))
paramedic2012 <- read_csv(here("inputs","data","2012_paramedic-incidents_raw.csv"))
paramedic2011 <- read_csv(here("inputs","data","2011_paramedic-incidents_raw.csv"))
paramedic2010 <- read_csv(here("inputs","data","2010_paramedic-incidents_raw.csv"))

## Standardizing Column Names ##

paramedic2017 <- paramedic2017 %>%
  rename(Forward_Sortation_Area = FSA)

paramedic2011 <- paramedic2011 %>%
  rename(Forward_Sortation_Area = FSA)

paramedic2010 <- paramedic2010 %>%
  rename(Forward_Sortation_Area = FSA)

## Bind Data ##
paramedic20192020_cleaned <- rbind(paramedic2019, paramedic2020)
paramedic11years_cleaned <- rbind(paramedic2010, 
                                  paramedic2011, 
                                  paramedic2012, 
                                  paramedic2013, 
                                  paramedic2014,
                                  paramedic2015,
                                  paramedic2016,
                                  paramedic2017, 
                                  paramedic2018, 
                                  paramedic2019, 
                                  paramedic2019, 
                                  paramedic2020)

## Reassigning Priority Codes back to datasets ##
### 2010-2020 ###
paramedic11years_cleaned <- paramedic11years_cleaned %>%
  mutate(Priority_Code = case_when( # case_when is basically if Priority_Number == X, ~ (then) "Name"
    Priority_Number == 1 ~ "Delta",
    Priority_Number == 3 ~ "Charlie",
    Priority_Number == 4 ~ "Bravo",
    Priority_Number == 5 ~ "Alpha",
    Priority_Number == 9 ~ "Echo",
    Priority_Number == 11 ~ "Alpha1",
    Priority_Number == 12 ~ "Alpha2",
    Priority_Number == 13 ~ "Alpha3")
  )

paramedic11years_cleaned <- paramedic11years_cleaned %>% 
  mutate(Priority_Definition = case_when(
    Priority_Number == 1 ~ "Life Threatening, not Cardiac/Respiratory Arrest",
    Priority_Number == 3 ~ "Serious, not Life Threatening",
    Priority_Number == 4 ~ "Non Serious/Non Life Threatening, Treatment Required",
    Priority_Number == 5 ~ "Non Serious/Non Life Threatening, Minimal Intervention",
    Priority_Number == 9 ~ "Life Threatening, Cardiac/Respiratory Arrest",
    Priority_Number == 11 ~ "Non Serious/Non Life Threatening, Minimal Intervention",
    Priority_Number == 12 ~ "Non Serious/Non Life Threatening, Minimal Intervention",
    Priority_Number == 13 ~ "Non Serious/Non Life Threatening, Minimal Intervention")
  )

### 2019-2020 ###
paramedic20192020_cleaned <- paramedic20192020_cleaned %>% 
  mutate(Priority_Code = case_when(
    Priority_Number == 1 ~ "Delta",
    Priority_Number == 3 ~ "Charlie",
    Priority_Number == 4 ~ "Bravo",
    Priority_Number == 5 ~ "Alpha",
    Priority_Number == 9 ~ "Echo",
    Priority_Number == 11 ~ "Alpha1",
    Priority_Number == 12 ~ "Alpha2",
    Priority_Number == 13 ~ "Alpha3")
  )

paramedic20192020_cleaned <- paramedic20192020_cleaned %>% 
  mutate(Priority_Definition = case_when(
    Priority_Number == 1 ~ "Life Threatening, not Cardiac/Respiratory Arrest",
    Priority_Number == 3 ~ "Serious, not Life Threatening",
    Priority_Number == 4 ~ "Non Serious/Non Life Threatening, Treatment Required",
    Priority_Number == 5 ~ "Non Serious/Non Life Threatening, Minimal Intervention",
    Priority_Number == 9 ~ "Life Threatening, Cardiac/Respiratory Arrest",
    Priority_Number == 11 ~ "Non Serious/Non Life Threatening, Minimal Intervention",
    Priority_Number == 12 ~ "Non Serious/Non Life Threatening, Minimal Intervention",
    Priority_Number == 13 ~ "Non Serious/Non Life Threatening, Minimal Intervention")
  )


### Additional Cleaning (2019-2020) ###
paramedic20192020_cleaned <- paramedic20192020_cleaned %>%
  mutate(Year = as.POSIXct(Dispatch_Time, format = "%m/%d/%Y %H:%M:%S")) %>% #Change datetime to POSIXct 
  mutate(Month = as.POSIXct(Dispatch_Time, format = "%m/%d/%Y %H:%M:%S")) #Change datetime to POSIXct 

paramedic20192020_cleaned$Year <- format(paramedic20192020_cleaned$Year, format = "%Y") #Extract only year
paramedic20192020_cleaned$Month <- format(paramedic20192020_cleaned$Month, format = "%m") #Extract only month

paramedic20192020_cleaned <- paramedic20192020_cleaned %>% #Decided to transform string numbers into month abbreviations for better visualization purposes
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

paramedic20192020_cleaned$Month <- factor(paramedic20192020_cleaned$Month, levels = month.abb) #Turning Months into factors for easier sorting

### Additional Cleaning (2010-2020) ###

paramedic11years_cleaned <- paramedic11years_cleaned %>%
  mutate(Year = as.POSIXct(Dispatch_Time, format = "%m/%d/%Y %H:%M:%S")) %>% #Change datetime to POSIXct 
  mutate(Month = as.POSIXct(Dispatch_Time, format = "%m/%d/%Y %H:%M:%S")) #Change datetime to POSIXct 

paramedic11years_cleaned$Year <- format(paramedic11years_cleaned$Year, format = "%Y") #Extract only year
paramedic11years_cleaned$Month <- format(paramedic11years_cleaned$Month, format = "%m") #Extract only month

paramedic11years_cleaned <- paramedic11years_cleaned %>% #Decided to transform string numbers into month abbreviations for better visualization purposes
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

paramedic11years_cleaned$Month <- factor(paramedic11years_cleaned$Month, levels = month.abb) #Turning Month to factor for easier sorting
paramedic11years_cleaned$Year <- as.character(paramedic11years_cleaned$Year) #Turning Year to character for graph manipulation

### Duplicates Removal ###
paramedic20192020_cleaned <- paramedic20192020_cleaned[!duplicated(paramedic20192020_cleaned$ID),]
paramedic11years_cleaned <- paramedic11years_cleaned[!duplicated(paramedic11years_cleaned$ID),]

### Save Data ###
write_csv(paramedic20192020_cleaned, here("inputs", "data", "2019-2020_paramedic-incidents_cleaned.csv"))
write_csv(paramedic11years_cleaned, here("inputs", "data", "2010-2020_paramedic-incidents_cleaned.csv"))
