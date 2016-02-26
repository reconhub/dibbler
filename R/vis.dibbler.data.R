#' Plot input data for dibbler
#'
#' This function plots dibbler's input data as a network, using different symbols and colors for different types of nodes. It uses the package \code{network}.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @param x an input dataset as returned by \code{dibbler.data}
#' @param cex a size factor for the nodes of the network
#' @param lab.cex a size factor for the tip annotations (genetic clusters)
#' @param color.internal a logical indicating whether internal nodes and their descending edges should be colored
#' @param col.pal1 a color palette to be used for the genetic clusters (tips)
#' @param col.pal2 a color palette to be used for identifying internal nodes
#' @param plot a logical indicating whether a plot should be displayed
#' @param ... further arguments to be passed to \code{visNetwork}
#'
#' @export
#' @importFrom visNetwork visNetwork
#'
#' @return the same output as \code{visNetwork}
#'
#' @seealso \code{\link[visNetwork]{visNetwork}} in the package \code{visNetwork}.
#'
#' @examples
#'
#' if(require(igraph) && require(network)){
#'
#' ## generate graph from edge list
#' Salmonella
#' g <- igraph::graph.data.frame(Salmonella$graph)
#'
#' input <- dibbler.data(graph=g, group=Salmonella$cluster)
#'
#' ## check info returned by function
#' temp <- viz.dibbler.input(input, plot=FALSE)
#' temp
#'
#' \dontrun{
#' ## opens a browser
#' viz.dibbler.input(input)
#' }
#' }
#'
vis.dibbler.input <- function(x, cex=1, lab.cex=1, plot=TRUE, ...){
                              ## color.internal=TRUE,
                              ## col.pal1=dibbler.pal1, col.pal2=dibbler.pal2,
    ## convert input graph to visNetwork inputs
    out <- igraph2visNetwork(x$graph)
    nodes <- out$nodes$id
    edges <- out$edges

    ## basic variables
    id.terminal <- which(!nodes %in% out$edges$from)
    id.basal <- which(!nodes %in% out$edges$to)
    id.internal <- which(!nodes %in% nodes[id.terminal])
    N <- length(nodes)
    N.internal <- length(id.internal)
    N.tips <- length(id.terminal)
    K <- length(levels(x$group))


    ## NODES ##
    ## GROUP
    ## (groups will define color)
    v.group <- rep("internal", N)
    names(v.group) <- nodes
    v.group[names(x$group)] <- as.character(x$group)

    ## ## group colors
    ## grp.col <- col.pal1(K)


    ## set value
    out$nodes$group <- v.group

    ## SHAPE
    ## vertex shapes
    v.shape <- rep("circle", N)
    v.shape[id.terminal] <- "triangle"
    v.shape[id.basal] <- "diamond"

    ## set value
    out$nodes$shape <- v.shape

    ## SIZES
    v.size <- sapply(nodes, function(e) sum(e == out$edges$from))
    v.size <- 1 + sqrt(v.size) * (cex/2)
    v.size[id.terminal] <- 1

    ## set value
    out$nodes$value <- v.size


    ## EDGES ##
    ## SHAPES
    ## set value
    out$edges$arrows <- "to"


    ## OUTPUT
    if(!plot) return(invisible(out))

     visNetwork::visNetwork(nodes=out$nodes, edges=out$edges, ...)
} # end viz.dibbler.input
