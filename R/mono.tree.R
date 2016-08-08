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
#' @return
#' A list with the following components:
#' \itemize{
#' \item
#' }
#' @examples
#'
#' ## generate graph from edge list
#' Salmonella
#'
#' x <- with(Salmonella, dibbler.data(graph=graph, group=cluster))
#'
#' ## run mono.tree
#' out <- mono.tree(x)
#' names(out)
#' out$trees
#'
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
        compo <- factor(stats::na.omit(x$group[tree]))

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
    case.compositions <- vapply(compositions, function(e)
                               paste(sort(names(e)), collapse="-"), character(1L))

    trees <- split(trees, case.compositions)


    ## Shape output and return result

    ## We return a list of the form:

    ## $[case.composition1]
    ## $[case.composition2]
    ## ...
    ## where each case composition is a list of trees:
    ## ...$tree1
    ## ...$tree2
    ## where each tree contains:
    ## ...$tree (a vector of node labels)
    ## ...$cases (a named factor giving cluster composition, with names = node labels)
    ## ...$n.cases (the number of cases)

    ## The ouput is ordered by decreasing composition sizes.

    ## Each composition is ordered by decreasing ratio of
    ## n.cases / length(tree)

    out <- vector(length(trees), mode="list")
    names(out) <- names(trees)

    ## build the output list (not yet ordered)
    for (i in seq_along(trees)) {
            out[[i]] <- list()

            for (j in seq_along(trees[[i]])) {
                tree <-  trees[[i]][[j]]
                cases = factor(stats::na.omit(x$group[tree]))
                out[[i]][[j]] <- list(tree = tree,
                                      cases = cases,
                                      n.cases = length(cases)
                                      )
            }

            names(out[[i]]) <- paste("tree", seq_along(trees[[i]]), sep = ".")
    }

    ## order the output by composition size
    n.cases <- vapply(out, function(e) e[[1]]$n.cases, 0L)
    new.order <- order(n.cases, decreasing=TRUE)
    out <- out[new.order]

    ## order each composition by n.cases/tree size ratio
    for (i in seq_along(out)) {
        ratio <- vapply(out[[i]], function(e) e$n.cases / length(e$tree),
                        double(1))
        new.order <- order(ratio, decreasing=TRUE)
        out[[i]] <- out[[i]][new.order]
    }

    return(out)
}
