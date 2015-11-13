library("glmnet")  # For ridge regression fitting. It also supports elastic-net and LASSO models 
library("gbm")  # For Gradient-Boosting
library("rpart")  # For building decision trees
library("CORElearn")


## linear regression

## read data file

## @ alldata: records for all NPVs
alldata = read.csv("data_fixed.csv", header=TRUE, na.strings = "NA")
## @ data: records for only 20 NPV
data = alldata[alldata$NPV == 20,]

lm_train_error <- 0
lm_test_error <- 0
area_train_error <- 0
area_test_error <- 0

## using 3300 (80%) records for training and the rest for testing
train_rows <- 1:3300
train_set <- data[train_rows,]
test_set <- data[-train_rows,]

lm_model <- lm(tjpt ~ jptnoarea + sumtrkPU, data = train_set)
coef(lm_model)
response_column <- which(colnames(train_set) == "tjpt")
lm_train_error <- mean(summary(lm_model)$residuals^2)
area_train_error <- mean((train_set$tjpt - train_set$jpt)^2)

lm_predictions <- predict(lm_model, test_set[, -response_column])
lm_test_error <- mean((lm_predictions - test_set$tjpt)^2)
area_test_error <- mean((test_set$jpt - test_set$tjpt)^2)

## comparison plot of lm vs. area-based
lm_offset <- lm_predictions - test_set$tjpt
h<-hist(lm_offset, breaks=50, col="red", xlab="Estimated Jpt - True Jpt", main="Linear regression vs. Area-based") 
xfit<-seq(min(lm_offset),max(lm_offset),length=40) 
yfit<-dnorm(xfit,mean=mean(lm_offset),sd=sd(lm_offset)) 
yfit <- yfit*diff(h$mids[1:2])*length(lm_offset) 
lines(xfit, yfit, col="black", lwd=2)

test_offset <- test_set$jpt - test_set$tjpt
#x2 <- testdf$offset
#h<-hist(x2, breaks=20, col="blue", xlab="h(x) - y on the test set", 
#main="Linear regression") 
xfit2<-seq(min(test_offset),max(test_offset),length=40) 
yfit2<-dnorm(xfit2,mean=mean(test_offset),sd=sd(test_offset)) 
yfit2 <- yfit2*diff(h$mids[1:2])*length(test_offset) 
lines(xfit2, yfit2, col="green", lwd=2)

  
## plot the t

#for(i in 1 :8 ){

# linear model
OLS_model <- lm(tjpt ~ jptnoarea + sumtrkPU, data = traindf)
coef(OLS_model)
response_column <- which(colnames(traindf) == "tjpt")
#trainerror[i] <-
mean(summary(OLS_model)$residuals^2)
#areatrainerr[i] <- 
mean((traindf$tjpt - traindf$jpt)^2)
predictions_ols <- predict(OLS_model, testdf[, -response_column])
#testerror[i] <- 
mean((predictions_ols - testdf$tjpt)^2)
#areatesterr[i] <- 
mean((testdf$tjpt - testdf$jpt)^2)

#}