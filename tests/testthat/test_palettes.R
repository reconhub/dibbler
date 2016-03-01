context("test palettes")


test_that("test: network <-> igraph", {
    ## skip on CRAN
    skip_on_cran()
    rm(list=ls())

    ## checks
    expect_error(dibbler.pal1())
    expect_error(dibbler.pal2())
    expect_error(dibbler.pal1("jio"))
    expect_error(dibbler.pal2("jio"))
    
    expect_equal(length(dibbler.pal1(7)),7)
    expect_equal(length(dibbler.pal2(3)),3) 
    
})
