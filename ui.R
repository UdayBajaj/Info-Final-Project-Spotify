library("shiny")
source("setup.R") # run the setup file

my_ui <- fluidPage(
  titlePanel("Danceability in Spotify's Music Catalogue"),
  sidebarLayout(
    sidebarPanel(p(tags$b("Introduction:"),
                   "This study is an analysis of changes and trends in popular music.
                   To do that, we used the Spotify API because Spotify is one of the most popular music streaming sites.
                   From there, we decided to track:"),
                 tags$ul(
                   tags$li("Most popular artists (based on their standings in the Top 50 Songs playlist)"),
                   tags$li("Average 'danceability' of songs across multiple selected genres (Pop, Hip Hop, Electronic, Rock, Country)"),
                   tags$li("Correlation (if any) between a song's 'danceability' and 'popularity' (see Defining Metrics below))")),
                   p("We beleive that these three metrics provide a general overview in music trends at a given time period, and are sufficient in answering our overarching questions. 
                   "),
                 p(tags$b("Defining Metrics:"),
                   tags$ul(
                    tags$li("Popularity: Spotify grades the popularity of songs on a 0 to 100 scale, with a score of 100 being the most popular and 0 being the least. The algorithim calculates this based on the number and frequency of plays the track has had, and how recent those plays are."),
                    tags$li("Danceability: Spotify grades the danceability (how suitable a track is for dancing) of a song on a 0.0 to 1.0 scale, with a score of 0.0 being very difficult to dance to and a score of 1.0 being very danceable. The algorithim calculates this based on a song's tempo, rythm stability, beat strength, and various other musical elements")
                   )),
                 p(tags$b("Source:"),
                   "All data is sourced from the Spotify Web API. The API provides metrics and details for their music streaming catalogue.",
                   tags$br(tags$a(href = "https://developer.spotify.com/documentation/web-api/", "More Information"))
                 )
    ),
    mainPanel(tabsetPanel(
      type = "tabs",
      tabPanel("Top Artists", 
               dataTableOutput("table"),
               p("Top Artists:
                The Top Artists tab features a list of the Top 10 most popular artists on Spotify. 
                 This is determined by analyzing the 10 most popular songs on Spotify and returning the names of their artists (in ranked order)
                 We thought that it would be interesting to track the popularity of artists over time, however Spotify's API makes it difficult to do that.
                 Regardless of that, by looking at the most popular artists at a given time, we can gain insights into popular music trends. 
                 "),
               p("Analysis:
                 First and formost, in this particular data set (as of 5/31/18) the majority of the most popular artists are male. Furthermore, of the artists on the list, the vast majority of them can be categorized as rappers.
                 Another point of note, almost half of the most popular tracks are a collaboration. Based on these observations, although it is difficult to make any broad strokes observations of music trends due to the limited sample size,
                 We can use this data to assert that rap music and rappers are incredibly popular at this time, as over half of the most popular artists are rappers")
               ),
      tabPanel("Genre Anaylsis",
               plotOutput("plot"),
               p("Bar graph depicting average track dancebility within each musical genres
                 Pop, Hip Hop, Electronic/Dance, Rock, and Country. The data is sourced
                 from playlists created by spotify containing popular music representative
                 of each genre's sound. Twenty songs are sampled from each playlist and
                 spotify danceability values are used to calculate a mean score for each
                 genre. Select a genre below to view the songs sampled in the vizualization."),
               selectInput("select_genre",
                           "Sampled Tracks",
                           c("Pop" = "pop",
                             "Hip Hop" = "hip",
                             "Electronic" = "electro",
                             "Rock" = "rock",
                             "Country" = "country")),
               h5(textOutput("table_title")),
               tableOutput("tracklist")),
      tabPanel("Popularity Analysis",
               popularity_plot_interactive,
               #plotOutput("plot2"),
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