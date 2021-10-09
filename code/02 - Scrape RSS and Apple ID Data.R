#Install packages

#NB: These have previously been loading during 01 - Get Chart Data.R 
#library(rvest)
#library(tidyverse)
#library(DT)
#library(itunesr)

#Read in the data generated in 01 - Get Chart Data.R if required.
podcast_info <- readRDS('data/podcast_info.rds')

#For the purposes of this demonstration, only information on the first three podcasts in the chart are gathered.
podcast_info <- podcast_info[1:3,] ##to select instead the first ten podcasts, amend 1:3 to 1:10. And so on.

#Gather information on the first podcast
url <- podcast_info$chartable_url[[1]]
podcast <- podcast_info$podcast[[1]]
webpage <- read_html(url)
podcast_page <- html_nodes(webpage,'.f6 a')
podcast_links <- as.data.frame(html_text(podcast_page))
podcast_links$urls <- as.data.frame(html_attr(podcast_page, 'href'))
rss_apple <- podcast_links %>%
  filter(`html_text(podcast_page)` == "RSS feed" | `html_text(podcast_page)` == "Listen on Apple Podcasts")
links <- as.data.frame(podcast)
links$chartable_url <- url
rss_apple <- as.data.frame(rss_apple$url)
links$rss <- rss_apple$`html_attr(podcast_page, "href")`[[1]]
links$apple <- rss_apple$`html_attr(podcast_page, "href")`[[2]]
links$apple_id <- gsub(".*id", "", links$apple[[1]])
links$apple_id <- sub("at.*", "", links$apple_id) 
links$apple_id <- str_remove(links$apple_id, "[?]")
links$apple_id <- as.numeric(links$apple_id)

#Gather information on the remaining podcasts
for (i in 2:nrow(podcast_info)) {
  url <- podcast_info$chartable_url[[i]]
  podcast <- podcast_info$podcast[[i]]
  number <- podcast_info$chart_position[[i]]
  print(paste("Getting info for", podcast, ": Number", number, sep = " "))
  webpage <- read_html(url)
  podcast_page <- html_nodes(webpage,'.f6 a')
  podcast_links <- as.data.frame(html_text(podcast_page))
  podcast_links$url <- as.data.frame(html_attr(podcast_page, 'href'))
  rss_apple <- podcast_links %>%
    filter(`html_text(podcast_page)` == "RSS feed" | `html_text(podcast_page)` == "Listen on Apple Podcasts")
  links_new <- as.data.frame(podcast)
  links_new$chartable_url <- url
  rss_apple <- as.data.frame(rss_apple$url)
  links_new$rss <- rss_apple$`html_attr(podcast_page, "href")`[[1]]
  links_new$apple <- rss_apple$`html_attr(podcast_page, "href")`[[2]]
  links_new$apple_id <- gsub(".*id", "", links_new$apple[[1]])
  links_new$apple_id <- sub("at.*", "", links_new$apple_id) 
  links_new$apple_id <- str_remove(links_new$apple_id, "[?]")
  links_new$apple_id <- as.numeric(links_new$apple_id)
  links <- rbind(links, links_new)
  rm(links_new, rss_apple, podcast_links)
  print(paste("Waiting", 5, "seconds before getting next podcast", sep = " "))
  Sys.sleep(5)
}

#Merge newly gathered information with original podcast_links dataframe
podcast_links <- merge(podcast_info,links, by="chartable_url")
podcast_links <- podcast_links[order(podcast_links$chart_position),]
podcast_links$podcast.x <- NULL
podcast_links <- podcast_links %>%
  rename(podcast = podcast.y)

#Optional housekeeping
rm(links, podcast_info, podcast_page, webpage, i, number, podcast, url) 

#write out data
write_rds(podcast_links, "data/podcast_links.rds")



