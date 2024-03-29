make_about_tables <- function(dat, col_names, order = FALSE, paging = FALSE, dom
                            = "Bt", search = FALSE) {

  colnames(dat) <- col_names

  DT::datatable(
    data = dat,
    extensions = 'Buttons',
    rownames = FALSE,
    class = ' hover row-border',
    selection = "multiple",
    options = list(
      ordering = order,
      paging = paging,
      searching = search,
      pageLength = 20,
      dom = dom,
      buttons = list('pdf'),
      initComplete = header_JS(DT_background_color, text_color = DT_text_color),
      autoWidth = TRUE

    )
  )

}
