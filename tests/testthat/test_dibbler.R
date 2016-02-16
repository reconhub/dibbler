context("Test dibbler")
library(igraph)

## test data ##
test_that("test: network <-> igraph", {
    ## SKIP ON CRAN
    skip_on_cran()
    rm(list=ls())

    ## GENERATE DATA
    set.seed(1)
    g1 <- make_tree(20, 3)

    ## need this hack for named vertices
    temp <- data.frame(lapply(
        igraph2data.frame(g1), as.character),
                       stringsAsFactors=FALSE)
    g1 <- graph.data.frame(temp)

    ## find times
    tips <- which(degree(g1, mode="out")==0)
    grp <- factor(sample(letters[1:4], replace=TRUE, size=length(tips)))
    names(grp) <- tips


    ## RUN DIBBLER
    out <- dibbler(dibbler.data(g1, grp))

})

