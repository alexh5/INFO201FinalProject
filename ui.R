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
library(shiny)
library(leaflet)

US.filtered.data <- read.csv("data/General_Hospital_Information_Lat_Lon.csv", stringsAsFactors = FALSE) 

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title

  titlePanel("Hospitals for Hearts"),
  navbarPage("",
             
             tabPanel("U.S. Hospital Map",
                      sidebarLayout(
                        sidebarPanel(
                          textInput("hospitalName", label = h3("Search For Hospital"), value = "", 
                                    placeholder = "Please type out the entire hospital name."),
                          selectInput("stateFilter", label = h3("Pick Your State"), 
                                      choices = c("All States", US.filtered.data$State), selected = "All States"),
                          helpText("Data from data.medicare.gov")
                        ),
                        mainPanel(
                          tags$style(type = "text/css", "#map {height: calc(90vh - 80px) !important;}"),
                          leafletOutput("map")
                        )
                      )
             ),
             
             tabPanel("Hospital Spending vs. Readmission",
                      sidebarLayout(
                        sidebarPanel(
                          radioButtons("choices", "Heart Problems",
                                       c("Heart Failure", "Heart Attack", "CABG"),
                                       selected = "Heart Failure"
                          ),
                          helpText("Data from data.medicare.gov")
                        ),
                        mainPanel(
                          plotlyOutput("plot1")
                        )
                      )
             ),
             
             tabPanel("Aspirin Score vs. Death Rate",
                      sidebarLayout(
                        sidebarPanel(
                          radioButtons("choices2", "Heart Problems",
                                       c("Heart Failure", "Heart Attack", "CABG"),
                                       selected = "Heart Failure"
                          ),
                          helpText("Data from data.medicare.gov")
                        ),
                        mainPanel(
                          plotlyOutput("plot2")
                        )
                      )
             )
  )
))




