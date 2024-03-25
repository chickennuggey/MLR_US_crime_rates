# set directory
# rm(list = ls())

# load in libraries
library(MASS)
library(car)
library(descr)
library(psych)
library(corrplot)

# read in data and select features of interest
data <- read.csv("crimedata.csv")
data <- data[, c("PctKidsBornNeverMar", "medIncome", "PctPopUnderPov", "TotalPctDiv", "RentMedian", "PctFam2Par", "PctNotHSGrad","PctUnemployed", "ViolentCrimesPerPop", "nonViolPerPop")]

# data cleaning
data <- data[complete.cases(data), ]
data <- data[data$PctKidsBornNeverMar != 0.00, ]

# descriptive stats
desc <- describe(data)[, c("mean", "sd", "min", "median", "max", "range", "se")]
var <- apply(data, 2, var)
desc <- round(cbind(desc, var), digits = 2)

# choosing predictors (compute correlation, pairwise correlation)
# pairs(data)
par(mfrow = c(1,1))
par(mar = c(4,4,4,4))
corr <- round(cor(data), digits = 2)
corrplot(corr, tl.srt = 60, tl.col = "black", tl.cex = 0.7, method = "number", number.cex = 0.9)

# create linear model
m1 <- lm(ViolentCrimesPerPop ~ PctKidsBornNeverMar + medIncome + PctPopUnderPov + TotalPctDiv + RentMedian + PctFam2Par + PctNotHSGrad + PctUnemployed + nonViolPerPop, data = data)
summary(m1)

par(mfrow = c(1, 4))
plot(m1)

# plot standardized residual for each predictor
StanRes1 <- rstandard(m1)
par(mfrow = c(2, 5))

plot(data$PctKidsBornNeverMar, StanRes1, xlab = "PctKidsBornNeverMar", ylab = "Standardized Residual")
plot(data$medIncome, StanRes1, xlab = "medIncome", ylab = "Standardized Residual")
plot(data$PctPopUnderPov, StanRes1, xlab = "PctPopUnderPov",ylab = "Standardized Residual")
plot(data$TotalPctDiv, StanRes1, xlab = "TotalPctDiv" ,ylab = "Standardized Residual")
plot(data$RentMedian, StanRes1, xlab = "RentMedian",ylab = "Standardized Residual")
plot(data$PctFam2Par, StanRes1, xlab = "PctFam2Par",ylab = "Standardized Residual")
plot(data$PctNotHSGrad, StanRes1,xlab = "PctNotHSGrad", ylab = "Standardized Residual")
plot(data$PctUnemployed, StanRes1,xlab = "PctUnemployed", ylab = "Standardized Residual")
plot(data$nonViolPerPop, StanRes1,xlab = "nonViolPerPop", ylab = "Standardized Residual")

# fit new linear regression model using the Box-Cox transformation to fix normality assumption
par(mfrow = c(2, 2))

bc <- boxcox(ViolentCrimesPerPop ~ PctKidsBornNeverMar + medIncome + PctPopUnderPov + TotalPctDiv + RentMedian + PctFam2Par + PctNotHSGrad + PctUnemployed + nonViolPerPop, data = data)
lambda <- bc$x[which.max(bc$y)]

m2 <- lm(((ViolentCrimesPerPop^lambda-1)/lambda) ~ PctKidsBornNeverMar + medIncome + PctPopUnderPov + TotalPctDiv + RentMedian + PctFam2Par + PctNotHSGrad + PctUnemployed + nonViolPerPop, data = data)

plot(m2)

# recheck standardized residual
# plot standardized residual for each predictor
StanRes1 <- rstandard(m2)
par(mfrow = c(2, 5))

plot(data$PctKidsBornNeverMar, StanRes1, xlab = "PctKidsBornNeverMar", ylab = "Standardized Residual")
plot(data$medIncome, StanRes1, xlab = "medIncome", ylab = "Standardized Residual")
plot(data$PctPopUnderPov, StanRes1, xlab = "PctPopUnderPov",ylab = "Standardized Residual")
plot(data$TotalPctDiv, StanRes1, xlab = "TotalPctDiv" ,ylab = "Standardized Residual")
plot(data$RentMedian, StanRes1, xlab = "RentMedian",ylab = "Standardized Residual")
plot(data$PctFam2Par, StanRes1, xlab = "PctFam2Par",ylab = "Standardized Residual")
plot(data$PctNotHSGrad, StanRes1,xlab = "PctNotHSGrad", ylab = "Standardized Residual")
plot(data$PctUnemployed, StanRes1,xlab = "PctUnemployed", ylab = "Standardized Residual")
plot(data$nonViolPerPop, StanRes1,xlab = "nonViolPerPop", ylab = "Standardized Residual")

# multi-collinearity and variable selection
vif(m2) 
step(m2, direction = "backward")

par(mfrow = c(1, 3))
avPlot(m2, variable = "PctPopUnderPov")
avPlot(m2, variable = "medIncome")
avPlot(m2, variable = "PctFam2Par")

m3 <- lm(formula = ((ViolentCrimesPerPop^lambda - 1)/lambda) ~ PctKidsBornNeverMar + 
           medIncome + TotalPctDiv + RentMedian + PctNotHSGrad + 
           PctUnemployed + nonViolPerPop, data = data)

par(mfrow = c(1, 4))
summary(m3)
plot(m3)

m4 <- lm(formula = ((ViolentCrimesPerPop^lambda - 1)/lambda) ~ PctKidsBornNeverMar + TotalPctDiv + RentMedian + PctNotHSGrad + 
           PctUnemployed + nonViolPerPop, data = data)
plot(m4)

# compare m3 and m4 to see if we want to include medIncome 
anova(m4, m3)

# remove outliers 
n <- nrow(data) 
p <- ncol(data) - 1

leverages <- which(hatvalues(m3) > 2 * (p+1)/n)
stdres <- rstandard(m3)
outlier1 <- which(stdres > 2 | stdres < -2) 
outlier2 <- which(cooks.distance(m3) > 4/(n-2))

outlier <- unique(c(outlier1, outlier2))

# final model 
m5 <- lm(formula = ((ViolentCrimesPerPop^lambda - 1)/lambda) ~ PctKidsBornNeverMar + medIncome + TotalPctDiv + RentMedian + PctNotHSGrad + 
           PctUnemployed + nonViolPerPop, data = data[-outlier, ])

plot(m5)
summary(m5)

# recheck standardized residual
# plot standardized residual for each predictor
StanRes1 <- rstandard(m5)
par(mfrow = c(2, 4))

plot(data[-outlier,]$PctKidsBornNeverMar, StanRes1, xlab = "PctKidsBornNeverMar", ylab = "Standardized Residual")
plot(data[-outlier,]$medIncome, StanRes1, xlab = "medIncome", ylab = "Standardized Residual")
plot(data[-outlier,]$TotalPctDiv, StanRes1, xlab = "TotalPctDiv" ,ylab = "Standardized Residual")
plot(data[-outlier,]$RentMedian, StanRes1, xlab = "RentMedian",ylab = "Standardized Residual")
plot(data[-outlier,]$PctNotHSGrad, StanRes1,xlab = "PctNotHSGrad", ylab = "Standardized Residual")
plot(data[-outlier,]$PctUnemployed, StanRes1,xlab = "PctUnemployed", ylab = "Standardized Residual")
plot(data[-outlier,]$nonViolPerPop, StanRes1,xlab = "nonViolPerPop", ylab = "Standardized Residual")



