library("shiny")
source("setup.R") # run the setup file

my_ui <- fluidPage(
  titlePanel("Danceability in Spotify's Music Catalogue"),
  sidebarLayout(
    sidebarPanel(p("Introduction:
                   For our study, we wanted to analyze changes and trends in popular music.
                   To do that, we decidede to use the Spotify API because Spotify is one of the most popular music streaming sites.
                   From there, we decided to track:
                   - the most popular artists (based on their standings in the Top 50 Songs playlist)
                   - the average 'danceability' of songs across multiple selected genres (Pop, Hip Hop, Electronic, Rock, Country)
                   - and the correlation (if any) between a song's 'danceability' and 'popularity' (see Defining Metrics below)
                   We beleive that these three metrics provide a general overview in music trends at a given time period, and are sufficient in answering our overarching questions. 
                   "),
                 p("The Spotify API: 
                    The Spotify API seemed intimidating at first, but after some experimenting and tinkering, became very easy to use and and easy to interpret.
                    We had originally hoped that Spotify would provide more data regarding the popularity of a track or artist across various regions, but unfortunately that was outside of the scope of the availible APIs. 
                    Ultimately, we were very satisfied with both the useability and the data provided by the Spotify API. 
                    "),
                 p("Defining Metrics:
                    Popularity - Spotify grades the popularity of songs on a 0 to 100 scale, with a score of 100 being the most popular and 0 being the least. The algorithim calculates this based on the number and frequency of plays the track has had, and how recent those plays are. 
                    Danceability - Spotify grades the danceability (how suitable a track is for dancing) of a song on a 0.0 to 1.0 scale, with a score of 0.0 being very difficult to dance to and a score of 1.0 being very danceable. The algorithim calculates this based on a song's tempo, rythm stability, beat strength, and various other musical elem"
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