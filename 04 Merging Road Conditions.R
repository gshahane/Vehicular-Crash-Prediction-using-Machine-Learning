setwd("C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Weather\\merged_RoadConditions")
data_rc <- read.csv("mohana_allYearDataFinalRecoded.csv", stringsAsFactors = FALSE)
data_rc <- data_rc[, 23:24]


setwd("C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Traffic")
data_all <- read.csv("merged_traffic_weather_2016.csv", stringsAsFactors = FALSE )

data_new<-merge(data_all, data_rc, by.x = "concat", by.y = "concat", all.x = TRUE)
