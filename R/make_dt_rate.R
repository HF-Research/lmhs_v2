make_dt_rate <- function(dat,
                         col_titles = NULL,
                         group_var = NULL,
                         dt_title = NULL,
                         messageTop = NULL,
                         messageBottom = NULL,
                         n_col = NULL,
                         thousands_sep = thousands_sep,
                         dec_mark = dec_mark,
                         digits = digits) {
  num_format_cols <- (1:n_col)[-1]
  hq <- length(num_format_cols) == 1
  rate_col <- num_format_cols[1]
  count_col <- num_format_cols[2]
  out <- DT::datatable(
    data = dat,
    extensions = 'Buttons',
    rownames = FALSE,
    class = 'hover row-border',
    options = list(
      language = list(url = "Danish.json"),
      lengthMenu = list(c(15, 50, -1), c('15', '50', 'Alle')),
      pageLength = 15,
      dom = "tBr",

      buttons = list(
        list(
          extend = "pdf",
          title = dt_title,
          messageTop = messageTop,
          messageBottom = messageBottom
        ),
        list(
          extend = "copy",
          title = dt_title,
          messageTop = messageTop,
          messageBottom = messageBottom
        )
      ),
      initComplete = header_JS(DT_background_color, text_color = DT_text_color)
    )
  )  %>%
    formatCurrency(
      columns = rate_col,
      currency = "",
      interval = 3,
      mark = thousands_sep,
      dec.mark = dec_mark,
      digits = 1
    ) %>%
    formatStyle(1:n_col, borderColor = "white") %>%
    # formatStyle(group_var,  fontWeight = "bold") %>%
    formatStyle(
      columns = names(dat),
      backgroundColor = DT_background_color,
      color = DT_text_color
    )
  if (!hq) {
    out <- out %>%
      formatCurrency(
        columns = count_col,
        currency = "",
        interval = 3,
        mark = thousands_sep,
        dec.mark = dec_mark,
        digits = 0
      )
  }
  out
}
