#' Clean Data (Location)
#' 
#' @description This function takes a dataframe object from the
#' \code{eq_clean_data} function and modifies the \code{LOCATION}
#' by removing the \code{COUNTRY} substring from the \code{LOCATION}
#' value. If the object is not a dataframe or has misnamed columns
#' for \code{COUNTRY} or \code{LOCATION}, then the function will
#' print an error message and return a \code{NULL} object.
#' 
#' @param clean_data A dataframe object returned by the 
#'   \code{eq_clean_data} function
#'
#' @return This function returns a cleaned dataframe, with the 
#' following 4 fields:
#' \itemize{
#'  \item{DATE}
#'  \item{LATITUDE}
#'  \item{LONGITUDE}
#'  \item{LOCATION}
#' }
#' 
#' @importFrom dplyr select mutate_
#' @importFrom lubridate dmy
#' @importFrom stringr str_replace str_to_title
#' 
#' @export
#'
#' @examples
#' \dontrun{eq_location_clean(clean_data)}

eq_location_clean <- function(clean_data){
  if(is.data.frame(clean_data)){
    clean_data <- tryCatch({
      clean_data %>%
        dplyr::mutate_(LOCATION = ~LOCATION %>%
                       stringr::str_replace(paste0(COUNTRY, ": "), "") %>%
                       stringr::str_to_title()) %>%
        dplyr::select(DATE, LATITUDE, LONGITUDE, LOCATION)
      }, error = function(e){
        print(paste("Invalid dataframe object. Columns should include",
                    "DATE, LATITUDE, LONGITUTE, COUNTRY, LOCATION."))
        return(NULL)
      })
  }else{
    print("Invalid variable type. Should be dataframe object.")
    return(NULL)
  }

  return(clean_data)
}
