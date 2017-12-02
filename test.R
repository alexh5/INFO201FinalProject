library("jsonlite")
library("httr")
library("dplyr")
library("leaflet")
library("stringr")

## Getting started using API to retrieve relevant data from data.medicare.gov


hospital.base.url <- "https://data.medicare.gov/resource/"

hospital.complications.url <- paste0(hospital.base.url, "ukfj-tt6v")
hospital.measures.url <- paste0(hospital.base.url, "w5ci-7egs")
hospital.readmissions.url <- paste0(hospital.base.url, "9n3s-kdb3")
hospital.spending.url <- paste0(hospital.base.url, "rrqw-56er")
hospital.compare.url <- paste0(hospital.base.url, "xubh-q36u")



## Data for: Which hospitals employ health measures that may or may not reduce the risk of
## death or complications after surgery?

hospital.complications.response <- GET(hospital.complications.url)
hospital.complications.response <- content(hospital.complications.response, "text")
hospital.complications.result <- fromJSON(hospital.complications.response)
# View(hospital.complications.result)

hospital.measures.response <- GET(hospital.measures.url)
hospital.measures.response <- content(hospital.measures.response, "text")
hospital.measures.result <- fromJSON(hospital.measures.response)
# View(hospital.measures.result)



## Data for: Which hospitals carry out successful surgeries with minimal hospital readmissions 
## in regards to heart attack or heart failure?

hospital.readmissions.response <- GET(hospital.readmissions.url)
hospital.readmissions.response <- content(hospital.readmissions.response, "text")
hospital.readmissions.result <- fromJSON(hospital.readmissions.response)
# View(hospital.readmissions.result)

hospital.spending.response <- GET(hospital.spending.url)
hospital.spending.response <- content(hospital.spending.response, "text")
hospital.spending.result <- fromJSON(hospital.spending.response)
# View(hospital.spending.result)





## Data for: What hospitals are around the country and what are their overall ratings of 
## safety and effectiveness? 
hospital.compare.response <- GET(hospital.compare.url)
hospital.compare.response <- content(hospital.compare.response, "text")
hospital.compare.result <- fromJSON(hospital.compare.response)
#View(hospital.compare.result)

hospital.compare.data <- select(hospital.compare.result, hospital_name, address, city, state, zip_code, phone_number,
                                hospital_type, hospital_overall_rating, safety_of_care_national_comparison,
                                effectiveness_of_care_national_comparison, patient_experience_national_comparison,
                                location)

#View(hospital.compare.data)

##DATA FOR LEAFLET MAP
##
#Read in data of hospitals in US
#setwd("~/info201/INFO201FinalProject")
US.data <- read.csv("first-2470-latlong.csv")
#Filter only relevent information
US.filtered.data <- select(US.data, State, lon,lat, Hospital.Name,Phone.Number, Hospital.overall.rating, Address, City, State, ZIP.Code)
#Remove locations with NUll data
US.filtered.data <- US.filtered.data[rowSums(is.na(US.filtered.data)) == 0,]
#Creates Column for hospital hyperlink
US.filtered.data$link <- paste0("https://www.google.com/search?q=", US.filtered.data$Hospital.Name)
US.filtered.data$link <- paste0("<a href='",US.filtered.data$link,"'>"," Link to Hospital" ,"</a>")
#Fix Hospital name and Phone Numbers
US.filtered.data$Hospital.Name <- str_to_title(test.next$Hospital.Name)
US.filtered.data$Phone.Number <- gsub("(\\d{3})(\\d{3})(\\d{4})$","\\1-\\2-\\3",US.filtered.data$Phone.Number)
US.filtered.data$Phone.Number <- sub("(.{3})(.*)", "(\\1)\\2", US.filtered.data$Phone.Number)
#Convert long and lat to numeric for leaflet
US.filtered.data$lon <- as.numeric(as.character(US.filtered.data$lon))
US.filtered.data$lat <- as.numeric(as.character(US.filtered.data$lat))



# must use dollar sign for latitude and longitude for location column
test2 <- test$location$latitude
  

View(test)
