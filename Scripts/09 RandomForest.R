library(sandwich)
library(msm)
library(pscl)
library(boot)
library(e1071)
library(gmodels)
library(randomForest)
library(DMwR)
require(ggplot2)
library(Consensus)
library(caret)
library(e1071)
library(randomForest)
library(gmodels)
require(pscl)
require(boot)
require(sandwich)
require(msm)
library(caret)
library(caret)

set.seed(124)
setwd( "C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Traffic")
finaldata= read.csv("MergeWithCrash_2016.csv", header= TRUE, stringsAsFactors = FALSE)
finaldata$binAccident <- 0 
finaldata$binAccident[which(finaldata$Freq != 0)] <- finaldata$Freq[which(finaldata$Freq != 0)]/finaldata$Freq[which(finaldata$Freq != 0)]
View(finaldata)

keep <- c("hour", "tmpf","dwpf","sknt","drct","gust","tfs","avg_speed","avg_headway","normal_vol","long_vol","occupancy","binAccident")
finaldata<-finaldata[ , (names(finaldata) %in% keep)]
View(finaldata)
finaldata$binAccident <- as.factor(finaldata$binAccident)


smp_size <- floor(0.75 * nrow(finaldata))
train_ind <- sample(seq_len(nrow(finaldata)), size = smp_size)


final_train <- finaldata[train_ind, ]
final_test <- finaldata[-train_ind, ]

print(nrow(final_train))
print(nrow(final_test))
View(final_train)
View(final_test)

#ggplot(finaldata, aes(count)) + geom_histogram() + scale_x_log10()
qplot(finaldata$Freq, geom="histogram") +xlab("Count")
qplot(finaldata$binAccident, geom="histogram") +xlab("Count")



final_train$binAccident <- as.factor(final_train$binAccident)

#Depending on balancing technique chosen one of the below two lines can be executed.
final_train<- upSample(x= final_train[, -ncol(final_train)], y= final_train$binAccident)
final_train<- downSample(x= final_train[, -ncol(final_train)], y= final_train$binAccident)

print(ncol(final_train))
View(final_train)
colnames(final_train)[13] <- "binAccident"
table(final_train$binAccident) 
table(final_test$binAccident)

randomForest_trainmodel<- randomForest(binAccident~., data = final_train, mtry = 4, importance= TRUE, ntree = 300)
#randomForest_trainmodel
pred_randomForest<-predict(randomForest_trainmodel, final_test)
CrossTable(final_test$binAccident, pred_randomForest, prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE, dnn = c("Actual","Predicted"))




#Variable Importance Plot
varImpPlot(randomForest_trainmodel, main = "Variable Importance Plot", pch=16, col='blue')

#ROCR Plots
library("ROCR")
write.csv(pred_randomForest, "pred_randomForest.csv")
pred.randomforest.csv<-read.csv("pred_randomForest.csv")
View(pred.randomforest.csv)
ROC.prediction<-prediction(predictions = pred.randomforest.csv$x, labels = final_test$binAccident)
perf<-performance(ROC.prediction,measure = "tpr", x.measure="fpr")
plot(perf, main = "",
     col = "blue", lwd = 3)
abline(a = 0, b = 1, lwd = 2, lty = 2)

