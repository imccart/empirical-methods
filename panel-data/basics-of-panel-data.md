What is Panel Data?
===================

Panel data describes the setting in which we have repeated observations
over time for the same units (e.g., people, firms, counties, etc.). Such
data often present an opportunity to estimate causal effects more
convincingly than in a purely cross-sectional setting, although that’s
certainly not always the case. I’d much rather read a strong analysis of
“lesser” data than a poor analysis of “better” data. But all else equal,
panel data tend to contain more information and more dimensions of
variation than we see in cross-sectional data, and thus more
opportunities for causal inference.

Slightly more formally, we observe some outcome
![y](https://latex.codecogs.com/png.latex?y "y") for units
![i=1,...,N](https://latex.codecogs.com/png.latex?i%3D1%2C...%2CN "i=1,...,N")
and over time period
![t=1,...,T](https://latex.codecogs.com/png.latex?t%3D1%2C...%2CT "t=1,...,T").
We denote the outcome for a given unit and time by
![y\_{it}](https://latex.codecogs.com/png.latex?y_%7Bit%7D "y_{it}").

Presentations
=============

Below are some presentations I’ve made in different settings. These more
or less repeat the information above but in a presentation format (more
figures, fewer words).

-   <a href="https://imccart.github.io/empirical-methods/panel-data/slides/intro-cdc202108.html">CDC
    Workshop, August 2021</a>

Code Files
==========

What good is a discussion of data and econometrics without some
practice?! Here are some very basic code files to implement the
estimators described above.

-   [Stata Code](code/Stata-panel.do)
-   [R Code](code/R-panel.R)

References
==========
