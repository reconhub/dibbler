#' Accessors for the dibbler objects
#'
#' These functions allow to access the content of \code{dibbler} objects.
#'
#'
#' @rdname accessors
#' 
#' @aliases dibbler_accessors
#' 
#' @seealso \code{\link{make_dibbler}} to create \code{dibbler} objects.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#' 
#' @export

"$.dibbler" <- function(x, name){
    if (name %in% c("network", "graph")) {
        name <- "contacts"
    }

    return(x[[name]])
}






#' @rdname accessors
#' @export

"[.dibbler" <- function(x, ...) {
    out <- getS3method("[", "epicontacts")(x, ...)
    nodes_in_graph <- epicontacts::get_id(out, "contacts")
    nodes_to_keep <- names(out$node_type) %in% nodes_in_graph
    out$node_type <- out$node_type[nodes_to_keep]
    return(out)
}
