#' Process input data for dibbler
#'
#' This function ...
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @param graph a input for buidling a graph (see details)
#' @param tree a phylogenetic tree with \code{phylo} class
#' @param data a list containing inputs for  \code{\link{dibbler}} as returned by \code{dibbler.data}
#'
#' @export
#' @importFrom intergraph asIgraph
#' @importFrom igraph graph.data.frame V
#'
#' @return a list of data suitable for input for \code{\link{dibbler}}
#'
#' @examples
#'
dibbler.data <- function(graph=NULL, tree=NULL, data=NULL){
    ## PROCESS INPUT ##
     ## HANDLE 'DATA' ##
    if(!is.null(data)){
    ## escape if data has been processed already
        if(inherits(data,"dibbler.input")) return(data)
    } else if(is.null(graph) || is.null(tree)){
        stop("graph or tree missing, and 'data' not provided")
    }


    ## HANDLE GRAPH ##
    ## input: data.frame / matrix
    ## (assumed ancestors -> descendent)
    if(is.data.frame(graph) || is.matrix(graph)){
        if(ncol(graph)<2) stop("edge matrix provided as graph has less than 2 columns")
        if(ncol(graph)>2) warning("edge matrix provided as graph has more than 2 columns; only using the first two")
        graph <- igraph::graph.data.frame(graph)
    }

    ## input: network
    if(inherits(graph, what="network")){
        graph <- intergraph::asIgraph(graph)
    }

    ## HANDLE TREE ##
    if(!inherits(tree, what="phylo")){
        stop("tree is not a phylo object")
    }


    ## MATCH TIPS AND NETWORK ##
    lab.graph <- labels(igraph::V(graph))
    lab.tree <- tree$tip.label
    lab.match <- intersect(lab.graph, lab.tree)
    if(length(lab.match)==0L) {
        stop("no match between vertices and tips")
    }
    id.graph.match <- match(lab.graph, lab.match)
    id.tree.match <- match(lab.tree, lab.match)



    ## RETURN OUTPUT ##
    out <- list(graph=graph,
                tree=tree,
                lab.match=lab.match,
                id.graph.match=id.graph.match,
                id.tree.match=id.tree.match
                )
    class(out) <- c("list", "dibbler.input")
    return(out)
} # end dibbler.data
