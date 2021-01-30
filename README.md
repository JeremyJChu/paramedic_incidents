# Paramedic Life Threatening Medical Emergencies vs COVID-19 Hospitalizations: Exposing the Toronto Neighbourhood Gap
Sourcing from the city of Toronto's [Open Data Portal](https://open.toronto.ca/), this project performs explaratory data analysis (EDA) on the [Paramedic Services Incident Dataset](https://open.toronto.ca/dataset/paramedic-services-incident-data/) and the [COVID-19 Cases in Toronto Dataset](https://open.toronto.ca/dataset/covid-19-cases-in-toronto/). The heatmap shapefile was obtained from Statistics Canada's [Forward Sortation Area](https://www12.statcan.gc.ca/census-recensement/2011/geo/bound-limit/bound-limit-2016-eng.cfm) file.

The paper can be found [here](https://github.com/JeremyJChu/paramedic_incidents/blob/main/outputs/paper/paramedic-incidents-study.pdf).
## Questions Asked
- Did the data show an increase in life threatening respiratory/cardiac (coded as Echo) emergencies in 2020 as compared to previous years?
- If so, was 2020 a uniquely **bad** year?
- Were there similarities between the Echo emergencies trend and the COVID-19 hospitalization trend?
- Which neighbourhoods in Toronto were at risk, and of what?
## Packages
This project was done entirely with R through R Studio. Results were knitted into a pdf through R Markdown. Packages used:
- tidyverse
- opendatatoronto
- here
- knitr
- gt
- magick
- ggpubr
- gridExtra
- gghighlight
- kableExtra
- bookdown
- grid
- rgdal
- rgeos
- maptools
## Setup
R Markdown was setup using the following settings:
```
classoption: table
output: bookdown::pdf_document2
header-includes: 
  \usepackage{float}
  \usepackage{colortbl} 
  \arrayrulecolor{white}
```
If you're running into issues knitting, please refer to script [07_extra_tinytex-troubleshooting.R](https://github.com/JeremyJChu/paramedic_incidents/blob/main/scripts/07_extra_tinytex-troubleshooting.R).
## How to Use 
The project is entirely reproducible. All data downloading, cleaning, and transformation are performed and segmented in the [scripts](scripts) folder. The [R Markdown](outputs/paper) sources all the scripts using the library `here`, so simply clone the repo and everything will run accordingly.

I have also taken the liberty in saving all the raw and cleaned datasets and stored them [here](inputs/data). The R Markdown contains the both options of either running the scripts or reading in the data from inputs, simply comment/uncomment the parts you would like to run. Clone the repo and everything will be there. 

## Changelog
2021-01-30
- Tested reproducibility with Windows machine
- Added troubleshooting script for knitting
- Added rgeos and gpclib in case running into issues on heatmaps
- Edited paper for grammar and clarity
- Updated scrips 05 and 06 to reflect new changes

2021-01-27
- Changed paper terminology and graph titles for better clarity

2021-01-26 (Second Update)
- Pushed literature

2021-01-26
- Pushed first draft. Currently missing final edits and literature files. Testing tbd on reproducibility on another comptuer 

## Meta
Jeremy Chu - [@Jeremyjchu](https://twitter.com/Jeremyjchu) - [jeremychuj@gmail.com](jeremychuj@gmail.com)

Distributed under the MIT License. See `LICENSE` for more information. 

https://github.com/JeremyJChu

## Credits
[Rohan Alexander](https://rohanalexander.com/) for support. 

[Unconstant Conjunction](https://unconj.ca/blog/) for mapping inspiration.


