#Install packages

#NB: These have previously been loading during 01 - Get Chart Data.R
#library(rvest)
#library(tidyverse)
#library(DT)
#library(itunesr)
#library(xml2)

#Read in the data generated in 01 - Get Chart Data.R if required.
podcast_links <- readRDS('data/podcast_links.rds')

#To demonstrate the get_reviews function from itunesr, we
#can cet 1st page of reviews for 1 podcast, 1 country
pod_id <- podcast_links$apple_id[[1]]
#Create reviews template
page <- 1
reviews <- getReviews(pod_id,'gb', page) #needs ID, country and page #
reviews$country <- 'gb'
reviews$podcast <- podcast_links$podcast[[1]]
reviews$pod_id <- podcast_links$apple_id[[1]]
reviews$review_page <- page
reviews <- reviews[, c(9:11, 1:8)]

#Create dataframe of all global Apple stores and countries
code <- c("al", "dz", "ao", "ai", "ag", "ar", "am", "au", "at", "az",
          "bs", "bh", "bb", "by", "be", "bz", "bj", "bm", "bt", "bo", 
          "bw", "br", "vg", "bn", "bg", "bf", "kh", "ca", "cv", "ky",
          "td", "cl", "cn", "co", "cr", "hr", "cy", "cz", "cg", "dk",
          "dm", "do", "ec", "eg", "sv", "ee", "fm", "fj", "fi", "fr",
          "gm", "de", "gh", "gb", "gr", "gd", "gt", "gw", "gy", "hn",
          "hk", "hu", "is", "in", "id", "ie", "il", "it", "jm", "jp",
          "jo", "kz", "ke", "kg", "kw", "la", "lv", "lb", "lr", "lt",
          "lu", "mo", "mk", "mg", "mw", "my", "ml", "mt", "mr", "mu", 
          "mx", "md", "mn", "ms", "mz", "na", "np", "nl", "nz", "ni",
          "ne", "ng", "no", "om", "pk", "pw", "pa", "pg", "py", "pe", 
          "ph", "pl", "pt", "qa", "tt", "ro", "ru", "kn", "lc", "vc", 
          "st", "sa", "sn", "sc", "sl", "sg", "sk", "si", "sb", "za", 
          "kr", "es", "lk", "sr", "sz", "se", "ch", "tw", "tj", "tz", 
          "th", "tn", "tr", "tm", "tc", "ug", "ua", "ae", "us", "uy", 
          "uz", "ve", "vn", "ye", "zw")

country <- c("Albania", "Algeria", "Angola", "Anguilla", "Antigua and Barbuda",
             "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bahamas",
             "Bahrain", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bermuda",
             "Bhutan", "Bolivia", "Botswana", "Brazil", "British Virgin Islands",
             "Brunei Darussalam", "Bulgaria", "Burkina-Faso", "Cambodia", "Canada",
             "Cape Verde", "Cayman Islands", "Chad", "Chile", "China", "Colombia", 
             "Costa Rica", "Croatia", "Cyprus", "Czech Republic", 
             "Democratic Republic of the Congo", "Denmark", "Dominica", "Dominican Republic",
             "Ecuador", "Egypt", "El Salvador", "Estonia", "Federated States of Micronesia", 
             "Fiji", "Finland", "France", "Gambia", "Germany", "Ghana", "Great Britain",
             "Greece", "Grenada", "Guatemala", "Guinea Bissau", "Guyana", "Honduras",
             "Hong Kong", "Hungaria", "Iceland", "India", "Indonesia", "Ireland",
             "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan",
             "Kenya", "Krygyzstan", "Kuwait", "Laos", "Latvia", "Lebanon",
             "Liberia", "Lithuania", "Luxembourg", "Macau", "Macedonia",
             "Madagascar", "Malawi", "Malaysia", "Mali", "Malta", "Mauritania",
             "Mauritius", "Mexico", "Moldova", "Mongolia", "Montserrat", "Mozambique",
             "Namibia", "Nepal", "Netherlands", "New Zealand", "Nicaragua", "Niger",
             "Nigeria", "Norway", "Oman", "Pakistan", "Palau", "Panama",
             "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland",
             "Portugal", "Qatar", "Republic of Trinidad and Tobago", "Romania",
             "Russia", "Saint Kitts and Nevis", "Saint Lucia",
             "Saint Vincent and the Grenadines", "Sao Tome e Principe",
             "Saudi Arabia", "Senegal", "Seychelles", "Sierra Leone",
             "Singapore", "Slovakia", "Slovenia", "Soloman Islands", 
             "South Africa", "South Korea", "Spain", "Sri Lanka", 
             "Suriname", "Swaziland", "Sweden", "Switzerland", 
             "Taiwan", "Tajikistan", "Tanzania", "Thailand", "Tunisia", 
             "Turkey", "Turkmenistan", "Turks and Caicos Islands", 
             "Uganda", "Ukraine", "United Arab Emirates", 
             "United States of America", "Uruguay", "Uzbekistan", 
             "Venezuela", "Vietnam", "Yemen", "Zimbabwe")  

apple <- as.data.frame(cbind(code, country))
write_rds(apple, 'data/apple_store_codes.rds')