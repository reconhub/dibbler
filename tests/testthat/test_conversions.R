context("Test conversions")


test_that("test: network <-> igraph", {
    ## skip on CRAN
    skip_on_cran()
    rm(list=ls())

    ## generate data
    set.seed(1)
    g0 <- igraph::sample_pa_age(10, pa.exp=1, aging.exp=0, aging.bin=1000)
    n1 <- igraph2network(g0)
    g1 <- network2igraph(n1)
    vis1 <- igraph2visNetwork(g1)
    vis2 <- network2visNetwork(n1)
    
    
    ## check classes
    expect_is(n1,"network")
    expect_is(g1,"igraph")
    expect_is(vis1,"list")
    expect_is(vis2,"list")
    expect_equal(length(vis1), 2)
    expect_equal(length(vis2), 2)
    expect_equal(names(vis1), c("nodes","edges"))
    expect_equal(names(vis2), c("nodes","edges"))

    ## compare edge lists
    n1.vec <- sort(apply(network2data.frame(n1),1,paste, collapse="->"))
    g1.vec <- sort(apply(igraph2data.frame(g1),1,paste, collapse="->"))
    vis1.vec <- sort(apply(vis1$edges, 1, paste, collapse="->"))
    vis2.vec <- sort(apply(vis2$edges, 1, paste, collapse="->"))
    
    names(n1.vec) <- names(g1.vec) <- names(vis1.vec) <- names(vis2.vec) <- NULL
    expect_identical(g1.vec, n1.vec)
    expect_identical(g1.vec,vis2.vec)
    expect_identical(vis1.vec,vis2.vec)
    
})

