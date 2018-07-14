#' Clean Data
#' 
#' @description This function takes the raw dataset and returns 
#' it in a readable format. The function also omits records with
#' \code{NA} values for \code{YEAR}, \code{MONTH}, \code{DAY}, 
#' \code{EQ_PRIMARY} and \code{INTENSITY}. If \code{TOTAL_DEATHS} 
#' is \code{NA}, then the function will return \code{DEATH_COUNT = 0}. 
#' If the file does not exist, then the function will print an error 
#' message and return a \code{NULL} object.
#'
#' @param file A character string representing the dataset file
#'   path and file name
#' 
#' @importFrom readr read_delim
#' @importFrom dplyr select mutate rename filter
#' @importFrom lubridate dmy
#'
#' @return This function returns a cleaned dataframe, from \code{YEAR = 1900} 
#' onwards, with the following 8 fields:
#' \itemize{
#'  \item{DATE}
#'  \item{LATITUDE}
#'  \item{LONGITUDE}
#'  \item{COUNTRY}
#'  \item{LOCATION}
#'  \item{MAGNITUDE}
#'  \item{INTENSITY}
#'  \item{DEATH_COUNT}
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
      dplyr::select(YEAR, MONTH, DAY, LATITUDE, LONGITUDE, COUNTRY, LOCATION_NAME,
                    EQ_PRIMARY, INTENSITY, TOTAL_DEATHS) %>%
      dplyr::filter(YEAR >= 1900, MONTH >= 1, DAY >= 1,
                    !is.na(EQ_PRIMARY), !is.na(INTENSITY)) %>%
      dplyr::mutate(DATE = lubridate::dmy(paste(DAY, MONTH, YEAR, sep = "/")),
                    LATITUDE = as.numeric(LATITUDE),
                    LONGITUDE = as.numeric(LONGITUDE),
                    EQ_PRIMARY = as.numeric(EQ_PRIMARY),
                    INTENSITY = as.numeric(INTENSITY),
                    TOTAL_DEATHS = ifelse(is.na(TOTAL_DEATHS), 0, TOTAL_DEATHS),
                    TOTAL_DEATHS = as.numeric(TOTAL_DEATHS)) %>%
      dplyr::rename(LOCATION = LOCATION_NAME, 
                    MAGNITUDE = EQ_PRIMARY,
                    DEATH_COUNT = TOTAL_DEATHS) %>%
      dplyr::select(DATE, LATITUDE, LONGITUDE, COUNTRY, LOCATION, 
                    MAGNITUDE, INTENSITY, DEATH_COUNT)
  }else{
    clean_data <- raw_data
  }
  
  return(clean_data)
}