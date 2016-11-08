setwd("C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Traffic")
data <- read.csv("MergeWithCrash_2016.csv", stringsAsFactors = FALSE )

#remove column x
data <- data[,-1]

#check Dimension
dim(data)

#names
names(data)

#structure
str(data)

#five numbers
fivenum(data$tmpf)
fivenum(data$dwpf)
fivenum(data$sknt)
fivenum(data$drct)
fivenum(data$gust)
fivenum(data$tfs)
fivenum(data$avg_speed)
fivenum(data$avg_headway)
fivenum(data$normal_vol)
fivenum(data$long_vol)
fivenum(data$occupancy)

#mean
mean(data$tmpf)
mean(data$dwpf)
mean(data$sknt)
mean(data$drct)
mean(data$gust)
mean(data$tfs)
mean(data$avg_speed)
mean(data$avg_headway)
mean(data$normal_vol)
mean(data$long_vol)
mean(data$occupancy)

#Standard Deviation
sd(data$tmpf)
sd(data$dwpf)
sd(data$sknt)
sd(data$drct)
sd(data$gust)
sd(data$tfs)
sd(data$avg_speed)
sd(data$avg_headway)
sd(data$normal_vol)
sd(data$long_vol)
sd(data$occupancy)

#stem plot
attach(data)
stem(tmpf)
stem(dwpf)
stem(sknt)
stem(occupancy)

#histogram
require(MASS)
truehist(data$tmpf, ylab = 'Frequency', col = 'grey', nbins = 'FD', xlab = "Air Temperature" )
truehist(data$dwpf, ylab = 'Frequency', col = 'grey', nbins = 'FD', xlab = "Dew Point Temp" )
truehist(data$sknt, ylab = 'Frequency', col = 'grey', nbins = 'FD', xlab = "Wind Speed in knots" )
truehist(data$drct, ylab = 'Frequency', col = 'grey', nbins = 'FD', xlab = "Wind Direction (degree N)" )
truehist(data$gust, ylab = 'Frequency', col = 'grey', nbins = 'FD', xlab = "Wind Gust in Knots" )
truehist(data$tfs, ylab = 'Frequency', col = 'grey', nbins = 'FD', xlab = "Pavement Temperature" )
truehist(data$avg_speed, ylab = 'Frequency', col = 'grey', nbins = 'FD', xlab = "Average Speed")
truehist(data$normal_vol, ylab = 'Frequency', col = 'grey', nbins = 'FD', xlab = "Normal Volume")
truehist(data$long_vol, ylab = 'Frequency', col = 'grey', nbins = 'FD', xlab = "Long Volume" )
truehist(data$occupancy, ylab = 'Frequency', col = 'grey', nbins = 'FD', xlab = "Occupancy" )

#Scatter Plot
plot(x = tmpf, y = tfs, xlab = "Air Temperature", ylab = "Pavement Temperature", main = "Scatter plot of Air Temperature vs Pavement Temperature")
plot(x = sknt, y = gust, xlab = "Wind Speed", ylab = "Wind Gust", main = "Scatter plot of Wind Speed vs Wind Gust")

data_noCrash <- subset(data, Freq>0)
plot(x = data_noCrash$avg_speed, y = data_noCrash$Freq, xlab = "Average Speed", ylab = "Crashes", main = "Scatter plot of Average Speed vs Number of Crashes (Hourly)", type = "s")

plot