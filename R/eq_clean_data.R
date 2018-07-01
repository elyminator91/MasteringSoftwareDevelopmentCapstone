#' Clean Data
#' 
#' @description This function takes the raw dataset and returns 
#' it in a readable format. The function also omits records with
#' \code{NA} values. If the file does not exist, then the function 
#' will print an error message and return a \code{NULL} object.
#'
#' @param file A character string representing the dataset file
#'   path and file name
#' 
#' @importFrom readr read_delim
#' @importFrom dplyr select mutate rename
#' @importFrom lubridate dmy
#'
#' @return This function returns a clean dataframe with 4 fields:
#' \itemize{
#'  \item{DATE}
#'  \item{LATITUDE}
#'  \item{LONGITUDE}
#'  \item{LOCATION}
#' }
#' 
#' @source The raw dataset is obtained from National Geophysical 
#'   Data Center / World Data Service (NGDC/WDS): Significant 
#'   Earthquake Database. National Geophysical Data Center, NOAA. 
#'   (\href{http://dx.doi.org/10.7289/V5TD9V7K}{doi:10.7289/V5TD9V7K})
#' 
#' @export
#'
#' @examples
#' \dontrun{eq_clean_data("./inst/extdata/dataset.txt")}

eq_clean_data <- function(file){
  raw_data <- tryCatch({
    readr::read_delim(file, delim = "\t")
  }, error = function(e){
    print(paste("File", file, "does not exist. Please check."))
    return(NULL)
  })
  
  if(!is.null(raw_data)){
    clean_data <- raw_data %>% 
      dplyr::select(YEAR, MONTH, DAY, LATITUDE, LONGITUDE, LOCATION_NAME) %>%
      dplyr::mutate(DATE = lubridate::dmy(paste(DAY, MONTH, YEAR, sep = "/")),
                    LATITUDE = as.numeric(LATITUDE),
                    LONGITUDE = as.numeric(LONGITUDE)) %>%
      dplyr::rename(LOCATION = LOCATION_NAME) %>%
      na.omit() %>%
      dplyr::select(DATE, LATITUDE, LONGITUDE, LOCATION)
  }else{
    clean_data <- raw_data
  }
  
  return(clean_data)
}