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
#'
#'
simulate.infection <- function(x){
    ## We pick a random node which will be the starting point of the outbreak; then a random process
    ## cascades this infection down to other nodes. Note that the graph may contain cycles, so we
    ## will need to keep track of the nodes browsed to avoid infinite recursion. In the case of
    ## multiple introductions, we just repeat the process as many times as needed.


}
