
#Script for automating data cleaning, processing and aggregating from 30 monthly weather data files

setwd("C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Weather\\Yearwise")
library(sqldf)
library(matrixStats)
library(lubridate)
library(plyr)

#Set up file header structure
data_original_weather = read.table(file = "RW_base.txt", header = TRUE, stringsAsFactors = FALSE,sep = ",")

#Collect data in a single data frame
name <- 'RW_'
Counter <-

for (i in 1:30)
  {
  
  i = 30
  
  url <-  paste("RW_", toString(i), ".txt", sep = "")
  print(url)
  data_original_weather_tmp = read.table(file = url, header = TRUE, stringsAsFactors = FALSE, sep=",")
  data_original_weather <- rbind(data_original_weather, data_original_weather_tmp)
  break
}

data_weather<- data_original_weather
df_all <- (data_weather)

#Remove extra columns
df_tfs <- df_all[, c(10, 12, 14, 16)]
mtx_tfs <- data.matrix(df_tfs)

#Take the row medians for pavement temperature records from 4 sensors
df_tfs['tfs'] <- rowMedians (mtx_tfs, na.rm = TRUE)
df_all <- NULL

data_original_weather1 <- data_original_weather[, -c(10:18)]
data_original_weather1['tfs'] <- df_tfs['tfs'] 
data_original_weather1 <- na.omit(data_original_weather1)

remove(df_tfs)
remove(df_all)
remove(mtx_tfs)
remove(data_original_weather_tmp)
remove(data_original_weather)
remove(data_weather)

#Extract hours from the timestamp
data_original_weather1$obtime<- ymd_hms(data_original_weather1$obtime)
data_original_weather1['hour'] <- hour(data_original_weather1$obtime)
data_original_weather1['date'] <- as.Date(data_original_weather1$obtime)

#aggregate weather records using median function based on weather station, date, and hour
df_merged_weather <- aggregate(data_original_weather1, by=list(data_original_weather1$station, data_original_weather1$date, data_original_weather1$hour), FUN="median")
df_merged_weather['station']<- df_merged_weather['Group.1']

#Generate primary key for merging with other records later
df_merged_weather['concat'] <- do.call(paste, c(df_merged_weather[1:30], sep = "")) 

head(df_merged_weather)
write.csv(df_merged_weather, "C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Weather\\Yearwise\\RW_Aggregated_nov2.csv")

remove(data_original_weather1)
