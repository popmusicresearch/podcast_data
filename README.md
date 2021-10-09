# Podcast Data 

Gathering data on Apple podcast charts along with episode, review and ratings data for podcasts listed in a given chart. For a full explanation of the process see [this post](https://www.popmusicresearch.org/post/rate-review-partone/) on my website


## scripts

<b>01 - Get Chart Data</b>

This script gathers data for a given podcast chart on the [Chartable](https://chartable.com) website.

<b>02 - Scrape RSS and Apple ID data</b>

This script uses the data gathered in the first script to extract RSS feed links and Apple IDs for each podcast in a given chart. 

<b>03 - Get episode data</b>

Using the RSS feed links gathered in the previous step, this script gathers epispode data for each of the podcasts in a given chart. 
