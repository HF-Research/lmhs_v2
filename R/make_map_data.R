map_data <- function(dat = dat,
                     data_var ,
                     map_obj) {
# Merges map data to attribute data in preperation for plotting map
  keep_vars <- c("strat_level", data_var)

  # Set Zero values to NA - 0s mean <4 observations, so we don't know the actual
  # value
  dat[get(data_var) == 0, (data_var) := NA]


  out_map <- map_obj
  tmp_m <-
    dat[, ..keep_vars]

  out_map <-
    merge(tmp_m,
          out_map,
          by.x = "strat_level",
          by.y = "name_kom",
          all.y = TRUE)

  # Re-order data. For some reason this important, and it might map improperyly
  # if not done
  setorder(out_map, id)
  out_map <- st_as_sf(out_map)
  sf::st_crs(out_map) <- 4326
  out_map

}
