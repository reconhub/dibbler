#' VIsualisation and Monitoring of EpidemicS
#'
#' The function \code{vimes} is used to identify clusters of related cases based on multiple data.
#'
#' !!! This package is still under development. Do not use it without contacting the author. !!!
#'
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @export
#' @importFrom igraph intersection
#'
#' @param x a list of the class 'vimes.input' as returned by \code{vimes.data}.
#' @param cutoff a vector with the same length as 'x' indicating cutoff distances beyond which individuals will not be connected in the separate graphs; recycled if needed. If NULL, interactive mode will be triggered to ask the user for cutoff distances.
#' @param graph.opt a list of graphical options for the graphs, as returned by \code{\link{vimes.graph.opt}}.
#' @param ... further arguments to be passed to \code{hist}.
#'
#' @seealso
#' \describe{
#' \item{\code{\link{vimes.data}}}{to prepare the input data.}
#' \item{\code{\link{vimes.prune}}}{for getting individual pruned graphs.}
#' }
#'
#' @examples
#'
#'  ## generate data
#'  set.seed(2)
#'  dat1 <- rnorm(30, c(0,1,6))
#'  dat2 <- rnorm(30, c(0,0,1))
#'  dat3 <- rnorm(30, c(8,1,2))
#'  x <- lapply(list(dat1, dat2, dat3), dist)
#'  x <- vimes.data(x)
#' plot(x)
#'
#'  ## analyse data
#'  res <- vimes(x, cutoff=c(2,4,2))
#'  res
#' plot(res$graph)
#'
vimes <- function(x, cutoff=NULL, graph.opt=vimes.graph.opt(), ...){
    ## CHECKS ##
    if(is.null(x)) stop("x is NULL")
    if(!is.list(x)) stop("x is not a list")
    if(!inherits(x, "vimes.input")) stop("x is not a vimes.input object")
    K <- length(x)
    if(!is.null(cutoff)) cutoff <- rep(cutoff, length=K)
    x.labels <- names(x)

    ## MAKE SEPARATE GRAPHS ##
    all.graphs <- list()
    for(i in seq_along(x)){
        all.graphs[[i]] <- vimes.prune(x[[i]], cutoff=cutoff[i], graph.opt=graph.opt, ...)
    }


    ## GET MAIN GRAPH ##
    ## intersect graphs ##
    g <- do.call(intersection, lapply(all.graphs, function(e) e$graph))

    ## set graphical options ##
    ## disable weights
    graph.opt$edge.label <- FALSE
    g <- set.graph.opt(g, graph.opt)

   ## find clusters ##
    groups <- clusters(g)
    names(groups) <- c("membership", "size", "K")

    ## add cluster colors ##
    groups$color <- graph.opt$col.pal(groups$K)
    names(groups$color) <- 1:groups$K

    ## ADJUST SEPARATE GRAPHS FEATURES ##
    for(i in seq_along(x)){
        ## vertex color ##
        V(all.graphs[[i]]$graph)$color <- V(g)$color

        ## layout ##
        all.graphs[[i]]$graph$layout <- g$layout
    }
    names(all.graphs) <- x.labels

    ## SHAPE/RETURN OUTPUT ##
    out <- list(graph=g, clusters=groups, cutoff=cutoff,
                separate.graphs=all.graphs)

    return(out)
} # end vimes
