context("test visNetwork functions")


test_that("test: network <-> igraph", {
    ## skip on CRAN
    skip_on_cran()
    rm(list=ls())

    ## get data
    g <- igraph::graph.data.frame(Salmonella$graph)
    input <- dibbler.data(graph=g, group=Salmonella$cluster)
    out.list <- vis.dibbler.data(input, plot=FALSE)
    out.vis <- vis.dibbler.data(input)
    
    ## checks
    expect_is(out.list, "list")
    expect_is(out.vis, "visNetwork")
    expect_is(out.vis, "htmlwidget")
    

})
