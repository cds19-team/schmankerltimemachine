### Data ######################################################################

data_url <- "https://gitlab.com/cds19-team/cds19/raw/master/"

img_metadata <- read_csv(paste0(data_url, "Daten/menus.csv")) %>% 
  mutate(Lokalname_original = str_replace(Dateiname_original, "_.*", "")) %>%
  mutate(
    Datum = case_when(
      nchar(Datum) == 4 ~ paste0("01.01.", Datum),
      !is.na(Datum) ~ Datum
    )
  ) %>%
  mutate(Kartentyp = str_to_title(str_replace_all(Kartentyp, "-", ""))) %>%
  mutate(Kartentyp = str_replace(Kartentyp, " Und ", " und ")) %>%
  mutate(Datum  = dmy(Datum)) %>% mutate(Jahr = year(Datum)) %>%
  mutate(Lokaltyp = str_replace(Lokaltyp, "Cafe", "Café")) %>%
  mutate(
    Lokaltyp = case_when(
      str_detect(Lokaltyp, "Bar") ~ "Bar",
      str_detect(Lokaltyp, "Hotel") ~ "Hotel",
      !is.na(Lokaltyp) ~ Lokaltyp,
      is.na(Lokaltyp) ~ "Lokal"
    )
  ) %>%
  mutate(
    Pronomen = case_when(
      Lokaltyp %in% c("Gaststätte", "Festhalle") ~ "Die",
      Lokaltyp %in% c("Bar", "Disco", "Bürgerstube") ~ "Die",
      !is.na(Lokaltyp) ~ "Das"
    )
  ) %>% 
  drop_na() %>%
  arrange(Lokalname, Datum, Kartentyp, Seite) %>%
  unite("Text", Pronomen, Lokaltyp, sep = " ")

metadata <- read_csv(paste0(data_url, "Daten/restaurants.csv")) %>% 
  rename(lat = Breitengrad) %>% rename(long = Längengrad) %>% 
  mutate(
    Schließung = case_when(
      str_detect(Schließung, "verm") ~ "vmtl. geschlossen",
      !is.na(Schließung) ~ "geschlossen"
    )
  ) %>%
  mutate(
    Eröffnung = case_when(
      !is.na(Eröffnung) ~ sprintf("wurde %s eröffnet", Eröffnung)
    )
  ) %>%
  mutate(
    Schließung = case_when(
      !is.na(Schließung) ~ sprintf("ist mittlerweile %s", Schließung)
    )
  ) %>%
  inner_join(img_metadata, by = c("Name" = "Lokalname_original")) %>%
  select(Lokalname, Eröffnung, Schließung, URL, lat, long) %>% distinct()

img_metadata_choices <- unique(img_metadata$Lokalname)

updateSelectInput(
  session, "select_restaurant", 
  choices = img_metadata_choices,
  selected = img_metadata_choices[1]
)

### Reactive Values ###########################################################

selected_row <- reactiveValues(id = 1) # should never be NULL
transcription <- reactiveValues(lines = NULL, text = NULL)

recommendation <- reactiveValues(text = NULL) # for reload
auto_menu <- reactiveValues(data = NULL) # if accepted

food_cart <- reactiveValues(data = 
  tibble(
    id = character(), name = character(), 
    entry = character(), price = character(),
    recipe_id = character()
  )
)

### Observers #################################################################

observe({
  req_and_assign(input$select_restaurant, "name")
  req_and_assign(selected_row$id, "row_id")
  
  eid <- filter_data(name, img_metadata) %>% 
    slice(row_id) %>% pull(Id)

  transcription$lines <- NULL
  transcription$text <- NULL
  
  if (length(eid) > 0) {
    if (eid %in% lines$eid) {
      lines <- filter(lines, eid == !!eid)
      
      text <- filter(texts, !is.na(id)) %>%
        filter(fid %in% lines$fid)
  
      if (nrow(text) > 0) {
        transcription$text <- text %>%
          mutate(id = paste(id, fid, sep = "_")) %>%
          mutate(id = str_replace_all(id, "_", ":"))
        
        transcription$lines <- lines %>% 
          filter(rid %in% text$rid)
      }
    }
  }
})

observe({
  if (is.null(transcription$text)) {
    shinyjs::hide("automate_menu_button")
    shinyjs::hide("recommendation")
    shinyjs::hide("select_food")
  } else {
    shinyjs::show("automate_menu_button")
    shinyjs::show("recommendation")
    shinyjs::click("reload_button")
    
    if (!is.null(input$rectangle_click_id)) {
      shinyjs::show("select_food")
    } else {
      shinyjs::hide("select_food")
    }
  }
})

observe({
  shinyjs::toggleState("automate_menu_confirm", 
    condition = !is.null(auto_menu$data)
  )
  
  shinyjs::toggleState("restaurant_confirm", 
    condition = !is.null(input$marker_click_id)
  )
})

observeEvent(input$select_menu_rows_selected, {
  selected_row$id <- input$select_menu_rows_selected
})

observeEvent(input$reload_button, {
  req_and_assign(transcription$text, "foods")
  
  if (!is.null(foods)) {
    # recommend some special (i.e., pricey) dish
    food_ids <- filter(foods, price >= quantile(price, 
        0.65, type = 8, na.rm = TRUE)) %>% pull(id)
      
    recommendation$text <- foods %>% 
      filter(id %in% food_ids) %>% group_by(id) %>% 
      summarise(text = paste(entry, collapse = " ")) %>%
      mutate(text = paste0("„", trimws(text), "“")) %>%
      filter(!str_detect(text, "[1-9]")) %>% 
      sample_n(2) %>% pull(text) %>% 
      paste(collapse = " oder ") %>%
      sprintf("Schon mal %s probiert?", .)
  }
})

observeEvent(input$leaflet_button, {
  text <- div(id = "leaflet-modal",
    tags$p(
      paste(
        "Wählen Sie eine Lokalität aus, indem Sie in der Karte auf den",
        "jeweiligen Marker klicken und danach „Übernehmen“ drücken. Blau",
        "hinterlegte Lokalitäten sind mittlerweile geschlossen."
      )
    ),
    leafletOutput("restaurant_leaflet", width = "100%", height = "300px")
  )
  
  id <- "restaurant_confirm"
  title <- "Lokalität auswählen"
  
  footer <- tagList(
    modalButton(icon("times")), 
    actionButton(id, "Übernehmen"), 
    modalButton("Abbrechen")
  )
  
  showModal(div(class = "confirm wider", modalDialog(title = title, 
    text, easyClose = TRUE, size = "s", footer = footer))
  )
})

observeEvent(input$restaurant_confirm, {
  req_and_assign(input$marker_click_id, "click_id")
  
  updateSelectInput(session, "select_restaurant", selected = click_id)
  removeModal() # modal does not close automatically on click
})

observeEvent(input$to_cart_button, {
  text <- transform_cart(input$to_cart_button)

  if (!(text[["id"]] %in% food_cart$data$id)) {
    food_cart$data <- bind_rows(food_cart$data, text)
  }
})

observeEvent(input$from_cart_button, {
  text <- bind_rows(transform_cart(input$from_cart_button))
  food_cart$data <- anti_join(food_cart$data, text)
})

observeEvent(input$automate_menu_button, {
  choices <- transcription$text %>% pull(category) %>% unique()
  
  text_values <- list(
    paste(
      "Sind Sie auf der Suche nach kulinarischer Vielfalt in Ihrem Alltag?",
      "Lassen Sie uns Ihr unvergessliches Menü von Morgen zusammenstellen."
    ),
    selectizeInput("automate_menu_categories", "Was darf es denn sein?", 
      choices[!is.na(choices)], multiple = TRUE),
    sliderInput("automate_menu_range", "Wie viel darf es kosten?", 
      min = 1, max = 50, value = 10, step = 1),
    uiOutput("automate_menu_text")
  )
  
  if (length(choices) < 2) text_values[[2]] <- NULL
  text <- div(id = "automate-menu-modal", tags$p(text_values))

  id <- "automate_menu_confirm"
  title <- "Menü zusammenstellen lassen"
  
  footer <- tagList(
    modalButton(icon("times")), 
    actionButton(id, "Übernehmen"), 
    modalButton("Abbrechen")
  )
  
  showModal(div(class = "confirm", modalDialog(title = title, 
    text, easyClose = TRUE, size = "s", footer = footer))
  )
})

observeEvent(input$automate_menu_confirm, {
  removeModal() # modal does not close automatically on click
  
  food_cart$data <- food_cart$data %>%
    bind_rows(auto_menu$data) %>% distinct()
  })

### Functions #################################################################

get_price <- function(ids, data) {
  ids <- split_ids(ids)

  price <- filter(data, id %in% ids) %>% 
    pull(price) %>% sum(na.rm = TRUE)
  
  return(price)
}

split_ids <- function(ids) {
  return(str_split(ids, "_") %>% deframe())
}

text_paste <- function(x) {
  return(sub(",\\s+([^,]+)$", " und \\1", x))
}

transform_cart <- function(text) {
  text <- str_replace(text, "cart_", "") %>% 
    str_split("_") %>% pluck(1) %>% na_if("")
  
  names(text) <- c("id", "name", 
    "entry", "price", "recipe_id")
  
  return(text)
}

filter_data <- function(name, data) {
  data <- data %>%
    filter(Lokalname == name) %>%
    select(Id, Kartentyp, Jahr, Seite, 
      Breite_orig, Höhe_orig)
  
  return(data)
}

render_tags <- function(text, icon) {
  text <- text %>% paste(collapse = " ")
  tags <- tagList(icon, HTML(text))

  return(tags)
}

get_overlay <- function(id, width, height) {
  url <- "https://dhvlab.gwi.uni-muenchen.de/cds19"
  
  render_text <- sprintf(
    "function(el, x) {
      var map = this;

      var url = '%s/images/large/%s.jpg',
          width = %s, height = %s;

      var south_west = map.unproject([0, height], map.getMaxZoom() - 1);
      var north_east = map.unproject([width, 0], map.getMaxZoom() - 1);

      var bounds = new L.LatLngBounds(south_west, north_east);
      var overlay = L.imageOverlay(url, bounds);

      overlay.addTo(map);
      map.fitBounds(bounds);
    }", url, id, width, height
  )
  
  return(render_text)
}

transform_y <- function(y, height) {
  return(height - y)
}

get_rectangle <- function(id, x_1, y_1, x_2, y_2) {
  render_text <- sprintf(
    "function(el, x) {
      var map = this;

      var x_1_y_1 = L.point(%s, %s);
      var lat_lng_1 = map.unproject(x_1_y_1, map.getMaxZoom() - 1);

      var x_2_y_2 = L.point(%s, %s);
      var lat_lng_2 = map.unproject(x_2_y_2, map.getMaxZoom() - 1);

      var bounds = [lat_lng_1, lat_lng_2];
      var rectangle = L.rectangle(bounds, {color: '#ef4019', weight: 0.5});

      rectangle.addTo(map);

      rectangle.on('click', function(e) {        
        Shiny.onInputChange('rectangle_click_id', '%s');
      });
    }", x_1, y_1, x_2, y_2, id
  )
  
  return(render_text)
}

get_recipe <- function(text, order_by = 2, limit = 1) {
  response <- GET(
    url = "https://api.chefkoch.de/v2/recipes?",
    query = list(
      orderBy = order_by,
      query = URLencode(text),
      minimumRating = "4",
      limit = limit
    )
  )
  
  if (response$status_code == 200) {
    content <- content(response)
    
    if (content$count > 0) {
      score <- content$results[[1]]$score
      
      if (score > 0.7) {
        return(content$results[[1]]$recipe$id)
      }
    }
  }

  return(NA_character_)
}

save_xml <- function(path) {
  data <- read_xml(path)
  
  lines <- xml_find_all(data, "./d1:facsimile") %>%
    map(extract_facs) %>% bind_rows()
  
  texts <- unique(lines$fid) %>% 
    map(extract_text, data = data) %>% bind_rows()

  saveRDS(lines, "data/lines.rds")
  saveRDS(texts, "data/texts.rds")
}

extract_facs <- function(data) {
  graphic <- xml_find_first(data, ".//d1:graphic")
  url <- xml_attr(graphic, "url")
  
  lines <- extract_lines(data)
  
  if (!is.null(lines)) {
    field <- img_metadata$Dateiname_original
    
    eid <- amatch(url, field, maxDist = 30)
    eid <- img_metadata$Id[eid]
    
    lines <- mutate(lines, eid = eid) %>%
      mutate(fid = xml_attr(data, "id"))
    
    return(lines)
  }
}

extract_lines <- function(data) {
  x_path <- ".//d1:zone[@rendition='Line']"
  lines <- xml_find_all(data, x_path) %>% xml_attrs()
  
  rid <- map(lines, length) %>% 
    unlist() %>% rep(seq_along(.), .)

  if (length(lines) > 0) {
    lines <- lines %>% 
      map_df(enframe) %>% 
      mutate(rid = rid) %>%
      spread(name, value) %>% 
      mutate_all(type.convert) %>% 
      mutate_if(is.factor, as.character)
  
    return(lines)
  }
}

extract_text <- function(facs_id, data) {
  get_texts <- function(x, x_path) {
    process_texts <- function(x) {
      texts <- enframe(x, name = NULL) %>%
        mutate(rid = row_number()) %>% 
        rename(entry = value) %>%
        filter(!is.na(entry))
      
      return(texts)
    }
    
    texts <- xml_find_first(x, x_path) %>% 
      xml_text() %>% process_texts()

    return(texts)
  }
  
  get_foods <- function(x) {
    get_entries <- function(x) {
      entries <- xml_text(xml_find_all(x, "./d1:name/text()"))
      
      if (length(entries) > 0) {
        prices <- xml_find_first(x, "./d1:Preis/text()") %>% 
          xml_text() %>% rep(length(.))
        
        entries <- tibble(entries, prices) %>% 
          t() %>% as.vector()
        
        return(entries)
      }
    }
    
    foods <- xml_find_all(x, "./d1:Eintrag") %>%
      map(get_entries) %>% unlist()
    
    if (length(foods) > 0) {
      foods <- matrix(foods, ncol = 2, byrow = TRUE)
      colnames(foods) <- c("entry", "price")
      
      foods <- as_tibble(foods)
    }
    
    return(foods)
  }
  
  x_path <- ".//d1:l[contains(@facs, '#%s_')]"
  x_path <- sprintf(x_path, facs_id)
  values <- xml_find_all(data, x_path)

  foods <- map(values, get_foods)
  texts <- get_texts(values, "./text()")
  
  x_path <- "./d1:Kategorie/text()"
  categories <- get_texts(values, x_path)
  
  count <- map(foods, nrow) %>% map(function(x) 
    ifelse(is.null(x), 0, x)) %>% unlist()

  if (sum(count) > 0) {
    foods <- foods %>% 
      discard(count == 0) %>% bind_rows() %>%
      mutate(rid = rep(seq_along(count), count)) %>%
      mutate(price = str_replace(price, ",", ".")) %>%
      mutate(price = as.double(price)) %>%
      inner_join(count(., rid)) %>% 
      mutate(x = price) %>% 
      fill(x, .direction = "up") %>%
      mutate(price = ifelse(n > 1, x, price)) %>%
      select(-c(n, x)) %>% mutate(id = row_number()) %>%
      mutate(id = ifelse(is.na(price), NA, id)) %>%
      fill(id, .direction = "up") %>%
      bind_rows(categories) %>% arrange(rid) %>%
      mutate(category = case_when(is.na(id) ~ entry)) %>%
      fill(category, .direction = "down") %>%
      filter(!is.na(id))
    
    if (length(unique(foods$category)) < 3) {
      foods <- mutate(foods, category = NA)
    }
    
    recipe <- select(foods, id, entry) %>% group_by(id) %>%
      summarise_all(
        list(~paste(na.omit(.), collapse = " "))
      ) %>%
      mutate(recipe_id = map(entry, get_recipe)) %>%
      mutate(recipe_id = unlist(recipe_id))
    
    foods <- left_join(foods, recipe)
    texts <- bind_rows(texts, categories, foods)
  }
  
  texts <- texts %>%
    mutate(fid = facs_id)

  return(texts)
}

get_marker <- function(id, x, y, z) {
  color <- if (is.na(z)) "orange" else "blue"
  
  render_text <- sprintf(
    "function(el, x) {
      var map = this;

      var icon = L.icon({
        iconUrl: 'marker_%s.png',
        iconSize: [14, 21]
      });

      var marker = L.marker([%s, %s], {icon: icon,});
      marker.addTo(map).bindPopup('%s').bindTooltip('%s');

      marker.on('click', function(e) {        
        Shiny.onInputChange('marker_click_id', '%s');
      });
    }", color, x, y, id, id, id
  )
  
  return(render_text)
}

cart_input_button <- function(id, name, entry, price, recipe_id, rm = TRUE) {
  text <- paste(id, name, entry, price, recipe_id, sep = "_")
  
  if (!rm) {
    title <- "Zum Warenkorb hinzufügen"
    icon <- icon("plus-circle")
    id <- "to_cart_button"
  } else {
    title <- "Aus dem Warenkorb entfernen"
    icon <- icon("minus-circle")
    id <- "from_cart_button"
  }

  button <- add_input(
    actionButton, text, "cart_", label = "", icon = icon, title = title,
    onclick = sprintf("Shiny.onInputChange(\"%s\", this.id);", id)
  )

  return(button)
}

### Output ####################################################################

output$restaurant_leaflet <- renderLeaflet({
  leaflet_data <- filter(metadata, !is.na(lat))
  
  leaflet <- leaflet() %>%
    addProviderTiles(providers$CartoDB.Positron,
      options = providerTileOptions(noWrap = TRUE)
    )

  # hacky, but otherwise input field is destroyed
  for (i in 1:nrow(metadata)) {
    leaflet <- leaflet %>%
      onRender(
        get_marker(
          leaflet_data$Lokalname[i], leaflet_data$lat[i], 
          leaflet_data$long[i], leaflet_data$Schließung[i]
        )
      )
  }
  
  leaflet <- leaflet %>%
    fitBounds(
      lng1 = max(leaflet_data$long),
      lng2 = min(leaflet_data$long),
      lat1 = max(leaflet_data$lat),
      lat2 = min(leaflet_data$lat)
    )
  
  return(leaflet)
})

output$menu_leaflet <- renderLeaflet({
  req_and_assign(input$select_restaurant, "name")
  req_and_assign(selected_row$id, "row_id")
  
  data <- filter_data(name, img_metadata) %>% slice(row_id)
  lines <- transcription$lines
  
  y_1 <- transform_y(4112, data$Höhe_orig)
  y_2 <- transform_y(3888, data$Höhe_orig)

  leaflet <- leaflet(options = 
      leafletOptions(
        crs = leafletCRS(
          crsClass = "L.CRS.Simple", 
          origin = c(0, 0) # top left
        ), 
        minZoom = 0, 
        maxZoom = 4
      )
    ) %>% 
    onRender(get_overlay(data$Id, data$Breite_orig, data$Höhe_orig))

  for (i in seq_along(lines$rid)) {
    leaflet <- leaflet %>%
      onRender(
        get_rectangle(
          lines$rid[i], lines$ulx[i], lines$uly[i], 
          lines$lrx[i], lines$lry[i]
        )
      )
  }
  
  return(leaflet)
})

output$homepage_button <- renderUI({
  req_and_assign(input$select_restaurant, "name")

  url_variants <- metadata %>% 
    filter(Lokalname == name) %>%
    filter(!is.na(URL)) %>% pull(URL)
  
  if (length(url_variants) > 0) {
    render_text <- url_button(
      "homepage_button", 
      icon("external-link"), 
      url_variants[1]
    )
    
    return(render_text)
  }
})

output$update_metadata <- renderUI({
  req_and_assign(input$select_restaurant, "name")

  render_text <- tagList()
  text <- NULL
  
  metadata <- metadata %>%
    filter(Lokalname == name) %>% 
    select(Eröffnung, Schließung) %>%
    filter(rowSums(!is.na(.)) > 0)
  
  if (nrow(metadata) > 0) {
    about <- c(metadata$Eröffnung[1], metadata$Schließung[1])
    
    text <- img_metadata %>% filter(Lokalname == name) %>%
      slice(1) %>% pull(Text) %>% c(about[!is.na(about)])
    
    if (length(text) > 2) {
      text <- c(text[1], paste(text[2:3], collapse = " und "))
    }
    
    text <- paste(text, collapse = " ") %>% paste0(".")
  }
  
  text <- c(text, "Es können folgende historische",
    "Speisekarten näher eingesehen werden.")
  
  render_text <- render_tags(text, icon("info-circle"))

  return(render_text)
})

output$select_menu <- DT::renderDataTable({
  req_and_assign(input$select_restaurant, "name")
  
  filter_data(name, img_metadata) %>%
    select(Kartentyp, Jahr, Seite)
}, escape = FALSE, rownames = FALSE, style = "bootstrap", server = TRUE, 
selection = list(mode = "single", selected = c(1)), 
options = list(
  rowCallback = JS(
    "function(row, data, index, indexfull) {",
      "for (var i = 0; i < data.length; i++) {",
        "$('td:eq(' + i + ')', row).attr('title', data[i]);",
      "}",
    "}"
  ), pageLength = 5, info = FALSE)
)

output$update_food <- renderUI({
  req_and_assign(input$select_restaurant, "name")
  req_and_assign(selected_row$id, "row_id")

  if (!is.null(transcription$text)) {
    text <- c("Für diese Speisekarte liegt uns eine Transkription vor.",
      "Klicken Sie auf einen orangefarbenen Bereich, um sie aufzurufen.")
    
    render_text <- render_tags(text, icon("info-circle"))
  } else {
    url <- "https://transkribus.eu/r/read/projects/"
    
    text <- c("Für diese Speisekarte liegt uns leider noch",
      "keine Transkription vor. Möchten Sie jetzt eine",
      sprintf("<a href='%s' target='_blank'>beisteuern</a>", url),
      ", um das Angebot zu erweitern?")
    
    render_text <- render_tags(text, icon("exclamation-circle"))
  }

  return(render_text)
})

output$select_food <- DT::renderDataTable({
  req_and_assign(input$select_restaurant, "name")
  req_and_assign(transcription$text, "text")
  req_and_assign(selected_row$id, "row_id")
  
  rid_clicked <- input$rectangle_click_id

  if (!is.null(rid_clicked)) {
    id_clicked <- filter(text, rid == rid_clicked)
    cart_ids <- food_cart$data$id
    
    if (!is.na(id_clicked$id[1])) { # food was selected
      text <- filter(text, id %in% id_clicked$id) %>% 
        group_by(id) %>%
        summarise_all(
          list(~paste(na.omit(.), collapse = " "))
        ) %>%
        mutate(
          button = case_when(
            id %in% cart_ids ~ cart_input_button(
              id, name, entry, price, recipe_id, rm = TRUE
            ),
            !(id %in% cart_ids) ~ cart_input_button(
              id, name, entry, price, recipe_id, rm = FALSE
            )
          )
        )
    } else { # text or category was selected
      text <- filter(text, rid == rid_clicked) %>% 
        mutate(button = "") # nothing to change here
    }
    
    text %>% 
      select(entry, price, button) %>% 
      mutate(price = as.double(price)) %>%
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

output$recommend_food <- renderUI({
  req_and_assign(recommendation$text, "text")
  render_text <- tagList(icon("thumbs-o-up"), text)

  return(render_text)
})

output$automate_menu_text <- renderUI({
  req_and_assign(input$automate_menu_range, "max_price")
  req_and_assign(input$select_restaurant, "name")
  req_and_assign(transcription$text, "text")
  
  choices <- text %>% pull(category) %>% unique()
  choices <- choices[!is.na(choices)]

  if (length(choices) > 0) {
    req_and_assign(input$automate_menu_categories, "categories")
    
    values <- filter(text, category %in% categories) %>%
      select(id, category) %>% distinct()
    
    # there is no tidy alternative, as far as I know
    ids <- split(values$id, values$category) %>% 
      cross_df() %>% unite("ids") %>%
      mutate(price = map(ids, 
        get_price, data = text)) %>%
      mutate(price = unlist(price)) %>%
      filter(price <= max_price)

    if (nrow(ids) > 0) {
      ids <- sample_n(ids, 1) %>% 
        pull(ids) %>% split_ids()
    }
  } else {
    ids <- sample_n(text, nrow(text)) %>%
      mutate(cum_price = cumsum(price)) %>%
      filter(cum_price <= max_price) %>% pull(id)
  }

  if (length(ids) > 0) {
    text <- filter(text, id %in% ids) %>%
      select(id, entry, price) %>% group_by(id) %>%
      summarise_all(
        list(~paste(na.omit(.), collapse = " "))
      )
    
    auto_menu$data <- text %>%
      mutate_all(as.character) %>%
      mutate(name = name)
    
    text <- paste0("„", text$entry, "“") %>%
      paste(collapse = ", ") %>% text_paste()
    
    render_text <- paste0("Wir empfehlen Ihnen ", text, ".")
  } else {
    auto_menu$data <- NULL
    
    render_text <- paste("Ihr Budget reicht leider nicht aus,", 
      "um ein Menü aus diesen Speisen zusammenzustellen.")
  }
  
  return(render_text)
})