****************************************
** Recent DD Estimators in Stata
****************************************
ssc install event_plot


** Callaway and Sant'Anna
ssc install csdid
ssc install drdid

insheet using "https://raw.githubusercontent.com/imccart/empirical-methods/main/data/medicaid-expansion/mcaid-expand-data.txt", clear
gen perc_unins=uninsured/adult_pop
egen stategroup=group(state)
drop if expand_ever=="NA"
replace expand_year="0" if expand_year=="NA"
destring expand_year, replace

csdid perc_unins, ivar(stategroup) time(year) gvar(expand_year) notyet
estat event, estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") xlabel(-6(1)4) title("Callaway and Sant'Anna (2020)")) stub_lag(T+#) stub_lead(T-#) together



** Callaway and Sant'Anna
ssc install csdid
ssc install drdid

insheet using "https://raw.githubusercontent.com/imccart/empirical-methods/main/data/medicaid-expansion/mcaid-expand-data.txt", clear
gen perc_unins=uninsured/adult_pop
egen stategroup=group(state)
drop if expand_ever=="NA"
replace expand_year="0" if expand_year=="NA"
destring expand_year, replace

csdid perc_unins, ivar(stategroup) time(year) gvar(expand_year) notyet
estat event, estore(cs)
event_plot cs, default_look graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") xlabel(-6(1)4) title("Callaway and Sant'Anna (2020)")) stub_lag(T+#) stub_lead(T-#) together



** Sun and Abraham
ssc install eventstudyinteract
ssc install avar

insheet using "https://raw.githubusercontent.com/imccart/empirical-methods/main/data/medicaid-expansion/mcaid-expand-data.txt", clear
gen perc_unins=uninsured/adult_pop
drop if expand_ever=="NA"
egen stategroup=group(state)
replace expand_year="." if expand_year=="NA"
destring expand_year, replace
gen event_time=year-expand_year
gen nevertreated=(event_time==.)

forvalues l = 0/4 {
	gen L`l'event = (event_time==`l')
}
forvalues l = 1/2 {
	gen F`l'event = (event_time==-`l')
}
gen F3event=(event_time<=-3)
eventstudyinteract perc_unins F3event F2event L0event L1event L2event L3event L4event, vce(cluster stategroup) absorb(stategroup year) cohort(expand_year) control_cohort(nevertreated)

event_plot e(b_iw)#e(V_iw), default_look graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") xlabel(-3(1)4)	title("Sun and Abraham (2020)")) stub_lag(L#event) stub_lead(F#event) plottype(scatter) ciplottype(rcap) together



** de Chaisemartin and D'Haultfoeuille
ssc install did_multiplegt

insheet using "https://raw.githubusercontent.com/imccart/empirical-methods/main/data/medicaid-expansion/mcaid-expand-data.txt", clear
gen perc_unins=uninsured/adult_pop
drop if expand_ever=="NA"
egen stategroup=group(state)
replace expand_year="." if expand_year=="NA"
destring expand_year, replace
gen event_time=year-expand_year
gen nevertreated=(event_time==.)
gen treat=(event_time>=0 & event_time!=.)

did_multiplegt perc_unins stategroup year treat, robust_dynamic dynamic(4) placebo(3) breps(100) cluster(stategroup) 
event_plot e(estimates)#e(variances), default_look graph_opt(xtitle("Periods since the event") ytitle("Average causal effect") ///
title("de Chaisemartin and D'Haultfoeuille (2020)") xlabel(-3(1)4)) stub_lag(Effect_#) stub_lead(Placebo_#) together

