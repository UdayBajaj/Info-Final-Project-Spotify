library("shiny")
library("ggplot2")
source("setup.R") # run the setup file

my_server <- function(input, output) {
  output$plot <- renderPlot({
    p <- ggplot(data = genre_dance_df) +
      geom_col(mapping  = aes(x = reorder(genre, -average_danceability),
                              y = average_danceability), fill = "#1db954") +
      labs(title = "Average Genre Danceability",
           x = "Music Genre",
           y = "Danceability Value (Score rated from 0 to 1)")
    p
  })
}

shinyServer(my_server)