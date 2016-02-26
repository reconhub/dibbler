

#' Convert a directed graphs from network object to data.frame
#'
#' The function convert a directed graph with the network format into a data.frame of edge lists (from, to)
#'
#' @export
#' @importFrom network as.edgelist
#'
#' @param x a \code{network} object.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @seealso
#' \describe{
#' Conversions in dibbler include:
#' \item{\code{\link{network2data.frame}}}{}
#' \item{\code{\link{igraph2data.frame}}}{}
#' \item{\code{\link{igraph2data.frame}}}{}
#' \item{\code{\link{igraph2network}}}{}
#' \item{\code{\link{network2igraph}}}{}
#' \item{\code{\link{igraph2igraph2visNetwork}}}{}
#' \item{\code{\link{network2igraph2visNetwork}}}{}
#' }
network2data.frame <- function(x){
    ## check class
    if(!inherits(x, what="network")) stop("x is not an network object")

    ## get edge list
    temp <- network::as.edgelist(x)

        ## get labels
    lab <- attr(temp, "vnames")

    ## restore labels
    out <- matrix(lab[temp], ncol=2)
    colnames(out) <- c("from","to")

    return(as.data.frame(out, stringsAsFactors=FALSE))
} # end network2data.frame






#' Convert a directed graphs from igraph to data.frame
#'
#' The function convert a directed graph with the igraph format into into a data.frame of edge lists (from, to).
#'
#' @export
#' @importFrom igraph as_data_frame
#'
#' @param x a \code{igraph} object.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @seealso
#' \describe{
#' Conversions in dibbler include:
#' \item{\code{\link{network2data.frame}}}{}
#' \item{\code{\link{igraph2data.frame}}}{}
#' \item{\code{\link{igraph2data.frame}}}{}
#' \item{\code{\link{igraph2network}}}{}
#' \item{\code{\link{network2igraph}}}{}
#' }
igraph2data.frame <- function(x){
    ## check class
    if(!inherits(x, what="igraph")) stop("x is not an igraph object")

    ## get edge list
    out <- igraph::as_data_frame(x)
    colnames(out) <- c("from","to")

    ## return
    return(out)
} # end igraph2data.frame






#' Convert a directed graphs from network to igraph
#'
#' The function convert a directed graph with the network format into an igraph object.
#'
#' @export
#' @importFrom igraph graph.data.frame
#'
#' @param x a \code{network} object.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @seealso
#' \describe{
#' Conversions in dibbler include:
#' \item{\code{\link{network2data.frame}}}{}
#' \item{\code{\link{igraph2data.frame}}}{}
#' \item{\code{\link{igraph2data.frame}}}{}
#' \item{\code{\link{igraph2network}}}{}
#' \item{\code{\link{network2igraph}}}{}
#' \item{\code{\link{igraph2igraph2visNetwork}}}{}
#' \item{\code{\link{network2igraph2visNetwork}}}{}
#' }
network2igraph <- function(x){
    ## check class
    if(!inherits(x, what="network")) stop("x is not an network object")

    ## get edge list
    out <- network2data.frame(x)

    ## make igraph object
    out <- igraph::graph.data.frame(out)

    return(out)
} # end network2igraph






#' Convert a directed graphs from igraph to network
#'
#' The function convert a directed graph with the igraph format into an network object.
#'
#' @export
#' @importFrom network network
#'
#' @param x a \code{igraph} object.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @seealso
#' \describe{
#' Conversions in dibbler include:
#' \item{\code{\link{network2data.frame}}}{}
#' \item{\code{\link{igraph2data.frame}}}{}
#' \item{\code{\link{igraph2data.frame}}}{}
#' \item{\code{\link{igraph2network}}}{}
#' \item{\code{\link{network2igraph}}}{}
#' \item{\code{\link{igraph2igraph2visNetwork}}}{}
#' \item{\code{\link{network2igraph2visNetwork}}}{}
#' }
igraph2network <- function(x){
    ## check class
    if(!inherits(x, what="igraph")) stop("x is not an igraph object")

    ## get edge list
    out <- igraph2data.frame(x)

    ## restore labels
    out <- network::network(out)

    return(out)
} # end igraph2network







#' Convert a directed graphs from igraph to visNetwork inputs
#'
#' The function convert a directed graph with the igraph format into inputs for visNetwork.
#'
#' @export
#' @importFrom igraph V
#'
#' @param x a \code{igraph} object.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @seealso
#' \describe{
#' Conversions in dibbler include:
#' \item{\code{\link{network2data.frame}}}{}
#' \item{\code{\link{igraph2data.frame}}}{}
#' \item{\code{\link{igraph2data.frame}}}{}
#' \item{\code{\link{igraph2network}}}{}
#' \item{\code{\link{network2igraph}}}{}
#' \item{\code{\link{igraph2igraph2visNetwork}}}{}
#' \item{\code{\link{network2igraph2visNetwork}}}{}
#' }
igraph2visNetwork <- function(x){
    ## check class
    if(!inherits(x, what="igraph")) stop("x is not an igraph object")

    ## get nodes
    nodes <- data.frame(id=labels(V(x)), stringsAsFactors=FALSE)

    ## get edges
    edges <- igraph2data.frame(x)

    return(list(nodes=nodes, edges=edges))
} # end igraph2network







#' Convert a directed graphs from network to visNetwork inputs
#'
#' The function convert a directed graph with the network format into inputs for visNetwork.
#'
#' @export
#' @importFrom network network.vertex.names
#'
#' @param x a \code{igraph} object.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @seealso
#' \describe{
#' Conversions in dibbler include:
#' \item{\code{\link{network2data.frame}}}{}
#' \item{\code{\link{igraph2data.frame}}}{}
#' \item{\code{\link{igraph2data.frame}}}{}
#' \item{\code{\link{igraph2network}}}{}
#' \item{\code{\link{network2igraph}}}{}
#' \item{\code{\link{igraph2igraph2visNetwork}}}{}
#' \item{\code{\link{network2igraph2visNetwork}}}{}
#' }
network2visNetwork <- function(x){
    ## check class
    if(!inherits(x, what="network")) stop("x is not an network object")

    ## get nodes
    nodes <- data.frame(id=network::network.vertex.names(x), stringsAsFactors=FALSE)

    ## get edges
    edges <- network2data.frame(x)

    return(list(nodes=nodes, edges=edges))
} # end igraph2network


