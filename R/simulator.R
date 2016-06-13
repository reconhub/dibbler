#' Simulation of infection over a network
#'
#' Under development, do not use!!
#'
#'
#' @author
#' Thibaut Jombart (\email{thibautjombart@@gmail.com}) and
#' Tim McMackin (\email{addyour@@email.here.com})
#'
#' @param x a graph represented as a 2-column matrix storing directed edges (from, to)
#' @param n.intro number of introductions
#' @param proba.trans a probability of transmission of the infection to a descending node
#'

## We pick a random node which will be the starting point of the outbreak; then a random process
## cascades this infection down to other nodes. Note that the graph may contain cycles, so we
## will need to keep track of the nodes browsed to avoid infinite recursion. In the case of
## multiple introductions, we just repeat the process as many times as needed.

simulate.infection <- function(x, n.intro=1, proba.trans=0.5){

    ## Various checks
    if (!inherits(x, c("matrix","data.frame"))) {
        stop("x should be a matrix or a data.frame")
    }
    if (ncol(x)!=2L) {
        stop("x must have two columns")
    }
    if (n.intro<0) {
        stop("n.intro is negative")
    }
    if (n.intro>1) {
        stop("n.intro >1 not implememnted (ask Tim!!!)")
    }


    colnames(x) <- c("from", "to")
    x$from <- as.character(x$from)
    x$to <- as.character(x$to)


    ## Pick a first node
    node.start <- sample(x$from, n.intro)

    ## For a give starting node...


    ## identify descending nodes
    ## pick the newly infected ones
    ## repeat



}
