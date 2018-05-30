library("shiny")
source("setup.R") # run the setup file

my_ui <- fluidPage(
  titlePanel("Danceability in Spotify's Music Catalogue"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(tabsetPanel(
      type = "tabs",
      tabPanel("Genres", plotOutput("plot"))
    ))
  )
)

shinyUI(my_ui)
