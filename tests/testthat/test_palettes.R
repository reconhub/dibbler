context("test palettes")


test_that("testing color palettes", {

    ## skip on CRAN
    skip_on_cran()

    ## checks
    expect_error(dibbler_pal1())
    expect_error(dibbler_pal2())
    expect_error(dibbler_pal1("jio"))
    expect_error(dibbler_pal2("jio"))
    
    expect_equal(length(dibbler_pal1(7)),7)
    expect_equal(length(dibbler_pal2(3)),3) 
    
})
