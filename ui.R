library(shiny)
library(plotly)
library(shiny)
library(leaflet)

US.filtered.data <- read.csv("data/General_Hospital_Information_Lat_Lon.csv", stringsAsFactors = FALSE) 

# Define UI for application 
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Hospitals for Hearts"),
  navbarPage("",
             
             # Home page
             tabPanel("Home",
                      
                      mainPanel(
                        p("Coronary artery disease (CAD) is the most common heart disease, and is the leading cause of 
                        death for both men and women in the U.S. CAD occurs when arteries become narrowed due to buildup 
                        of cholesterol and plaque in the inner walls. As a result, the heart is unable to receive adequate 
                        amounts of blood from arteries. Blood clots then form, causing heart attacks which will inflict 
                        permanent damage on the heart. CAD also weakens heart muscle overtime, if not treated.Coronary artery
                        bypass graft (CABG) is a surgery that creates new routes for blood flow to the heart. This surgery
                        is meant for people suffering from CAD, and is one of the most common major surgeries performed in the
                        U.S. The graft for the is usually a vein from the leg or inner chest wall."),
                        p(),
                        p("We used Data.Medicare.gov's official hospital data sets to address the following questions:"),
                        p("-	What hospitals are around the country and what are their overall ratings of safety and effectiveness?"),
                        p("-	Which hospitals employ health measures that may or may not reduce the risk of death or complications"),
                        p("-	Which hospitals carry out successful surgeries with minimal hospital readmissions in regards to heart 
                          attack or heart failure?")
                      )
             ),
             
             # Map page
             tabPanel("U.S. Hospital Map",
                      
                      # Defines search bar and drop down list in side panel
                      sidebarLayout(
                        sidebarPanel(
                          textInput("hospitalName", label = h3("Search For Hospital"), value = "", 
                                    placeholder = "Please type out the entire hospital name."),
                          selectInput("stateFilter", label = h3("Pick Your State"), 
                                      choices = c("All States and Territories", US.filtered.data$State), selected = "All States and Territories"),
                          helpText("Data from data.medicare.gov")
                        ),
                        
                        # Defines map and its brief description
                        mainPanel(
                          p("This following map displays hospitals across the United States that are Centers for Medicare & 
                            Medicaid Services (CMS). Clicking on a hospital will show its name, address, phone number, rating,
                            and a link to a Google search."),
                          
                          tags$style(type = "text/css", "#map {height: calc(85vh - 80px) !important;}"),
                          leafletOutput("map")
                        )
                      )
             ),
             
             # First scatter plot
             tabPanel("Hospital Spending vs. Readmission",
                      
                      # Defines radio buttons in side panel
                      sidebarLayout(
                        sidebarPanel(
                          radioButtons("choices", "Heart Problems",
                                       c("Heart Failure", "Heart Attack", "CABG"),
                                       selected = "Heart Failure"
                          ),
                          helpText("Data from data.medicare.gov")
                        ),
                        
                        # Defines scatter plot and its brief description
                        mainPanel(
                          p("In the Hospital Spending vs. Readmission graph, we compared hospitals' spending to their readmission 
                        ratio to see if there's a correlation between the two variables. The hospital spending variable is a ratio 
                        that tells how much a hospital spends compared to the national average. A ratio of 1.0 means a hospital 
                        spends as much as the national average, a ratio below 1.0 means the hospital spends less than the national 
                        average, and a ratio above 1.0 means the hospital spends more. The y-axis, excess readmission ratio, is 
                        also a national comparison. A ratio of 1.0 means the number of patients readmitted after discharge in that
                        hospital is the same as national average, while a ratio of less than 1.0 means the number of patients 
                        readmitted after discharge is less than national average, and a ratio of greater than 1.0 means number of 
                        patients readmitted is more than the national average. For all three graphs, heart failure, heart attack, 
                        and CABG, there appears to be no correlation between how much a hospital spends and the patient readmission rate."),
                          plotlyOutput("plot1")
                        )
                      )
             ),
             
             # Second scatter plot
             tabPanel("Aspirin Score vs. Death Rate",
                      
                      # Defines radio buttons in side panel
                      sidebarLayout(
                        sidebarPanel(
                          radioButtons("choices2", "Heart Problems",
                                       c("Heart Failure", "Heart Attack", "CABG"),
                                       selected = "Heart Failure"
                          ),
                          helpText("Data from data.medicare.gov")
                        ),
                        
                        # Defines second scatter plot and its brief description
                        mainPanel(
                               p("We compared the death rate of patients to aspirin score in hospitals. The lower the death rate score, the lower death
                        rate reported by the hospital. For the aspirin score, the higher the better, meaning patients received aspirin in time 
                        to alleviate their pain. There does not seem to be any correlation between the data points."),
                          plotlyOutput("plot2")
                        )
                      )
             )
  )
))




