What is TWFE?
=============

Two-way fixed effects (TWFE) is essentially just a shorthand for a
specific and very common regression specification that includes fixed
effects for units
![i=1,...,N](https://latex.codecogs.com/png.latex?i%3D1%2C...%2CN "i=1,...,N")
and time
![t=1,...,T](https://latex.codecogs.com/png.latex?t%3D1%2C...%2CT "t=1,...,T").
I’ll denote these by
![\\gamma\_{i}](https://latex.codecogs.com/png.latex?%5Cgamma_%7Bi%7D "\gamma_{i}")
and
![\\gamma\_{t}](https://latex.codecogs.com/png.latex?%5Cgamma_%7Bt%7D "\gamma_{t}"),
respectively. TWFE is more general than a 2x2 DD specification because
it allows for intercept shifts for each units and for each time period,
as opposed to shifts only among each treated/control group and
treated/control period. However, this extra generality doesn’t really do
much in the case of a single treated group and a single treatment time,
since the overall group and overall treatment period dummies in the 2x2
case are effectively an average of the individual unit and individual
time period fixed effects, respectively.

More formally, recall our original DD regression specification,<br>
![y\_{it} = \\alpha + \\beta \\times 1(Post) + \\lambda \\times 1(Treat) + \\delta \\times 1(Post) \\times 1(Treat) + \\varepsilon](https://latex.codecogs.com/png.latex?y_%7Bit%7D%20%3D%20%5Calpha%20%2B%20%5Cbeta%20%5Ctimes%201%28Post%29%20%2B%20%5Clambda%20%5Ctimes%201%28Treat%29%20%2B%20%5Cdelta%20%5Ctimes%201%28Post%29%20%5Ctimes%201%28Treat%29%20%2B%20%5Cvarepsilon "y_{it} = \alpha + \beta \times 1(Post) + \lambda \times 1(Treat) + \delta \times 1(Post) \times 1(Treat) + \varepsilon").
Here, we have a single treated group and a single treatment time, so we
capture treatment time with a post-period indicator, treated group with
a treatment indicator, and the interaction between the two variables is
our treatment effect of interest. But we can generalize this to allow
for dummies for each unit (rather than treated/control group) and
similarly for each time period (rather than pre/post groups). This
doesn’t change our treatment effect estimates, but it is “more
efficient” (standard errors are going to be smaller). Doing so yields
the following regression specification:

![y\_{it} = \\alpha + \\delta D\_{it} + \\gamma\_{i} + \\gamma\_{t} + \\varepsilon,](https://latex.codecogs.com/png.latex?y_%7Bit%7D%20%3D%20%5Calpha%20%2B%20%5Cdelta%20D_%7Bit%7D%20%2B%20%5Cgamma_%7Bi%7D%20%2B%20%5Cgamma_%7Bt%7D%20%2B%20%5Cvarepsilon%2C "y_{it} = \alpha + \delta D_{it} + \gamma_{i} + \gamma_{t} + \varepsilon,")

<br> where
![\\gamma\_{i}](https://latex.codecogs.com/png.latex?%5Cgamma_%7Bi%7D "\gamma_{i}")
and
![\\gamma\_{t}](https://latex.codecogs.com/png.latex?%5Cgamma_%7Bt%7D "\gamma_{t}")
denote a set of unit ![i](https://latex.codecogs.com/png.latex?i "i")
and time period ![t](https://latex.codecogs.com/png.latex?t "t") dummy
variables (or fixed effects), and where
![\\delta](https://latex.codecogs.com/png.latex?%5Cdelta "\delta")
captures our treatment effect of interest just as before.

Terminology
===========

What are we estimating?
=======================

Presentations
=============

Below are some presentations I’ve made in different settings. These more
or less repeat the information above but in a presentation format (more
figures, fewer words).

<a href="https://imccart.github.io/empirical-methods/panel-data/slides/twfe-cdc202108.html">CDC
Workshop, August 2021</a>

Code Files
==========

What good is a discussion of data and econometrics without some
practice?! Here are some very basic code files to implement the
estimators described above.

-   [Stata Code](code/Stata-event.do)
-   [R Code](code/R-event.R)

References
==========
