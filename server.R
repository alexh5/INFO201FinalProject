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
  
  output$plot1 <- renderPlot({
    
  })
  
  output$plot2 <- renderPlot({
    
  })
  
 
 
}
)
