tabPanel(
  ui_main_title,
  value = "main",
  useShinyjs(),


  fluidRow(div(
    # This changes the column width (i.e. proportion) based on width of screen)
    class = "col-xs-12 col-sm-5 col-md-4 col-lg-3",

    wellPanel(class = "well_input",
              fluidRow(
                radioGroupButtons(
                  inputId = "rate_count",
                  label = choose_respondent_type,
                  choices = respondent_type_choices,
                  justified = TRUE
                ),
                selectInput(
                  inputId = "respondend_type",
                  label = choose_topic,
                  choices = topic_choices,
                  selectize = TRUE
                ),
                fluidRow(uiOutput("question_choices")),
              ))
  )




  )






)
