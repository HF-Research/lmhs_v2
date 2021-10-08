make_static_map <- function(dat,
                            map_obj,
                            data_var,
                            legend_text,
                            mini_map_lines = dk_sp$mini_map_lines,
                            pretty_variable = prettyVariable()[2],
                            plot_title = plotTitle(),
                            thousands_sep = thousands_sep,
                            dec_mark = dec_mark) {
  z <- map_obj

  mini_map_lines <- as.data.table(mini_map_lines)
  legend_title <- legend_text %>%
    gsub(pattern = ": ", "\n", .)

  fill_var <- sym(data_var)
  dat_range <- range(dat, na.rm = TRUE)
  mid_point <- dat_range[2] - ((dat_range[2] - dat_range[1]) / 2)

  ggplot() +
    geom_sf(data = z, aes(fill = !!fill_var), color = "grey35") +
    scale_fill_gradientn(
      # low = "#FFFFCC",
      # mid = "#FD8D3C",
      # midpoint = mid_point,
      # high = "#800026",
      colors = RColorBrewer::brewer.pal(9, name = "YlOrRd"),
      limits = dat_range,
      labels = function(x)
        format(
          x,
          big.mark = thousands_sep,
          decimal.mark = dec_mark,
          scientific = FALSE
        )
    ) +
    geom_segment(
      data = mini_map_lines,
      color = "grey",
      size = 1.2,
      aes(
        x = mini_map_lines[name == "bottom_left"]$X1,
        xend = mini_map_lines[name == "bottom_right"]$X1+0.1,
        y = mini_map_lines[name == "bottom_right"]$X2,
        yend = mini_map_lines[name == "bottom_right"]$X2
      )
    ) +
    # This is invisible and serves only to extend the map canvas to the right,
    # so there is space to move the legend to the right.
    geom_segment(
      data = mini_map_lines,
      color = "white",
      size = 1.2,
      aes(
        x = mini_map_lines[name == "bottom_left"]$X1,
        xend = mini_map_lines[name == "bottom_right"]$X1+1.5,
        y = mini_map_lines[name == "bottom_right"]$X2-0.1,
        yend = mini_map_lines[name == "bottom_right"]$X2-0.1
      )
    )+
    geom_segment(
      data = mini_map_lines,
      color = "grey",
      size = 1.2,
      aes(
        x = mini_map_lines[name == "bottom_left"]$X1,
        xend = mini_map_lines[name == "bottom_left"]$X1,
        y = mini_map_lines[name == "bottom_left"]$X2,
        yend = mini_map_lines[name == "top_left"]$X2
      )
    ) +
    annotate(
      "text",
      x = mini_map_lines$X1[3] - 2.2,
      y = mini_map_lines$X2[3] - 2.0,
      label = "Credit: Livetmedenhjertesygdom.dk",
      size = 3.5,
      fontface = "italic",
      color = "grey30"
    )+
    theme_void() +
    labs(
      fill = legend_title,
      title = stringr::str_wrap(plot_title, 55)
    )+

    theme(
      legend.position = c(0.82, 0.82),
      legend.text = element_text(size = 14),
      legend.title = element_text(size = 14),
      plot.title = element_text(size = 19)
    ) +  guides(fill = guide_colourbar(barwidth = 1,
                                       barheight = 10))

}
