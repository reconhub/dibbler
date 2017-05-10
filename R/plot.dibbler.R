#' Plot input data for dibbler
#'
#' This function plots dibbler's input data as a network, using different
#' symbols and colors for different types of nodes. It uses the package
#' \code{network}.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @importFrom graphics plot
#' 
#' @importFrom magrittr "%>%"
#' 
#'
#' @export

plot.dibbler <- function(x, y = NULL, ...){

    df_to_add <- data.frame(id = names(x$node_type),
                            group = factor(x$node_type))

    x$linelist <- merge(x$linelist, df_to_add,
                        by = "id", all = TRUE)
    
    out <- getS3method("plot", "epicontacts")(x, y, ...)

    out <- out %>%
        visNetwork::visGroups(groupname = "terminal",
                              shape = "icon",
                              list(code = "f007", color = "red")) %>%
                                  visNetwork::addFontAwesome()
    
    return(out)
} # end plot.dibbler
