# UI INPUT ----------------------------------------------------------------

# These observeEvents are needed to check and update the possible question to
# show in the question dropdown menu
observeEvent(input$person_type, {
  topic_choices <- d$topics_by_person[[input$person_type]]
  updateSelectizeInput(
    session,
    inputId = "topic",
    label = choose_topic,
    choices = topic_choices,
    selected = topic_choices[1]
  )

})

observeEvent(input$topic, {
  req(input$topic)
  question_choices <-
    d$q_by_topic_person[[paste0(input$person_type, ".", input$topic)]]
  freezeReactiveValue(input, "question_name_short")
  updateSelectizeInput(
    session,
    inputId = "question_name_short",
    label = choose_question,
    choices = question_choices,
    selected = question_choices[1]
  )
})

observeEvent(input$question_name_short, {
  req(input$question_name_short)
  strat_choices <-
    d$strat_by_item[[paste0(input$person_type, ".", input$question_name_short)]]
  freezeReactiveValue(input, "strat")
  updateRadioGroupButtons(
    session,
    inputId = "strat",
    label = choose_stratification,
    choices = strat_choices,
    selected = strat_choices[1]
  )
})

observe(label = "tabsMaps", {
  # Shows map tab only when geo data is selected
  shinyjs::toggle(
    condition = (input$strat == "Region" && !hq()),
    selector = paste0("#data_vis_tabs li a[data-value=", txt_tab_title_map, "]")
  )
})

# Switch tabs when isGeo == FALSE
observeEvent(label = "forceTabSwitchMap", input$strat, {
  if (input$data_vis_tabs == txt_tab_title_map &&
      input$strat != "Region")
    updateTabsetPanel(session = session,
                      inputId = "data_vis_tabs",
                      selected = "Grafer")
})


# DATA --------------------------------------------------------------------

plot_data <- reactive({
  x <- input$strat
  y <- input$question_name_short
  # I can't remember why an isolate() is needed here, but I guess it is to stop
  # needless invalidations of some of the inputs
  isolate(d$dat[person_type == input$person_type &
                  topic_dk == input$topic &
                  question_name_short == input$question_name_short &
                  strat == input$strat])

})
# CASE --------------------------------------------------------------------
case <- reactive({

  # This is to simplify the logic around switching between the differnt types of
  # results that are shown
  req(input$question_name_short)
  case <- "pat_svar"
  if (input$person_type == "paar")
    if (input$strat == "Køn/alder") {
      case <- "paar_age_sex"
    } else if (input$strat != "Svarfordeling") {
      case <- "paar_strat"
    } else{
      case <- "paar_svar"
    }

  else if (input$strat == "Køn/alder") {
    case <- "pat_age_sex"
    if (hq())
      case <- "pat_age_sex_mean"
  } else if (input$strat != "Svarfordeling") {
    case <- "pat_strat"
    if (hq())
      case <- "pat_strat_mean"
  }
  case
})
# PRETTY TEXT -------------------------------------------------------------

pretty_title <- reactive({
  plot_title <-
    str_wrap(plot_data()[1]$questionText, width = 75)
  plot_title
})

pretty_title_sub <- reactive({
  plot_title_sub <- ""
  if (hq()) {
    plot_title_sub <- "Max score er 3, højere score er bedre"
  }
  else if (input$strat != "Svarfordeling") {
    plot_title_sub <- plot_data()$response[1]

  } else if (plot_data()[, converted_binary == 1][1]) {
    plot_title_sub <- plot_data()$converted_binary_response[1]
  }
  plot_title_sub
})

output$outcome_title_dt  <- renderText({
  req(input$strat)
  pretty_title()
})

output$outcome_title_sub_dt <- renderText({
  req(input$question_name_short,
      input$strat,
      nrow(plot_data()) > 0)
  pretty_title_sub()
})
output$outcome_title_map  <- renderText({
  req(input$strat)
  pretty_title()
})

output$outcome_title_sub_map <- renderText({
  req(input$question_name_short,
      input$strat,
      nrow(plot_data()) > 0)
  pretty_title_sub()
})

# HELPER TEXT -------------------------------------------------------------
output$outcome_description <- renderUI({
  req(input$question_name_short,
      input$strat, nrow(plot_data()) > 0)
  x  <- gsub(pattern = "[0-9]", '', input$question_name_short)
  if (nchar(x) == 0)
    return(" ")
  x  <- gsub(pattern = "^.", '', x)
  x <- str_trim(x)

  out <-
    d$scales[var_name_short == x, .(var_name_new, text)]
  if (nrow(out) == 0)
    return("")

  out_title <- tags$b(out$var_name_new)
  tagList(out_title, out$text)
  # Add link for further reading - if link exists, otherwise just desc
  # url <- a(ui_read_more,
  #          href = (out$link),
  #          target = "_blank")
  #
  # if (out$link != "na") {
  #   tagList(out_title, out$desc, url)
  # }
  # else {
  #   tagList(out_title, out$desc)
  # }

})

output$helper_weighted <- renderUI({
  req(input$question_name_short,
      input$strat, nrow(plot_data()) > 0)

  if (input$person_type != "pat")
    return(" ")
  out_title <- tags$b(txt_weighted_helper_title)
  tagList(out_title, txt_weighted_helper)


})



# HELPER REACTIVES --------------------------------------------------------
valid_plot <- reactive({
  req(input$topic,
      input$question_name_short,
      input$strat,
      nrow(plot_data()) > 0)
  TRUE
})

hq <- reactive({
  # HeartQol plots are different in a couple ways, so this is a simple reactive
  # to flag those items
  hq <- FALSE
  hq <- grepl("HeartQol", input$question_name_short)
  hq
})


response_to_last <- reactive({
  # For some of the battery items, we want to move a specific response to the
  # bottom of the plot. This is usually because we want the equivilant of a NA
  # resopnse to be shown at the bottom.
  req(valid_plot())
  plot_dat <- plot_data()
  if (input$person_type == "pat") {
    return(last_response_switch_pat(plot_dat$question_number[1]))
  }
   return(last_response_switch_paar(plot_dat$question_number[1]))
})

large_plot <- reactive({
  flag_large_plot(x = plot_data(),
                  input$strat,
                  input$person_type,
                  input$question_name_short)
})


# PLOT --------------------------------------------------------------------

output$plot <- renderPlotly({
  req(valid_plot())
  input$strat
  input$question_name_short
  isolate({
    large_plot <- large_plot()
    title_length <- nchar(pretty_title())
    long_title <- title_length > 150 | nchar(pretty_title_sub()) > 1

    # Axis labels
    axis_title_y <- "Vægtet andel(%)*"
    if (input$person_type == "paar") {
      axis_title_y <- "Andel(%)"
    } else if (hq()) {
      axis_title_y <- "Vægtet mean*"
    }
    axis_title_x <-
      plot_data()[, strat][1]
    if (input$strat == "Svarfordeling") {
      axis_title_x <- ""
    }

    # Formatting
    axis_font_size <- 20
    tick_font_size <- 15
    legend_font_size <- 20

    if (large_plot) {
      tmp <- axis_title_x
      axis_title_x <- axis_title_y
      axis_title_y <- tmp
      tick_font_size <- 13
    }
    # Action
    plot_dat <- plot_data()
    selected_response <- response_to_last()
    unique_plot_order <- !is.null(selected_response)
    if (unique_plot_order) {
      plot_dat <-
        re_order_plot(x = plot_dat,
                      last_response_str = selected_response)
    }

    plot <- make_plotly(
      strat = input$strat,
      dat = plot_dat,
      q = input$question_name_short,
      large_plot = large_plot,
      unique_plot_order = unique_plot_order,
      axis_title_x = axis_title_x,
      num_digits = 1,
      hq = hq()
    )
    format_plotly(
      plot_out = plot$plot,
      large_plot = large_plot,
      hq = hq(),
      long_title = long_title,
      plot_title = pretty_title(),
      plot_title_sub = pretty_title_sub(),
      axis_title_x = axis_title_x,
      axis_title_y = axis_title_y,
      axis_font_size = axis_font_size,
      tick_font_size = tick_font_size,
      legend_font_size = legend_font_size,
      num_digits = 1
    )
  })
})


# TABLES ------------------------------------------------------------------
output$table_rate <- renderDT({
  req(input$topic,
      input$question_name_short,
      input$strat,
      nrow(plot_data()) > 0)
  input$strat
  input$question_name_short
  isolate({
    case <- case()
    col_titles1 <- c("Vægtet andel(%)*", "Vægtet antal*")
    col_titles2 <- c("Andel(%)", "Antal")
    col_titles_mean <- c("Vægtet mean*")

    data_cols <- switch(
      case,
      "pat_svar" = col_titles1,
      "pat_age_sex" = col_titles1,
      "pat_age_sex_mean" = col_titles_mean,
      "pat_strat" = col_titles1,
      "pat_strat_mean" = col_titles_mean,
      "paar_svar" = col_titles2,
      "paar_age_sex" = col_titles2,
      "paar_strat" = col_titles2
    )

    dat <- switch(
      case,
      "pat_svar" = plot_data()[, .(response, percent, count)],
      "pat_age_sex" = plot_data()[, .(Køn, Alder, percent, count)],
      "pat_age_sex_mean" = plot_data()[, .(Køn, Alder, mean)],
      "pat_strat" = plot_data()[, .(strat_level, percent, count)],
      "pat_strat_mean" = plot_data()[, .(strat_level, mean)],
      "paar_svar" = plot_data()[, .(response, percent, count)],
      "paar_strat" = plot_data()[, .(strat_level, percent, count)],
      "paar_age_sex" = plot_data()[, .(Køn, Alder, percent, count)]
    )
    tmp <- c(plot_data()$strat[1], data_cols)
    age_sex_tmp <- c("Køn", "Alder", data_cols)
    col_titles <- switch(
      case,
      "pat_svar" = c("Svar", data_cols),
      "pat_age_sex" = age_sex_tmp,
      "pat_age_sex_mean" = age_sex_tmp,
      "pat_strat" = tmp,
      "pat_strat_mean" = tmp,
      "paar_svar" = c("Svar", data_cols),
      "paar_strat" = tmp,
      "paar_age_sex" = age_sex_tmp
    )

    dt_title <- pretty_title()
    if (large_plot()) {
      setorder(dat, -percent)
    }

    names(dat) <- col_titles
    top <- ""
    if (input$strat != "Svarfordeling") {
      top <- pretty_title_sub()
    }
    messageTop = top
    messageBottom = "Livmedenhjertesygdom.dk"
    n_col <- ncol(dat)
    make_dt_rate(
      dat = dat,
      col_titles = col_titles,
      dt_title = dt_title,
      messageTop = messageTop,
      n_col = n_col,
      messageBottom = messageBottom,
      thousands_sep = thousands_sep,
      dec_mark = dec_mark,
      digits = 1,
      case = case
    )
  })
})

# MAPS --------------------------------------------------------------------

map_data_obj <- reactive({
  dat <-
    copy(plot_data()) # Make copy so not corrupt reactive data

  map_data(
    dat = dat,
    data_var = "percent",
    map_obj = d$dk_sf_data$l1
  )
})

leaflet_map <- reactive({
  if (hq()) {
    data_var <- "mean"
  } else{
    data_var <- "percent"
  }

  map_data <- map_data_obj()

  legend_opacity = 0.9

  fill_data <- plot_data()[, min(get(data_var))]
  fill_data <-
    c(fill_data, fill_data + d$max_diff_map_colors[[data_var]])
  pal <-
    colorNumeric(palette = "YlOrRd", domain = fill_data,)

  # This is created so NA doesn't appear on the legend
  pal_NA <-
    colorNumeric("YlOrRd", fill_data, na.color = rgb(0, 0, 0, 0))

  fill_colors <-
    ~ pal(map_data[[data_var]])
  popup_text <- pretty_title_sub() %>%
    gsub(": ", ": <br>", .)
  popup <-
    make_leaflet_popup(
      geo_name = map_data[["Region"]],
      var_title1 = popup_text,
      data = map_data[[data_var]],
      percent = !hq()
    )
  legend_title <- paste0(pretty_title_sub(), " (%)") %>%
    gsub(": ", ": <br>", .)


  map <- makeLeaflet(
    map_data = map_data,
    fill_colors = fill_colors,
    label_popup = popup,
    mini_map_lines = d$dk_sf_data$mini_map_lines

  ) %>%
    addLegend(
      "topright",
      pal = pal_NA,
      values = fill_data,
      title = legend_title,
      bins = 4,
      na.label = "",
      layerId = "legend",
      opacity = legend_opacity,
      labFormat = labelFormat(big.mark = ".", digits = 0)
    )
  return(list(
    map = map,
    fill_data = fill_data,
    data_var = data_var
  ))
})

output$map <- renderLeaflet({
  req(input$strat == "Region",
      input$question_name_short,
      nrow(plot_data() > 0))

  leaflet_map()$map
})

output$download_map <- downloadHandler(
  filename = "map_livetmedhjertesygdom.png",
  content = function(file) {

    # To download a map, we need a static map (in this case a ggplot) for the
    # user. We can't really download a leaflet - I think I tried implementations
    # that would transform a leaflet map on the fly for download, but they did
    # not work very well, for reasons I can't remember
    #
    make_static_map(
      dat = leaflet_map()$fill_data,
      map_obj = map_data_obj(),
      mini_map_lines = d$dk_sf_data$mini_map_lines,
      legend_text = pretty_title_sub(),
      data_var = leaflet_map()$data_var,
      plot_title = pretty_title(),
      thousands_sep = ".",
      dec_mark = ","
    ) %>% ggsave(
      filename = file,
      plot = .,
      width = 12,
      height = 20,
      units = "cm",
      scale = 1.61
    )
  }
)
