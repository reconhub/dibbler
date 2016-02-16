#' Modelling food-borne outbreaks using genetic data
#'
#' The function \code{dibbler} is used for inferring the transmission of food-borne diseases across a food distribution network using pathogen genome sequences sampled for a set of cases.
#'
#' !!! This package is still under development. Do not use it without contacting the author. !!!
#'
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @export
#'
#' @param x a list of the class 'dibbler.input' as returned by \code{\link{dibbler.data}}.
#' @param graph.opt a list of options are returned by  \code{\link{dibbler.graph.opt}}.
## #' @param ... further arguments to be passed to other functions
#'
#' @seealso
#' \describe{
#' \item{\code{\link{dibbler.data}}}{to prepare the input data.}
#' }
#'
#' @examples
#'
dibbler <- function(x=dibbler.data(), graph.opt=dibbler.graph.opt()){
    ## CHECKS ##
    if(is.null(x)) stop("x is NULL")
    if(!is.list(x)) stop("x is not a list")
    if(!inherits(x, "dibbler.input")) stop("x is not a dibbler.input object")

    ## PERFORM  ##
    freq <- list()
    conf <- numeric()

    ## for all internal nodes...
    for(i in seq_along(x$lab.graph)){
        ## get tree from the node
        tree <- dfs(graph=x$graph, root=i,
                    neimode="out", unreachable=FALSE)$order

        ## remove NAs
        tree.names <- names(tree)
        to.keep <- is.na(tree)
        tree <- as.integer(tree)[to.keep]
        names(tree) <- tree.names[to.keep]

        ## isolate tips
        tips <- intersect(names(tree),x$lab.match)

        ## get group frequencies
        freq[[i]] <- table(x$group[tips])/length(tips)

        ## get confidence measure
        ## (prop of terminal nodes in tree)
        conf[i] <- mean(tree %in% x$id.group.matxch)
    }

    ## SHAPE/RETURN OUTPUT ##
    names(freq) <- names(conf) <- x$lab.graph
    out <- list(freq=freq, conf=conf, graph=x$graph)

    return(out)
} # end dibbler
