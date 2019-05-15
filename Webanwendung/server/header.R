### Data ######################################################################

search_choices <- filter(texts, !is.na(id)) %>%
  mutate(id = paste(id, fid, sep = ":")) %>%
  select(entry, id) %>%  group_by(id) %>%
  summarise_all(
    list(~paste(na.omit(.), collapse = " "))
  ) %>%
  sample_n(nrow(.))

search_choices <- setNames(
  search_choices$id,
  search_choices$entry
)

updateSelectizeInput(
  session, "search_food",
  choices = search_choices,
  selected = ""
)

### Observers #################################################################

observeEvent(input$header_about_button, {
  text <- read_tsv("data/about.html", col_names = FALSE) %>% 
    pull(X1) %>% paste(collapse = "")

  show_modal(text, title = "Über die „Schmankerl Time Machine“")
})

observeEvent(input$search_food, {
  req_and_assign(input$search_food, "search_food")
  
  if (nchar(search_food) > 0) {
    fid <- str_split(search_food, ":")[[1]][2]
    eid <- filter(lines, fid == !!fid) %>%
      slice(1) %>% pull(eid)

    name <- filter(img_metadata, Id == eid) %>% pull(Lokalname)
    updateSelectInput(session, "select_restaurant", selected = name)
  }
})

observe({
  if (nrow(food_cart$data) == 0) {
    shinyjs::hide("header_cart_overview")
  } else {
    shinyjs::show("header_cart_overview")
  }
})

observeEvent(input$recipe_button, {
  req_and_assign(food_cart$data, "food_cart_data")
  
  food_cart_data <- food_cart_data %>%
    na_if("") %>% filter(!is.na(recipe_id))
  
  if (nrow(food_cart_data) == 0) {
    text <- div(id = "recipe-modal", 
      tags$p(
        paste(
          "Leider können wir Ihnen keine Rezepte für die Speisen",
          "anbieten, die in ihrem Warenkorb liegen."
        )
      )
    )
  } else {
    text <- div(id = "recipe-modal", 
      tags$p(
        paste(
          "Zu folgenden Speisen, die in Ihrem Warenkorb liegen, können",
          "wir Ihnen ein Rezept zum Nachkochen anbieten."
        )
      ),
      DT::dataTableOutput("select_recipe")
    )
  }
  
  title <- "Schmankerl nachkochen"
  
  showModal(div(class = "error", modalDialog(title = title, text,
    easyClose = TRUE, size = "s", footer = modalButton(icon("times"))))
  )
})

### Functions #################################################################

add_link <- function(recipe_id) {
  url <- paste0("window.open('https://www.chefkoch.de/",
    "rezepte/%s/', '_blank')")

  button <- add_input(
    actionButton, recipe_id, "go_to_chefkoch_", label = "", 
    icon = icon("sign-out"), url = url
  )

  return(button)
}

### Output ####################################################################

output$header_cart_overview <- renderMenu({
  req_and_assign(food_cart$data, "food_cart_data")
  
  total <- food_cart_data$price %>% 
    as.double() %>% sum(na.rm = TRUE) %>% 
    paste("Zu zahlender Betrag:", icon("money"), .) %>%
    paste(tooltip_button("recipe_button", fa_icon = icon("cutlery")))

  if (nrow(food_cart_data) > 0) {
    food_cart_data <- apply(
      food_cart_data, 1, function(row) {
        messageItem(
          from = row[["entry"]], 
          message = HTML(paste(
            icon("map-marker"), row[["name"]], 
            icon("money"), row[["price"]]
          )),
          icon = icon("paste")
        )
      }
    )

    food_cart_data[[length(food_cart_data) + 1]] <- 
      tags$li(class = "footer", HTML(total))

    dropdownMenu(
      icon = icon("shopping-cart"), 
      .list = food_cart_data
    )
  }
})

output$select_recipe <- DT::renderDataTable({
  req_and_assign(food_cart$data, "food_cart_data")
  
  food_cart_data <- food_cart_data %>%
    na_if("") %>% filter(!is.na(recipe_id))
  
  if (nrow(food_cart_data) > 0) {
    food_cart_data %>%
      mutate(link = add_link(recipe_id)) %>%
      mutate(price = as.double(price)) %>%
      select(entry, price, link) %>%
      rename(Eintrag = entry) %>%
      rename(Preis = price)
  }
}, escape = FALSE, rownames = FALSE, style = "bootstrap", server = TRUE, 
selection = list(mode = "single", selected = c(1)), 
options = list(
  rowCallback = JS(
    "function(row, data, index, indexfull) {",
      "for (var i = 0; i < data.length - 1; i++) {",
        "$('td:eq(' + i + ')', row).attr('title', data[i]);",
      "}",
    "}"
  ), pageLength = 5, info = FALSE, dom = "t", columnDefs = list(
    list(className = "dt-right", "targets" = 2),
    list(targets = 2, orderable = FALSE))
  )
)