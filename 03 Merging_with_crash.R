setwd("C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Traffic")

crash_data <- read.csv("C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Crash Data\\crash_data.csv", stringsAsFactors = FALSE)
crash_10km <- subset(crash_data, RWIS_Distance < 10000)

#get date format
crash_10km$CRASH_DATE<- strtrim(crash_10km$CRASH_DATE, 10)
crash_10km['date']<- mdy(crash_10km$CRASH_DATE)
#crash_10km['date'] <- as.Date(crash_10km$CRASH_DATE)

#crash_10km$CRASH_DATE<- gsub('/', '-', crash_10km$CRASH_DATE)
crash_10km$TIMESTR <- as.POSIXct(crash_10km$TIMESTR, format = "%H:%M")
crash_10km$TIMESTR <- format(crash_10km$TIMESTR, format = "%H")
crash_10km$TIMESTR <- as.integer(crash_10km$TIMESTR)
crash_10km['concatCrash'] <- paste(crash_10km$RWIS_ID, crash_10km$date, crash_10km$TIMESTR, sep = "")
crash_10km['countRecords'] = 1

#merging with weather and traffic data

crash_10km_Count <- table(crash_10km$concatCrash)
crash_10km_Count <- as.data.frame(crash_10km_Count)
merged1 <- read.csv("merged_traffic_weather_2015.csv", stringsAsFactors = FALSE)
MergeWithCrash <- merge(merged1, crash_10km_Count, by.x = "concat", by.y = "Var1", all.x = TRUE)
MergeWithCrash$Freq[is.na(MergeWithCrash$Freq)] <- 0

# write file
write.csv(MergeWithCrash, "MergeWithCrash_2015.csv")
