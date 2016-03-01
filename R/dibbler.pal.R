#' Color palettes used in dibbler
#'
#' These functions are color palettes used in dibbler.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @param n a number of colors
#'
#' @rdname palettes
#' @aliases palettes dibbler.pal1 dibbler.pal2
#'
#' @export
#' @importFrom grDevices colorRampPalette
#'
#' @examples
#'
#' plot(1:4, cex=8, pch=20, col=dibbler.pal1(4), main="dibbler.pal1")
#' plot(1:20, col=dibbler.pal1(20), pch=20, cex=6, main="dibbler.pal1")
#' plot(1:10, col=dibbler.pal2(10), pch=20, cex=6, main="dibbler.pal2")
dibbler.pal1 <- function(n){
    if(!is.numeric(n)) stop("n is not a number")
    colors <- c("#cc6666", "#ff8566", "#ffb366","#33cccc",
                "#85e0e0", "#adc2eb", "#9f9fdf","#666699")
    return(colorRampPalette(colors)(n))

}


#' @rdname palettes
#' @export
dibbler.pal2 <- function(n){
    if(!is.numeric(n)) stop("n is not a number")
    colors <- c("#ccddff", "#79d2a6", "#ffb3b3",
                "#a4a4c1","#ffcc00", "#ff9f80",
                "#ccff99", "#df9fbf","#ffcc99",
                "#cdcdcd")
    if(n<length(colors)) {
        return(colors[seq_len(n)])
    } else {
        return(colorRampPalette(colors)(n))
    }
}
