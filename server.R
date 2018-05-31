library("shiny")
library("ggplot2")
library("dplyr")
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

  # create table showing sampled songs for each genre selected by user  
  output$tracklist <- renderTable({
    if(input$select_genre == "pop") {
    tracks_table <- pop_data$items$track %>%
        select(name) %>%
        slice(1:20) %>%
        mutate(danceability = genre_danceability[1:20]) %>%
        rename(Track = name, Danceability = danceability)
    }
    if(input$select_genre == "hip") {
      tracks_table <- hiphop_data$items$track %>%
        select(name) %>%
        slice(1:20) %>%
        mutate(danceability = genre_danceability[21:40]) %>%
        rename(Track = name, Danceability = danceability)
    }
    if(input$select_genre == "electro") {
      tracks_table <- electro_data$items$track %>%
        select(name) %>%
        slice(1:20) %>%
        mutate(danceability = genre_danceability[41:60]) %>%
        rename(Track = name, Danceability = danceability)
    }
    if(input$select_genre == "rock") {
      tracks_table <- rock_data$items$track %>%
        select(name) %>%
        slice(1:20) %>%
        mutate(danceability = genre_danceability[61:80]) %>%
        rename(Track = name, Danceability = danceability)
    }
    if(input$select_genre == "country") {
      tracks_table <- country_data$items$track %>%
        select(name) %>%
        slice(1:20) %>%
        mutate(danceability = genre_danceability[81:100]) %>%
        rename(Track = name, Danceability = danceability)
    }
    tracks_table
  })
  
  # create header for table
  output$table_title <- renderText({
    if(input$select_genre == "pop") {
      title_result <- "Mega Hit Mix Playlist by Spotify"
    }
    if(input$select_genre == "hip") {
      title_result <- "Rap Caviar Playlist by Spotify"
    }
    if(input$select_genre == "electro") {
      title_result <- "mint Playlist by Spotify"
    }
    if(input$select_genre == "rock") {
      title_result <- "Rock This Playlist by Spotify"
    }
    if(input$select_genre == "country") {
      title_result <- "Hot Country Playlist by Spotify"
    }
    title_result
  })
  
  output$plot2 <- renderPlot({
    popularity_plot_interactive
  })
  output$table <- renderDataTable(top_ten_artists)
}

shinyServer(my_server)
