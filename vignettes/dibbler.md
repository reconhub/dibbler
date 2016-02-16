---
title: "Investigation of food-borne disease outbreaks"
author: "Thibaut Jombart"
date: "2016-02-16"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteEngine{rmarkdown::render}
  %\VignetteIndexEntry{Investigation of food-borne disease outbreaks.}
  \usepackage[utf8]{inputenc}
---



*dibbler*: Investigation of food-borne disease outbreaks.

=================================================
*dibbler* provides tools for investigating food-borne outbreaks with (at least partly) known food distribution networks, and genetic information on the cases.
This document provides an overview of the package's content.


Installing *dibbler*
-------------
To install the development version from github:

```r
library(devtools)
install_github("thibautjombart/dibbler")
```

The stable version can be installed from CRAN using:

```r
install.packages("dibbler")
```

Then, to load the package, use:

```r
library("dibbler")
```


A short demo
------------------
Here is a short demonstration of the package using a dummy dataset.


```r
library(igraph)
library(dibbler)

## GENERATE DATA
set.seed(1)
g1 <- make_tree(20, 3)

## need this hack for named vertices
temp <- data.frame(lapply(
igraph2data.frame(g1), as.character),
stringsAsFactors=FALSE)
g1 <- graph.data.frame(temp)

## find times
tips <- which(degree(g1, mode="out")==0)
grp <- factor(sample(letters[1:4], replace=TRUE, size=length(tips)))
names(grp) <- tips


## RUN DIBBLER
out <- dibbler(dibbler.data(g1, grp))
```

Checking and plotting the output:

```r
plot(out$graph, vertex.label="")
```

![plot of chunk dibbler](figs/dibbler-1.png)


