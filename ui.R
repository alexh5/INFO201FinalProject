#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#
library(shiny)
library(plotly)
#source("test.R")
library(shiny)
library(leaflet)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Map of Hospitals in United States"),
  navbarPage("",
             
             
    tabPanel("Map",
      sidebarLayout(
        sidebarPanel(
          textInput("hospitalName", label = h3("Search for Hospital"), value = ""),
          selectInput("stateFilter", label = h3("Pick your State"), 
                      choices = c("All States", US.filtered.data$State), selected = "All States")
        ),
        mainPanel(
          tags$style(type = "text/css", "#map {height: calc(90vh - 80px) !important;}"),
          leafletOutput("map")
        )
      )
    ),
             
    
    
    tabPanel("Insert Name Here 1",
      sidebarLayout(
        sidebarPanel(
          radioButtons("choices", "Heart Problems",
                       c("Heart Failure", "Heart Attack", "CABG"),
                       selected = "Heart Failure"
          )
          
        ),
        mainPanel(
          plotlyOutput("plot1")
        )
      )
    ),
    
    
    tabPanel("Insert Name Here 2",
      sidebarLayout(
        sidebarPanel(
          radioButtons("choices2", "Heart Problems",
                       c("Heart Failure", "Heart Attack", "CABG"),
                       selected = "Heart Attack"
          )
        ),
        mainPanel(
          plotlyOutput("plot2")
        )
      )
    )
  )
))
             
    
    
  
  