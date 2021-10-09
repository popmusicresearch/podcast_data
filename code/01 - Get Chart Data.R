#Load required packages. 
#Use install.package('name of package') if not previously installed.
##NB: itunesr is no longer available in CRAN but is available at: https://github.com/amrrs/itunesr

library(rvest)
library(tidyverse)
library(DT)
library(itunesr)

#Create the get_podcast_chart function
get_podcast_chart <- function(chart_url, name) {
  webpage <- read_html(chart_url)
  podcast_names <- html_nodes(webpage,'.f3 a')
  podcast_info <- as.data.frame(html_text(podcast_names))
  podcast_info$chartable_url <- as.data.frame(html_attr(podcast_names, 'href'))
  podcast_info <- podcast_info[3:nrow(podcast_info), ]
  podcast_info$chart_position <- 1:nrow(podcast_info)
  podcast_info$chart <- chart_name
  podcast_info$date <- Sys.Date()
  podcast_info <- podcast_info[, c(3:5, 1:2)]
  podcast_info <- podcast_info %>%
    rename(podcast = `html_text(podcast_names)`)
  podcast_info$chartable_url$`html_attr(podcast_names, "href")`
  urls <- podcast_info$chartable_url$`html_attr(podcast_names, "href")`
  podcast_info$chartable_url <- urls
  rm(webpage, podcast_names, urls)
  #write_rds(podcast_info, "podcast_chart_info.rds") - if you want to write out the result as an RDS file
  return(podcast_info)
}

#The function takes two inputs:
# 1 - The URL of a given chart on Chartable.com
# 2 - The name of that chart

chart_url <- 'https://chartable.com/charts/itunes/gb-music-podcasts'
chart_name <- "Apple Podcasts - Great Britain - Music"
podcast_info <- get_podcast_chart(chart_url, chart_name)

#Write out data as rds file
write_rds(podcast_info, "data/podcast_info.rds")

#Optional housekeeping: remove chart_url, chart_name and get_podcast_chart
rm(chart_name, chart_url, get_podcast_chart)