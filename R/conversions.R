

#' Convert a directed graphs from network to igraph
#'
#' The function convert a directed graph with the network format into an igraph object.
#'
#' @export
#' @importFrom igraph graph.data.frame
#' @importFrom network as.edgelist
#'
#' @param x a \code{network} object.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
network2igraph <- function(x){
    ## get edge list
    temp <- network::as.edgelist(x)

        ## get labels
    lab <- attr(temp, "vnames")

    ## restore labels
    out <- matrix(lab[temp], ncol=2)
    colnames(out) <- c("from","to")

    ## make igraph object
    out <- igraph::graph.data.frame(as.data.frame(out))

    return(out)
} # end network2igraph







#' Convert a directed graphs from igraph to network
#'
#' The function convert a directed graph with the igraph format into an network object.
#'
#' @export
#' @importFrom network graph.data.frame network
#' @importFrom igraph as.edgelist as_data_frame
#'
#' @param x a \code{igraph} object.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
igraph2network <- function(x){
    ## get edge list
    temp <- igraph::as_data_frame(out)


    ## restore labels
    out <- network::network(temp)

    return(out)
} # end igraph2network
