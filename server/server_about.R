# DATATABLES --------------------------------------------------------------
aboutFAQDT <- reactive({
  colnames(about_dat_faq) <- col_names_faq
  n_col <- NCOL(about_dat_faq)
  DT::datatable(
    data = about_dat_faq,

    rownames = FALSE,
    class = ' hover row-border',
    selection = c("multiple"),
    options = list(
      lengthMenu = list(c(15, 50, -1), c('15', '50', 'Alle')),
      pageLength = 15,
      dom = "f",
      initComplete = header_JS(DT_background_color, text_color = DT_text_color)
    )
  ) %>%
    formatStyle(1:n_col, borderColor = "white") %>%
    formatStyle(columns = c(1), width = '30%')


})

aboutDiagDT <- reactive({
  col_names_diag <- names(d$diag)
  make_about_tables(d$diag, col_names_diag)

})

aboutEduDT <- reactive({
  col_subset <-
    c(paste0("edu_name_", lang),
      paste0("long_desc_", lang),
      "code_simple")
  edu <- edu[, ..col_subset]
  colnames(edu) <- col_names_edu

  edu[[1]] <- gsub("/ ", " / ", edu[[1]])

  edu[, (col_names_edu) := lapply(.SD, function(i) {
    gsub("<e5>", "å", i, fixed = TRUE)
  })]

  makeAboutTables(edu, col_names_edu)
})
# TEXT --------------------------------------------------------------------


output$ui_about_section_title <- renderText({
  inx <- purrr::map_lgl(about_choices, function(i) {
    i == input$about_selection
  })
  names(about_choices[inx])
})

# Pulls the text from txt_ui_objects.R
output$ui_about_desc <- renderUI({
  x <- about_text[[input$about_selection]]

  HTML(paste0(x, collapse = "<br><br>"))
})


# RENDER ------------------------------------------------------------------

output$table_faq <- renderDT({
  aboutFAQDT()
}, server = FALSE)

output$table_diag <- renderDT({
  if(input$about_selection!="pop")
    return(NULL)
  aboutDiagDT()
}, server = FALSE)
output$table_edu <- renderDT({
  aboutEduDT()
}, server = FALSE)


# DOWNLOAD CUTPOINTS ------------------------------------------------------

output$download_pat <- downloadHandler(
  filename = "variable_cutpoints_patienter.pdf",
  content = function(file) {
    file.copy("pre_processing/cp.pdf", file)
  }
)

output$download_paar <- downloadHandler(
  filename = "variable_cutpoints_paaroerende.pdf",
  content = function(file) {
    file.copy("pre_processing/cp_paar.pdf", file)
  }
)

