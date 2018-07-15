#' Create Map
#' 
#' @description This function takes a filted dataframe object and create
#' a map of the earthquakes with a popup label describing the earthquakes.
#'
#' @param filtered_data A subset dataframe from the \code{eq_clean_data}
#'   function for the country and period of interest
#' @param annot_col A character string representing the column name from
#'   the dataset from which the label of earthquake should be obtained
#' 
#' @importFrom leaflet leaflet addTiles addCircleMarkers
#' @import dplyr
#' 
#' @return A leaflet object representing the map of earthquake points
#' 
#' @export
#'
#' @examples
#' \dontrun{readr::read_delim("./inst/extdata/dataset.txt", delim = "\t") %>% 
#'   eq_clean_data() %>% 
#'   eq_location_clean() %>%
#'   filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>% 
#'   mutate(popup_text = eq_create_label(.)) %>% 
#'   eq_map(annot_col = "popup_text")}

eq_map <- function(filtered_data, annot_col = "DATE"){
  map = leaflet::leaflet() %>%
    leaflet::addProviderTiles(leaflet::providers$OpenStreetMap) %>%
    leaflet::addTiles() %>%
    leaflet::addCircleMarkers(data = filtered_data,
                              radius = ~ MAGNITUDE,
                              lng = ~ LONGITUDE,
                              lat = ~ LATITUDE,
                              popup = ~ filtered_data[[annot_col]],
                              weight = 2)
  return(map)
}