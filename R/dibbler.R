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
#' @param ... further arguments to be passed to other functions
#'
#' @seealso
#' \describe{
#' \item{\code{\link{dibbler.data}}}{to prepare the input data.}
#' }
#'
#' @examples
#'
dibbler <- function(x=dibbler.data(), ...){
    ## CHECKS ##
    if(is.null(x)) stop("x is NULL")
    if(!is.list(x)) stop("x is not a list")
    if(!inherits(x, "dibbler.input")) stop("x is not a dibbler.input object")

    ## PERFORM  ##
    freq <- list()

    ## for all internal nodes...
    for(i in seq_along(x$lab.graph)){
        ## get tree from the node
        tree <- dfs(graph=x$graph, root=i,
                    neimode="out", unreachable=FALSE)$order

        ## isolate tips
        tips <- intersect(names(tree),x$lab.match)

        ## get group frequencies
        out[[i]] <- table(x$group[tips])/length(tips)

        ## get confidence measure
        ## (prop of terminal nodes in tree)
        conf <- mean(tree %in% x$id.terminal)
    }

    ## SHAPE/RETURN OUTPUT ##
    out <- list()
    names(freq) <- names(conf) <- x$lab.graph
    out$freq <- freq
    out$conf <- conf
    out$graph <- x$graph

    return(out)
} # end dibbler
