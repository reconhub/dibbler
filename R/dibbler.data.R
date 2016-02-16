#' Process input data for dibbler
#'
#' This function ...
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @param graph a input for buidling a graph (see details)
#' @param tree a phylogenetic tree with \code{phylo} class
#' @param ... a list containing inputs for  \code{\link{dibbler}}
#'
#' @export
#' @importFrom stats as.dist
#'
#' @return a list of data suitable for input for \code{\link{dibbler}}
#'
#' @examples
#'
dibbler.data <- function(graph=NULL, tree=NULL, ...){
    ## PROCESS INPUT ##
    ## extract data from list ##
    data <- list(...)
    if(length(data)==0L) stop("no data to process")

    ## escape if data has been processed already
    if(inherits(data[[1]],"dibbler.input")) return(data[[1]])

    ## if first item is a list, use it as input
    if(is.list(data[[1]])) data <- data[[1]]


    ## RETURN OUTPUT ##
    out <- list()
    class(out) <- c("list", "dibbler.input")
    return(out)
} # end dibbler.data
