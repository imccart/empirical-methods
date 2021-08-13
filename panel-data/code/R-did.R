########################################
## Difference-in-Differences in R
########################################
library(tidyverse)  
mcaid.data <- read_tsv("https://raw.githubusercontent.com/imccart/empirical-methods/main/data/medicaid-expansion/mcaid-expand-data.txt")

## Looking at the data
ins.plot.dat <- mcaid.data %>% filter(expand_year==2014 | is.na(expand_year), !is.na(expand_ever)) %>%
  mutate(perc_unins=uninsured/adult_pop) %>%
  group_by(expand_ever, year) %>% summarize(mean=mean(perc_unins))

ins.plot <- ggplot(data=ins.plot.dat, aes(x=year,y=mean,group=expand_ever,linetype=expand_ever)) + 
  geom_line() + geom_point() + theme_bw() +
  geom_vline(xintercept=2013.5, color="red") +
  geom_text(data = ins.plot.dat %>% filter(year == 2016), 
            aes(label = c("Non-expansion","Expansion"),
                x = year + 1,
                y = mean)) +
  guides(linetype=FALSE) +
  labs(
    x="Year",
    y="Fraction Uninsured",
    title="Share of Uninsured over Time"
  )


## Simple 2x2 DD
reg.dat <- mcaid.data %>% filter(expand_year==2014 | is.na(expand_year), !is.na(expand_ever)) %>%
  mutate(perc_unins=uninsured/adult_pop,
         post = (year>=2014), 
         treat=post*expand_ever)

dd.ins.reg <- lm(perc_unins ~ post + expand_ever + post*expand_ever, data=reg.dat)
msummary(dd.ins.reg)
