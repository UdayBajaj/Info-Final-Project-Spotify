library("shiny")
source("setup.R") # run the setup file

my_ui <- fluidPage(
  titlePanel("Danceability in Spotify's Music Catalogue"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(tabsetPanel(
      type = "tabs",
      tabPanel("Top Artists"),
      tabPanel("Genre Anaylsis",
               plotOutput("plot"),
               selectInput("select_genre",
                           "Sampled Tracks",
                           c("Pop" = "pop",
                             "Hip Hop" = "hip",
                             "Electronic" = "electro",
                             "Rock" = "rock",
                             "Country" = "country")),
               tableOutput("tracklist")),
      tabPanel("Popularity Analysis",
               plotOutput("plot2", click = "plot_click"),
               verbatimTextOutput("info"),
               p("")
               )
    ))
  )
)

shinyUI(my_ui)
