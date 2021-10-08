ui_tabpanel_DTs <- function(){
  tabPanel(
  title = "Tabeller",
  fluidRow(
    class = "row_outcome_title",
    column(
      11,
      class = "output_titles",
      align = "left",
      textOutput("outcome_title_dt"),
      br(),
      textOutput("outcome_title_sub_dt")
    )
  ),
  fluidRow(DTOutput("table_rate"))
)
}
