tabPanel(ui_main_title,
         value = "main",
         useShinyjs(),
         fluidRow(

           # INPUT -------------------------------------------------------------------
           div(# This changes the column width (i.e. proportion) based on width of screen)
             class = "col-xs-12 col-sm-5 col-md-4 col-lg-3",

             wellPanel(
               class = "well_input",
               fluidRow(column(
                 6,
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
                 )
               ),
               column(
                 6,
                 radioGroupButtons(
                   inputId = "strat",
                   label = choose_stratification,
                   choices = starting_vals_strat,
                   justified = TRUE,
                   direction = "vertical"
                 )
               )),

               fluidRow(
                 selectizeInput(
                   inputId = "question_name_short",
                   label = choose_question,
                   choices = character(0)
                 )
               )

             )),


           # OUTPUT ------------------------------------------------------------------


           div(
             class = "col-xs-12 col-sm-7 col-md-8 col-lg-8",
             align = "right",
             tabsetPanel(
               id = "data_vis_tabs",
               type = "pill",

               # Graph panel
               tabPanel(title = "Grafer",
                        br(),
                        plotlyOutput("plot", height = "600px")),
               tabPanel(title = "Tabeller",
                        fluidRow(
                          class = "row_outcome_title",
                          column(
                            11,
                            class = "output_titles",
                            align = "left",
                            textOutput("outcome_title_dt")
                          )
                        ),
                        fluidRow(DTOutput("table_rate")))

             )
           )


         ))
