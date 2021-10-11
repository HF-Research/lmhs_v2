# TEXT --------------------------------------------------------------------
output$ui_guide_title <- renderText({
  ui_guide_title
})


output$ui_guide_text <- renderUI({
  x <- guide_text
  HTML(paste0(x, collapse = "<br><br>"))
})

