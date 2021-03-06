library("glmnet")  # For ridge regression fitting. It also supports elastic-net and LASSO models 
library("gbm")  # For Gradient-Boosting
library("rpart")  # For building decision trees
library("CORElearn")

## @ alldata: records for all NPVs
alldata = read.csv("data_fixed.csv", header=TRUE, na.strings = "NA")
## @ data: records for only 20 NPV
data = alldata[alldata$NPV == 20,]

## Distribution of offsets
hist(data$jptnoarea - data$tjpt, col=rgb(0.1, 0.1, 0.1,0.5), breaks= 50, xlab="Estimated Jpt - True Jpt", main = "Distribution of offsets")
hist(data$jpt - data$tjpt, col=rgb(0,0, 1,0.5), breaks= 50, add = T)
legend("topright", fill=c(rgb(0.1, 0.1, 0.1,0.5), rgb(0,0, 1,0.5)), c("Raw Jpt Offset", "Area-based Jpt offset"))

## Mean value of Offset as a function of Npv
meansRawOffsetEachNPV <-aggregate(alldata$jptnoarea- alldata$tjpt, by=list(alldata$NPV), FUN=mean)
meansAreaOffsetEachNPV <- aggregate(alldata$jpt- alldata$tjpt, by=list(alldata$NPV), FUN=mean)
plot(meansRawOffsetEachNPV$Group.1, meansRawOffsetEachNPV$x, xlab="NPV", ylab="Mean of Offset", ylim=c(2.5,50), col="black", pch=19)
lines(meansRawOffsetEachNPV$Group.1, meansRawOffsetEachNPV$x, col="black")
points(meansAreaOffsetEachNPV$Group.1, meansAreaOffsetEachNPV$x, col='blue')
lines(meansAreaOffsetEachNPV$Group.1, meansAreaOffsetEachNPV$x, col='blue')
legend("topleft",pch=c(19,1), col=c("black", "blue"), c("Raw Jpt Offset", "Area-based Jpt Offset"), bty="o",  box.col="darkgreen", cex=.8)

## RMS of Offset as a function of NPV
rmsRawOffsetEachNPV <- aggregate(alldata$jptnoarea - alldata$tjpt, by=list(alldata$NPV))



## Mean value of offset as a function of sigma*sqrt(A)
plot(data$data$sigma * sqrt(data$area))

#data = data[data$tjpt != 0,]
data$noise = data$area * data$rho
data$offset = data$tjpt - data$jpt
data$var = data$sigma * sqrt(data$area)
  
trainerror <- 0
testerror<-0
areatrainerr <- 0
areatesterr <-0
#for(i in 1 :8 ){
  
train_rows <- sample(nrow(data), round(nrow(data) *0.8 ))
traindf <- data[train_rows, ]
testdf <- data[-train_rows, ]


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

plot(1:8, trainerror,  ylim=c(0, 80), col = 'red', 'l')
lines(1:8, testerror, col="yellow", lwd=2,'l')
lines(1:8, areatrainerr, col="blue", lwd=2,'l')
lines(1:8, areatesterr, col="black", lwd=2,'l')

legend("topleft", legend = c("train_lin, test_lin, train_area, test_area"), lty=c(1,1,1,1),lwd=c(2,2,2,2), col=c("red","yellow","blue","black"))  

x <- predictions_ols - testdf$tjpt
#x <- predictions_ols
h<-hist(x, breaks=20, col="red", xlab="h(x) - y on the test set", 
        main="Linear regression") 
xfit<-seq(min(x),max(x),length=40) 
yfit<-dnorm(xfit,mean=mean(x),sd=sd(x)) 
yfit <- yfit*diff(h$mids[1:2])*length(x) 
lines(xfit, yfit, col="black", lwd=2)

x2 <- testdf$jpt - testdf$tjpt
#x2 <- testdf$offset
#h<-hist(x2, breaks=20, col="blue", xlab="h(x) - y on the test set", 
        #main="Linear regression") 
xfit2<-seq(min(x2),max(x2),length=40) 
yfit2<-dnorm(xfit2,mean=mean(x2),sd=sd(x2)) 
yfit2 <- yfit2*diff(h$mids[1:2])*length(x2) 
lines(xfit2, yfit2, col="green", lwd=2)

#gbm model

gbm_formula <- as.formula(offset ~ jptnoarea + rho  + area + sigma + sumtrkPV + sumtrkPU)
gbm_model <- gbm(gbm_formula, data=traindf, n.trees = 50, bag.fraction = 0.75, cv.folds = 10, interaction.depth = 2)
gbm_perf <- gbm.perf(gbm_model, method = "cv")
summary(gbm_model)

predictions_gbm <- predict(gbm_model, newdata = testdf, n.trees = gbm_perf, type = "response")
mean((predictions_gbm - testdf$offset)^2)
mean((testdf$jpt - testdf$tjpt)^2)

# glmnet
# For glmnet we make a copy of our dataframe into a matrix
trainx_dm <- data.matrix(traindf[, -response_column - 9])

lasso_model <- cv.glmnet(x = trainx_dm, y = traindf$tjpt, alpha = 1)

ridge_model <- cv.glmnet(x = trainx_dm, y = traindf$tjpt, alpha = 0)

testx_dm <- data.matrix(testdf[, -response_column])
predictions_lasso <- predict(lasso_model, newx = testx_dm, type = "response", s = "lambda.min")[, 1]
predictions_ridge <- predict(ridge_model, newx = testx_dm, type = "response", s = "lambda.min")[, 1]

mean((predictions_lasso - testdf$tjpt)^2)
mean((predictions_ridge - testdf$tjpt)^2)

# decision trees
dtree_model <- rpart(tjpt ~ jptnoarea + noise + area + sigma + sumtrkPV + sumtrkPU, traindf, method = "anova")
predictions_dtree <- predict(dtree_model, testdf[, -response_column])
mean((predictions_dtree - testdf$tjpt)^2)

# locally weighed linear regression
modelLWLR <- CoreModel(tjpt ~ jptnoarea + rho + area + sigma + sumtrkPV + sumtrkPU, data = traindf, model="regTree",
                       modelTypeReg=8, minNodeWeightTree=Inf)
#print(modelLWLR) # simple visualization, test also others with function plot
predictions_lwlr <- predict(modelLWLR, testdf, type="both") # prediction on testing set
mean((predictions_lwlr - testdf$tjpt)^2)
destroyModels(modelLWLR)

