ui_tabpanel_graph <- function(height){
  tabPanel(title = "Grafer",
         br(),
         plotlyOutput("plot", height = height))
}
