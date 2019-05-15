panel_speisekarten <- tabItem(tabName = "speisekarten",
  fluidRow(
    column(width = 3,
      box(width = 12, title = p("Lokalität auswählen", 
          tooltip_button("leaflet_button", 
            fa_icon = icon("map-o"))
          ), 
          class = "inner-padding",
        selectInput("select_restaurant", "", choices = "")
      ),
      box(width = 12, title = p("Weitere Informationen",
          uiOutput("homepage_button")),
        uiOutput("update_metadata"),
        DT::dataTableOutput("select_menu")
      )
    ),
    
    box(width = 6, title = p("Speisekarte ansehen"), 
      leafletOutput("menu_leaflet", 
        width = "100%", height = "100%")
    ),
    
    div(class = "dark-blue",
      box(width = 3, title = p("Speisen auswählen",
          tooltip_button("automate_menu_button", 
            fa_icon = icon("question-circle"))
          ), 
        uiOutput("update_food"),
        DT::dataTableOutput("select_food")
      ),
      hidden(
        div(id = "recommendation",
          box(width = 3, title = p("Besonders empfehlenswert",
              tooltip_button("reload_button", 
                fa_icon = icon("refresh"))
              ), 
            uiOutput("recommend_food")
          )
        )
      )
    )
  )
)