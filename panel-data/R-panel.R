########################################
## Panel data estimates in Stata
########################################
  
## FE (within) estimator
library(readstata13)
library(fixest)
wagepan <- read.dta13("http://fmwww.bc.edu/ec-p/data/wooldridge/wagepan.dta")
feols(lwage~exper + expersq | nr, data=wagepan)


## Manually demeaning the data
wagepan <- wagepan %>%
  group_by(nr) %>%
  mutate(demean_lwage=lwage - mean(lwage),
         demean_exper=exper - mean(exper),
         demean_expersq=expersq - mean(expersq))
summary(lm(demean_lwage~demean_exper + demean_expersq, data=wagepan))


## First differencing
wagepan <- wagepan %>%
  group_by(nr) %>%
  arrange(year) %>%
  mutate(fd_lwage=lwage - lag(lwage),
         fd_exper=exper - lag(exper),
         fd_expersq=expersq - lag(expersq)) %>%
  na.omit()
summary(lm(fd_lwage~0 + fd_exper + fd_expersq, data=wagepan))