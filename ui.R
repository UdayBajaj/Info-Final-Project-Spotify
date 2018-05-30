library("shiny")
source("setup.R") # run the setup file

my_ui <- fluidPage(
  titlePanel("Danceability in Spotify's Music Catalogue"),
  sidebarLayout(
    sidebarPanel(),
    mainPanel(tabsetPanel(
      type = "tabs",
      tabPanel("Top Artists"),
      tabPanel("Genre Anaylsis", plotOutput("plot")),
      tabPanel("Popularity Analysis")
    ))
  )
)

shinyUI(my_ui)
