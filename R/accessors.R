#' Accessors for the dibbler objects
#'
#' These functions allow to access the content of \code{dibbler} objects.
#'
#' @seealso \code{\link{make_dibbler}} to create \code{dibbler} objects.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#' 
#' @export
#' 
"$.dibbler" <- function(x, name){
    if (name %in% c("network", "graph")) {
        name <- "contacts"
    }

    return(x[[name]])
}
