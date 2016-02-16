#' Color palettes used in vimes
#'
#' These functions are color palettes used in vimes.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @param n a number of colors
#'
#' @rdname palettes
#' @aliases palettes vimes.pal1 vimes.pal2
#'
#' @export
#' @importFrom grDevices colorRampPalette
#'
#' @examples
#'
#' plot(1:4, cex=8, pch=20, col=vimes.pal1(4), main="vimes.pal1")
#' plot(1:20, col=vimes.pal1(20), pch=20, cex=6, main="vimes.pal1")
#' plot(1:10, col=vimes.pal2(10), pch=20, cex=6, main="vimes.pal2")
vimes.pal1 <- function(n){
    colors <- c("#ff6666", "#666699")
    if(n<length(colors)) {
        return(colors[seq_len(n)])
    } else {
        return(colorRampPalette(colors)(n))
    }
}


#' @rdname palettes
#' @export
vimes.pal2 <- function(n){
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
