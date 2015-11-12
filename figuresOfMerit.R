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
rms <- function(x) {
  return (sqrt(mean(x^2)))
}
rmsRawOffsetEachNPV <- aggregate(alldata$jptnoarea - alldata$tjpt, by=list(alldata$NPV), FUN=rms)
rmsAreaOffsetEachNPV <- aggregate(alldata$jpt - alldata$tjpt, by=list(alldata$NPV), FUN=rms)
plot(rmsRawOffsetEachNPV$Group.1, rmsRawOffsetEachNPV$x, xlab="NPV", ylab="RMS of Offset", ylim=c(5,50), col="black", pch=19)
lines(rmsRawOffsetEachNPV$Group.1, rmsRawOffsetEachNPV$x, col="black")
points(rmsAreaOffsetEachNPV$Group.1, rmsAreaOffsetEachNPV$x, col='blue')
lines(rmsAreaOffsetEachNPV$Group.1, rmsAreaOffsetEachNPV$x, col='blue')
legend("topleft",pch=c(19,1), col=c("black", "blue"), c("Raw Jpt Offset", "Area-based Jpt Offset"), bty="o",  box.col="darkgreen", cex=.8)
