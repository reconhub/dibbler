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
#' @importFrom igraph "E" "E<-" "V" "V<-" "layout_nicely"
#'
#' @examples
#' dibbler.graph.opt()
#'
dibbler.graph.opt <- function(...){
    ## GET ARGUMENTS ##
    config <- list(...)

    ## SET DEFAULTS ##
    defaults <- list(col.pal=dibbler.pal1,
                     col=NULL,
                     layout=igraph::layout_nicely,
                     seed=1,
                     min.size=3,
                     max.size=10,
                     label.family="sans",
                     label.color="black",
                     edge.label=FALSE)

    ## MODIFY CONFIG WITH ARGUMENTS ##
    config <- modify.defaults(defaults, config)

    return(config)
} # end graph.setup





## non-export function to set graph options ##
set.graph.opt <- function(g, opt, freq, conf){
    ## check class
    if(!inherits(g, "igraph")) stop("g is not a igraph object")

    ## layout ##
    set.seed(opt$seed)
    g$layout <- opt$layout(g)

    ## vertices ##
    ## shape
    V(g)$shape <- "pie"

    ## pie values
    V(g)$pie <- freq

    ## pie color
    if(is.null(opt$col)){
        K <- length(freq[[1]]) # number of genetic clusters
        V(g)$pie.color <- list(opt$col.pal(K))
    } else {
        V(g)$pie.color <- list(opt$col)
    }

    ## size: proportional to 'confidence'
    vsize <- conf-min(conf) # set min to zero
    vsize[degree(g, mode="ou")==0] <- 0 # set tips to zero
    vsize <- (vsize/max(vsize)) * (opt$max.size - opt$min.size) # set offset from min
    vsize <- vsize + opt$min.size # set min

    V(g)$size <- vsize

    ## font
    V(g)$label.family <- opt$label.family

    ## font color
    V(g)$label.color <- opt$label.color

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
