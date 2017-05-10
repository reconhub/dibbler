#' Print method for dibbler objects
#'
#' This method prints the content of \code{dibbler} objects, giving an overview
#' of the food distribution network and the reported cases.
#'
#' @export
#'
#' @author Thibaut Jombart (\email{thibautjombart@@gmail.com})
#'
#' @param x A \code{\link{dibbler}} object.
#'
#' @param ... further parameters to be passed to other methods (currently not
#' used)
#'
print.dibbler <- function(x, ...){
    cat("\n/// Foodborne outbreak //\n")
    cat("\n  // class:", paste(class(x), collapse=", "))
    cat("\n  //", format(nrow(x$linelist),big.mark=","),
        "cases in linelist;",
        format(nrow(x$contacts), big.mark=","),
        "edges; ", ifelse(x$directed, "directed", "non directed"),
        "\n")

    cat("\n  // linelist\n\n")
    print(dplyr::tbl_df(x$linelist))

    cat("\n  // network\n\n")
    print(dplyr::tbl_df(x$contacts))

    cat("\n node types:")
    print(x$node_type)

    cat("\n")
}
