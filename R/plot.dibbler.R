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
#' @param x A \code{dibbler} object.
#'
#' @param y An optional variable from the linelist defining groups used to color
#' the network.
#'
#' @param col_pal A color palette to be used for the groups; defaults to
#' \code{dibbler_pal1}.
#'
#' @param ... Further arguments passed to the \code{plot.epicontacts} method.
#' 
#' @export
#'
#' @examples
#'
#' \dontrun{
#' if (require(outbreaks)) {
#' 
#'   v_data <- s_enteritidis_pt59$graph
#'   n_data <- data.frame(id = names(s_enteritidis_pt59$cluster),
#'                        cluster = s_enteritidis_pt59$cluster)
#'
#'   x <- make_dibbler(v_data, n_data)
#'   x
#'
#'   plot(x)
#'   plot(x, "cluster")
#' }
#' }

plot.dibbler <- function(x, y = NULL, col_pal = dibbler_pal1,
                         ...){
    df_to_add <- data.frame(id = names(x$node_type),
                            group = factor(x$node_type))

    x$linelist <- merge(x$linelist, df_to_add,
                        by = "id", all = TRUE)


    ## If 'y' is provided, this information is used to define groups. If not
    ## available, default groups will be defined by their types (entry,
    ## internal, or terminal).
    
    if (!is.null(y)) {
        new_group <- paste(x$linelist$group,
                           x$linelist[, y], sep = "_")
        new_group <- sub("_NA$", "", new_group)
        x$linelist$group <- factor(new_group)
    }

    groups <- levels(x$linelist$group)
    nb_groups <- length(groups)


    ## Here we define group attributes based on type for the shape, and 'y' for
    ## the color (the latter is optional)

    colors <- rep("grey", nb_groups)
    colors[grep("entry", groups)] <- "black"
    id_to_color <- grep("_", groups)
    new_colors <- fac2col(grep("_", groups, value = TRUE), col_pal)
    colors[id_to_color]  <- new_colors
    
    
    icons <- vector(mode = "list", length = nb_groups)
    for (i in seq_len(nb_groups)) {
        if (string_in("entry", groups[i])) {
            code <- "f140"
            size <- 60
        } else if (string_in("internal", groups[i])) {
            code <- "f015"
            size <- 50
        } else {
            code <- "f007"
            size <- 40
        }
        
        icons[[i]] <- list(code = code,
                           size = size,
                           color = colors[i])
    }
    
    out <- utils::getS3method("plot", "epicontacts")(x, y = NULL, ...)

    for (i in seq_len(nb_groups)) {
        out <- out %>%
            visNetwork::visGroups(
                groupname = groups[i],
                shape = "icon",
                icon = icons[[i]]
                )
    }
    
    out <- out %>% visNetwork::addFontAwesome()
    
    return(out)
} # end plot.dibbler
