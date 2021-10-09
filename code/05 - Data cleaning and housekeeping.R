#Load required packages
install.packages('lubridate')
library(lubridate)
library(dplyr)
library(readr)
library(stringr)

##NB: These small bits of housekeeping are optional, but I have found them
# helpful when it comes to analysis and/or visualisation. 

#Load in data collected in earlier phases
episode_data <- read_rds('data/episode_data.rds')
reviews <- read_rds('data/reviews.rds')

#Convert pub_date from character to date 
class(episode_data$pubdate)
episode_data$date <- str_sub(episode_data$pubdate, 6)
episode_data$date <- dmy_hms(episode_data$date)
class(episode_data$date)

#Make podcasts a factor
class(episode_data$podcast)
episode_data$podcast <- as.factor(episode_data$podcast)
class(episode_data$podcast)

#Rename Date to date in th reviews dataframe
reviews <- reviews %>%
  rename(date = Date)

#Create date_only variable
reviews$date_only <- date(reviews$date)

#Give each review a sequential number for each podcast
reviews <- reviews %>% 
  group_by(podcast) %>% 
  arrange(date) %>%
  mutate(review_id = row_number())

#For visualisations, create a shortened name for each podcast.
reviews$short_name <- substr(reviews$podcast, 1, 10)


#write out data
write_rds(episode_data, "data/episode_data.rds")
write_rds(reviews, "data/reviews.rds")

