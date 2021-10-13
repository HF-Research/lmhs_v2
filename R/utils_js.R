header_JS <- function(background_color, text_color){
  JS(
    # Table hearder background color
    paste0("function(settings, json) {",
           "$(this.api().table().header()).css({'background-color': '", background_color, "', 'color':'",text_color,"'});",
           "}"
    )
  )
}

buttit_html <- function(x){
  paste0("<ui><li>",
         paste0(x, collapse = "</li><li>"),
         "</ui></li>")
}

re_order_plot <- function(x, last_response_str){
  x <- x[,.(response, percent)]
  setorder(x, -percent)
  sub <- x[!grepl(last_response_str, response)]
  sub_last <- x[grepl(last_response_str, response)]
  out <- rbind(sub, sub_last)
  out[, plot_order:=1:.N]
  out
}
