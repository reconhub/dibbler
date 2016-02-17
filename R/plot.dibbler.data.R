#' Plot input data for dibbler
#'
#' This function plots dibbler's input data as a network, using different symbols and colors for different types of nodes. It uses the package \code{network}.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @param x an input dataset as returned by \code{dibbler.data}
#' @param y unused argument, for compatibility with the \code{plot} generic
#' @param cex a size factor for the nodes of the network
#' @param lab.cex a size factor for the tip annotations (genetic clusters)
#' @param color.internal a logical indicating whether internal nodes and their descending edges should be colored
#' @param col.pal1 a color palette to be used for the genetic clusters (tips)
#' @param col.pal2 a color palette to be used for identifying internal nodes
#' @param ... further arguments to be passed to \code{plot.network}
#' @export
#'
#' @return the same output as \code{plot.network}
#'
#' @seealso \code{\link[network]{plot.network}} in the package \code{network}.
#'
#' @examples
#'
#' if(require(igraph) && require(network)){
#'
#' ## generate graph from edge list
#' Salmonella
#' g <- graph.data.frame(Salmonella$graph)
#'
#' input <- dibbler.data(graph=g, group=Salmonella$cluster)
#' plot(input)
#' plot(input, cex=2, color.internal=FALSE)
#' }
#'
plot.dibbler.input <- function(x, y=NULL, cex=1, lab.cex=1, color.internal=TRUE,
                               col.pal1=dibbler.pal1, col.pal2=dibbler.pal2, ...){
    ## convert input graph to network
    net <- igraph2network(x$graph)
    net.df <- network2data.frame(net)
    v.names <- network.vertex.names(net)
    id.terminal <- which(!v.names %in% net.df$from)
    id.basal <- which(!v.names %in% net.df$to)
    id.internal <- which(!v.names %in% v.names[id.terminal])

    ## basic variables
    N <- length(network.vertex.names(net))
    N.internal <- length(id.internal)
    N.tips <- length(id.terminal)
    K <- length(levels(x$group))

    ## vertex labels
    temp <- x$group
    v.lab <- rep("", N)
    names(v.lab) <- network.vertex.names(net)
    v.lab[names(x$group)] <- as.character(x$group)

    ## internal node colors
    v.col <- rep("grey",.5, N)
    names(v.col) <- network.vertex.names(net)
    if(color.internal){
        v.col[id.internal] <- col.pal2(N.internal)
    }

    ## group colors
    grp.col <- col.pal1(K)

    ## tip colors
    v.col[names(x$group)] <- grp.col[x$group]

    ## vertex shapes
    v.sides <- rep(50, N)
    v.sides[id.terminal] <- 3
    v.sides[id.basal] <- 6
    v.lwd <- rep(1,N)
    v.lwd[id.basal] <- 3

    ## vertex sizes
    v.size <- sapply(v.names, function(e) sum(e == net.df$from))
    v.size <- 1 + sqrt(v.size) * (cex/2)
    v.size[id.terminal] <- 1

    ## edge color
    e.df <- as.matrix(net, matrix.type="edgelist")
    e.col <- v.col[attr(e.list, "vnames")[e.df[,1]]]

    ## make plot
    out <- plot(net, label=v.lab, label.cex=lab.cex,
         edge.col=e.col, vertex.col=v.col,
         label.col=v.col, vertex.cex=v.size,
         vertex.sides=v.sides,
         vertex.lwd=v.lwd, ...)

    return(invisible(out))
} # end plot.dibbler.input




## ## node size

## ## edge color
## e.list <- as.matrix(net, matrix.type="edgelist")
## e.col <- v.col[attr(e.list, "vnames")[e.list[,1]]]
## #e.col <- v.col[net.dat$ancestor]
