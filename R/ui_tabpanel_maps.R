ui_tabpanel_map <- function(){
  tabPanel(
  title = "Kort",
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
        "map", width = 560, height = 550
      )
      # fluidRow(
      #   downloadButton(
      #     outputId = "downloadMapsMale",
      #     label = paste0(ui_download, " ", ui_sex_levels[2]),
      #     class = "btn radiobtn btn-default",
      #   )
      # )
    ),
    br()
  )
)
}
