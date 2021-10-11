make_plotly <-
  function(strat,
           dat,
           q,
           large_plot,
           axis_title_x,
           num_digits,
           hq) {
    if (strat == "Svarfordeling") {
      plot_out <- dat %>%
        plot_ly()

      if (large_plot) {
        plot_out <- plot_out %>% add_trace(
          x = ~ percent,
          y = ~ reorder(response, percent),
          type = "bar"
        )
        return(list(plot = plot_out))
      }
      plot_out <- plot_out %>% add_trace(
        x = ~ reorder(response, group),
        y = ~ percent,
        type = "bar"
      )
      return(list(plot = plot_out))
    }


    if (strat == "Køn/alder") {
      tooltip <-
        paste0("%{text}: <br><b>%{y:,.",
               num_digits,
               "f}<extra></extra>")

      dat <- dat[get(txt_sex) != "Total"]

      if (hq) {
        plot_out <- dat %>%
          plot_ly() %>%
          add_trace(
            x = ~ Alder,
            y = ~ mean,
            color = ~ get(txt_sex),
            text =  ~ get(txt_sex),
            colors = graph_colors,
            type = "bar",
            hovertemplate = tooltip
          )
        return(list(plot = plot_out))
      }
      plot_out <- dat %>%
        plot_ly() %>%
        add_trace(
          x = ~ Alder,
          y = ~ percent,
          color = ~ get(txt_sex),
          text =  ~ get(txt_sex),
          colors = graph_colors,
          type = "bar",
          hovertemplate = tooltip
        )
      return(list(plot = plot_out))
    }
    if (hq) {
      plot_out <- dat %>%
        plot_ly() %>%
        add_trace(x = ~ strat_level,
                  y = ~ mean,
                  type = "bar")
      return(list(plot = plot_out))
    }
    plot_out <- dat %>%
      plot_ly() %>%
      add_trace(
        x = ~ reorder(strat_level, group),
        y = ~ percent,
        type = "bar"
      )
    return(list(plot = plot_out))
  }


format_plotly <-
  function(plot_out,
           large_plot,
           hq,
           long_title,
           plot_title,
           plot_title_sub,
           axis_title_x,
           axis_title_y,
           axis_font_size,
           tick_font_size,
           legend_font_size,
           num_digits) {
    bar_gap <- 0.4
    plot_out <- plot_out %>%
      layout(
        margin = list(t = 90),
        title = list(
          text = paste0(plot_title,
                        '<br>',
                        '<sub><i>',
                        plot_title_sub,
                        "</sub></i>"),
          x = 0,
          yanchor = "top",
          y = 0.95,
          font = list(family = c("Roboto"),
                      size = 25)
        ),
        xaxis = list(
          title = list(text = axis_title_x,
                       font = list(size = axis_font_size)),
          tickfont = list(size = tick_font_size)
        ),
        yaxis = list(
          title = list(text = axis_title_y,
                       font = list(size = axis_font_size)),
          tickfont = list(size = tick_font_size),
          tickformat = paste0(",.", num_digits)
        ),
        hoverlabel = list(font = list(size = 18)),
        legend = list(
          itemsizing = "constant",
          font = list(size = legend_font_size)
        )
      ) %>%
      config(
        locale = "da",
        modeBarButtonsToRemove = c(
          "zoomIn2d",
          "zoomOut2d",
          "zoom2d",
          "pan2d",
          "select2d",
          "lasso2d",
          "autoScale2d",
          "resetScale2d"
        )
      )


    if (large_plot) {
      plot_out <- plot_out %>% layout(
        hovermode = "y unified",
        xaxis = list(range = c(0, 100)),
        yaxis = list(title = list(standoff = 10))
      ) %>% config(toImageButtonOptions = list(
        filename = paste0("LMHS- "),
        width = 700,
        height = 1000,
        scale = "1"
      ))
    } else if (!hq) {
      plot_out <- plot_out %>%
        layout(hovermode = "x unified",
               yaxis = list(range = c(0, 100)),
               bargap=bar_gap) %>%
        config(toImageButtonOptions = list(
          filename = paste0("LMHS- "),
          width = 1000,
          height = 500,
          scale = "1"
        ))
    } else{
      plot_out <- plot_out %>%
        layout(hovermode = "x unified",
               yaxis = list(range = c(0, 3)),
               bargap=bar_gap
               ) %>%
        config(toImageButtonOptions = list(
          filename = paste0("LMHS- "),
          width = 1000,
          height = 500,
          scale = "1"
        ))
    }

    if (long_title) {
      plot_out <- plot_out %>% layout(margin = list(t = 130))
    }
    plot_out
  }
