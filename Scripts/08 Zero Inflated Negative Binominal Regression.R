require(ggplot2)
library(DMwR)
library(Consensus)
library(caret)
library(e1071)
require(pscl)
require(boot)
require(sandwich)
require(msm)
library(caret)
require(MASS)
library(ggplot2)
require(sandwich)
require(msm)
require(pscl)
require(boot)
require(e1071)
require(gmodels)
require(randomForest)

setwd("C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Traffic")
set.seed(124)

#Import and processing of the data 
finaldata= read.csv("MergeWithCrash_2016_Binomial.csv",header= TRUE, stringsAsFactors = FALSE)
finaldata$binAccident <- 0 
finaldata$binAccident[which(finaldata$Freq != 0)] <- finaldata$Freq[which(finaldata$Freq != 0)]/finaldata$Freq[which(finaldata$Freq != 0)]
keep <- c("hour","tmpf","dwpf","sknt","drct","gust","tfs","avg_speed","normal_vol","long_vol","occupancy","Freq","binAccident")
finaldata<-finaldata[ , (names(finaldata) %in% keep)]

#Creation of the training and testing data
smp_size <- floor(0.75 * nrow(finaldata))
train_ind <- sample(seq_len(nrow(finaldata)), size = smp_size)
final_train <- finaldata[train_ind, ]
final_test <- finaldata[-train_ind, ]

summary(final_train)

#Histogram
ggplot(final_train, aes(Freq)) + geom_histogram() + scale_x_log10()

#Zero Inflated Binomial Regression Model
#Use variable 'binAccident' for classification and variable 'Freq' for regression
m1 <- zeroinfl(Freq ~ hour+tmpf+dwpf+sknt+drct+tfs+avg_speed+gust+long_vol | normal_vol ,data = final_train)
summary(m1)

predict_zeroInf = NULL
final_test$predicted<-predict(m1, final_test)
final_test$predicted_raw<- final_test$predicted

#Use for rounding off predictions for Classification
#final_test$predicted[final_test$predicted>0.5]<-1
#final_test$predicted[final_test$predicted<0.5]<-0

#Use for rounding off predictions for regresion
final_test$predicted <- round(final_test$predicted, digits = 0)

#Cross table generation
CrossTable(final_test$Freq, final_test$predicted, prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE, dnn = c("Actual","Predicted"))

#ROCR Plots
library("ROCR")

final_train$predicted<-predict(m1, final_train)

ROC.prediction<-prediction(predictions = final_train$predicted, labels = final_train['binAccident'])
perf<-performance(ROC.prediction,measure = "tpr", x.measure="fpr")
plot(perf, main = "",
col = "blue", lwd = 3)
abline(a = 0, b = 1, lwd = 2, lty = 2)

