#### Preamble ####
# Purpose: Add additional columns based on research on the Medical Dispatch Priority System
# Author: Jeremy Chu
# Contact: jeremychuj@gmail.com
# Date: 19 January 2021
# Pre-requisites: 00_get-data-paramedic-incidents.R, dataframes paramedic2019 and paramedic2020 loaded in the environment
# TODOs: Add columns for priority codes, add columns for explanations to priority codes

#### Workspace set-up ####
library(tidyverse)

## paramedic2020 ##
# Reassigning Priority Codes back to dataset
paramedic2020_cleaned <- paramedic2020 %>% 
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

paramedic2020_cleaned <- paramedic2020_cleaned %>% 
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

## paramedic2019 ##
# Reassigning Priority Codes back to dataset
paramedic2019_cleaned <- paramedic2019 %>% 
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

paramedic2019_cleaned <- paramedic2019_cleaned %>% 
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

### Bind Data ###
paramedic20192020_cleaned <- rbind(paramedic2019_cleaned, paramedic2020_cleaned)

### Additional Cleaning ###
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
  

### Save Data ###
write_csv(paramedic2020_cleaned, here("inputs", "data", "2020_paramedic-incidents_cleaned.csv"))
write_csv(paramedic2019_cleaned, here("inputs", "data", "2019_paramedic-incidents_cleaned.csv"))
write_csv(paramedic20192020_cleaned, here("inputs", "data", "2019-2020_paramedic-incidents_cleaned.csv"))
