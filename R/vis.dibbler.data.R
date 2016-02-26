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
#' @param plot a logical indicating whether a plot should be displayed
#' @param legend a logical indicating whether a legend should be added to the plot
#' @param selector a logical indicating whether a group selector tool should be added to the plot
#' @param editor a logical indicating whether an editor tool should be added to the plot
#' @param ... further arguments to be passed to \code{visNetwork}
#'
#' @export
#' @importFrom visNetwork visNetwork visGroups visLegend
#' @importFrom magrittr "%>%"
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
#' vis.dibbler.input(input)
#' }
#' }
#'
vis.dibbler.input <- function(x, cex=1, lab.cex=1, plot=TRUE, legend=TRUE,
                              selector=TRUE, editor=TRUE,
                              col.pal=dibbler.pal1, ...){
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
    ## LABELS
    out$nodes$label <- nodes

    ## GROUP
    ## (groups will define color)
    v.group <- rep("internal", N)
    names(v.group) <- nodes
    v.group[names(x$group)] <- as.character(x$group)

    ## set value
    out$nodes$group <- v.group

    ## TITLE
    ## (used when hovering over nodes)


    ## SHAPE
    ## vertex shapes
    v.shape <- rep("dot", N)
    v.shape[id.terminal] <- "triangle"
    v.shape[id.basal] <- "diamond"

    ## set value
    out$nodes$shape <- v.shape

    ## SIZES
    out$nodes$value <- sapply(nodes, function(e) sum(e == out$edges$from))


    ## EDGES ##
    ## SHAPES
    ## set value
    out$edges$arrows <- "to"

    ## COLORS
    out$edges$color <- "grey"

    ## OUTPUT
    ## escape if no plotting
    if(!plot) return(invisible(out))

    ## visNetwork output
    out <- visNetwork::visNetwork(nodes=out$nodes, edges=out$edges, ...)

    ## add group info/color
    out <- out %>% visGroups(groupname = "internal", color = "grey")
    grp.col <- col.pal(K)
    for(i in seq.int(K)){
        out <- out %>% visGroups(groupname = levels(x$group)[i], color = grp.col[i])
    }

    ## add legend
    if(legend){
        out <- out %>% visLegend()
    }

    ## add selector
    if(selector){
        out <- out %>% visOptions(selectedBy = "group")
    }

    ## add editor
    if(editor){
        out <- out %>% visOptions(manipulation = TRUE)
    }

    return(out)
} # end viz.dibbler.input
