library("httr")
library("RCurl") # new package we haven't used before make sure to install
library("jsonlite")

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
# create token/key for all requests for the API
token <- auth_body$access_token

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
