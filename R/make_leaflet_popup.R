make_leaflet_popup <- function(geo_name, var_title1, data,percent) {

  # geo_name is place name. var_title1 and var_title two is the title broken
  # where two spaces occur ("  "). Data is the datapoint passed to the function
  out <- paste0(
    "<strong><center>",
    geo_name,
    '</strong></center>',
    '<p style = "font-size:0.8em; margin-bottom:0px">',
    var_title1, ": ",
    '</p>',
    '<strong><center><p style = "font-size:1.2em; margin-bottom:0px">',
    formatC(data, big.mark = ".", decimal.mark = ",", format = "f", digits = 1)

  )
  if(percent){
    out <- paste0(out, "%")
  }
  out <- paste0(out,"</strong></p></center>")
  lapply(out, htmltools::HTML)

}
