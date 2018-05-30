library("httr")
# install.packages("RCurl")
library("RCurl") # new package we haven't used before make sure to install
library("jsonlite")
library("ggplot2")
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
     encode = "form")

auth_body <- content(auth)
auth_body

# create token/key for all requests for the API
token <- auth_body$access_token
print(token)

playlist_response <- GET(
  "https://api.spotify.com/v1/users/spotifycharts/playlists/37i9dQZEVXbLRQDuF5jeBp/tracks",
  add_headers("Authorization" = paste0("Bearer ", token))
)
body <- content(playlist_response, "text")
playlist_response

top50 <- fromJSON(body)

View(top50)
View(top50$items)

song_id <- top50$items$track$id
View(song_id)

top50_track_response <- GET(
  paste0(
    "https://api.spotify.com/v1/audio-features/?ids=",
    paste0(song_id, collapse = ",")
  ),
  add_headers("Authorization" = paste0("Bearer ", token))
)

audio_features_body <- content(top50_track_response, "text")
top50_audio_features <- fromJSON(audio_features_body)

View(top50_audio_features)


# song id, track name, popularity, danceability

top50_df <- data.frame(top50$items$track$id, top50$items$track$name, top50$items$track$popularity, top50_audio_features$audio_features$danceability)
View(top50_df)

popularity_danceability <- top50_df


top50_plot <-ggplot(top50_df, aes(x = top50$items$track$popularity, y = top50_audio_features$audio_features$danceability)) +
  geom_point(aes(color = "Top 50 Tracks"))
  labs(title = "Top 50 United States Chart: Popularity vs. Danceability", x = "Popularity", y = "Danceability", color = "Track Name") +
  xlim(60,100) +
  ylim(0.2,1)

top50_plot



