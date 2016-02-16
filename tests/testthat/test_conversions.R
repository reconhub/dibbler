context("Test conversions")


## test data ##
test_that("test: network <-> igraph", {
    ## skip on CRAN
    skip_on_cran()
    rm(list=ls())

    ## generate data
    set.seed(1)
    g0 <- igraph::sample_pa_age(10, pa.exp=1, aging.exp=0, aging.bin=1000)
    n1 <- igraph2network(g0)
    g1 <- network2igraph(n1)

    ## check classes
    expect_is(n1,"network")
    expect_is(g1,"igraph")

    ## compare edge lists
    n1.vec <- sort(apply(network2data.frame(n1),1,paste, collapse="->"))
    g1.vec <- sort(apply(igraph2data.frame(g1),1,paste, collapse="->"))
    names(n1.vec) <- names(g1.vec) <- NULL
    expect_identical(g1.vec, n1.vec)
})

