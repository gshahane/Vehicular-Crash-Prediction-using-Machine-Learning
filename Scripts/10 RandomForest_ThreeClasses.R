library(ggplot2)
library(lattice)
library(caret)
library(sandwich)
library(msm)
library(pscl)
library(boot)
library(e1071)
library(gmodels)
library(randomForest)
library(DMwR)
library(Consensus)
library(e1071)
library(randomForest)
library(gmodels)
require(caret)



set.seed(124)
setwd( "C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Traffic")
finaldata= read.csv("MergeWithCrash_2016_Recoded.csv",header= TRUE, stringsAsFactors = FALSE)
View(finaldata)

keep <- c("hour","tmpf","dwpf","sknt","drct","gust","tfs","avg_speed","avg_headway","normal_vol","long_vol","occupancy","Freq")

finaldata<-finaldata[ , (names(finaldata) %in% keep)]
View(finaldata)

smp_size <- floor(0.75 * nrow(finaldata))
train_ind <- sample(seq_len(nrow(finaldata)), size = smp_size)


final_train <- finaldata[train_ind, ]
final_test <- finaldata[-train_ind, ]

print(nrow(final_train))
print(nrow(final_test))
View(final_train)
View(final_test)
summary(final_train)

#Training dataset has Freq as 0:91373, 1:2066, 2:194.
#Subset 0's and 1's in one dataset and 2nd in other dataset
train_subset_01<- subset(final_train, Freq == 0 | Freq == 1)
train_subset_2<- subset(final_train, Freq == 2)
summary(train_subset_01)
summary(train_subset_2)

train_subset_01$Freq <- as.factor(train_subset_01$Freq)
train_subset_2$Freq <- as.factor(train_subset_2$Freq)
summary(train_subset_01)
summary(train_subset_2)

#final_train$binAccident <- as.factor(final_train$binAccident)
#final_train<- upSample(x= final_train[, -ncol(final_train)], y= final_train$binAccident)
#final_train<- downSample(x= final_train[, -ncol(final_train)], y= final_train$binAccident)

train_subset_01<- downSample(x= train_subset_01[, -ncol(train_subset_01)], y= train_subset_01$Freq)
summary(train_subset_01)
ncol(train_subset_01)
colnames(train_subset_01)[13] <- "Freq"


nrow(train_subset_2)
nrow(train_subset_01)
train_subset_2<-rbind(train_subset_01, train_subset_2)
nrow(train_subset_2)
train_subset_2$Freq <- as.factor(train_subset_2$Freq)
summary(train_subset_2)

train_subset_2<- upSample(x= train_subset_2[, -ncol(train_subset_2)], y= train_subset_2$Freq)
summary(train_subset_2)
final_train<-train_subset_2

print(ncol(final_train))
colnames(final_train)[13] <- "Freq"
View(final_train)

table(final_train$Freq) 
table(final_test$Freq)

randomForest_trainmodel<- randomForest(Freq~., data = final_train, mtry = 6, importance= TRUE, ntree = 400)
#randomForest_trainmodel
pred_randomForest<-predict(randomForest_trainmodel, final_test)
CrossTable(final_test$Freq, pred_randomForest, prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE, dnn = c("Actual","Predicted"))




#Variable Importance Plot
varImpPlot(randomForest_trainmodel, main = "Variable Importance Plot", pch=16, col='blue')

#ROCR Plots
#install.packages("ROCR")
library("ROCR")
write.csv(pred_randomForest, "pred_randomForest.csv")
pred.randomforest.csv<-read.csv("pred_randomForest.csv")
View(pred.randomforest.csv)
ROC.prediction<-prediction(predictions = pred.randomforest.csv$x, labels = final_test$Freq)
perf<-performance(ROC.prediction,measure = "tpr", x.measure="fpr")
plot(perf, main = "",
     col = "blue", lwd = 3)
abline(a = 0, b = 1, lwd = 2, lty = 2)

