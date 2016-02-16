[![Travis-CI Build Status](https://travis-ci.org/thibautjombart/dibbler.png?branch=master)](https://travis-ci.org/thibautjombart/dibbler)

[![codecov.io](https://codecov.io/github/thibautjombart/dibbler/coverage.svg?branch=master)](https://codecov.io/github/thibautjombart/dibbler?branch=master)




```
## Error in parse_block(g[-1], g[1], params.src): duplicate label 'load'
```


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

