# INFO201FinalProject

Here is the [link](https://alexh5.shinyapps.io/INFO201FinalProject/) to our Shiny app.

## Project Description:

The dataset we’ll be working with is Data.Medicare.gov, which provides access to official data from hospitals across the United States under the Centers for Medicare & Medicaid Services (CMS). The data is found at https://data.medicare.gov/. The data is collected from Medicare.gov’s Compare Websites and Directories, which includes categories such as Hospital, Nursing Home, and Physician Compare Datasets. Many comparisons of interest are available at the hospital, state, and national levels.

The target audience is people that are likely experiencing health problems such as heart failure or heart attack and are interested in surgery including coronary artery bypass grafting (CABG). Possible surgery patients are unsure of which hospital to go to to ensure that they are taken care of and their complications are resolved.

Here are some questions the target audience may consider:
-	What hospitals are around the country and what are their overall ratings of safety and effectiveness?
-	Which hospitals employ health measures that may or may not reduce the risk of death or complications after surgery?
-	Which hospitals carry out successful surgeries with minimal hospital readmissions in regards to heart attack or heart failure?

The audience would welcome data on what hospitals across the nation are effective and safe in their practices. This would play a factor their decision in choosing the hospital where they think they can receive the best care for their situation.

## Technical Description:

Our group will produce a Shiny app that will include three tabs/pages, each of which will answer a different question regarding healthcare. We plan to have an interactive map detailing the locations of hospitals and general information, as well as two other graph visualizations

We will be using the Socrata Open Data API to gain access to the Data.Medicare.Gov datasets. However, the dataset contains so much information, we’ll need to perform a handful of select and filter operations to obtain the variables we’re interested in analyzing. Then, we intend to calculate ratios for some of the variables in order to better compare between different hospitals. Finally, we’ll use the data of interest to create different types of graphs for the target audience to visualize correlations and draw inferences from the data.  

New libraries that will be useful in our rendering of the graphs include the “mapdata” package, which will allow us to create an outline of the U.S. map. We also plan on using the “plotly” package to make our graphs more visually appealing. Lastly, we plan on using “rsconnect” package to publish our Shiny app. We do not plan on answering questions with statistical analysis or machine learning at this moment.

Challenges we anticipate include gathering data using an API key. Assignment 5 was difficult to get started with getting accustomed to utilizing the key to access data. Another issue will be to properly modify the data passed into a data frame. Finally, since Shiny app is relatively new to us, it may take some time to get familiar with it. Hopefully Assignment 8 will help in that regard.
