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
               plotOutput("plot")),
      tabPanel("Popularity Analysis",
               plotOutput("plot2"),
               p("The scatterplot above represents the data for popularity and danceability values for the U.S. Top 50 Chart playlist on Spotify,
                 with popularity on the x-axis and danceability on the y-axis. We thought that popularity and danceability would be interesting 
                categories of data, since they are very distinct but also very closely related in that the sound of most mainstream, popular 
                music also happens to be music that you can dance to. Despite this, our data visualization for the Top 50 U.S. Chart shows no 
                strong correlation between popularity and danceability.")
               )
    ))
  )
)

shinyUI(my_ui)
