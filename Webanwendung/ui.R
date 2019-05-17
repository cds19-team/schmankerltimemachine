require(shiny)
require(shinydashboard)
require(shinyjs)
library(leaflet)
library(htmlwidgets)
require(DT)

helper_files <- list.files(path = "./helpers", pattern = "*.R")
helper_files <- paste0("helpers/", helper_files)

for (i in seq_along(helper_files)) {
  source(helper_files[i], local = TRUE, encoding = "UTF-8")$value
}

tool_name <- "Schmankerl Time Machine"
url_name <- tolower(gsub(" ", "", tool_name))

ui_files <- list.files(path = "./ui", pattern = "*.R")
if (length(ui_files) > 0) ui_files <- paste0("ui/", ui_files)

for (i in seq_along(ui_files)) {
  source(ui_files[i], local = TRUE, encoding = "UTF-8")$value
}

header <- dashboardHeader(
  title = a(
    img(src = sprintf("logo_%s_alt.png", url_name), title = tool_name),
    href = sprintf("https://dhvlab.gwi.uni-muenchen.de/%s/", url_name),
    title = tool_name, target = "_blank"
  ),
  
  tags$li(class = "dropdown",
    selectizeInput("search_food", label = NULL, width = "258px", choices = "", 
      options = list(placeholder = "Wo gibt es ...", maxItems = 1))
  ),
  
  dropdownMenuOutput("header_cart_overview"),
  
  tags$li(class = "dropdown", 
    actionButton(
      "header_about_button", label = "", 
      icon = icon("info-circle")
    ),
    
    url_button(
      "header_github_button", icon("gitlab"), 
      "https://gitlab.com/cds19-team/cds19"
    )
  )
)

sidebar <- dashboardSidebar(
  disable = TRUE,
  
  tags$head(tags$link(rel = "icon", type = "image/png", href = "favicon.ico")),
  tags$head(tags$link(rel = "stylesheet", type = "text/css", href = "theme.css")),
  tags$head(tags$script(src = "script.js")),
  
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", 
      href = "https://fonts.googleapis.com/css?family=Merriweather")
  ),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", 
      href = "https://fonts.googleapis.com/css?family=Muli")
  ),

  sidebarMenu(id = "sidebar-menu",
    menuItem("Speisekarten", tabName = "speisekarten", icon = icon("cutlery"))
  )
)

body <- dashboardBody(
  useShinyjs(),
  
  div(id = "loading-content", loading_screen(tool_name)),

  hidden(div(id = "app-content", 
      tabItems(panel_speisekarten)
    )
  )
)

dashboardPage(header, sidebar, body, title = tool_name)