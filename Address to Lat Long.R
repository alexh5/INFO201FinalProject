#load ggmap
library(ggmap)

# Select the file from the file chooser
fileToLoad <- file.choose(new = TRUE)

# Read in the CSV data and store it in a variable 
origAddress <- read.csv(fileToLoad, stringsAsFactors = FALSE)
#origAddress <- head(origAddress, -2406)

# Initialize the data frame
geocoded <- data.frame(stringsAsFactors = FALSE)

# Loop through the addresses to get the latitude and longitude of each address and add it to the
# origAddress data frame in new columns lat and lon
library("devtools")
devtools::install_github("dkahle/ggmap")
register_google <- function (key, account_type, client, signature, second_limit, day_limit) {
  
  # get current options
  options <- getOption("ggmap")
  
  # check for client/sig specs
  if (!missing(client) &&  missing(signature) ) {
    stop("if client is specified, signature must be also.")
  }
  if ( missing(client) && !missing(signature) ) {
    stop("if signature is specified, client must be also.")
  }
  if (!missing(client) && !missing(signature) ) {
    if (goog_account() == "standard" && missing(account_type)) {
      stop("if providing client and signature, the account type must be premium.")
    }
  }
  
  # construct new ones
  if(!missing(key)) options$google$key <- key
  if(!missing(account_type)) options$google$account_type <- account_type
  if(!missing(day_limit)) options$google$day_limit <- day_limit
  if(!missing(second_limit)) options$google$second_limit <- second_limit
  if(!missing(client)) options$google$client <- client
  if(!missing(signature)) options$google$signature <- signature
  
  # # set premium defaults
  if (!missing(account_type) && account_type == "premium") {
    if(missing(day_limit)) options$google$day_limit <- 100000
  }
  
  # class
  class(options) <- "ggmap_credentials"
  
  # set new options
  options(ggmap = options)
  
  # return
  invisible(NULL)
}

register_google(key = "AIzaSyBRE69Y_cLAbfe9rDJTVs6n1m-X0pD2gkE")

for(i in 1:nrow(origAddress)) {
  tryCatch({
    # Print("Working...")
    result <- geocode(origAddress$Location[i], output = "latlona", source = "google")
    origAddress$lon[i] <- as.numeric(result[1])
    origAddress$lat[i] <- as.numeric(result[2])
    origAddress$geoAddress[i] <- as.character(result[3])
  }, warning = function(w) {
    # log the warning or take other action here
  }, error = function(e) {
    # log the error or take other action here
  }, finally = {
    # this will execute no matter what else happened
  })
}

# Write a CSV file containing origAddress to the working directory
write.csv(origAddress, "geocoded.csv", row.names=FALSE)
