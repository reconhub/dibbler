context("test internal functions")


test_that("test: network <-> igraph", {
    ## skip on CRAN
    skip_on_cran()
    rm(list=ls())

    expect_error(dibbler:::modify.defaults(list(toto=1), list(toto=1, tata=2)))

})
