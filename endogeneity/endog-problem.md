---
title: "How big is the problem?"
date: '2021-08-12'
output: 
  html_document:
    keep_md: TRUE
    toc: TRUE
    toc_depth: 3
    pandoc_args: --webtex
bibliography: '../BibTeX_Library.bib'
math: true
---



It would be great if we could test for whether we really had an endogeneity problem or not. But alas, that's just not in the cards. Instead, a good starting point is to see "how much" of an endogeneity problem we'd have to have to overturn our current results. There are several papers in this area. Here, I'll mention just two that also have supporting Stata or R code. Those papers are [Oster 2019](#oster) and [Cinelli and Hazlett 2020](#cinelli).

In both cases, the idea is as follows... Lots of applied researchers assess "coefficient stability" by including different sets of control variables that are intended to proxy for some potentially important unobserved factor. This is not informative of omitted variables bias if the existing controls already do a very poor job of explaining the outcome. As Prof. Oster notes, "Omitted variable bias is proportional to coefficient movements, but only if such movements are scaled by the change in R-squared when controls are included."


# Oster 2019 {#oster}

Extending the work of @altonji2005, @oster2019 lays out a scenario in which we can fully decompose our outcome of interest into a treatment effect (denoted $\beta$), observed controls (denoted by $W_{1}$), unobserved controls (denoted by $W_{2}$), and some iid error term. Denote by $X$ the treatment variable, such that $$Y = \beta X + W_{1} + W_{2} + \epsilon.$$ We then need to consider values (or a range of values) for two key objects. 

1. What is the maximum $R^2$ value we could obtain if we observed $W_{2}$? Let's call this $R_{\text{max}}^{2}$. If we think the outcome is fully deterministic if we were to observe all relevant variables, then $R_{\text{max}}^{2}=1$, but we could consider smaller values as well.

2. What is the degree of selection on observed variables relative to unobserved variables? We can denote this value as $\delta$, and define $\delta$ as the value such that: $$\delta \times \frac{Cov(W_{1},X)}{Var(W_{1})} = \frac{Cov(W_{2},X)}{Var(W_{2})}.$$

We then need to define a few objects that we can directly estimate with the data:

1. Denote by $R^{2}_{X}$ the $R^{2}$ from a regression of $Y$ on treatment (and only treatment, no covariates). Similarly denote by $\hat{\beta}_{X}$ the value of $\beta$ estimated from that regression. 

2. Denote by $R^{2}_{X,W_{1}}$ the $R^{2}$ from a regression of $Y$ on treatment and observed controls. Again, denote the estimated value of $\beta$ from this regression as $\hat{\beta}_{X, W_{1}}$. 

Under the assumption that the relative size of coefficients from a regression of $Y$ on $X$ and observed variables are equal to those from a regression of $X$ and the observed variables, @oster2019 then shows that the true coefficient of interest ($\beta$ from the full regression) converges to the following:

$$\beta^{*} \approx \hat{\beta}_{X,W_{1}} - \delta \times \left[\hat{\beta}_{X} - \hat{\beta}_{X,W_{1}}\right] \times \frac{R_{max}^{2} - R_{X,W_{1}}^{2}}{R_{X,W_{1}}^{2} - R_{X}^{2}} \xrightarrow{p} \beta.$$

If we relax the assumption of equal "relative contributions" between the observed covariates and $Y$ versus the observed covariates and $X$, then the results are a little more complicated. In that case, @oster2019 shows that $$\beta^{*} = \hat{\beta}_{X,W_{1}} - \nu_{1} \xrightarrow{p} \beta,$$ or $$\beta^{*} \in \left\{ \hat{\beta}_{X,W_{1}} - \nu_{1}, \hat{\beta}_{X,W_{1}} - \nu_{2}, \hat{\beta}_{X,W_{1}} - \nu_{3} \right\},$$
where $\nu_{1}$, $\nu_{2}$, and $\nu_{3}$ are roots of a cubic function, $f(\nu)$, derived in the paper. In the case of more than one root, then one element of $\beta^{*}$ converges in probability to $\beta$. If $\delta=1$, then some additional simplifications can be made, but the point is that we now have an expression for the bias as a function of $\delta$ and $R^{2}_{max}$. 

So what do we gain from all of this? Well, @oster2019 shows that we can also work backwards and find the value of $\delta$ such that $\beta=0$. In other words, say we estimate using OLS some effect, $\hat{\beta}_{X, W_{1}}$. How big must the role of selection on unobservables be in order to completely overpower our estimate such that the true effect is actually 0? 

Another approach is to consider a range of $R^{2}_{max}$ and $\delta$ to bound the estimated treatment effect. Using $\delta=1$ as an upper bound for $\delta$ (i.e., observables are at least as important as the unobservables), and $\bar{R}^{2}_{max}$ as an upper bound for $R^{2}_{max}$, then the bounds on $\beta^{*}$ are $\left[ \hat{\beta}_{X,W_{1}}, \beta^{*}(\bar{R}^{2}_{max}, 1) \right]$.

Finally, @oster2019 suggests setting $\delta=1$ and identifying the value of $R^{2}_{max}$ for which $\beta=0$. This would tell us how much of the variation in $Y$ would need to be explained by unobservables in order for the true effect to be null (given our estimate, $\hat{\beta}_{X,W_{1}}$.

There is also a Stata command, `psacalc`, to do these calculations for us (if you're a Stata user). 

# Cinelli and Hazlett 2020 {#cinelli}

@cinelli2020 offers a more general approach that does not require functional form assumptions on treatment assignment or on the distribution of unobserved confounders. The intuition of their approach is similar, but I see it as more general than @oster2019 and others. That said, one sensitivity measure proposed in @cinelli2020 requires users to impose some form of a "baseline" covariate in order to gauge relative strength of omitted variables. Once such a variable is specified, we can consider how big confounding must be relative to this relationship estimated from your data. You have to say what this "other relationship" is. And I'm not entirely clearly how this measure works if this estimated relationship is itself subject to endogeneity concerns. 

Nonetheless, they also have a program to implement their analysis in both Stata and R, [sensemakr](https://github.com/carloscinelli/sensemakr).


# References
