#' Plot input data for dibbler
#'
#' This function plots dibbler's input data as a network, using different symbols and colors for different types of nodes. It uses the package \code{network}.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @param x an input dataset as returned by \code{dibbler.data}
#' @param y unused argument, for compatibility with the \code{plot} generic
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
plot.dibbler.data <- function(x, y=NULL, col.pal1=dibbler.pal1, col.pal2=dibbler.pal2, ...){
    ## convert input graph to network
    net <- igraph2network(x$graph)
    net.df <- network2data.frame(net)
    v.names <- network.vertex.names(net)
    id.terminal <- which(!v.names %in% net.df$from)
    id.basal <- which(!v.names %in% net.df$to)
    id.internal <- which(!v.names %in% v.names[id.terminal])


    ## get basic variables
    N <- length(network.vertex.names(net))
    N.internal <- length(id.internal)
    N.tips <- length(id.terminal)
    K <- length(levels(x$group))

    ## get vertex v.labels
    temp <- x$group
    v.lab <- rep("", N)
    names(v.lab) <- network.vertex.names(net)
    v.lab[names(x$group)] <- as.character(x$group)

    ## get internal node colors
    v.col <- rep("grey",.5, N)
    names(v.col) <- network.vertex.names(net)
    v.col[id.internal] <- col.pal2(N.internal)

    ## get group colors
    grp.col <- col.pal1(K)

    ## get tip colors
    v.col[names(x$group)] <- grp.col[x$group]

    ## get shapes
    v.sides <- rep(50, N)
    v.sides[id.terminal] <- 3
    v.sides[id.basal] <- 6
    v.lwd <- rep(1,N)
    v.lwd[id.basal] <- 3

    ## set sizes
    v.size[id.terminal] <- 1

    ## make plot
    plot(net, label=v.lab, label.cex=1,
         edge.col=e.col, vertex.col=v.col,
         label.col=v.col, vertex.cex=v.size,
         vertex.sides=v.sides,
         vertex.lwd=v.lwd, ...)

    return(out)
} # end dibbler.data




## ## node size
## v.size <- sapply(network.vertex.names(net), function(e) sum(e == net.dat$ancestor))
## v.size <- 1 + sqrt(v.size)/2

## ## edge color
## e.list <- as.matrix(net, matrix.type="edgelist")
## e.col <- v.col[attr(e.list, "vnames")[e.list[,1]]]
## #e.col <- v.col[net.dat$ancestor]
