show_modal <- function(text, title, name = NULL, class = NULL) {
  footer <- modalButton(icon("times"))
  modal_class <- paste(class, "error")

  if (nchar(text) > 175) {
    modal_class <- paste(modal_class, "wider")
  }
  
  showModal(div(class = modal_class, modalDialog(title = title, 
    HTML(text), easyClose = TRUE, size = "s", footer = footer))
  )
}

url_button <- function(id, fa_icon, url) {
  url <- sprintf("window.open('%s', '_blank')", url)
  
  button <- tooltip_button(
    id = id, fa_icon = fa_icon, onclick = url
  )
  
  return(button)
}

tooltip_button <- function(id, label = "", fa_icon, ...) {
  button <- actionButton(id, label, icon = fa_icon, title = get(id), 
    'data-toggle' = "tooltip", 'data-placement' = "auto bottom", ...)
  
  return(button)
}

add_input <- function(FUN, ids, id, class = NULL, url = NULL, ...) {
  inputs <- NULL
  
  for (i in ids) {
    if (!is.null(url)) {
      inputs <- c(
        inputs, as.character(FUN(paste0(id, i), 
        onclick = sprintf(url, i), ...))
      )
    } else {
      inputs <- c(
        inputs, as.character(FUN(paste0(id, i), ...))
      )
    }
  }
  
  if (!is.null(class)) {
    inputs <- gsub("btn ", sprintf("btn %s ", class), inputs)
  }
  
  return(inputs)
}

loading_screen <- function(tool_name) {
  tags$div(class = "shiny-notification",
    tags$div(class = "shiny-notification-close"),
    tags$div(class = "shiny-notification-content",
      tags$div(class = "shiny-notification-content-text",
        tags$div(class = "shiny-progress-notification",
          tags$div(class = "progress progress-striped active",
            tags$div(class = "progress-bar")
          ),
          
          tags$div(class = "progress-text",
            tags$span(class = "progress-message", 
              sprintf("„%s“ wird geladen", tool_name)),
            tags$span(class = "progress-detail")
          )
        )
      )
    )
  )
}

options(
  DT.options = list(
    pagingType = "simple", info = FALSE, 
    dom = "<\"top\">rt<\"bottom\"iflp><\"clear\">", 
    lengthChange = FALSE, search = list(regex = TRUE), 
    language = list(
      search = "", searchPlaceholder = "Filter", 
      emptyTable = "Keine Daten in der Tabelle vorhanden", 
      info = "_START_ bis _END_ von _TOTAL_ Einträgen", 
      infoEmpty = "0 bis 0 von 0 Einträgen", 
      infoFiltered = "(gefiltert von _MAX_ Einträgen)", 
      lengthMenu = "_MENU_ Einträge anzeigen", 
      loadingRecords = "Wird geladen ...", 
      processing = "Bitte warten ...", 
      zeroRecords = "Keine Einträge vorhanden.", 
      paginate = list(
        `first` = "<i class='fa fa-angle-left'></i>", 
        `previous` = "<i class='fa fa-angle-left'></i>", 
        `next` = "<i class='fa fa-angle-right'></i>", 
        `last` = "<i class='fa fa-angle-right'></i>"
      ), 
      aria = list(
        sortAscending = ": Spalte aufsteigend sortieren",
        sortDescending = ": Spalte absteigend sortieren"
      )
    )
  )
)

pdf(NULL) # fix problem in plot printout