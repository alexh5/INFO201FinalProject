library("jsonlite")
library("httr")
library("dplyr")

## Getting started using API to retrieve relevant data from data.medicare.gov


hospital.base.url <- "https://data.medicare.gov/resource/"

hospital.complications.url <- paste0(hospital.base.url, "ukfj-tt6v")
hospital.measures.url <- paste0(hospital.base.url, "w5ci-7egs")
hospital.readmissions.url <- paste0(hospital.base.url, "9n3s-kdb3")
hospital.spending.url <- paste0(hospital.base.url, "rrqw-56er")
hospital.compare.url <- paste0(hospital.base.url, "xubh-q36u")



## Data for: Which hospitals employ health measures that may or may not reduce the risk of
## death or complications after surgery?

#hospital.complications.response <- GET(hospital.complications.url)
#hospital.complications.response <- content(hospital.complications.response, "text")
#hospital.complications.result <- fromJSON(hospital.complications.response)
# View(hospital.complications.result)
#hospital.measures.response <- GET(hospital.measures.url)
#hospital.measures.response <- content(hospital.measures.response, "text")
#hospital.measures.result <- fromJSON(hospital.measures.response)
#View(hospital.measures.result)



hospital.complications.data <- select(hospital.complications.result, hospital_name, measure_name, score) %>%
  filter(measure_name == "Death rate for CABG" | measure_name == "Heart failure (HF) 30-Day Mortality Rate" | measure_name == "Acute Myocardial Infarction (AMI) 30-Day Mortality Rate")
# View(hospital.complications.data)




hospital.measures.data <- select(hospital.measures.result, hospital_name, measure_name, measure_response) %>%
  filter(measure_name == "General Surgery Registry" | measure_name == "Safe surgery checklist use (inpatient)" | measure_name == "Safe surgery checklist use (outpatient)")
View(hospital.measures.data)


## Data for: Which hospitals carry out successful surgeries with minimal hospital readmissions 
## in regards to heart attack or heart failure?

#hospital.readmissions.response <- GET(hospital.readmissions.url)
#hospital.readmissions.response <- content(hospital.readmissions.response, "text")
#hospital.readmissions.result <- fromJSON(hospital.readmissions.response)
#View(hospital.readmissions.result)




hospital.readmissions.result <- read.csv("data/Hospital_Readmissions_Reduction_Program.csv", stringsAsFactors = F)
hospital.spending.result <- read.csv("data/Medicare_Hospital_Spending_Per_Patient_-_Hospital.csv")



hospital.readmissions.data <- select(hospital.readmissions.result, Hospital.Name, Measure.Name, Number.of.Discharges,
                                     Number.of.Readmissions, Excess.Readmission.Ratio, State) 
hospital.HF.data <- filter(hospital.readmissions.data, Measure.Name == "READM-30-HF-HRRP" & (State == "WA" | State == "CA" | State == "OR")) %>% select(Hospital.Name, State,Measure.Name,Excess.Readmission.Ratio)
hospital.AMI.data <- filter(hospital.readmissions.data, Measure.Name == "READM-30-AMI-HRRP" & (State == "WA" | State == "CA" | State == "OR")) %>% select(Hospital.Name, State,Measure.Name, Excess.Readmission.Ratio)
hospital.CABG.data <- filter(hospital.readmissions.data, Measure.Name == "READM-30-CABG-HRRP" & (State == "WA" | State == "CA" | State == "OR")) %>% select(Hospital.Name, State,Measure.Name, Excess.Readmission.Ratio)

hospital.spending.data <- filter(hospital.spending.result,(State == "WA" | State == "CA" | State == "OR")) %>% select(Hospital.Name, State, Score)

# Get hospital names from readmissions HF
hospital.names.readmissions <- hospital.HF.data[, 1]

# Filter spending by hospital names from readmissions HF
hospital.spending.test <- subset(hospital.spending.data, Hospital.Name %in% hospital.names.readmissions)
hospital.spending.test <- hospital.spending.test[-c(13), ]



joined.data <- inner_join(hospital.spending.test, hospital.HF.test)
joined.data <- filter(joined.data, Score != "Not Available" & Excess.Readmission.Ratio != "Not Available")



# Get hospital names for spending
hospital.names.spending <- hospital.spending.test[, 1]
hospital.names.spending <- as.character(hospital.names.spending)

# Filter readmissions by hospital names from spending
hospital.HF.test <- subset(hospital.HF.data, Hospital.Name %in% hospital.names.spending)








View(hospital.spending.data)



hospital.spending.vs.HF.data <- left_join(hospital.spending.test, hospital.HF.data)

test <- merge(data.frame(hospital.HF.data, row.names=NULL), data.frame(hospital.spending.data, row.names=NULL), by = 0, all = TRUE)[-1]



hospital.spending.response <- GET(hospital.spending.url)
hospital.spending.response <- content(hospital.spending.response, "text")
hospital.spending.result <- fromJSON(hospital.spending.response)
#View(hospital.spending.result)

hospital.spending.data <- select(hospital.spending.result, hospital_name, score)
View(hospital.spending.data)




## Data for: What hospitals are around the country and what are their overall ratings of 
## safety and effectiveness? 
hospital.compare.response <- GET(hospital.compare.url)
hospital.compare.response <- content(hospital.compare.response, "text")
hospital.compare.result <- fromJSON(hospital.compare.response)
View(hospital.compare.result)

hospital.compare.data <- select(hospital.compare.result, hospital_name, address, city, state, zip_code, phone_number,
                                hospital_type, hospital_overall_rating, safety_of_care_national_comparison,
                                effectiveness_of_care_national_comparison, patient_experience_national_comparison,
                                location)

View(hospital.compare.data)



test <- select(hospital.compare.data, location)
#%>%
#  select(test, location$latitude)


# must use dollar sign for latitude and longitude for location column
test2 <- test$location$latitude
  

View(test)