#Script for automating data cleaning, processing and aggregating from 30 monthly weather data files
setwd("C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Traffic\\Chicago\\Yearwise")

#Set up file header structure
data_original_traffic <- read.table(file = "TF_base.txt", stringsAsFactors = FALSE, header = TRUE, sep = ",")

#Collect data in a single data frame
for (i in 25:30)
  {
    url <-  paste("TF_", toString(i), ".txt", sep = "")
    print(url)
    data_original_traffic_tmp = read.table(file = url, header = TRUE, stringsAsFactors = FALSE, sep=",")
    data_original_traffic_tmp[is.na(data_original_traffic_tmp)] <- 0 
    data_original_traffic <- rbind(data_original_traffic, data_original_traffic_tmp)
  }

remove(data_original_traffic_tmp)

#Extract hours from the timestamp
data_original_traffic$obtime<- ymd_hms(data_original_traffic$obtime)
data_original_traffic['hour'] <- hour(data_original_traffic$obtime)
data_original_traffic['date'] <- as.Date(data_original_traffic$obtime)

#aggregate weather records using median function based on weather station, date, and hour
df_merged_traffic <- aggregate(data_original_traffic, by=list(data_original_traffic$station, data_original_traffic$date, data_original_traffic$hour), FUN="median")
df_merged_traffic['station']<- df_merged_traffic['Group.1']

remove(data_original_traffic)
remove(data_original_traffic1)

attach(df_merged_traffic)

#Generate primary key for merging with other records later
df_merged_traffic['station']<- df_merged_traffic['Group.1']
df_merged_traffic['concat'] <- do.call(paste, c(df_merged_traffic[1:3], sep = "")) 

write.csv(df_merged_traffic, "C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Traffic\\traffic_Aggregated_new.csv")




#Merge Traffic and Weather records

df_join_weather_traffic = sqldf("SELECT * FROM df_merged_weather JOIN df_merged_traffic ON (df_merged_weather.station=df_merged_traffic.station AND df_merged_weather.date=df_merged_traffic.date AND df_merged_weather.hour=df_merged_traffic.hour)")
write.csv(df_join_weather_traffic, "C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Traffic\\merged_traffic_weather.csv")

df_join_weather_traffic1<-df_join_weather_traffic[,-c(1:3,16:21, 28:29)]
df_join_weather_traffic_final<-df_join_weather_traffic1[,c(1, 2, 12, 11,3:10, 13:19)]
#View(df_join_weather_traffic_final)

write.csv(df_join_weather_traffic_final, "C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Traffic\\merged_traffic_weather_nov2_2016.csv")
