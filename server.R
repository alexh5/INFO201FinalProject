library(shiny)
library(leaflet)
library(plotly)
library(dplyr)
library(stringr)

# Define server logic
shinyServer(function(input, output, session) {
  #sets up data for Map
  US.data <- read.csv("data/General_Hospital_Information_Lat_Lon.csv", stringsAsFactors = FALSE)
  US.data$Hospital.Name <- str_to_title( US.data$Hospital.Name)
  US.data <- arrange(US.data, Hospital.Name)
  # Filter only relevent information
  US.filtered.data <- select(US.data, State, lon,lat, Hospital.Name,Phone.Number, Hospital.overall.rating, Address, City, State, ZIP.Code)
  # Remove locations with NUll data
  US.filtered.data <- US.filtered.data[rowSums(is.na(US.filtered.data)) == 0,]
  # Creates Column for hospital hyperlink
  US.filtered.data$link <- paste0("https://www.google.com/search?q=", US.filtered.data$Hospital.Name)
  US.filtered.data$link <- paste0("<a href='",US.filtered.data$link,"'>"," Link to Hospital" ,"</a>")
  # Fix Hospital name and Phone Numbers
  US.filtered.data$Hospital.Name <- str_to_title(US.filtered.data$Hospital.Name)
  US.filtered.data$Phone.Number <- gsub("(\\d{3})(\\d{3})(\\d{4})$","\\1-\\2-\\3",US.filtered.data$Phone.Number)
  US.filtered.data$Phone.Number <- sub("(.{3})(.*)", "(\\1)\\2", US.filtered.data$Phone.Number)
  # Convert long and lat to numeric for leaflet
  US.filtered.data$lon <- as.numeric(as.character(US.filtered.data$lon))
  US.filtered.data$lat <- as.numeric(as.character(US.filtered.data$lat))
  US.map.data <- US.filtered.data
  # Icon for hospitals
  hospital <- makeIcon("data/Hospital.jpg", iconWidth = 50, iconHeight = 50)
  
  # Produces drop down list for state and search bar for hospital
  output$state <- renderPrint({ input$statefilter })
  output$value <- renderPrint({ input$hospitalName })
  #sets up rv as previous input of stateFilter
  rv <- reactiveValues(lstval="All States and Territories",curval="All States and Territories")
  observeEvent(input$stateFilter, {rv$lstval <- rv$curval; rv$curval <- input$stateFilter})
  # Produces interactive map
  output$map <- renderLeaflet({
    # If state & hospital are not selected
    if(input$stateFilter == "All States and Territories" & input$hospitalName == "All Hospitals") { 
      US.map.data <- US.filtered.data
    # If state isn't selected and hospital is selected
    } else if (input$stateFilter == "All States and Territories" & input$hospitalName != "All Hospitals") { 
      US.map.data <- US.filtered.data
      if(rv$lstval != "All States and Territories" ) {
        updateSelectInput(session, "hospitalName", choices = c("All Hospitals",US.map.data$Hospital.Name))
        rv$lstval <- "All States and Territories"
      }
    # If state is selected & hospital is not selected
    } else if ( input$stateFilter != "All States and Territories" & input$hospitalName == "All Hospitals") { 
      US.State <- filter(US.filtered.data, State == input$stateFilter)
      US.map.data <- filter(US.filtered.data, State == input$stateFilter)
      updateSelectInput(session, "hospitalName", choices = c("All Hospitals",US.map.data$Hospital.Name))
    # If state and hospital are selected
    } else if (input$stateFilter != "All States and Territories" & input$hospitalName != "All Hospitals"){ 
      US.State <- filter(US.filtered.data, State == input$stateFilter)
      if(input$hospitalName %in% US.State$Hospital.Name != TRUE) {
        US.map.data <- filter(US.filtered.data, State == input$stateFilter)
        updateSelectInput(session, "hospitalName", choices = c("All Hospitals",US.map.data$Hospital.Name)) 
      }
    }
    # If hospital is selected
    if (input$hospitalName != "All Hospitals") { 
      US.map.data <- filter(US.map.data, Hospital.Name == str_to_title(input$hospitalName))
    }
    leaflet(data = US.map.data) %>% addTiles() %>%
      addMarkers( ~US.map.data$lon, ~US.map.data$lat,
                  popup = paste(
                    US.map.data$Hospital.Name, "<br>",
                    US.map.data$Address, "<br>",
                    US.map.data$City, US.map.data$State, US.map.data$ZIP.Code, "<br>",
                    "Number:", US.map.data$Phone.Number, "<br>",
                    "Hospital overall rating:", US.map.data$Hospital.overall.rating, "<br>",
                    US.map.data$link
                  ),
                  clusterOptions = markerClusterOptions(),
                  #Implements Icon
                  icon = hospital
      )
  })
  
  
  
  # Read in big data and filter for columns relative to the three heart problems for first scatter plot
  hospital.readmissions.result <- read.csv("data/Hospital_Readmissions_Reduction_Program.csv", stringsAsFactors = FALSE)
  hospital.spending.result <- read.csv("data/Medicare_Hospital_Spending_Per_Patient_-_Hospital.csv", stringsAsFactors = FALSE)
  hospital.readmissions.data <- select(hospital.readmissions.result, Hospital.Name, Measure.Name, Number.of.Discharges,
                                       Number.of.Readmissions, Excess.Readmission.Ratio, State) 
  hospital.readmissions.HF.data <- filter(hospital.readmissions.data, Measure.Name == "READM-30-HF-HRRP" & 
                                            (State == "WA" | State == "CA" | State == "OR")) %>%
    select(Hospital.Name, State, Measure.Name,Excess.Readmission.Ratio)
  joined.readmissions.AMI.data <- filter(hospital.readmissions.data, Measure.Name == "READM-30-AMI-HRRP" &
                                           (State == "WA" | State == "CA" | State == "OR")) %>%
    select(Hospital.Name, State, Measure.Name, Excess.Readmission.Ratio)
  joined.readmissions.CABG.data <- filter(hospital.readmissions.data, Measure.Name == "READM-30-CABG-HRRP" &
                                            (State == "WA" | State == "CA" | State == "OR")) %>%
    select(Hospital.Name, State, Measure.Name, Excess.Readmission.Ratio)
  hospital.spending.data <- filter(hospital.spending.result, (State == "WA" | State == "CA" | State == "OR")) %>%
    select(Hospital.Name, State, Score)
  
  # Finds and select for matching hospital names in the spending and readmissions data set
  hospital.names.readmissions <- hospital.readmissions.HF.data[, 1]
  hospital.spending.subset <- subset(hospital.spending.data, Hospital.Name %in% hospital.names.readmissions)
  hospital.spending.subset <- hospital.spending.subset[-c(13), ]
  
  hospital.names.spending <- hospital.spending.subset[, 1]
  hospital.readmissions.HF.subset <- subset(hospital.readmissions.HF.data, Hospital.Name %in% hospital.names.spending)
  hospital.readmissions.AMI.subset <- subset(joined.readmissions.AMI.data, Hospital.Name %in% hospital.names.spending)
  hospital.readmissions.CABG.subset <- subset(joined.readmissions.CABG.data, Hospital.Name %in% hospital.names.spending)
  
  # Merges relevant spending and readmissions data together to form new data frames for use in graphing
  joined.readmissions.HF <- inner_join(hospital.spending.subset, hospital.readmissions.HF.subset) %>%
    filter(Score != "Not Available" & Excess.Readmission.Ratio != "Not Available")
  joined.readmissions.AMI <- inner_join(hospital.spending.subset, hospital.readmissions.AMI.subset) %>%
    filter(Score != "Not Available" & Excess.Readmission.Ratio != "Not Available")
  joined.readmissions.CABG <- inner_join(hospital.spending.subset, hospital.readmissions.CABG.subset) %>%
    filter(Score != "Not Available" & Excess.Readmission.Ratio != "Not Available")
  
  # Produces first interactive scatter plot
  output$plot1 <- renderPlotly({
    
    # Selects relevant data based on user's selection of heart problem
    if (input$choices == "Heart Failure") {
      target.data <- joined.readmissions.HF
      title.label <- "Heart Failure"
    } else if (input$choices == "Heart Attack") {
      target.data <- joined.readmissions.AMI
      title.label <- "Heart Attack"
    } else {
      target.data <- joined.readmissions.CABG
      title.label <- "CABG"
    }
    
    # Graph scatter plot
    graph <- plot_ly(
      data  = target.data, x = ~Score, y = ~Excess.Readmission.Ratio, type = "scatter",
      text = ~paste("Hospital: ", Hospital.Name, '<br>State:', State),
      marker = list(
        color = factor(target.data$State, labels = c("orange", "purple","green"))
      )
    ) %>%
      layout(
        title = title.label,
        xaxis = list(tickangle = 45,
                     title = "Hospital Spending Compared to Average"
        ),
        yaxis = list(
          title = "Excess Readmission Ratio"
        )
      )
  })
  
  
  
  # Read in big data and filter for columns relative to the three heart problems for the second scatter plot
  hospital.timely.result <- read.csv("data/Timely_and_Effective_Care_-_Hospital.csv", stringsAsFactors = FALSE)
  hospital.timely.result$Score <- as.numeric(hospital.timely.result$Score)
  hospital.timely.data <- filter(hospital.timely.result, Measure.Name == "Aspirin at Arrival" & 
                                   (State == "WA" | State == "CA" | State == "OR")) %>%
    select(Hospital.Name, State, Score)
  colnames(hospital.timely.data)[3] <- "Aspirin.Score"
  hospital.complications.result <- read.csv("data/Complications_and_Deaths_-_Hospital.csv", stringsAsFactors = FALSE)
  hospital.complications.result$Score <- as.numeric(hospital.complications.result$Score)
  hospital.complications.data <- select(hospital.complications.result, Hospital.Name, State, Measure.Name, Score) %>%
    filter(Measure.Name == "Death rate for CABG" | Measure.Name == "Heart failure (HF) 30-Day Mortality Rate" |
             Measure.Name == "Acute Myocardial Infarction (AMI) 30-Day Mortality Rate",  
           State == "WA" | State == "CA" | State == "OR")
  colnames(hospital.complications.data)[4] <- "Death.Rate.Score"
  
  hospital.death.rate.CABG.data <- filter(hospital.complications.data, Measure.Name == "Death rate for CABG")
  hospital.death.rate.HF.data <- filter(hospital.complications.data, 
                                        Measure.Name == "Heart failure (HF) 30-Day Mortality Rate")
  hospital.death.rate.AMI.data <- filter(hospital.complications.data, 
                                         Measure.Name == "Acute Myocardial Infarction (AMI) 30-Day Mortality Rate")
  
  # Finds and select for matching hospital names in the aspirin and death rate data set
  hospital.names.timely <- hospital.timely.data[, 1]
  hospital.death.rate.CABG.subset <- subset(hospital.death.rate.CABG.data, Hospital.Name %in% hospital.names.timely)
  hospital.death.rate.HF.subset <- subset(hospital.death.rate.HF.data, Hospital.Name %in% hospital.names.timely)
  hospital.death.rate.AMI.subset <- subset(hospital.death.rate.AMI.data, Hospital.Name %in% hospital.names.timely)
  
  hospital.names.death.rate.HF <- hospital.death.rate.HF.subset[, 1]
  hospital.timely.subset <- subset(hospital.timely.data, Hospital.Name %in% hospital.names.death.rate.HF)
  
  # Merges relevant aspirin and death rate data together to form new data frames for use in graphing
  joined.complications.HF <- inner_join(hospital.death.rate.HF.subset, hospital.timely.subset) %>%
    filter(Aspirin.Score != "Not Available" & Death.Rate.Score != "Not Available")
  joined.complications.AMI <- inner_join(hospital.death.rate.AMI.subset, hospital.timely.subset) %>%
    filter(Aspirin.Score != "Not Available" & Death.Rate.Score != "Not Available")
  joined.complications.CABG <- inner_join(hospital.death.rate.CABG.subset, hospital.timely.subset) %>%
    filter(Aspirin.Score != "Not Available" & Death.Rate.Score != "Not Available")
  
  
  # Produces second interactive scatter plot
  output$plot2 <- renderPlotly({
    
    # Selects relevant data based on user's selection of heart problem
    if (input$choices2 == "Heart Failure") {
      target.data <- joined.complications.HF
      title.label <- "Heart Failure"
    } else if (input$choices2 == "Heart Attack") {
      target.data <- joined.complications.AMI
      title.label <- "Heart Attack"
    } else {
      target.data <- joined.complications.CABG
      title.label <- "CABG"
    }
    
    # Graph scatter plot
    graph <- plot_ly(
      data  = target.data, x = ~Aspirin.Score, y = ~Death.Rate.Score, type = "scatter",
      text = ~paste("Hospital: ", Hospital.Name, '<br>State:', State),
      marker = list(
        color = factor(target.data$State, labels = c("orange", "purple","green"))
      )
    ) %>%
      layout(
        title = title.label,
        xaxis = list(
          title = "Aspirin Score"
        ),
        yaxis = list(
          title = "Death Rate Score"
        )
      )
  })
})