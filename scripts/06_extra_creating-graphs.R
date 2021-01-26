#### Preamble ####
# Purpose: OPTIONAL: Creating PNG files of all graphs in R Markdown
# Author: Jeremy Chu
# Contact: jeremychuj@gmail.com
# Date: 22 January 2021
# Pre-requisites: Scripts: 00 - 03 already run. 2019-2020_paramedic-incidents_cleaned.csv, 2010-2020_paramedic-incidents_cleaned.csv, and 2020_covid-cases_cleaned.csv loaded into global environment.
#                 If scripts already run, data should already be loaded. An additional read_csv function will also be available in the code below.                  
#TODOs: Create Charts and Graphs


### Workspace Setup ###
library(tidyverse)
library(here)
library(knitr)
library(gt)
library(magick)
library(ggpubr)
library(cowplot)
library(gridExtra)
library(gghighlight)
library(directlabels)

### Read Data (If Scripts not Run) ###
paramedic20192020_cleaned <- read_csv(here("inputs","data","2019-2020_paramedic-incidents_cleaned.csv"))
paramedic11years_cleaned <- read_csv(here("inputs","data","2010-2020_paramedic-incidents_cleaned.csv"))
covid_monthCount <- read_csv(here("inputs","data","2020_covid-cases_cleaned.csv"))

## Figure 1a Medical Bar ##

paramedic20192020_cleaned$Year <- as.character(paramedic20192020_cleaned$Year) #Turning Year from numeric to character so fill works

medical_bar <- #Plotting Bar Chart 
  paramedic20192020_cleaned %>%
  filter(Incident_Type == "Medical") %>%
  ggplot(mapping = aes(x = Priority_Code, fill = Year)) +
  geom_bar(position = position_dodge()) +
  geom_text(stat = "count", aes(label = ..count..), vjust=1.6, color="black", #Stat "count" allows for labelling of bar chart with no y axis
            position = position_dodge(0.9), size=2.0) +
  scale_fill_brewer(palette="Blues") +
  theme(panel.grid = element_blank(), #No grid
        axis.text.y = element_blank(), #No y axis text
        axis.title = element_blank(), #No axis title for both axes
        axis.ticks = element_blank(), #No ticks, the little black lines, in both axes
        legend.title = element_blank(), #No legend title
        panel.background = element_blank(), #No grey background
        plot.title = element_text(size = 10, face = "bold", hjust = 0.5), #Title size and face adjustment
        plot.caption = element_text(size = 6)) + #Caption size adjustment 
  labs(x = "Priority Number", #Adding labels and misc text
       y = "Count",
       title = "How were Medical Incidents Classified in 2019 and 2020?",
       caption ="Source: Open Data Toronto")

# Saving Chart to Folder for RMD 
ggsave(medical_bar, file = here("outputs/paper/images/04_2019-2020-medical_bar.png"), width = 8, height = 5)

## Figure 1b Vehicle Bar (No Longer Used in RMD) ##

vehicle_bar <-
  paramedic20192020_cleaned %>%
  filter(Incident_Type == "Motor Vehicle Accident") %>%
  ggplot(mapping = aes(x = Priority_Code, fill = Year)) +
  geom_bar(position = position_dodge()) +
  geom_text(stat = "count", aes(label = ..count..), vjust=1.6, color="black",
            position = position_dodge(0.9), size=2.0) +
  scale_fill_brewer(palette="Blues") +
  theme(panel.grid = element_blank(),
        axis.text.y = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        legend.title = element_blank(),
        panel.background = element_blank(),
        plot.title = element_text(size = 10, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 6)
  ) +
  labs(x = "Priority Number",
       y = "Count",
       title = "How were Motor Vehicle Incidents classified in 2019 and 2020?",
       caption ="Source: Open Data Toronto")

## Panel with Medical Bar & Vehicle Bar (No Longer Used in RMD) ##

medical_vehicle_panel <-
  grid.arrange(
    medical_bar +
      theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = , "cm")),
    
    vehicle_bar +
      theme(plot.margin = unit(c(0.2, 0.2, 0.2, 0.2), units = , "cm"))
  )

# Saving Chart 

ggsave(medical_vehicle_panel, file = here("outputs/paper/images/00_medical-vehicle_panel.png"), width = 8, height = 7)

## Line Graph Comparing Echo Incidents Between 2019 and 2020 ##

# Creating Echo Table
echo_count <-
  paramedic20192020_cleaned %>%
  filter(Incident_Type == "Medical" & Priority_Code == "Echo") %>%
  group_by(Year, Month) %>%
  count()

echo_count$Month <- factor(echo_count$Month, levels = month.abb) #Turning Months into factors for easier sorting

# Creating Line Graph
echo_line_graph <- 
  echo_count %>%
  ggplot(aes(x = Month, y = n, color = Year)) +
  geom_line(aes(group = Year)) +
  geom_point() +
  scale_color_brewer(palette = "Blues") +
  theme(panel.grid = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_blank(),
        legend.position = "top",
        legend.title = element_blank(),
        plot.title = element_text(size = 10, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 6)
  ) +
  labs(x = "Priority Number",
       y = "Count",
       title = "Respiratory or Cardiac Medical Incidents by Month (2019 vs 2020)",
       caption ="Source: Open Data Toronto")

# Saving Line Graph
ggsave(echo_line_graph, file = here("outputs/paper/images/01_echo-line_graph.png"), width = 7, height = 3)

## Plotting 11 Years Comparison of Echo Incidents ##

# Creating Echo 11 Years Table 
echo_11yr_count <-
  paramedic11years_cleaned %>%
  filter(Incident_Type == "Medical" & Priority_Code == "Echo") %>%
  group_by(Year, Month) %>%
  count() %>%
  ungroup()

echo_11yr_count$Month <- factor(echo_11yr_count$Month, levels = month.abb) #Turning Month to factor for easier sorting
echo_11yr_count$Year <- as.character(echo_11yr_count$Year) #Turning Year to character for graph manipulation

# Plotting 11 Years Line Graph
echo_11yr_line_graph  <- 
  echo_11yr_count %>%
  ggplot(aes(x = Month, y = n, group = Year)) +
  geom_line(aes(color = Year)) +
  geom_point(aes(color = Year)) +
  scale_color_manual(values=c("#60809f")) + 
  gghighlight(Year == "2020") +
  theme(panel.grid = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_blank(),
        plot.title = element_text(size = 10, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 6)
  ) +
  labs(title = "2010-2020 Comparison of Respiratory and Cardiac Emergencies",
       caption ="Source: Open Data Toronto")  

# Saving Line Graph
ggsave(echo_11yr_line_graph, file = here("outputs/paper/images/03_echo-11yr-line_graph.png"), width = 8, height = 4)

## Figure 5 Echo Incidents vs COVID Case Trends in 2020 ##

# Preparing the Data
echo_2020_count <- 
  echo_count %>% 
  filter(Year == 2020)

covid_echo <- merge(echo_2020_count, covid_monthCount, by.x = "Month", by.y = "Month") #Merging Datasets

covid_echo <- covid_echo %>% 
  rename(echo_number = n) #Renaming column for sanity

# Plotting the Graph
case_number_trend <- 
  covid_echo %>%
  ggplot() +
  geom_line(aes(x = Month, y = case_number, group = Year), color = "#bd4279") +
  geom_point(aes(x = Month, y = case_number, group = Year), color = "#bd4279") +
  theme(panel.grid = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_blank(),
        plot.title = element_text(size = 10, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 6)) +
  labs(title = "2020 COVID Case Trend by Month",
       caption ="Source: Open Data Toronto")  


echo_number_trend <-
  covid_echo %>%
  ggplot() +
  geom_line(aes(x = Month, y = echo_number, group = Year), color = "#60809f") +
  geom_point(aes(x = Month, y = echo_number, group = Year), color = "#60809f") +
  theme(panel.grid = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_blank(),
        plot.title = element_text(size = 10, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 6)) +
  labs(title = "2020 Echo Incidents Trend by Month",
       caption ="Source: Open Data Toronto")  

echo_case_panel <- grid.arrange(echo_number_trend, case_number_trend, ncol = 2)

# Saving the Graph
ggsave(echo_case_panel, file = here("outputs/paper/images/05_echo-case_panel.png"), width = 8, height = 5)