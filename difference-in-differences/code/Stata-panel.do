****************************************
** Panel data estimates in Stata
****************************************

** FE (within) estimator
ssc install bcuse
bcuse wagepan
xtset nr year
xtreg lwage exper expersq, fe


** Manually demeaning the data
foreach x of varlist lwage exper expersq {
  egen mean_`x'=mean(`x')
  egen demean_`x'=`x'-mean_`x'
}
reg demean_lwage demean_exper demean_expersq


** First differencing
** note: the "d." operator only works with identical time gaps (1 in this case)
reg d.lwage d.exper d.expersq, noconstant