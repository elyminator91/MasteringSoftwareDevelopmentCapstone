---
title: "MasteringSoftwareDevelopmentCapstone"
author: "Vignette Author"
date: "2018-07-15"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{MasteringSoftwareDevelopmentCapstone}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---



This package contains functions to clean and visualise earthquake data.

## Load Library

```r
library(readr)
library(dplyr)
library(stringr)
library(lubridate)
library(ggplot2)
library(leaflet)
library(MasteringSoftwareDevelopmentCapstone)
```

## Import Dataset
The raw dataset is obtained from National Geophysical Data Center / World Data Service (NGDC/WDS): Significant Earthquake Database. National Geophysical Data Center, NOAA. Click here [doi:10.7289/V5TD9V7K](http://dx.doi.org/10.7289/V5TD9V7K)

For convenience, the data has been preloaded into `./inst/extdata/dataset.txt`.


```r
raw_data <- system.file("extdata", "dataset.txt", 
                        package = "MasteringSoftwareDevelopmentCapstone")
```

## Clean Data
This create a cleaned data for earthquakes since 01 Jan 1900, excluding data points with missing magnitude or intensity.

```r
cleaned_data <- eq_clean_data(raw_data)
cleaned_data <- eq_location_clean(cleaned_data)
head(cleaned_data, 5)
#> # A tibble: 5 x 8
#>   DATE       LATITUDE LONGITUDE COUNTRY   LOCATION    MAGNI~ INTEN~ DEATH~
#>   <date>        <dbl>     <dbl> <chr>     <chr>        <dbl>  <dbl>  <dbl>
#> 1 1900-07-12     40.3      43.1 TURKEY    " Kars,Kar~   5.90   8.00    0  
#> 2 1900-10-09     57.1    -153   USA       Alaska:  K~   8.30   8.00    0  
#> 3 1900-10-29     11.0    - 66.0 VENEZUELA " Macuto"     8.40  10.0    25.0
#> 4 1900-12-25     43.0     146   RUSSIA    " Kuril Is~   7.90   9.00    0  
#> 5 1901-02-15     26.0     100   CHINA     " Yunnan P~   6.00   8.00    0
```

## Create Timeline Plot

```r
ggplot(data = cleaned_data, 
       aes(x = DATE, country = COUNTRY, label = LOCATION, magnitude = MAGNITUDE)) +
  geom_timeline(ctry = "MEXICO", xmin = dmy("01/01/2000"), xmax = dmy("01/01/2018")) +
  geom_timeline_label(n_max = 2, ctry = "MEXICO", 
                      xmin = dmy("01/01/2000"), xmax = dmy("01/01/2018")) +
  theme_classic()
```

![](MasteringSoftwareDevelopmentCapstone_files/figure-html/unnamed-chunk-6-1.png)<!-- -->

## Create Map Plot

```r
cleaned_data %>% 
  filter(COUNTRY == "MEXICO" & year(DATE) >= 2000) %>% 
  mutate(popup_text = eq_create_label(.)) %>% 
  eq_map(annot_col = "popup_text")
```

<!--html_preserve--><div id="htmlwidget-6706b7994fc59485fc99" style="width:480px;height:384px;" class="leaflet html-widget"></div>
<script type="application/json" data-for="htmlwidget-6706b7994fc59485fc99">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"addProviderTiles","args":["OpenStreetMap",null,null,{"errorTileUrl":"","noWrap":false,"zIndex":null,"unloadInvisibleTiles":null,"updateWhenIdle":null,"detectRetina":false,"reuseTiles":false}]},{"method":"addTiles","args":["//{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",null,null,{"minZoom":0,"maxZoom":18,"maxNativeZoom":null,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"continuousWorld":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":null,"unloadInvisibleTiles":null,"updateWhenIdle":null,"detectRetina":false,"reuseTiles":false,"attribution":"&copy; <a href=\"http://openstreetmap.org\">OpenStreetMap<\/a> contributors, <a href=\"http://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA<\/a>"}]},{"method":"addCircleMarkers","args":[[18.77,17.302,16.493,16.878,17.397,17.235,14.728,17.682],[-104.104,-100.198,-98.231,-99.498,-100.972,-100.746,-92.578,-95.653],[7.5,6,7.4,6.2,7.2,6.4,6.9,6.3],null,null,{"lineCap":null,"lineJoin":null,"clickable":true,"pointerEvents":null,"className":"","stroke":true,"color":"#03F","weight":2,"opacity":0.5,"fill":true,"fillColor":"#03F","fillOpacity":0.2,"dashArray":null},null,null,["<b>Location: <\/b> Villa De Alvarez, Colima, Tecoman, Jalisco<br><b>Magnitude: <\/b>7.5<br><b>Total Deaths: <\/b>29<br>","<b>Location: <\/b> Guerrero, Atoyac<br><b>Magnitude: <\/b>6<br><b>Total Deaths: <\/b>0<br>","<b>Location: <\/b> Guerrero, Oaxaca<br><b>Magnitude: <\/b>7.4<br><b>Total Deaths: <\/b>2<br>","<b>Location: <\/b> San Marcos, Acapulco<br><b>Magnitude: <\/b>6.2<br><b>Total Deaths: <\/b>0<br>","<b>Location: <\/b> Guerrero; Mexico City<br><b>Magnitude: <\/b>7.2<br><b>Total Deaths: <\/b>0<br>","<b>Location: <\/b> Tecpan<br><b>Magnitude: <\/b>6.4<br><b>Total Deaths: <\/b>0<br>","<b>Location: <\/b>Mexico; Guatemala:  San Marcos<br><b>Magnitude: <\/b>6.9<br><b>Total Deaths: <\/b>3<br>","<b>Location: <\/b> Oaxaca<br><b>Magnitude: <\/b>6.3<br><b>Total Deaths: <\/b>1<br>"],null,null,null,null]}],"limits":{"lat":[14.728,18.77],"lng":[-104.104,-92.578]}},"evals":[],"jsHooks":[]}</script><!--/html_preserve-->
