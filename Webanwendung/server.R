require(tidyverse)
require(lubridate)
require(stringdist)
require(purrr)
require(httr)
require(xml2)

helper_files <- list.files(path = "./helpers", pattern = "*.R")
helper_files <- paste0("helpers/", helper_files)

for (i in seq_along(helper_files)) {
  source(helper_files[i], local = TRUE, encoding = "UTF-8")$value
}

shinyServer(function(input, output, session) {
  observeEvent(input$intro_button, {
    removeModal() # modal does not close automatically on click
  })
  
  # save_xml(path = "data/tei.xml")
  lines <- readRDS("data/lines.rds")
  texts <- readRDS("data/texts.rds")
  
  server_files <- list.files(path = "./server", pattern = "*.R")
  
  if (length(server_files) > 0) {
    server_files <- paste0("server/", server_files)
  }
  
  for (i in seq_along(server_files)) {
    source(server_files[i], local = TRUE, encoding = "UTF-8")$value
  }

  shinyjs::hide(id = "loading-content", anim = TRUE, animType = "fade")    
  shinyjs::show(id = "app-content")
  
  # show introductory modal with some fancy (beer) stuff
  intro_text <- read_tsv("data/index.html", col_names = FALSE) %>% 
    pull(X1) %>% paste(collapse = "")
  
  show_modal(intro_text, title = "", class = "intro")
})