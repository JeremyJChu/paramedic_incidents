#### Preamble ####
# Purpose: Generate geomaps of paramedic-incidents and covid-19 datasets
# Author: Jeremy Chu
# Contact: jeremychuj@gmail.com
# Date: 22 January 2021
# Pre-requisites: Run 00-04 R scripts. Have covid_hospitalized and paramedic20192020_cleaned data in Global Environment. Have fsas shape data loaded.
#TODOs: Create a geomap that is saved as a png.

#### Setup Workspace ####

#install.packages("rgdal")
#install.packages("broom")
#install.packages("mapproj")
#install.packages("rgeos")
#install.packages("maptools")
library(rgdal)
library(broom)
library(mapproj)
library(rgeos)
library(maptools)
library(here)
library(gridExtra)

#### Read Data ####
covid_hospitalized <- read_csv(here("inputs", "data", "2020_covid-cases-hospitalization_cleaned.csv"))
paramedic20192020_cleaned <- read_csv(here("inputs", "data", "2019-2020_paramedic-incidents_cleaned.csv"))


## The Following Shapefile manipulation code follows a tutorial from https://unconj.ca/blog/choropleth-maps-with-r-and-ggplot2.html ##

## Optional - Reading Shapefile Locally  ##
#fsas <-  readOGR(dsn = path.expand(here("inputs/shapefiles/lfsa000b16a_e.shp")), layer = "lfsa000b16a_e") #Read shapefile locally, note that you need all the other accompanying files to read it in, otherwise you get an error

### Manipulation of Shapefile ###
toronto.fsas <- fsas[substr(fsas$CFSAUID, 1, 1) == 'M',] #Extracts Toronto Postal Codes
data <- ggplot2::fortify(toronto.fsas, region = "CFSAUID") #Turning object into something plottable by ggplot
data$fsa <- factor(data$id)
data$id <- NULL

### Transforming data in preparation for merging ###

## Transforming data in preparation for merging ##

# Covid Data
covid_hospitalized_allmonths <- covid_hospitalized %>% # Creating a table that groups and counts by FSA
  group_by(FSA) %>%
  count() %>%
  rename(fsa = FSA) %>% #rename FSA to fsa to join later
  rename(covidcases = n) #rename n into something more understandable

plot.data_covid_allmonths <- left_join(data, covid_hospitalized_allmonths) # Merge the location data with the covid data, joining under the "fsa" column. left_join is used because merge causes polygon tearing.

# Paramedic Incident Data (2020)
paramedic2020_map_allmonths <- paramedic20192020_cleaned %>% # Creating a table that groups and counts by FSA
  filter(Year == "2020") %>% 
  group_by(Forward_Sortation_Area) %>%
  count() %>%
  rename(fsa = Forward_Sortation_Area) %>% # rename Forward_Sortation_Area to fsa to join later
  rename(echo2020cases = n) #rename n into something more understandable

plot.data_para_allmonths <- left_join(data, paramedic2020_map_allmonths) # Merge the location data with paramedic data, joining under the "fsa" column. left_join is used because merge causes polygon tearing.

# Paramedic Incident Data (2019)
paramedic2019_map_allmonths <- paramedic20192020_cleaned %>% # Creating a table that groups and counts by FSA
  filter(Year == "2019") %>% 
  group_by(Forward_Sortation_Area) %>%
  count() %>%
  rename(fsa = Forward_Sortation_Area) %>% # rename Forward_Sortation_Area to fsa to join later
  rename(echo2019cases = n) #rename n into something more understandable


plot.data_para_2019 <- left_join(data, paramedic2019_map_allmonths) # Merge the location data with paramedic data, joining under the "fsa" column. left_join is used because merge causes polygon tearing.

## Plotting the Maps ##
# Covid Map
covid_map <- ggplot(plot.data_covid_allmonths, aes(x = long, y = lat, group = group, fill = covidcases)) +
  geom_polygon() +
  coord_equal() +
  scale_fill_continuous(high = "#cc3350", low = "#33CCAF") + # Adjusting Heatmap colors 
  theme(panel.grid = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        panel.background = element_blank(),
        legend.title = element_blank(),
        plot.title = element_text(size = 10, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 6)) +
  labs(title = "Toronto COVID-19 Cases Heatmap",
       caption ="Source: Open Data Toronto")  

# Paramedic Map (2020)
paramedic_map <- ggplot(plot.data_para_allmonths, aes(x = long, y = lat, group = group, fill = echo2020cases)) +
  geom_polygon() +
  coord_equal() +
  scale_fill_continuous(high = "#cc3350", low = "#33CCAF") + # Adjusting Heatmap colors 
  theme(panel.grid = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        panel.background = element_blank(),
        legend.title = element_blank(),
        plot.title = element_text(size = 10, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 6)) +
  labs(title = "Toronto Echo Incidents Heatmap",
       caption ="Source: Open Data Toronto")  

# Paramedic Map (2019)

map2019 <- ggplot(plot.data_para_2019, aes(x = long, y = lat, group = group, fill = echo2019cases)) +
  geom_polygon() +
  coord_equal() +
  scale_fill_continuous(high = "#cc3350", low = "#33CCAF") + # Adjusting Heatmap colors 
  theme(panel.grid = element_blank(),
        axis.title = element_blank(),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        panel.background = element_blank(),
        legend.title = element_blank(),
        plot.title = element_text(size = 10, face = "bold", hjust = 0.5),
        plot.caption = element_text(size = 6)) +
  labs(title = "Toronto 2019 Echo Incidents Heatmap",
       caption ="Source: Open Data Toronto")  

#Putting 2020 Echo and COVID into 1 Panel
covid_echo_mapping_panel <-
  grid.arrange(paramedic_map, covid_map, ncol = 2)

#Saving Data
ggsave(covid_echo_mapping_panel, file = here("outputs/paper/images/06_2020-covid-echo-mapping-panel.png"), width = 8, height = 5)
ggsave(map2019, file = here("outputs/paper/images/07_2019-echo-heatmap.png"), width = 8, height = 5)

