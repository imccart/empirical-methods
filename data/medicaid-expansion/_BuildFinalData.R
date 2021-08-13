
# Meta --------------------------------------------------------------------

## Title:  Combine ACS and Medicaid Expansion Data
## Author: Ian McCarthy
## Date Created: 12/6/2019
## Date Edited:  8/13/2021


# Preliminaries -----------------------------------------------------------
if (!require("pacman")) install.packages("pacman")
pacman::p_load(tidyverse, ggplot2, dplyr, lubridate, readr, readxl,
               scales, gganimate, cobalt, stargazer, haven, ggthemes,
               acs, tidyr)

source('data/paths.R')
source('data/medicaid-expansion/Medicaid.R')
source('data/medicaid-expansion/ACS.R')


# Tidy --------------------------------------------------------------------
final.data <- final.insurance %>%
  left_join(kff.final, by="State") %>%
  mutate(expand_year = year(date_adopted),
         expand = (year>=expand_year & !is.na(expand_year))) %>%
  rename(expand_ever=expanded)

write_tsv(final.data,'data/medicaid-expansion/mcaid-expand-data.txt',append=FALSE,col_names=TRUE)
