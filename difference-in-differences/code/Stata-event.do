****************************************
** Event Studies in Stata
****************************************
ssc install reghdfe

** Common treatment timing
insheet using "https://raw.githubusercontent.com/imccart/empirical-methods/main/data/medicaid-expansion/mcaid-expand-data.txt", clear
gen perc_unins=uninsured/adult_pop
keep if expand_year=="2014" | expand_year=="NA"
drop if expand_ever=="NA"
gen post=(year>=2014)
gen treat=(expand_ever=="TRUE")
gen treat_post=(expand=="TRUE")

reghdfe perc_unins treat##ib2013.year, absorb(state)
gen coef = .
gen se = .
forvalues i = 2012(1)2018 {
    replace coef = _b[1.treat#`i'.year] if year == `i'
    replace se = _se[1.treat#`i'.year] if year == `i'
}

* Make confidence intervals
gen ci_top = coef+1.96*se
gen ci_bottom = coef - 1.96*se

* Limit ourselves to one observation per year
keep year coef se ci_*
duplicates drop

* Create connected scatterplot of coefficients
* with CIs included with rcap 
* and a line at 0 from function
twoway (sc coef year, connect(line)) (rcap ci_top ci_bottom year) ///
    (function y = 0, range(2012 2018)), xtitle("Year") ///
    caption("Estimates and 95% CI from Event Study")



** Differential treatment timing
insheet using "https://raw.githubusercontent.com/imccart/empirical-methods/main/data/medicaid-expansion/mcaid-expand-data.txt", clear
gen perc_unins=uninsured/adult_pop
drop if expand_ever=="NA"
replace expand_year="." if expand_year=="NA"
destring expand_year, replace
gen event_time=year-expand_year
replace event_time=-1 if event_time==.

forvalues l = 0/4 {
	gen L`l'event = (event_time==`l')
}
forvalues l = 1/2 {
	gen F`l'event = (event_time==-`l')
}
gen F3event=(event_time<=-3)

reghdfe perc_unins F3event F2event L0event L1event L2event L3event L4event, absorb(state year) cluster(state)
gen coef = .
gen se = .
forvalues i = 2(1)3 {
    replace coef = _b[F`i'event] if F`i'event==1
    replace se = _se[F`i'event] if F`i'event==1
}
forvalues i = 0(1)4 {
    replace coef = _b[L`i'event] if L`i'event==1
    replace se = _se[L`i'event] if L`i'event==1
}
replace coef = 0 if F1event==1
replace se=0 if F1event==1

* Make confidence intervals
gen ci_top = coef+1.96*se
gen ci_bottom = coef - 1.96*se

* Limit ourselves to one observation per year
keep if event_time>=-3 & event_time<=4
keep event_time coef se ci_*
duplicates drop

* Create connected scatterplot of coefficients
* with CIs included with rcap 
* and a line at 0 from function
sort event_time
twoway (sc coef event_time, connect(line)) (rcap ci_top ci_bottom event_time) ///
    (function y = 0, range(-3 4)), xtitle("Time") ///
    caption("Estimates and 95% CI from Event Study") xlabel(-3(1)4)

