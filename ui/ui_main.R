tabPanel(
  ui_main_title,
  value = "main",
  useShinyjs(),
  fluidRow(
    # INPUT -------------------------------------------------------------------
    div(
      # This changes the column width (i.e. proportion) based on width of screen)
      class = "col-xs-12 col-sm-5 col-md-4 col-lg-3",

      wellPanel(class = "well_input",
                fluidRow(
                  column(6,
                         fluidRow(
                           radioGroupButtons(
                             inputId = "person_type",
                             label = choose_person_type,
                             choices = person_type_choices,
                             justified = TRUE,
                             direction = "vertical"
                           )
                         ),
                         fluidRow(
                           selectizeInput(
                             inputId = "topic",
                             label = choose_topic,
                             choices = character(0)


                           )
                         )),
                  column(
                    6,
                    radioGroupButtons(
                      inputId = "strat",
                      label = choose_stratification,
                      choices = starting_vals_strat,
                      justified = TRUE,
                      direction = "vertical"
                    )
                  )
                ),

                fluidRow(
                  selectizeInput(
                    inputId = "question_name_short",
                    label = choose_question,
                    choices = character(0)
                  )
                )),

# HELPER TEXT -------------------------------------------------------------
fluidRow(
  wellPanel(class = "well_description",
            uiOutput("helper_weighted"))),

      fluidRow(
        wellPanel(class = "well_description",
                  uiOutput("outcome_description")))
    ),

        # OUTPUT ------------------------------------------------------------------


        div(
          class = "col-xs-12 col-sm-7 col-md-8 col-lg-8",
          align = "right",
          tabsetPanel(
            id = "data_vis_tabs",
            type = "pill",


            ui_tabpanel_graph(height = "700px"),
            ui_tabpanel_DTs(),
            ui_tabpanel_map()

          )
        )


      )
    )
