#' Create Map Label
#'
#' @description This function takes a filted dataframe object and create
#' \code{html} format data labels for each earthquake point.
#' 
#' @param filtered_data A subset dataframe from the \code{eq_clean_data}
#'   function for the country and period of interest
#' 
#' @return A list of character type representing the description for each
#'   earthquake, including its location, magnitude, and total deaths
#'   
#' @export
#'
#' @examples
#' \dontrun{eq_create_label(.)}

eq_create_label <- function(filtered_data){
  
  popup_text = ""
  popup_text = paste0(popup_text, ifelse(!is.na(filtered_data$LOCATION),
                                         paste0("<b>Location: </b>", 
                                                filtered_data$LOCATION, 
                                                "<br>"), ""))
  popup_text = paste0(popup_text, ifelse(!is.na(filtered_data$MAGNITUDE),
                                         paste0("<b>Magnitude: </b>", 
                                                filtered_data$MAGNITUDE, 
                                                "<br>"), ""))
  popup_text = paste0(popup_text, ifelse(!is.na(filtered_data$DEATH_COUNT),
                                         paste0("<b>Total Deaths: </b>", 
                                                filtered_data$DEATH_COUNT, 
                                                "<br>"), ""))
  
  return(popup_text)
}