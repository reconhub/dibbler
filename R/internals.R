string_in <- function(str, x, ...) {
    length(grep(str, x, ...)) > 0L
}
