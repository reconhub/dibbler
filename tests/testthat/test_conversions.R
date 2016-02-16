context("Test conversions")


## test data ##
test_that("test: network <-> igraph", {
    ## skip on CRAN
    skip_on_cran()
    rm(list=ls())

    ## generate data
    set.seed(1)
    g1 <- sample_pa_age(10, pa.exp=1, aging.exp=0, aging.bin=1000)
    g1 <- graph.data.frame(as_data_frame(g1)) # need to ensure sorting
    
    net <- igraph2network(g1)
    g2 <- network2igraph(net)
    
    ## check output shape
    
    ## check attributes

    ## round trip

})

