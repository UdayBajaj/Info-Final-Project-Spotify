library("httr")
# install.packages("RCurl")
library("RCurl") # new package we haven't used before make sure to install
library("jsonlite")
library("dplyr")
library("ggplot2")
library("plotly")

# This file is for authorizing the spotify API making requests to the API and
# making calls to the API

# store client_id and client_secret in keys.R file hidden by gitignore
source("keys.R")

# format project id for authorization with the API
id_secret <- base64(paste(client_id, client_secret, sep = ":"))

# authorize project with API
auth <- POST("https://accounts.spotify.com/api/token",
  add_headers("Authorization" = paste0("Basic ", id_secret)),
  body = list(grant_type = "client_credentials"),
  encode = "form"
)

auth_body <- content(auth)
auth_body

# create token/key for all requests for the API
token <- auth_body$access_token


##################
##################
# Even's Section #
##################
##################

### The following get requests are each for playlists created by spotify
### which are representative of a popular music for a specific music genre

# get rap caviar playlist by spotify
# these tracks represent the hip hop genre
hiphop_response <- GET(
  "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZF1DX0XUsuxWHRQd/tracks",
  add_headers("Authorization" = paste0("Bearer ", token))
)
hiphop_body <- content(hiphop_response, "text")
hiphop_data <- fromJSON(hiphop_body)

# get mega hit mix playlist by spotify
# these tracks represent the pop genre
pop_response <- GET(
  "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZF1DXbYM3nMM0oPk/tracks",
  add_headers("Authorization" = paste0("Bearer ", token))
)
pop_body <- content(pop_response, "text")
pop_data <- fromJSON(pop_body)

# get mint playlist by spotify
# these tracks represent the electronic genre
electro_response <- GET(
  "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZF1DX4dyzvuaRJ0n/tracks",
  add_headers("Authorization" = paste0("Bearer ", token))
)
electro_body <- content(electro_response, "text")
electro_data <- fromJSON(electro_body)

# get rock this playlist by spotify
# these tracks represent the rock genre
rock_response <- GET(
  "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZF1DXcF6B6QPhFDv/tracks",
  add_headers("Authorization" = paste0("Bearer ", token))
)
rock_body <- content(rock_response, "text")
rock_data <- fromJSON(rock_body)

# get hot country playlist by spotify
# these tracks represent the country genre
country_response <- GET(
  "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZF1DX1lVhptIYRda/tracks",
  add_headers("Authorization" = paste0("Bearer ", token))
)
country_body <- content(country_response, "text")
country_data <- fromJSON(country_body)

# format the first 20 track id's from each playlist into one vector
genre_track_ids <- c(
  pop_data$items$track$id[1:20],
  hiphop_data$items$track$id[1:20],
  electro_data$items$track$id[1:20],
  rock_data$items$track$id[1:20],
  country_data$items$track$id[1:20]
)

# get the audio features for the 100 sampled songs
genre_track_response <- GET(
  paste0(
    "https://api.spotify.com/v1/audio-features/?ids=",
    paste0(genre_track_ids, collapse = ",")
  ),
  add_headers("Authorization" = paste0("Bearer ", token))
)
genre_track_body <- content(genre_track_response, "text")
genre_track_data <- fromJSON(genre_track_body)

# store the vector of danceability values for the tracks
genre_danceability <- genre_track_data$audio_features$danceability

# create vector of the mean danceability values for each genre from the 
# sampled tracks. Order corresponds to: pop, hiphop, electronic, rock, country
average_danceability <- c(
  mean(genre_danceability[1:20], na.rm = TRUE),
  mean(genre_danceability[21:40], na.rm = TRUE),
  mean(genre_danceability[41:60], na.rm = TRUE),
  mean(genre_danceability[61:80], na.rm = TRUE),
  mean(genre_danceability[81:100], na.rm = TRUE)
)

genre_dance_df <- data.frame("genre" = c("Pop",
                               "Hip Hop",
                               "Electronic",
                               "Rock",
                               "Country"),
                             average_danceability)


##################
##################
# Uday's Section #
##################
##################

#creates the URI that will be used in the Get Request
base_uri <- "https://api.spotify.com/v1/users/"
user_id <- "wavypaper"
playlist_id <- "37i9dQZEVXbLRQDuF5jeBp"
response_uri <- paste0(base_uri,user_id, "/playlists/",playlist_id,"/tracks")

# Makes an API request to Spotify for the desired data
response <- GET(
  response_uri,
  add_headers("Authorization" = paste0("Bearer ", token))
)

# Unpakcs the JSON data and makes it readable
body <- content(response, "text")
parsed_data <- fromJSON(body)
flat_data <- flatten(parsed_data$items)

# Organizes the tracks by popularity and passes the 10 most popular tracks to a 
# Seperate dataset
flat_data <- arrange(flat_data, desc(track.popularity))
top_10_tracks <- slice(flat_data, 1:10)

# Seperates out the nested list of artist data by each artist allowing for
# reading and data manipulation
artist_list <- top_10_tracks$track.album.artists
number_one <- as.data.frame(artist_list[1])
number_two <- as.data.frame(artist_list[2])
number_three <- as.data.frame(artist_list[3])
number_four <- as.data.frame(artist_list[4])
number_five <- as.data.frame(artist_list[5])
number_six <- as.data.frame(artist_list[6])
number_seven <- as.data.frame(artist_list[7])
number_eight<- as.data.frame(artist_list[8])
number_nine <- as.data.frame(artist_list[9])
number_ten <- as.data.frame(artist_list[10])

# returns the name of the artist(s) that worked on each song
artist_one <- paste(number_one$name, collapse = ', ')
artist_two <- paste(number_two$name, collapse = ', ')
artist_three <- paste(number_three$name, collapse = ', ')
artist_four <- paste(number_four$name, collapse = ', ')
artist_five <- paste(number_five$name, collapse = ', ')
artist_six <- paste(number_six$name, collapse = ', ')
artist_seven <- paste(number_seven$name, collapse = ', ')
artist_eight <- paste(number_eight$name, collapse = ', ')
artist_nine <- paste(number_nine$name, collapse = ', ')
artist_ten <- paste(number_ten$name, collapse = ', ')

# creates a vector of artist names that will be passed into a dataframe
ordered_artists <- c(artist_one, 
                     artist_two, 
                     artist_three, 
                     artist_four, 
                     artist_five, 
                     artist_six,
                     artist_seven, 
                     artist_eight, 
                     artist_nine,
                     artist_ten )

# initializes and creates a dataframw with the popularity ranking of artists
# based on the most popular songs on spotify
top_ten_artists <- data.frame(matrix(, nrow=10, ncol=0))
top_ten_artists <- mutate(top_ten_artists, Rank = c(1:10))
top_ten_artists <- mutate(top_ten_artists, Artists = ordered_artists)
View(top_ten_artists)

#################
### Daniel's ####
#################

# Make an API request to Spotify for the desired data (Top 50 U.S. Chart playlist)
playlist_response <- GET(
  "https://api.spotify.com/v1/users/spotifycharts/playlists/37i9dQZEVXbLRQDuF5jeBp/tracks",
  add_headers("Authorization" = paste0("Bearer ", token))
)

# Unpack the JSON data and make it readable
body <- content(playlist_response, "text")
top50 <- fromJSON(body)
song_id <- top50$items$track$id

# Get the audio features for the Top 50 U.S. Chart playlist
top50_track_response <- GET(
  paste0(
    "https://api.spotify.com/v1/audio-features/?ids=",
    paste0(song_id, collapse = ",")
  ),
  add_headers("Authorization" = paste0("Bearer ", token))
)

# Unpack the JSON data for audio features and make it readable
audio_features_body <- content(top50_track_response, "text")
top50_audio_features <- fromJSON(audio_features_body)

# Store song id, track name, popularity, danceability into a data frame
top50_df <- data.frame(top50$items$track$id, top50$items$track$name, top50$items$track$popularity, top50_audio_features$audio_features$danceability)


# Create scatter plot for data frame via ggplot2
popularity <- top50$items$track$popularity
danceability <- top50_audio_features$audio_features$danceability

popularity_plot <- ggplot(top50_df, aes(x = popularity, y = danceability)) +
  geom_point(mapping = NULL, data = NULL, stat = "identity") +
  geom_smooth(method = "lm") +
  theme(legend.position="none") +
  labs(title = "Top 50 United States Chart: Popularity vs. Danceability", x = "Popularity", y = "Danceability") +
  xlim(75,100) +
  ylim(0.25,1)
p <- ggplotly(popularity_plot)
