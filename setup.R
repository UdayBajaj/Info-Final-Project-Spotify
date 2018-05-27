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
     encode = "form")

auth_body <- content(auth)
# create token/key for all requests for the API
token <- auth_body$access_token
<<<<<<< HEAD

playlist_response <- GET(
  "https://api.spotify.com/v1/users/spotify/playlists/37i9dQZF1DX0XUsuxWHRQd/tracks",
  add_headers("Authorization" = paste0("Bearer ", token))
)
=======
>>>>>>> 8e159fd4b731fed609aa0565bfbbddbdcbdc8749
