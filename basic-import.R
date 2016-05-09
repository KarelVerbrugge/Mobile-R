################################
# DATA IMPORT TEMPLATE FOR AWARE
################################

# R script written by Karel Verbrugge
# Suitable for importing AWARE study data from a SQL research server
# Exports data as a set of .csv files based on available sensors


# LIBRARIES AND FUNCTIONS
#########################

library("RMySQL")
library("plyr")
library(ggplot2)
shift <- function(x, n) c(tail(x, -n), rep(NA, n))


# CONNECT TO AWARE SERVER AND QUERY FOR EXISTING DATA
#####################################################

# Define connection to the AWARE research server
# If you use the default AWARE dashboard, following applies
#     host= 'awareframework.com'
#     port= 3306
# Check dashboard for personal login

AWARE <- dbConnect(MySQL(), user='username', password='password', host='awareframework.com', port=3306, dbname='dbname')

# Check server for available data
# This example includes basic foreground app, notification and screen logging
# Add sensors and fields accordingly
# Fetch request requires definition of n = -1 to query more than the default number of rows (500)

# Create a list of available data frames for export regardless of specifics
datalist <- c()

# Foreground applications
# Resource: http://www.awareframework.com/applications/

foreground_query <- dbSendQuery(AWARE, "SELECT _id, timestamp, device_id, package_name, application_name FROM applications_foreground")
data_foreground <- fetch(foreground_query, n = -1)
datalist[length(datalist) + 1] <- "data_foreground"

# Notifications
# Resource: http://www.awareframework.com/applications/

notifications_query <- dbSendQuery(AWARE, "SELECT _id, timestamp, device_id, package_name, application_name, text, sound, vibrate, flags FROM applications_notifications")
data_notifications <- fetch(notifications_query, n = -1)
datalist[length(datalist) + 1] <- "data_notifications"

# Screen status
# Resource: http://www.awareframework.com/screen/

screen_query <- dbSendQuery(AWARE, "SELECT _id, timestamp, device_id, screen_status FROM screen")
data_screen <- fetch(screen_query, n = -1)
datalist[length(datalist) + 1] <- "data_screen"


# PRE-PROCESSING
################

# Add readable timestamp variable
# AWARE are based on UNIX epoch but measured in milliseconds, so divide by 1000 before conversion

data_foreground$time <- as.POSIXct(data_foreground$timestamp/1000, tz = "CET", origin="1970-01-01")
data_notifications$time <- as.POSIXct(data_notifications$timestamp/1000, tz = "CET", origin="1970-01-01")
data_screen$time <- as.POSIXct(data_screen$timestamp/1000, tz = "CET", origin="1970-01-01")

# Add readable screen status variable
# Values are based on AWARE documentation

screen_values <- c(0:3)
screen_labels <- c("off","on","locked","unlocked")
data_screen$status <- screen_labels[match(data_screen$screen_status, screen_values)]

# Backup raw data files to .csv

for (i in 1:length(datalist)) {
  write.csv(datalist[i], file = paste0(""",datalist[i],".csv"")
}

write.csv(data_foreground, file = "dataset_foreground.csv")
write.csv(data_notifications, file = "dataset_notifications.csv")
write.csv(data_screen, file = "dataset_screen.csv")
