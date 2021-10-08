map_data <- function(dat = dat,
                     data_var ,
                     map_obj) {
  browser()
  keep_vars <- c("id", pretty_aggr_level, data_var)
  keep_data_vars <- c(ui_sex, pretty_aggr_level, data_var)
  # Set Zero values to NA - 0s mean <4 observations, so we don't know the actual
  # value
  dat[get(data_var) == 0, (data_var) := NA]

  # MALES
  out_m <- map_obj
  tmp_m <-
    dat[get(ui_sex) == "male" &
          get(pretty_aggr_level) != "Unknown", ..keep_data_vars]

  out_m <-
    merge(tmp_m,
          out_m,
          by.x = pretty_aggr_level,
          by.y = "name_kom",
          all.y = TRUE)

  # Remove unneed vars and re-order data
  out_m <- out_m[, (ui_sex) := NULL]
  setorder(out_m, id)

  # Female
  out_f <- map_obj
  tmp_f <-
    dat[get(ui_sex) == "female" &
          get(pretty_aggr_level) != "Unknown", ..keep_data_vars]

  out_f <-
    merge(tmp_f,
          out_f,
          by.x = pretty_aggr_level,
          by.y = "name_kom",
          all.y = TRUE)

  # Remove unneed vars and re-order data
  out_f <- out_f[, (ui_sex) := NULL]


  # Combine for output
  out <- list(male = out_m,
              female = out_f)
  out <- lapply(out, st_as_sf)
  st_crs(out$male) <- 4326
  st_crs(out$female) <- 4326

  out

}
