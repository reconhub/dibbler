#' Set up graphical options for graphs
#'
#' This function sets up graphical options for \code{igraph} objects.
#' Existing options include:
#' \describe{
#' \item{col.pal}{a color palette used for the groups; defaults to dibbler.pal1}
#' \item{layout}{a layout function used for plotting the graph; see \code{?layout_nicely} for more information.}
#' \item{seed}{a random seed to be used for plotting the graph}
#' \item{vertex.size}{the size of the vertices; defaults to 10}
#' \item{label.family}{a font family for labels; defaults to "sans"}
#' \item{label.color}{the color of the labels; defaults to "black"}
#' \item{edge.label}{a logical indicating if weights should be used to annotate the edges; defaults to FALSE}
#'}
#'
#' @param ... a list of named graphical options; see Description.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @export
#' @importFrom utils modifyList
#' @importFrom igraph "E" "E<-"
#'
#' @examples
#' dibbler.graph.opt()
#'
dibbler.graph.opt <- function(...){
    ## GET ARGUMENTS ##
    config <- list(...)

    ## SET DEFAULTS ##
    defaults <- list(col.pal=dibbler.pal2,
                     layout=layout_nicely,
                     seed=1,
                     vertex.size=10,
                     label.family="sans",
                     label.color="black",
                     edge.label=FALSE)

    ## MODIFY CONFIG WITH ARGUMENTS ##
    config <- modify.defaults(defaults, config)

    return(config)
} # end graph.setup





## non-export function to set graph options ##
set.graph.opt <- function(g, opt){
    ## check class
    if(!inherits(g, "igraph")) stop("g is not a igraph object")

    ## find clusters ##
    groups <- clusters(g)

    ## layout ##
    set.seed(opt$seed)
    g$layout <- opt$layout(g)

    ## vertices ##
    ## color
    groups$color <- opt$col.pal(groups$no)
    V(g)$color <- groups$color[groups$membership]

    ## size
    V(g)$size <- opt$vertex.size

    ## font
    V(g)$label.family <- opt$label.family

    ## font color
    V(g)$label.color <- opt$label.color

    ##  edges ##
    ## labels
    if(length(E(g))>0 && opt$edge.label) {
        E(g)$label <- E(g)$weight
    }

    ## color
    E(g)$label.color <-  opt$label.color

    ## font
    ##    E(g)$label.family <- "sans" # bugs for some reason

    ## RETURN GRAPH ##
    return(g)
} # set.graph.opt




## non-exported function by Rich Fitzjohn ##
modify.defaults <- function(defaults, x){
    extra <- setdiff(names(x), names(defaults))
    if (length(extra) > 0L){
        stop("Additional invalid options: ", paste(extra, collapse=", "))
    }
    modifyList(defaults, x)
} # end modify.defaults
