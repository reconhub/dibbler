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
#' A list of monochromatic trees assembled by case composition, so that each component
#' corresponds to a unique set of cases.  Each composition contains the following components:
#'
#' \itemize{
#' \item cases: a vector of case node labels
#' \item n.cases: the number of cases in this composition
#' \item trees: a list of corresponding monochromatic trees
#' }
#' Each tree is defined as a vector of node labels.
#' Compositions are ordered by sizes (largest trees first).
#'
#' Within a composition, trees are ordered from the smallest one (i.e., closest to the tips) to the
#' largest one.
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
#'
#' out[[1]] # look at largest composition
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

    ##   $[case.composition1]
    ##   $[case.composition2]
    ## ...

    ## Where a composition is a defined as a set of cases included in the tree; each case
    ## composition is a list with:
    ##   $cases: vector of case node labels
    ##   $n.cases: number of cases
    ##   $trees: a list of trees

    ## where each tree is a vector of node labels.

    ## The ouput is ordered by decreasing composition sizes.

    ## Each composition is ordered by decreasing ratio of
    ## n.cases / length(tree)

    out <- vector(length(trees), mode="list")
    names(out) <- names(trees)

    ## build the output list (not yet ordered)
    for (i in seq_along(trees)) {
        out[[i]] <- list()
        first.tree <- trees[[i]][[1L]]
        out[[i]]$cases <- factor(stats::na.omit(x$group[first.tree]))
        out[[i]]$n.cases <- length(out[[i]]$cases)
        out[[i]]$trees <- trees[[i]]
    }

    ## order the output by composition size
    n.cases <- vapply(out, function(e) e$n.cases, 0L)
    new.order <- order(n.cases, decreasing=TRUE)
    out <- out[new.order]

    ## order each composition by n.cases/tree size ratio
    ## as each composition has the same number of cases,
    ## we effectively sort by increasing tree size
    for (i in seq_along(out)) {
        tree.size <- sapply(out[[i]]$trees, length)
        new.order <- order(tree.size)
        out[[i]]$trees <- out[[i]]$trees[new.order]
    }

    return(out)
}
