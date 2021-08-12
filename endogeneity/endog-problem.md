# The Problem

It would be great if we could test for whether we really had an endogeneity problem or not. But alas, that’s just not in the cards. Instead, a good starting point is to see “how much” of an endogeneity problem we’d have to have to overturn our current results. There are several papers in this area. Here, I’ll mention just two that also have supporting Stata or R code. Those papers are [Oster 2019](endog-problem.md#oster) and [Cinelli and Hazlett 2020](endog-problem.md#cinelli).

In both cases, the idea is as follows… Lots of applied researchers assess “coefficient stability” by including different sets of control variables that are intended to proxy for some potentially important unobserved factor. This is not informative of omitted variables bias if the existing controls already do a very poor job of explaining the outcome. As Prof. Oster notes, “Omitted variable bias is proportional to coefficient movements, but only if such movements are scaled by the change in R-squared when controls are included.”

## Oster 2019

Extending the work of Altonji, Elder, and Taber \(2005\), Oster \(2019\) lays out a scenario in which we can fully decompose our outcome of interest into a treatment effect \(denoted ![\beta](https://latex.codecogs.com/png.latex?%5Cbeta)\), observed controls \(denoted by ![W\_{1}](https://latex.codecogs.com/png.latex?W_%7B1%7D)\), unobserved controls \(denoted by ![W\_{2}](https://latex.codecogs.com/png.latex?W_%7B2%7D)\), and some iid error term. Denote by ![X](https://latex.codecogs.com/png.latex?X) the treatment variable, such that

![Y = \beta X + W\_{1} + W\_{2} + \epsilon.](https://latex.codecogs.com/png.latex?Y%20%3D%20%5Cbeta%20X%20%2B%20W_%7B1%7D%20%2B%20W_%7B2%7D%20%2B%20%5Cepsilon.)

We then need to consider values \(or a range of values\) for two key objects.

1. What is the maximum ![R^2](https://latex.codecogs.com/png.latex?R%5E2) value we could obtain if we observed ![W\_{2}](https://latex.codecogs.com/png.latex?W_%7B2%7D)? Let’s call this ![R\_{\text{max}}^{2}](https://latex.codecogs.com/png.latex?R_%7B%5Ctext%7Bmax%7D%7D%5E%7B2%7D). If we think the outcome is fully deterministic if we were to observe all relevant variables, then ![R\_{\text{max}}^{2}=1](https://latex.codecogs.com/png.latex?R_%7B%5Ctext%7Bmax%7D%7D%5E%7B2%7D%3D1), but we could consider smaller values as well.
2. What is the degree of selection on observed variables relative to unobserved variables? We can denote this value as ![\delta](https://latex.codecogs.com/png.latex?%5Cdelta), and define ![\delta](https://latex.codecogs.com/png.latex?%5Cdelta) as the value such that:

   ![\delta \times \frac{Cov\(W\_{1},X\)}{Var\(W\_{1}\)} = \frac{Cov\(W\_{2},X\)}{Var\(W\_{2}\)}.](https://latex.codecogs.com/png.latex?%5Cdelta%20%5Ctimes%20%5Cfrac%7BCov%28W_%7B1%7D%2CX%29%7D%7BVar%28W_%7B1%7D%29%7D%20%3D%20%5Cfrac%7BCov%28W_%7B2%7D%2CX%29%7D%7BVar%28W_%7B2%7D%29%7D.)

We then need to define a few objects that we can directly estimate with the data:

1. Denote by ![R^{2}\_{X}](https://latex.codecogs.com/png.latex?R%5E%7B2%7D_%7BX%7D) the ![R^{2}](https://latex.codecogs.com/png.latex?R%5E%7B2%7D) from a regression of ![Y](https://latex.codecogs.com/png.latex?Y) on treatment \(and only treatment, no covariates\). Similarly denote by ![\hat{\beta}\_{X}](https://latex.codecogs.com/png.latex?%5Chat%7B%5Cbeta%7D_%7BX%7D) the value of ![\beta](https://latex.codecogs.com/png.latex?%5Cbeta) estimated from that regression.
2. Denote by ![R^{2}\_{X,W\_{1}}](https://latex.codecogs.com/png.latex?R%5E%7B2%7D_%7BX%2CW_%7B1%7D%7D) the ![R^{2}](https://latex.codecogs.com/png.latex?R%5E%7B2%7D) from a regression of ![Y](https://latex.codecogs.com/png.latex?Y) on treatment and observed controls. Again, denote the estimated value of ![\beta](https://latex.codecogs.com/png.latex?%5Cbeta) from this regression as ![\hat{\beta}\_{X, W\_{1}}](https://latex.codecogs.com/png.latex?%5Chat%7B%5Cbeta%7D_%7BX%2C%20W_%7B1%7D%7D).

Under the assumption that the relative size of coefficients from a regression of ![Y](https://latex.codecogs.com/png.latex?Y) on ![X](https://latex.codecogs.com/png.latex?X) and observed variables are equal to those from a regression of ![X](https://latex.codecogs.com/png.latex?X) and the observed variables, Oster \(2019\) then shows that the true coefficient of interest \(![\beta](https://latex.codecogs.com/png.latex?%5Cbeta) from the full regression\) converges to the following:

![\beta^{\*} \approx \hat{\beta}\_{X,W\_{1}} - \delta \times \left\[\hat{\beta}\_{X} - \hat{\beta}\_{X,W\_{1}}\right\] \times \frac{R\_{max}^{2} - R\_{X,W\_{1}}^{2}}{R\_{X,W\_{1}}^{2} - R\_{X}^{2}} \xrightarrow{p} \beta.](https://latex.codecogs.com/png.latex?%5Cbeta%5E%7B%2A%7D%20%5Capprox%20%5Chat%7B%5Cbeta%7D_%7BX%2CW_%7B1%7D%7D%20-%20%5Cdelta%20%5Ctimes%20%5Cleft%5B%5Chat%7B%5Cbeta%7D_%7BX%7D%20-%20%5Chat%7B%5Cbeta%7D_%7BX%2CW_%7B1%7D%7D%5Cright%5D%20%5Ctimes%20%5Cfrac%7BR_%7Bmax%7D%5E%7B2%7D%20-%20R_%7BX%2CW_%7B1%7D%7D%5E%7B2%7D%7D%7BR_%7BX%2CW_%7B1%7D%7D%5E%7B2%7D%20-%20R_%7BX%7D%5E%7B2%7D%7D%20%5Cxrightarrow%7Bp%7D%20%5Cbeta.)

If we relax the assumption of equal “relative contributions” between the observed covariates and ![Y](https://latex.codecogs.com/png.latex?Y) versus the observed covariates and ![X](https://latex.codecogs.com/png.latex?X), then the results are a little more complicated. In that case, Oster \(2019\) shows that

![\beta^{\*} = \hat{\beta}\_{X,W\_{1}} - \nu\_{1} \xrightarrow{p} \beta,](https://latex.codecogs.com/png.latex?%5Cbeta%5E%7B%2A%7D%20%3D%20%5Chat%7B%5Cbeta%7D_%7BX%2CW_%7B1%7D%7D%20-%20%5Cnu_%7B1%7D%20%5Cxrightarrow%7Bp%7D%20%5Cbeta%2C)

or

![\beta^{\*} \in \left\{ \hat{\beta}\_{X,W\_{1}} - \nu\_{1}, \hat{\beta}\_{X,W\_{1}} - \nu\_{2}, \hat{\beta}\_{X,W\_{1}} - \nu\_{3} \right\},](https://latex.codecogs.com/png.latex?%5Cbeta%5E%7B%2A%7D%20%5Cin%20%5Cleft%5C%7B%20%5Chat%7B%5Cbeta%7D_%7BX%2CW_%7B1%7D%7D%20-%20%5Cnu_%7B1%7D%2C%20%5Chat%7B%5Cbeta%7D_%7BX%2CW_%7B1%7D%7D%20-%20%5Cnu_%7B2%7D%2C%20%5Chat%7B%5Cbeta%7D_%7BX%2CW_%7B1%7D%7D%20-%20%5Cnu_%7B3%7D%20%5Cright%5C%7D%2C)

where ![\nu\_{1}](https://latex.codecogs.com/png.latex?%5Cnu_%7B1%7D), ![\nu\_{2}](https://latex.codecogs.com/png.latex?%5Cnu_%7B2%7D), and ![\nu\_{3}](https://latex.codecogs.com/png.latex?%5Cnu_%7B3%7D) are roots of a cubic function, ![f\(\nu\)](https://latex.codecogs.com/png.latex?f%28%5Cnu%29), derived in the paper. In the case of more than one root, then one element of ![\beta^{\*}](https://latex.codecogs.com/png.latex?%5Cbeta%5E%7B%2A%7D) converges in probability to ![\beta](https://latex.codecogs.com/png.latex?%5Cbeta). If ![\delta=1](https://latex.codecogs.com/png.latex?%5Cdelta%3D1), then some additional simplifications can be made, but the point is that we now have an expression for the bias as a function of ![\delta](https://latex.codecogs.com/png.latex?%5Cdelta) and ![R^{2}\_{max}](https://latex.codecogs.com/png.latex?R%5E%7B2%7D_%7Bmax%7D).

So what do we gain from all of this? Well, Oster \(2019\) shows that we can also work backwards and find the value of ![\delta](https://latex.codecogs.com/png.latex?%5Cdelta) such that ![\beta=0](https://latex.codecogs.com/png.latex?%5Cbeta%3D0). In other words, say we estimate using OLS some effect, ![\hat{\beta}\_{X, W\_{1}}](https://latex.codecogs.com/png.latex?%5Chat%7B%5Cbeta%7D_%7BX%2C%20W_%7B1%7D%7D). How big must the role of selection on unobservables be in order to completely overpower our estimate such that the true effect is actually 0?

Another approach is to consider a range of ![R^{2}\_{max}](https://latex.codecogs.com/png.latex?R%5E%7B2%7D_%7Bmax%7D) and ![\delta](https://latex.codecogs.com/png.latex?%5Cdelta) to bound the estimated treatment effect. Using ![\delta=1](https://latex.codecogs.com/png.latex?%5Cdelta%3D1) as an upper bound for ![\delta](https://latex.codecogs.com/png.latex?%5Cdelta) \(i.e., observables are at least as important as the unobservables\), and ![\bar{R}^{2}\_{max}](https://latex.codecogs.com/png.latex?%5Cbar%7BR%7D%5E%7B2%7D_%7Bmax%7D) as an upper bound for ![R^{2}\_{max}](https://latex.codecogs.com/png.latex?R%5E%7B2%7D_%7Bmax%7D), then the bounds on ![\beta^{\*}](https://latex.codecogs.com/png.latex?%5Cbeta%5E%7B%2A%7D) are ![\left\[ \hat{\beta}\_{X,W\_{1}}, \beta^{\*}\(\bar{R}^{2}\_{max}, 1\) \right\]](https://latex.codecogs.com/png.latex?%5Cleft%5B%20%5Chat%7B%5Cbeta%7D_%7BX%2CW_%7B1%7D%7D%2C%20%5Cbeta%5E%7B%2A%7D%28%5Cbar%7BR%7D%5E%7B2%7D_%7Bmax%7D%2C%201%29%20%5Cright%5D).

Finally, Oster \(2019\) suggests setting ![\delta=1](https://latex.codecogs.com/png.latex?%5Cdelta%3D1) and identifying the value of ![R^{2}\_{max}](https://latex.codecogs.com/png.latex?R%5E%7B2%7D_%7Bmax%7D) for which ![\beta=0](https://latex.codecogs.com/png.latex?%5Cbeta%3D0). This would tell us how much of the variation in ![Y](https://latex.codecogs.com/png.latex?Y) would need to be explained by unobservables in order for the true effect to be null \(given our estimate, ![\hat{\beta}\_{X,W\_{1}}](https://latex.codecogs.com/png.latex?%5Chat%7B%5Cbeta%7D_%7BX%2CW_%7B1%7D%7D).

There is also a Stata command, `psacalc`, to do these calculations for us \(if you’re a Stata user\).

## Cinelli and Hazlett 2020

Cinelli and Hazlett \(2020\) offers a more general approach that does not require functional form assumptions on treatment assignment or on the distribution of unobserved confounders. The intuition of their approach is similar, but I see it as more general than Oster \(2019\) and others. That said, one sensitivity measure proposed in Cinelli and Hazlett \(2020\) requires users to impose some form of a “baseline” covariate in order to gauge relative strength of omitted variables. Once such a variable is specified, we can consider how big confounding must be relative to this relationship estimated from your data. You have to say what this “other relationship” is. And I’m not entirely clearly how this measure works if this estimated relationship is itself subject to endogeneity concerns.

Nonetheless, they also have a program to implement their analysis in both Stata and R, [sensemakr](https://github.com/carloscinelli/sensemakr).

## References

Altonji, Joseph G, Todd E Elder, and Christopher R Taber. 2005. “An Evaluation of Instrumental Variable Strategies for Estimating the Effects of Catholic Schooling.” _Journal of Human Resources_ 40 \(4\): 791–821.

Cinelli, Carlos, and Chad Hazlett. 2020. “Making Sense of Sensitivity: Extending Omitted Variable Bias.” _Journal of the Royal Statistical Society: Series B \(Statistical Methodology\)_ 82 \(1\): 39–67.

Oster, Emily. 2019. “Unobservable Selection and Coefficient Stability: Theory and Evidence.” _Journal of Business & Economic Statistics_ 37 \(2\): 187–204. [https://doi.org/10.1080/07350015.2016.1227711](https://doi.org/10.1080/07350015.2016.1227711).

