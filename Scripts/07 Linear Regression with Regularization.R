install.packages("car")
library(car)

#check the data

setwd("C:\\Users\\gaura\\Documents\\MIM - UMCP\\3rd Sem\\INFM750\\Project Data\\Traffic")
data <- read.csv("MergeWithCrash_2016.csv", stringsAsFactors = FALSE )
summary(data)
head(data)

#Keep only predictor variables
data_reglm <- data[,-c(1:6, 8:9)]

#Creation of the training and testing data
testdx<-which(1:nrow(data_reglm)%%4==0)
crash_train<-data_reglm[-testdx,]
crash_test<-data_reglm[testdx,]

#Run Linear Regression model
model<-lm(Freq~.,data=crash_train)
prediction<-predict(model,newdata=crash_test)

#Check Correlation between predicted values and testing data/groundtruth
cor(prediction,crash_test$Freq)

#Check residuals
rs<-residuals(model)
qqnorm(rs)
qqline(rs)

#Cross validation with regularization
library(glmnet)
cv.fit<-cv.glmnet(as.matrix(crash_train[,c(-14)]),as.vector(crash_train[,14]),alpha=1)

plot(cv.fit)
coef(cv.fit)

#Check Lambda value
cv.fit$lambda.min
prediction<-predict(cv.fit,newx=as.matrix(crash_test[,c(-14)]))

#Check Correlation between predicted values and testing data/groundtruth
cor(prediction,as.vector(crash_test[,14]))
summary(model)
