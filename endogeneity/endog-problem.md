It would be great if we could test for whether we really had an
endogeneity problem or not. But alas, that’s just not in the cards.
Instead, a good starting point is to see “how much” of an endogeneity
problem we’d have to have to overturn our current results. There are
several papers in this area. Here, I’ll mention just two that also have
supporting Stata or R code. Those papers are [Oster 2019](#oster) and
[Cinelli and Hazlett 2020](#cinelli).

In both cases, the idea is as follows… Lots of applied researchers
assess “coefficient stability” by including different sets of control
variables that are intended to proxy for some potentially important
unobserved factor. This is not informative of omitted variables bias if
the existing controls already do a very poor job of explaining the
outcome. As Prof. Oster notes, “Omitted variable bias is proportional to
coefficient movements, but only if such movements are scaled by the
change in R-squared when controls are included.”

Oster 2019
==========

Extending the work of Altonji, Elder, and Taber (2005), Oster (2019)
lays out a scenario in which we can fully decompose our outcome of
interest into a treatment effect (denoted *β*), observed controls
(denoted by *W*<sub>1</sub>), unobserved controls (denoted by
*W*<sub>2</sub>), and some iid error term. Denote by *X* the treatment
variable, such that
*Y* = *β**X* + *W*<sub>1</sub> + *W*<sub>2</sub> + *ϵ*.
We then need to consider values (or a range of values) for two key
objects.

1.  What is the maximum *R*<sup>2</sup> value we could obtain if we
    observed *W*<sub>2</sub>? Let’s call this
    *R*<sub>max</sub><sup>2</sup>. If we think the outcome is fully
    deterministic if we were to observe all relevant variables, then
    *R*<sub>max</sub><sup>2</sup> = 1, but we could consider smaller
    values as well.

2.  What is the degree of selection on observed variables relative to
    unobserved variables? We can denote this value as *δ*, and define
    *δ* as the value such that:
    $$\\delta \\times \\frac{Cov(W\_{1},X)}{Var(W\_{1})} = \\frac{Cov(W\_{2},X)}{Var(W\_{2})}.$$

We then need to define a few objects that we can directly estimate with
the data:

1.  Denote by *R*<sub>*X*</sub><sup>2</sup> the *R*<sup>2</sup> from a
    regression of *Y* on treatment (and only treatment, no covariates).
    Similarly denote by *β̂*<sub>*X*</sub> the value of *β* estimated
    from that regression.

2.  Denote by *R*<sub>*X*, *W*<sub>1</sub></sub><sup>2</sup> the
    *R*<sup>2</sup> from a regression of *Y* on treatment and observed
    controls. Again, denote the estimated value of *β* from this
    regression as *β̂*<sub>*X*, *W*<sub>1</sub></sub>.

Under the assumption that the relative size of coefficients from a
regression of *Y* on *X* and observed variables are equal to those from
a regression of *X* and the observed variables, Oster (2019) then shows
that the true coefficient of interest (*β* from the full regression)
converges to the following:

$$\\beta^{\*} \\approx \\hat{\\beta}\_{X,W\_{1}} - \\delta \\times \\left\[\\hat{\\beta}\_{X} - \\hat{\\beta}\_{X,W\_{1}}\\right\] \\times \\frac{R\_{max}^{2} - R\_{X,W\_{1}}^{2}}{R\_{X,W\_{1}}^{2} - R\_{X}^{2}} \\xrightarrow{p} \\beta.$$

If we relax the assumption of equal “relative contributions” between the
observed covariates and *Y* versus the observed covariates and *X*, then
the results are a little more complicated. In that case, Oster (2019)
shows that
$$\\beta^{\*} = \\hat{\\beta}\_{X,W\_{1}} - \\nu\_{1} \\xrightarrow{p} \\beta,$$
or
*β*<sup>\*</sup> ∈ {*β̂*<sub>*X*, *W*<sub>1</sub></sub>−*ν*<sub>1</sub>,*β̂*<sub>*X*, *W*<sub>1</sub></sub>−*ν*<sub>2</sub>,*β̂*<sub>*X*, *W*<sub>1</sub></sub>−*ν*<sub>3</sub>},
where *ν*<sub>1</sub>, *ν*<sub>2</sub>, and *ν*<sub>3</sub> are roots of
a cubic function, *f*(*ν*), derived in the paper. In the case of more
than one root, then one element of *β*<sup>\*</sup> converges in
probability to *β*. If *δ* = 1, then some additional simplifications can
be made, but the point is that we now have an expression for the bias as
a function of *δ* and *R*<sub>*m**a**x*</sub><sup>2</sup>.

So what do we gain from all of this? Well, Oster (2019) shows that we
can also work backwards and find the value of *δ* such that *β* = 0. In
other words, say we estimate using OLS some effect,
*β̂*<sub>*X*, *W*<sub>1</sub></sub>. How big must the role of selection
on unobservables be in order to completely overpower our estimate such
that the true effect is actually 0?

Another approach is to consider a range of
*R*<sub>*m**a**x*</sub><sup>2</sup> and *δ* to bound the estimated
treatment effect. Using *δ* = 1 as an upper bound for *δ* (i.e.,
observables are at least as important as the unobservables), and
*R̄*<sub>*m**a**x*</sub><sup>2</sup> as an upper bound for
*R*<sub>*m**a**x*</sub><sup>2</sup>, then the bounds on *β*<sup>\*</sup>
are
\[*β̂*<sub>*X*, *W*<sub>1</sub></sub>,*β*<sup>\*</sup>(*R̄*<sub>*m**a**x*</sub><sup>2</sup>,1)\].

Finally, Oster (2019) suggests setting *δ* = 1 and identifying the value
of *R*<sub>*m**a**x*</sub><sup>2</sup> for which *β* = 0. This would
tell us how much of the variation in *Y* would need to be explained by
unobservables in order for the true effect to be null (given our
estimate, *β̂*<sub>*X*, *W*<sub>1</sub></sub>.

There is also a Stata command, `psacalc`, to do these calculations for
us (if you’re a Stata user).

Cinelli and Hazlett 2020
========================

Cinelli and Hazlett (2020) offers a more general approach that does not
require functional form assumptions on treatment assignment or on the
distribution of unobserved confounders. The intuition of their approach
is similar, but I see it as more general than Oster (2019) and others.
That said, one sensitivity measure proposed in Cinelli and Hazlett
(2020) requires users to impose some form of a “baseline” covariate in
order to gauge relative strength of omitted variables. Once such a
variable is specified, we can consider how big confounding must be
relative to this relationship estimated from your data. You have to say
what this “other relationship” is. And I’m not entirely clearly how this
measure works if this estimated relationship is itself subject to
endogeneity concerns.

Nonetheless, they also have a program to implement their analysis in
both Stata and R,
[sensemakr](https://github.com/carloscinelli/sensemakr).

References
==========

Altonji, Joseph G, Todd E Elder, and Christopher R Taber. 2005. “An
Evaluation of Instrumental Variable Strategies for Estimating the
Effects of Catholic Schooling.” *Journal of Human Resources* 40 (4):
791–821.

Cinelli, Carlos, and Chad Hazlett. 2020. “Making Sense of Sensitivity:
Extending Omitted Variable Bias.” *Journal of the Royal Statistical
Society: Series B (Statistical Methodology)* 82 (1): 39–67.

Oster, Emily. 2019. “Unobservable Selection and Coefficient Stability:
Theory and Evidence.” *Journal of Business & Economic Statistics* 37
(2): 187–204. <https://doi.org/10.1080/07350015.2016.1227711>.
