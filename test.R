library("jsonlite")
library("httr")

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
# View(hospital.compare.result)
