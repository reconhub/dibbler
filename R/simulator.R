#' Simulation of infection over a network
#'
#' Under development, do not use!!
#'
#'
#' @author
#' Thibaut Jombart (\email{thibautjombart@@gmail.com}) and
#' Tim McMackin (\email{addyour@@email.here.com})
#'
#' @param x a graph represented as a 2-column matrix storing directed edges (from, to)
#' @param n.intro number of introductions
#' @param proba.trans a probability of transmission of the infection to a descending node
#'

## We pick a random node which will be the starting point of the outbreak; then a random process
## cascades this infection down to other nodes. Note that the graph may contain cycles, so we
## will need to keep track of the nodes browsed to avoid infinite recursion. In the case of
## multiple introductions, we just repeat the process as many times as needed.

simulate.infection <- function(x, n.intro=1, proba.trans=0.8){

    ## Various checks
    if (!inherits(x, c("matrix","data.frame"))) {
        stop("x should be a matrix or a data.frame")
    }
    if (ncol(x)!=2L) {
        stop("x must have two columns")
    }
    if (n.intro<0) {
        stop("n.intro is negative")
    }
    if (n.intro>1) {
        stop("n.intro >1 not implememnted (ask Tim!!!)")
    }


    colnames(x) <- c("from", "to")
    x$from <- as.character(x$from)
    x$to <- as.character(x$to)

    nodes <- unique(as.vector(unlist(as.matrix(x))))

    n.edges <- nrow(x)
    n.nodes <- length(nodes)
    infected <- rep(FALSE, n.nodes)
    names(infected) <- nodes

    probas <- c(proba.trans, 1-proba.trans)

    ## Pick a first node
    has.been.infected <- new.infected <- sample(nodes, n.intro, replace=TRUE)

    ## For a give starting node 'v'...
    while(length(new.infected)>0){
        current.infectors <- new.infected
        for(v in new.infected){

            ## set infection for 'v'
            infected[v] <- TRUE

            ## identify descending nodes
            descending.nodes <- x$to[which(v==x$from)]

            ## pick the newly infected ones
            new.infected <- c(new.infected, descending.nodes[sample(c(TRUE,FALSE),
                                                                    length(descending.nodes),
                                                                    prob=probas, replace=TRUE)]
                              )

            ## discard nodes which were currently infectors
            new.infected <- setdiff(new.infected, current.infectors)
        }
    }


    ## The returned result will be a list containing:
    ## - the input graph (from/to matrix or data.frame)
    ## - a vector of all nodes
    ## - infected: a vector of logicals, one value for each nodes; TRUE means this node has been
    ## infected
    n.inf <- sum(infected)
    out <- list(graph=x, infected=infected, n.infected=n.inf)
    return(out)
}
