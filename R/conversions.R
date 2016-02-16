

#' Convert a directed graphs between network and igraph
#'
#' @export
#' @importFrom igraph graph.data.frame
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
}
