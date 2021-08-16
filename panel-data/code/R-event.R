########################################
## Event Studies in R
########################################
library(tidyverse)
library(modelsummary)
library(data.table)
library(fixest)
mcaid.data <- read_tsv("https://raw.githubusercontent.com/imccart/empirical-methods/main/data/medicaid-expansion/mcaid-expand-data.txt")

## Common treatment timing
reg.dat <- as.data.table(mcaid.data) %>% 
  filter(expand_year==2014 | is.na(expand_year), !is.na(expand_ever)) %>%
  mutate(perc_unins=uninsured/adult_pop,
         post = (year>=2014), 
         treat=post*expand_ever)

mod.twfe <- feols(perc_unins~i(year, expand_ever, ref=2013) | State + year,
                  cluster=~State,
                  data=reg.dat)
iplot(mod.twfe, 
      xlab = 'Time to treatment',
      main = 'Event study')


## Differential treatment timing
reg.dat <- as.data.table(mcaid.data) %>% 
  filter(!is.na(expand_ever)) %>%
  mutate(perc_unins=uninsured/adult_pop)
reg.dat[, time_to_treat := ifelse(expand_ever==TRUE, year-expand_year, 0)]

reg.dat <- reg.dat %>%
  mutate(time_to_treat=ifelse(time_to_treat<=-3,-3,time_to_treat))

mod.twfe <- feols(perc_unins~i(time_to_treat, expand_ever, ref=-1) | State + year,
                  cluster=~State,
                  data=reg.dat)
iplot(mod.twfe, 
      xlab = 'Time to treatment',
      main = 'Event study')
