ui_tabpanel_map <- function(){
  tabPanel(
  title = txt_tab_title_map,
  fluidRow(
    class = "row_outcome_title",
    column(
      11,
      class = "output_titles",
      align = "left",
      textOutput("outcome_title_map"),
      br(),
      textOutput("outcome_title_sub_map")
    )
  ),
  fluidRow(
    column(
      class = "col_leaflet",
      12,
      align = "left",
      leafletOutput(
        "map", width = 570, height = 550
      ),
      fluidRow(
        downloadButton(
          outputId = "download_map",
          label = paste0(txt_download),
          class = "btn radiobtn btn-default",
        )
      )
    ),
    br()
  )
)
}
