########################################
## Recent DD Estimators in R
########################################
library(tidyverse)
library(modelsummary)
library(data.table)
library(fixest)
mcaid.data <- read_tsv("https://raw.githubusercontent.com/imccart/empirical-methods/main/data/medicaid-expansion/mcaid-expand-data.txt")


## Callaway and Sant'Anna
library(did)
library(DRDID)

reg.dat <- mcaid.data %>% 
  filter(!is.na(expand_ever)) %>%
  mutate(perc_unins=uninsured/adult_pop,
         post = (year>=2014), 
         treat=post*expand_ever,
         expand_year=ifelse(is.na(expand_year),0,expand_year)) %>%
  filter(!is.na(perc_unins)) %>%
  group_by(State) %>%
  mutate(stategroup=cur_group_id()) %>% ungroup()

mod.cs <- att_gt(yname="perc_unins", tname="year", idname="stategroup",
                 gname="expand_year",
                 data=reg.dat, panel=TRUE, est_method="dr",
                 allow_unbalanced_panel=TRUE)
mod.cs.event <- aggte(mod.cs, type="dynamic")
ggdid(mod.cs.event)


## Sun and Abraham
reg.dat <- mcaid.data %>% 
  filter(!is.na(expand_ever)) %>%
  mutate(perc_unins=uninsured/adult_pop,
         post = (year>=2014), 
         treat=post*expand_ever,
         expand_year = ifelse(expand_ever==FALSE, 10000, expand_year),
         time_to_treat = ifelse(expand_ever==FALSE, -1, year-expand_year),
         time_to_treat = ifelse(time_to_treat < -3, -3, time_to_treat))

mod.sa <- feols(perc_unins~sunab(expand_year, time_to_treat) | State + year,
                cluster=~State,
                data=reg.dat)
iplot(mod.sa,
      xlab = 'Time to treatment',
      main = 'Event study')


## de Chaisemartin and D'Haultfoeuille
library(DIDmultiplegt)
reg.dat <- mcaid.data %>% 
  filter(!is.na(expand_ever)) %>%
  mutate(perc_unins=uninsured/adult_pop,
         treat=case_when(
           expand_ever==FALSE ~ 0,
           expand_ever==TRUE & expand_year<year ~ 0,
           expand_ever==TRUE & expand_year>=year ~ 1))

mod.ch <- did_multiplegt(df=reg.dat, Y="perc_unins", G="State", T="year", D="treat",
                         placebo=3, dynamic=4, brep=50, cluster="State")
mod.ch