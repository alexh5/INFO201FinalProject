#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
#source("test.R")
library(shiny)
library(leaflet)
library(plotly)
library(dplyr)


#con for hospitals
#hospital <- makeIcon("data/Hospital.jpg",40,40)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$map <- renderLeaflet({
    leaflet(data = US.filtered.data) %>% addTiles() %>%
      addMarkers( ~US.filtered.data$lon, ~US.filtered.data$lat,
                 popup = paste(
                   US.filtered.data$Hospital.Name, "<br>",
                   US.filtered.data$Address, "<br>",
                   US.filtered.data$City, US.filtered.data$State, US.filtered.data$ZIP.Code, "<br>",
                   "Number:", US.filtered.data$Phone.Number, "<br>",
                   "Hospital overall rating:", US.filtered.data$Hospital.overall.rating, "<br>",
                   US.filtered.data$link
                               ),
                 clusterOptions = markerClusterOptions()
                 #Implements Icon
                 #, icon = hospital
                 )
    
     })
  
  output$plot1 <- renderPlotly({
    
    # Read in big data and filter for columns relative to the three heart problems
    hospital.readmissions.result <- read.csv("data/Hospital_Readmissions_Reduction_Program.csv", stringsAsFactors = F)
    hospital.spending.result <- read.csv("data/Medicare_Hospital_Spending_Per_Patient_-_Hospital.csv")
    hospital.readmissions.data <- select(hospital.readmissions.result, Hospital.Name, Measure.Name, Number.of.Discharges,
                                         Number.of.Readmissions, Excess.Readmission.Ratio, State) 
    hospital.HF.data <- filter(hospital.readmissions.data, Measure.Name == "READM-30-HF-HRRP" & (State == "WA" | State == "CA" | State == "OR")) %>% select(Hospital.Name, State,Measure.Name,Excess.Readmission.Ratio)
    hospital.AMI.data <- filter(hospital.readmissions.data, Measure.Name == "READM-30-AMI-HRRP" & (State == "WA" | State == "CA" | State == "OR")) %>% select(Hospital.Name, State,Measure.Name, Excess.Readmission.Ratio)
    hospital.CABG.data <- filter(hospital.readmissions.data, Measure.Name == "READM-30-CABG-HRRP" & (State == "WA" | State == "CA" | State == "OR")) %>% select(Hospital.Name, State,Measure.Name, Excess.Readmission.Ratio)
    hospital.spending.data <- filter(hospital.spending.result,(State == "WA" | State == "CA" | State == "OR")) %>% select(Hospital.Name, State, Score)
    
    
    hospital.names.readmissions <- hospital.HF.data[, 1]
    hospital.spending.subset <- subset(hospital.spending.data, Hospital.Name %in% hospital.names.readmissions)
    hospital.spending.subset <- hospital.spending.subset[-c(13), ]

    hospital.names.spending <- hospital.spending.subset[, 1]
    hospital.HF.subset <- subset(hospital.HF.data, Hospital.Name %in% hospital.names.spending)
    hospital.AMI.subset <- subset(hospital.AMI.data, Hospital.Name %in% hospital.names.spending)
    hospital.CABG.subset <- subset(hospital.CABG.data, Hospital.Name %in% hospital.names.spending)
    
    joined.HF <- inner_join(hospital.spending.subset, hospital.HF.subset)
    joined.HF <- filter(joined.HF, Score != "Not Available" & Excess.Readmission.Ratio != "Not Available")
    joined.AMI <- inner_join(hospital.spending.subset, hospital.AMI.subset)
    joined.AMI <- filter(joined.AMI, Score != "Not Available" & Excess.Readmission.Ratio != "Not Available")
    joined.CABG <- inner_join(hospital.spending.subset, hospital.CABG.subset)
    joined.CABG <- filter(joined.CABG, Score != "Not Available" & Excess.Readmission.Ratio != "Not Available")

    
    # Selects relevant data based on user's selection of heart problem
    if (input$choices == "Heart Failure") {
      target.data <- joined.HF
      title.label <- "Heart Failure"
    } else if (input$choices == "Heart Attack") {
      target.data <- joined.AMI
      title.label <- "Heart Attack"
    } else {
      target.data <- joined.CABG
      title.label <- "CABG"
    }
    
    # Graph scatter plot
    graph <- plot_ly(
      data  = target.data, x = ~Score, y = ~Excess.Readmission.Ratio, type = "scatter",
      text = ~paste("Hospital: ", Hospital.Name, '<br>State:', State)
    ) %>%
      layout(
      title = title.label,
      xaxis = list(
        title = "Hospital Spending Compared to Average"
      ),
      yaxis = list(
        title = "Excess Readmission Ratio"
      )

    )

        
  })
  
  output$plot2 <- renderPlotly({
    
  })
  
 
 
}
)
