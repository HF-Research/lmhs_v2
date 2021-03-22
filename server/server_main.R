# UI INPUT ----------------------------------------------------------------

observeEvent(input$person_type,{
  topic_choices <- d$topics_by_person[[input$person_type]]
  freezeReactiveValue(input, "topic")
  updateSelectizeInput(
    session,
    inputId = "topic",
    label = choose_topic,
    choices = topic_choices,
    selected = topic_choices[1]
  )

})

listen_question <- reactive({
  list(input$person_type,input$topic)
})
observeEvent(listen_question() ,{

  freezeReactiveValue(input, "question")

  question_choices <-
    d$q_by_topic_person[[paste0(input$person_type, ".", input$topic)]]

  updateSelectizeInput(
    session,
    inputId = "question",
    label = choose_question,
    choices = question_choices,
    selected = question_choices[1]
  )

})

# PLOT --------------------------------------------------------------------

plot_data <- reactive({
  d$dat[person_type == input$person_type &
          topic == input$topic &
          question == input$question &
          stratification_level == input$stratification]
})
output$plot <- plotly::renderPlotly({
  req(input$person_type,
      input$topic,
      input$question,
      input$stratification)


  if (input$stratification == "age_sex") {
    tooltip <-
      paste0("%{text}: <br><b>%{y:,.", num_digits, "f}<extra></extra>")
    plot_out <- plot_data() %>%
      plot_ly() %>%
      add_trace(
        x = ~ stratification_value_1,
        y = ~ value,
        color = ~ stratification_value_2,
        text =  ~ stratification_value_2,
        colors = graph_colors,
        type = "bar",
        hovertemplate = tooltip
      )
  } else{
    plot_out <- plot_data() %>%
      plot_ly() %>%
      add_trace(
        x = ~ stratification_value_1,
        y = ~ value,
        type = "bar"
      )
  }
  plot_title <- "Test title"
  axis_title_x <-
    names(stratification_choices[stratification_choices == input$stratification])
  axis_title_y <- "Test y value"
  plot_out %>%
    layout(
      margin = list(t = 70),
      title = list(
        text = plot_title,
        x = 0,
        yanchor = "bottom",
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
        range = c(0, 100),
        tickformat = paste0(",.", num_digits)
      ),
      hoverlabel = list(font = list(size = 18)),
      hovermode = "x unified",
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
      ),
      toImageButtonOptions = list(
        filename = paste0("LMHS- "),
        width = 1000,
        height = 500,
        scale = "2"
      )
    )


})
