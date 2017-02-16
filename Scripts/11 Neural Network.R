
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

library(caret)
final_train$binAccident<- as.factor(final_train$binAccident)
train_ds<- downSample(x= final_train[,-c(12, 13)], y= final_train$binAccident, list = FALSE, yname = "binAccident")
train_downsampled<-as.data.frame(train_ds)
summary(final_train)

"""

#Implement Neural Network
library(neuralnet)
n <- names(final_train)
nn<-neuralnet(binAccident ~ hour+tmpf+dwpf+sknt+drct+gust+tfs+avg_speed+normal_vol+long_vol+occupancy,data=final_train,hidden=c(5,3),linear.output=FALSE)

#Predict

final_test1 <- final_test[, - c(12, 13)]
pr.nn <- compute(nn,final_test1)
pr <-as.data.frame(pr.nn)

final_test['bin_nn_result']<- round(pr$net.result)

plot(final_test$binAccident,final_test$bin_nn_result,col='red',main='Real vs predicted NN',pch=18,cex=0.7)
abline(0,1,lwd=2)
legend('bottomright',legend='NN',pch=18,col='red', bty='n')

#Cross table generation
library(gmodels)
#CrossTable(final_test$binAccident, final_test$bin_nn_result, prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE, dnn = c(Actual,Predicted))
"""

#with downsa,plng

final_train <- train_downsampled
final_train$binAccident <- as.numeric(final_train$binAccident)

#Implement Neural Network
library(neuralnet)

i = 0

for (i in 0:16){
  
  i <- as.integer(i)
  n <- names(final_train)
  nn<-neuralnet(binAccident ~ tmpf+dwpf+sknt+drct+gust+tfs+avg_speed+normal_vol,data=final_train, hidden = i, act.fct= 'logistic', linear.output=FALSE)
  
  #Predict
  
  final_test1 <- final_test[, - c(12, 13)]
  final_test1$hour<- as.numeric(final_test1$hour)
  
  #pr.nn <- compute(nn,final_test1[,-12])
  pr.nn <- compute(nn,final_test1[,c("tmpf", "dwpf", "sknt", "drct", "gust", "tfs", "avg_speed", "normal_vol")])
  pr <-as.data.frame(pr.nn)
  
  final_test['bin_nn_result']<- round(pr$net.result)
  
  plot(final_test$binAccident,final_test$bin_nn_result,col='red',main='Real vs predicted NN',pch=18,cex=0.7)
  abline(0,1,lwd=2)
  legend('bottomright',legend='NN',pch=18,col='red', bty='n')
  
  print("number of layers")
  print(i)
  #Cross table generation
  library(gmodels)
  CrossTable(final_test$binAccident, final_test$bin_nn_result, prop.chisq = FALSE, prop.c = FALSE, prop.r = FALSE, dnn = c("Actual","Predicted"))
}
