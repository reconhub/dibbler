######################################
## THESE FUNCTIONS ARE NOT EXPORTED ##
######################################



## This function checks data content, basically looking for a valid, non-empty dibbler.data. object.
check.data <- function(x) {
    if (is.null(x)) stop("x is NULL")
    if (!is.list(x)) stop("x is not a list")
    if (length(x) == 0L) stop("x has a length of zero")
    if (!inherits(x, "dibbler.data")) stop("x is not a dibbler.data object")
}
