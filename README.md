[![Travis-CI Build Status](https://travis-ci.org/thibautjombart/dibbler.png?branch=master)](https://travis-ci.org/thibautjombart/dibbler)

[![codecov.io](https://codecov.io/github/thibautjombart/dibbler/coverage.svg?branch=master)](https://codecov.io/github/thibautjombart/dibbler?branch=master)





*dibbler*: investigation of food-borne disease outbreaks
========================================================

> *And then you bit onto them, and learned once again that Cut-me-own-Throat
>   Dibbler could find a use for bits of an animal that the animal didn't know
>   it had got. Dibbler had worked out that with enough fried onions and mustard
>   people would eat anything.* [Terry Pratchett, Moving Pictures.]

*dibbler* provides tools for investigating food-borne outbreaks with (at least
partly) known food distribution networks, and genetic information on the cases.
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
------------

Here is a short demonstration of the package using an anonymised Salmonella
outbreak dataset, distributed in the *outbreaks* package as
`s_enteritidis_pt59`. The function `make_dibbler` will match the structure of
the network and the case data, and create a `dibbler` object:

```r
names(s_enteritidis_pt59$graph)
```

```
## [1] "from" "to"
```

```r
head(s_enteritidis_pt59$graph)
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
dim(s_enteritidis_pt59$graph)
```

```
## [1] 103   2
```

```r
s_enteritidis_pt59$cluster
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

```r
case_data <- with(s_enteritidis_pt59, 
                  data.frame(id = names(cluster), cluster = cluster))
head(case_data)
```

```
##            id cluster
## d81c17 d81c17       A
## 064974 064974       A
## 3b712b 3b712b       A
## 486c07 486c07       A
## 6f5824 6f5824       A
## c77a84 c77a84       A
```

```r
x <- make_dibbler(net = s_enteritidis_pt59$graph, nodes_data = case_data)
x
```

```
## 
## /// Foodborne outbreak //
## 
##   // class: dibbler, epicontacts
##   // 43 cases in linelist; 103 edges;  directed 
## 
##   // linelist
## 
##            id cluster
## d81c17 d81c17       A
## 064974 064974       A
## 3b712b 3b712b       A
## 486c07 486c07       A
## 6f5824 6f5824       A
## c77a84 c77a84       A
## 
##   // network
## 
##     from     to
## 1 2e7967 dd73b6
## 2 2e7967 c7cd02
## 3 2e7967 2afba4
## 4 2e7967 4df851
## 5 2e7967 48f980
## 6 2e7967 2d3187
## 
##  // node types
##     2e7967     cd48bf     dd73b6     7ba446     642cb4     c7cd02 
##    "entry" "internal" "internal" "internal" "internal" "internal" 
##     5b44d7     2afba4     fc7f8f     963c41     f60e85     4941c6 
## "internal" "internal"    "entry" "internal" "internal" "internal" 
##     53d0b4     13dc78     9c0e59     6ddfa3     3301f4     874918 
##    "entry" "internal" "internal" "internal"    "entry" "internal" 
##     f46d1e     0b6e5a     c190fa     337cac     03eee3     c1dc98 
## "internal" "internal"    "entry" "internal" "internal" "internal" 
##     a7a903     d2d08f     030327     6d4b91     76a432     7fa3b1 
## "internal"    "entry" "internal" "internal" "internal" "internal" 
##     f83f2e     881955     e42c72     4df851     d4d75e     7be343 
## "internal" "internal" "internal" "internal" "internal" "internal" 
##     735807     238842     3e93ce     f7fc94     8e02f0     b16cf0 
## "internal"    "entry" "internal" "internal" "internal" "internal" 
##     51ca98     81e071     dc72e8     4e2918     2fabc7     ad208a 
## "internal" "internal" "internal" "internal" "internal" "internal" 
##     48f980     24dba7     327734     4e8dc8     206e37     958de8 
## "internal" "internal" "internal" "internal" "internal" "internal" 
##     2d3187     7d21f1     acf7bb     9f5aad     0b57e4     78e5ba 
## "internal" "internal" "terminal" "terminal" "terminal" "terminal" 
##     ca432a     e45c54     80afad     cede47     82b4fc     732379 
## "terminal" "terminal" "terminal" "terminal" "terminal" "terminal" 
##     9199be     7d3df0     c77a84     6f5824     3b712b     1e7431 
## "terminal" "terminal" "terminal" "terminal" "terminal" "terminal" 
##     37aad9     44060b     905296     f951d8     b4e5d5     1b55d2 
## "terminal" "terminal" "terminal" "terminal" "terminal" "terminal" 
##     a6fcaf     24876f     0fffca     09f4a0     38881f     d81c17 
## "terminal" "terminal" "terminal" "terminal" "terminal" "terminal" 
##     1569a5     064974     161814     c09e12     b08945     f80b2e 
## "terminal" "terminal" "terminal" "terminal" "terminal" "terminal" 
##     35a9b6     6e0643     efee6b     252679     f59e4b     ef7028 
## "terminal" "terminal" "terminal" "terminal" "terminal" "terminal" 
##     1f4d22     486c07 
## "terminal" "terminal"
```


The resulting object is an extension of `epicontact` objects; for more
information on these objects, and how to handle them, see the [*epicontacts*
website](http://www.repidemicsconsortium.org/epicontacts/).

Here we plot the object, asking to use `"cluster"` to define colored groups:


```r
plot(x, "cluster")
```

<img src="https://github.com/reconhub/dibbler/raw/master/figs/plot_x.png" width="600px">

This is a screenshot of the actual image, which needs to be visualised on a web broswer.
Groups are indicated in colors, while different types of nodes are indicated with different symbols:

- *entry nodes*: 'origins' of the network, indicated by targets; typically farms

- *internal nodes*: nodes located inside the network, indicated as buildings;
   typically factories or restaurants; note that if the network indicates
   person-to-person transmission, then internal nodes could be cases as well

- *terminal nodes*: nodes located at the periphery of the network, indicated as
   people; typically cases


