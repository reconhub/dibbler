#' Idendify monochromatic trees
#'
#' The function \code{mono.tree} identifies subtrees of a food distribution network which contain only one pathogenic lineage.
#'
#' !!! This package is still under development. Do not use it without contacting the author. !!!
#'
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @export
#' @importFrom igraph dfs
#'
#' @param x a list of the class 'dibbler.data' as returned by \code{\link{dibbler.data}}.
## #' @param ... further arguments to be passed to other functions
#'
#' @seealso
#' \describe{
#' \item{\code{\link{dibbler.data}}}{to prepare the input data.}
#' }
#'
#' @examples
#'
#' if(require(igraph)){
#' ## generate graph from edge list
#' Salmonella
#' g <- graph.data.frame(Salmonella$graph)
#'
#' ## run mono.tree
#' out <- mono.tree(dibbler.data(graph=g, group=Salmonella$cluster))
#'
#' ## check output
#' names(out)
#' head(out$freq)
#' head(out$conf)
#' out$graph
#'
#' ## plot results
#' plot(out$graph, vertex.label="",
#' main="dibbler: inferred pathogen distribution")
#' }
mono.tree <- function(x=dibbler.data()){
    ## CHECKS ##
    check.data(x)

    ## LOOK FOR MONOCHROMATIC TREES ##

    ## The algorithm is as follows:
    ## 1) identify all subtrees using depth first search (one subtree per internal node)
    ## 2) identify cluster composition for each subtree
    ## 3) keep only monochromatic subtrees
    ## 4) keep only the largesty monochromatic trees; this bit is less trivial, and requires 2
    ## steps;
    ## 4.1) identify the number of cases contained by each tree, define as the 'case.size'
    ## 4.2) discard all trees contained in trees with larger case.size

    trees <- list() # will be the list of monochromatic trees
    compositions <- list() # will be the corresponding case composition
    case.sizes <- integer(0) # will be the case.size
    counter <- 1L

    ## for all internal nodes...
    for (i in seq_along(x$lab.graph)) {
        ## get tree from the node
        tree <- igraph::dfs(graph=x$graph, root=i,
                    neimode="out", unreachable=FALSE)$order

        ## remove NAs, keep only labels
        tree <- names(tree)[!is.na(tree)]

        ## cluster composition of tree
        compo <- factor(na.omit(x$group[tree]))

        ## compute case sizes
        case.size <- length(compo)

        ## retain or discard tree
        if (length(levels(compo)) == 1L && length(tree) > 1L) {
            trees[[counter]] <- tree
            compositions[[counter]] <- compo
            case.sizes[counter] <- case.size
            names(trees)[counter] <-
                names(compositions)[counter] <-
                    names(case.sizes[counter]) <- names(igraph::V(x$graph)[i])
            counter <- counter + 1
        }
    }


    ## At this stage, 'trees' contains all monochromatic trees. We need to remove those contained in
    ## larger ones (see item 4 of the algo above).
    i <- 1L
    while (i < length(trees)) {
        tree <- trees[[i]]
        case.size <- case.sizes[i]

        contained.in <- vapply(trees, function(e) all(tree %in% e), logical(1))

        ## remove tree if contained in larger one
        if (any(contained.in & case.size < case.sizes)) {
            trees <- trees[-i]
            compositions <- compositions[-i]
            case.sizes <- case.sizes[-i]
        } else {

            ## move to the next tree
            i <- i + 1
        }
    }


    ## TODO: would need to group trees by tip composition
    tip.compositions <- vapply(compositions, function(e)
                               paste(sort(names(e)), collapse="-"), character(1L))

    trees <- split(trees, tip.compositions)
    compositions <- split(compositions, tip.compositions)
    case.sizes <- split(case.sizes, tip.compositions)


    ## shape output and return result
    out <- list(trees = trees,
                compositions = compositions,
                case.sizes = case.sizes)

    ## ## SET OUTPUT GRAPH ATTRIBUTES ##
    ## graph <- set.graph.opt(x$graph, graph.opt, freq=freq, conf=conf)

    ## ## SHAPE/RETURN OUTPUT ##
    ## names(freq) <- names(conf) <- x$lab.graph
    ## out <- list(freq=freq, conf=conf, graph=graph)

    return(out)
}
