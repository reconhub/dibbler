#' Modelling food-borne outbreaks using genetic data
#'
#' The function \code{dibbler} is used for inferring the transmission of food-borne diseases across a food distribution network using pathogen genome sequences sampled for a set of cases.
#'
#' !!! This package is still under development. Do not use it without contacting the author. !!!
#'
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @export
#'
#' @param x a list of the class 'dibbler.input' as returned by \code{\link{dibbler.data}}.
#' @param ... further arguments to be passed to other functions
#'
#' @seealso
#' \describe{
#' \item{\code{\link{dibbler.data}}}{to prepare the input data.}
#' }
#'
#' @examples
#'
dibbler <- function(x=dibbler.data(), ...){
    ## CHECKS ##
    if(is.null(x)) stop("x is NULL")
    if(!is.list(x)) stop("x is not a list")
    if(!inherits(x, "dibbler.input")) stop("x is not a dibbler.input object")

    ## SHAPE/RETURN OUTPUT ##
    out <- list()

    return(out)
} # end dibbler
