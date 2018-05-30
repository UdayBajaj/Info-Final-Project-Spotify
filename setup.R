library("httr")
library("RCurl") # new package we haven't used before make sure to install
library("jsonlite")
library("dplyr")

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




