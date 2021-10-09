#Install packages

#NB: These have previously been loading during 01 - Get Chart Data.R
#library(rvest)
#library(tidyverse)
#library(DT)
#library(itunesr)
#library(xml2)

#Read in the data generated in 01 - Get Chart Data.R if required.
podcast_links <- readRDS('data/podcast_links.rds')

#Get episode data for the first podcast
podcast_name <- podcast_links$podcast[[1]]
rss <- podcast_links$rss[[1]]
pod_id <- podcast_links$apple_id[[1]]
chart <- podcast_links$chart[[1]]
chart_week <- podcast_links$date[[1]] 
chart_position <- podcast_links$chart_position[[1]]
css_descriptors <- c('title', 'pubDate', 'itunes\\:summary', 'itunes\\:duration') # XML tags of interest
col_names <- c('title', 'pubdate','summary', 'duration') # Initial column names for tibble
# Load XML feed and extract items nodes
podcast_feed <- read_xml(rss)
items <- xml_nodes(podcast_feed, 'item')
# Extracts from an item node the content defined by the css_descriptor
extract_element <- function(item, css_descriptor) { 
  element <- xml_node(item, css_descriptor) %>% xml_text
  element 
}
episode_data <- sapply(css_descriptors, function(x) { 
  extract_element(items, x)}
) %>% as_tibble()
names(episode_data) <- col_names # Set new column names
episode_data$podcast <- podcast_name
episode_data$rss <- rss 
episode_data$pod_id <- pod_id
episode_data$chart <- chart
episode_data$chart_week <- chart_week
episode_data$chart_position <- chart_position
episode_data$episode_id <- nrow(episode_data):1
episode_data <- episode_data[c(5:11, 1:4)]

#Get episode data for remaining podcasts
for (i in 2:nrow(podcast_links)) {
  try ({
    episode_data <- episode_data
    podcast_name <- podcast_links$podcast[[i]]
    print(paste("Getting info for", podcast_name, sep = " "))
    rss <- podcast_links$rss[[i]]
    pod_id <- podcast_links$apple_id[[i]]
    chart <- podcast_links$chart[[i]]
    chart_week <- podcast_links$date[[i]] 
    chart_position <- podcast_links$chart_position[[i]]
    css_descriptors <- c('title', 'pubDate', 'itunes\\:summary', 'itunes\\:duration') # XML tags of interest
    col_names <- c('title', 'pubdate','summary', 'duration') # Initial column names for tibble
    # Load XML feed and extract items nodes
    podcast_feed <- read_xml(rss)
    items <- xml_nodes(podcast_feed, 'item')
    # Extracts from an item node the content defined by the css_descriptor
    extract_element <- function(item, css_descriptor) { 
      element <- xml_node(item, css_descriptor) %>% xml_text
      element 
    }
    episodes <- sapply(css_descriptors, function(x) { 
      extract_element(items, x)}
    ) %>% as_tibble()
    names(episodes) <- col_names # Set new column names
    episodes$podcast <- podcast_name
    episodes$rss <- rss 
    episodes$pod_id <- pod_id
    episodes$chart <- chart
    episodes$chart_week <- chart_week
    episodes$chart_position <- chart_position
    episodes$episode_id <- nrow(episodes):1
    episodes <- episodes[c(5:11, 1:4)]
    episode_data <- rbind(episode_data, episodes)
    rm(episodes)
  })
}

#Check to see if any of the podcasts in the original chart data are missing
episode_data_ids <- unique(episode_data$pod_id)
podcasts_missing <- podcast_links %>%
  filter(!apple_id %in% episode_data_ids)
nrow(podcasts_missing)

## [1] 0

#write out the data
write_rds(episode_data, "data/episode_data.rds")

#Optional housekeeping
rm(items, podcast_feed, chart, chart_position, 
   chart_week, col_names, css_descriptors, episode_data_ids, 
   i, pod_id, podcast_name, rss, extract_element, podcasts_missing)