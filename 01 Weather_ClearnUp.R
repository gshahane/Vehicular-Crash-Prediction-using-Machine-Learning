setwd("C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Weather\\Yearwise")
library(sqldf)
library(matrixStats)
library(lubridate)
library(plyr)
data_original_weather = read.table(file = "RW_base.txt", header = TRUE, stringsAsFactors = FALSE,sep = ",")
#View(data_original_weather)

name <- 'RW_'
Counter <-

for (i in 25:30)
  {
  url <-  paste("RW_", toString(i), ".txt", sep = "")
  print(url)
  data_original_weather_tmp = read.table(file = url, header = TRUE, stringsAsFactors = FALSE, sep=",")
  data_original_weather <- rbind(data_original_weather, data_original_weather_tmp)
}

data_weather<- data_original_weather
df_all <- (data_weather)

df_tfs <- df_all[, c(10, 12, 14, 16)]
mtx_tfs <- data.matrix(df_tfs)
df_tfs['tfs'] <- rowMedians (mtx_tfs, na.rm = TRUE)
#View(df_tfs)
#View(mtx_tfs)
df_all <- NULL

#(-c(10:17))
data_original_weather1 <- data_original_weather[, -c(10:18)]
data_original_weather1['tfs'] <- df_tfs['tfs'] 
#data_original_weather[omit.na(data_original_weather)] <- 0 
data_original_weather1 <- na.omit(data_original_weather1)

df_tfs <- NULL
df_all <- NULL
mtx_tfs<- NULL
data_original_weather_tmp <- NULL
data_original_weather <- NULL
data_weather <- NULL

#View(data_original_weather)

data_original_weather1$obtime<- ymd_hms(data_original_weather1$obtime)
#data_original_weather1$obtime <- ((format(data_original_weather1$obtime,'%H'))
data_original_weather1['hour'] <- hour(data_original_weather1$obtime)
data_original_weather1['date'] <- as.Date(data_original_weather1$obtime)


#df_merged_weather <- sqldf("SELECT station, date, hour, min(longitude) as longitude, min(latitude) as latitude, AVG(tmpf) as avgtmpf, AVG(dwpf) as avgdwpf, AVG(sknt) as avgsknt, AVG(drct) as avgdrct, AVG(gust) as avggust FROM data_original_weather1 GROUP BY station, date, hour")
df_merged_weather <- aggregate(data_original_weather1, by=list(data_original_weather1$station, data_original_weather1$date, data_original_weather1$hour), FUN="median")

df_merged_weather['station']<- df_merged_weather['Group.1']
df_merged_weather['concat'] <- do.call(paste, c(df_merged_weather[1:30], sep = "")) 

head(df_merged_weather)
#View(df_merged_weather)
#df_merged_weather$obtime <- as.Date(df_merged_weather$obtime, format = "%m-%d-%y")
write.csv(df_merged_weather, "C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Weather\\Yearwise\\RW_Aggregated_nov2.csv")

data_original_weather1 <- NULL
