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
