ui <- function(request) {
  div(
    useShinyjs(),
    extendShinyjs(script = "www/numberFormatter.js", functions = "numberFormatter"),
    tags$head(
      includeHTML("www/google-analytics.html"),

      # JS code to add link to en/dk version of website
      includeScript("www/checkBrowser.js")


    ),
    tags$a(
      img(
        src = "hf-logo.png",
        align = "left",
        style = "padding-top: 20px; padding-bottom: 40px; padding-left: 2.5rem;",
        height = "110px"
      ), href = "https://hjerteforeningen.dk/", target ="_blank"),
    fluidPage(
      div(style = "padding-left: 0px; padding-right: 0px;",
          titlePanel(
            title = "",
            windowTitle = tags$head(
              tags$link(rel = "icon", type = "image/png", href = "hf-icon.png"),
              tags$title("LMHS")
            )
          ))
    ),


    navbarPage(
      title = 'LMHS',
      id = "bar",
      theme = "css-app-specifc.css",
      collapsible = TRUE,
      selected = "main",
      source(file.path("ui", "ui_main.R"), local = TRUE)$value,
      source(file.path(
        "ui", "ui_about.R"
      ), local = TRUE)$value


    )

  )
}
