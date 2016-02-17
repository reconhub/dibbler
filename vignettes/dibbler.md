---
title: "Investigation of food-borne disease outbreaks"
author: "Thibaut Jombart"
date: "2016-02-17"
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
Here is a short demonstration of the package using an anonymised Salmonella outbreak dataset.

All we need to run the method is:
1. a directed graph representing the **food network**, which can be provided as:
  - a `data.frame` with two columns (to,from)
  - a `igraph` object
  - a `network` object
2. a `factor` defining groups for some of the nodes of the network; this `factor` needs to be named, and the labels provided will be matched against the network.

Here, all this information is contained in the *Salmonella* dataset:

```r
names(Salmonella)
```

```
## [1] "graph"   "cluster"
```

```r
head(Salmonella$graph)
```

```
##     from     to
## 1 2e7967 dd73b6
## 2 2e7967 c7cd02
## 3 2e7967 2afba4
## 4 2e7967 4df851
## 5 2e7967 48f980
## 6 2e7967 2d3187
```

```r
Salmonella$cluster
```

```
## d81c17 064974 3b712b 486c07 6f5824 c77a84 1f4d22 f951d8 44060b 905296 
##      A      A      A      A      A      A      A      A      A      A 
## b4e5d5 0fffca 78e5ba e45c54 ca432a 0b6e5a ef7028 732379 82b4fc 9199be 
##      A      B      B      B      B      B      B      B      B      B 
## cede47 9f5aad acf7bb 24876f 37aad9 1e7431 0b57e4 09f4a0 a6fcaf f59e4b 
##      B      C      C      C      C      C      C      C      C      C 
## 1b55d2 7d3df0 b08945 f80b2e efee6b 6e0643 252679 35a9b6 80afad 1569a5 
##      C      C      A      A      A      A      A      A      A      A 
## 161814 c09e12 38881f 
##      A      A      A 
## Levels: A B C
```

We build a `igraph` object from the list of edges:

```r
library(igraph)
g <- graph.data.frame(Salmonella$graph)
g
```

```
## IGRAPH DN-- 98 103 -- 
## + attr: name (v/c)
## + edges (vertex names):
##  [1] 2e7967->dd73b6 2e7967->c7cd02 2e7967->2afba4 2e7967->4df851
##  [5] 2e7967->48f980 2e7967->2d3187 cd48bf->e42c72 cd48bf->7d21f1
##  [9] dd73b6->874918 7ba446->f83f2e 642cb4->327734 c7cd02->337cac
## [13] 5b44d7->f7fc94 5b44d7->2fabc7 2afba4->5b44d7 2afba4->c1dc98
## [17] 2afba4->b16cf0 2afba4->206e37 2afba4->958de8 fc7f8f->dd73b6
## [21] 963c41->acf7bb 963c41->9f5aad f60e85->4941c6 4941c6->0b57e4
## [25] 53d0b4->c7cd02 13dc78->0b6e5a 13dc78->78e5ba 13dc78->ca432a
## [29] 13dc78->e45c54 9c0e59->80afad 6ddfa3->a7a903 3301f4->7ba446
## + ... omitted several edges
```

We can now run `dibbler` on the data, and examine the output:

```r
out <- dibbler(dibbler.data(graph=g, group=Salmonella$cluster))
names(out)
```

```
## [1] "freq"  "conf"  "graph"
```

```r
head(out$freq)
```

```
## $`2e7967`
## 
##      A      B      C 
## 0.5833 0.2083 0.2083 
## 
## $cd48bf
## 
##      A      B      C 
## 0.6667 0.1111 0.2222 
## 
## $dd73b6
## 
## A B C 
## 0 1 0 
## 
## $`7ba446`
## 
## A B C 
## 0 0 1 
## 
## $`642cb4`
## 
## A B C 
## 1 0 0 
## 
## $c7cd02
## 
## A B C 
## 1 0 0
```

```r
head(out$conf)
```

```
## 2e7967 cd48bf dd73b6 7ba446 642cb4 c7cd02 
## 0.4706 0.5000 0.6667 0.3333 0.3333 0.5000
```

```r
out$graph
```

```
## IGRAPH DN-- 98 103 -- 
## + attr: layout (g/n), name (v/c), shape (v/c), pie (v/x),
## | pie.color (v/x), size (v/n), label.family (v/c), label.color
## | (v/c)
## + edges (vertex names):
##  [1] 2e7967->dd73b6 2e7967->c7cd02 2e7967->2afba4 2e7967->4df851
##  [5] 2e7967->48f980 2e7967->2d3187 cd48bf->e42c72 cd48bf->7d21f1
##  [9] dd73b6->874918 7ba446->f83f2e 642cb4->327734 c7cd02->337cac
## [13] 5b44d7->f7fc94 5b44d7->2fabc7 2afba4->5b44d7 2afba4->c1dc98
## [17] 2afba4->b16cf0 2afba4->206e37 2afba4->958de8 fc7f8f->dd73b6
## [21] 963c41->acf7bb 963c41->9f5aad f60e85->4941c6 4941c6->0b57e4
## + ... omitted several edges
```

```r
plot(out$graph, vertex.label="")
```

![plot of chunk dibbler](figs/dibbler-1.png)

The output items are:
- `$freq`: a list containing vectors of estimated cluster frequencies for each internal node of the graph
- `$conf`: a vector containing confidence indices for the estimates at each node; these are defined as the proportion of terminal nodes in the tree spanning from the node.
- `$graph`: an `igraph` object containing the above information in addition to the original network



