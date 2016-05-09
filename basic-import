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

# Foreground applications

foreground_query <- dbSendQuery(AWARE, "SELECT _id, timestamp, device_id, package_name, application_name FROM applications_foreground")
data_foreground <- fetch(foreground_query, n = -1)

# Notifications

notifications_query <- dbSendQuery(AWARE, "SELECT _id, timestamp, device_id, package_name, application_name, text, sound, vibrate, flags FROM applications_notifications")
data_notifications <- fetch(notifications_query, n = -1)

# Screen status

screen_query <- dbSendQuery(AWARE, "SELECT _id, timestamp, device_id, screen_status FROM screen")
data_screen <- fetch(screen_query, n = -1)
