****************************************
** Differences-in-Differences in Stata
****************************************
insheet using "https://raw.githubusercontent.com/imccart/empirical-methods/main/data/medicaid-expansion/mcaid-expand-data.txt", clear


** Looking at the data
gen perc_unins=uninsured/adult_pop
keep if expand_year=="2014" | expand_year=="NA"
drop if expand_ever=="NA"
collapse (mean) perc_unins, by(year expand_ever)
graph twoway (connected perc_unins year if expand_ever=="FALSE", color(black) lpattern(solid)) ///
  (connected perc_unins year if expand_ever=="TRUE", color(black) lpattern(dash)), ///
  xline(2013.5) ///
	ytitle("Fraction Uninsured") xtitle("Year") legend(off) text(0.15 2017 "Non-expansion", place(e)) text(0.08 2017 "Expansion", place(e))


** Simple 2x2 DD
gen post=(year>=2014)
gen treat=(expand_ever=="TRUE")
gen treat_post=(expand=="TRUE")

reg perc_unins treat post treat_post

** note - Stata 17 has didregress that will do a lot of this automatically