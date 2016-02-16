#' Process input data for dibbler
#'
#' This function ...
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @param graph a input for buidling a graph (see details)
#' @param group a factor defining genetic clusters
#' @param data a list containing inputs for  \code{\link{dibbler}} as returned by \code{dibbler.data}
#'
#' @export
#' @importFrom igraph graph.data.frame V
#'
#' @return a list of data suitable for input for \code{\link{dibbler}}
#'
#' @examples
#'
dibbler.data <- function(graph=NULL, group=NULL, data=NULL){
    ## PROCESS INPUT ##
     ## HANDLE 'DATA' ##
    if(!is.null(data)){
    ## escape if data has been processed already
        if(inherits(data,"dibbler.input")) return(data)
    } else if(is.null(graph) || is.null(group)){
        stop("graph or group missing, and 'data' not provided")
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
        graph <- network2igraph(graph)
    }

    ## HANDLE GROUP ##
    if(is.character(group) || is.numeric(group)) group <- factor(group)
    if(!is.factor(group)) stop("group is not a factor")
    if(is.null(names(group))){
        stop("group factor has no names")
    }


    ## MATCH NETWORK AND GROUPS LABELS ##
    ## find matching labels
    lab.graph <- labels(igraph::V(graph))
    lab.group <- names(group)
    lab.match <- intersect(lab.graph, lab.group)
    if(length(lab.match)==0L) {
        stop("no match between vertices and group labels")
    }
    ## index of nodes in match
    id.graph.match <- which(lab.graph %in% lab.match)
    ## index of cases in match
    id.group.match <- which(lab.group %in% lab.match)

    ## EXTRACT NETWORK FEATURES ##
    ## index of terminal nodes
    id.terminal <- which(!lab.graph %in% igraph2data.frame(graph)$from)
    ## index of basal nodes
    id.basal <- which(!lab.graph %in% igraph2data.frame(graph)$to)
    ## index of internal nodes
    id.internal <- which(lab.graph %in% igraph2data.frame(graph)$from)

    ## label of terminal nodes
    lab.terminal <- lab.graph[id.terminal]
    ## label of basal nodes
    lab.basal <- lab.graph[id.basal]
    ## label of internal nodes
    lab.internal <- lab.graph[id.internal]


    ## RETURN OUTPUT ##
    out <- list(graph=graph,
                group=group,
                lab.match=lab.match,
                id.graph.match=id.graph.match,
                id.group.match=id.group.match,
                id.terminal=id.terminal,
                id.basal=id.basal,
                lab.terminal=lab.terminal,
                lab.basal=lab.basal
                )
    class(out) <- c("list", "dibbler.input")
    return(out)
} # end dibbler.data
