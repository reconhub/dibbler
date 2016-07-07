#' Simulation of infection over a network
#'
#' Under development, do not use!!
#'
#'
#' @author
#' Thibaut Jombart (\email{thibautjombart@@gmail.com})
#'
#' @param x a graph represented as a 2-column matrix storing directed edges (from, to)
#' @param n.intro number of introductions
#' @param p.trans a probability of transmission of the infection to a descending node
#'

## We pick a random node which will be the starting point of the outbreak; then a random process
## cascades this infection down to other nodes. Note that the graph may contain cycles, so we
## will need to keep track of the nodes browsed to avoid infinite recursion. In the case of
## multiple introductions, we just repeat the process as many times as needed.

simulate.infection <- function(x, n.intro=1, p.trans=0.8){

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


    ## 'x' will contain the edge data.frame, 'nodes' is a vector of all nodes in the graph
    colnames(x) <- c("from", "to")
    x$from <- as.character(x$from)
    x$to <- as.character(x$to)
    nodes <- unique(as.vector(unlist(as.matrix(x))))

    ## This function finds descending nodes from a given 'infector' node, and decide which of these
    ## gets infected based on the transmission probability; it returns a (possibly empty) vector of
    ## characters containing node IDs.
    spread.from.node <- function(infector, p.trans){
        descending.nodes <- x$to[which(infector==x$from)]
        become.infected <- sample(c(TRUE,FALSE),
                                  length(descending.nodes),
                                  prob=c(p.trans, 1-p.trans), replace=TRUE)
        out <- descending.nodes[become.infected]
        return(out)
    }


    ## Initialise algorithm

    ## infectious: vector of currently infectious node IDs
    ## infected.and.removed: vector of previously infected node IDs

    infectious <- sample(nodes, n.intro, replace=TRUE)
    infected.and.removed <- character(0)

    ## Algorithm:

    ## i) pick 1st node of 'infectious' as 'current.infector'

    ## ii) determine new infections from this node, and add them to 'infectious', making sure
    ## previously infected nodes cannot become infectious again

    ## iii) move 'current.infector' from 'infectious' to 'infected.and.removed'
    ## repeat until 'infectious' is empty

    while(length(infectious)>0){
        current.infector <- infectious[1]
        infected.and.removed <- c(infected.and.removed, current.infector)
        new.infected <- setdiff(spread.from.node(current.infector, p.trans),
                                infected.and.removed)
        infectious <- c(infectious[-1], new.infected)
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
