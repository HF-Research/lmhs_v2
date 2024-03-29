makeLeaflet <- function(
  map_data = map_data,
  fill_colors = fill_colors,
  label_popup = popup,
  mini_map_lines = dk_sp$mini_map_lines){

  leaflet(
    # elementId = element_id,
          options = leafletOptions(zoomControl = FALSE,
                                   preferCanvas = TRUE)) %>%
    setView(lng = 10.408,
            lat = 56.199752,
            zoom = 7,) %>%
    setMaxBounds(
      lng1 = 8.1,
      lng2 = 12.7,
      lat1 = 54.5,
      lat2 = 58.0
    ) %>%
    addPolygons(
      data = map_data,
      fillColor  = fill_colors,
      weight = 1,
      opacity = 1,
      color = "grey",
      fillOpacity = 0.9,
      label = label_popup,
      labelOptions = labelOptions(
        style = list("font-weight" = "normal", # CSS styles
                     padding = "3px 8px"),
        offset = c(0, 0),
        sticky = FALSE,
        textsize = "17px",
        direction = "auto",
        opacity = 1
      ),
      highlightOptions = highlightOptions(weight = 4,
                                          bringToFront = TRUE)
    ) %>%
    addPolylines(
      data = mini_map_lines,
      lng = ~ X1,
      lat = ~ X2,
      color = "grey",
      weight = 4
    )

}


