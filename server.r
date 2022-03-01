shinyServer(function(input, output, session) {

  source(file.path("server", "server_main.R"),
         encoding = "UTF-8",
         local = TRUE)$value
  source(file.path("server", "server_about.R"),
         encoding = "UTF-8",
         local = TRUE)$value
  source(file.path("server", "server_guide.R"),
         encoding = "UTF-8",
         local = TRUE)$value

  # POPUP IE WARNING --------------------------------------------------------

  observeEvent(label = "IEwarning",  input$check, {
    if (input$check == "TRUE") {
      showModal(
        modalDialog(
          title = "The LMHS app does not work with Internet Explorer",
          easyClose = TRUE,
          fade = TRUE,
          tags$p(
            "Please choose Chrome / Firefox / Safari / Edge"
          )

        )
      )
    }
  })


})
