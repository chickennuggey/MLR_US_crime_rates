# MLR_US_crime_rates
Project: Predicting Violent Crime Rates in the United States

Dataset: *https://www.kaggle.com/datasets/michaelbryantds/crimedata*

## Introduction
Although the general trend of violent crime rate in California has decreased over the past decade, there has been a gradual increase from 2014 of about 391 violent crimes per 100,000 residents to 495 violent crime per 100,000 residents in 2022, resulting in an overall 26.4% increase. These violent crimes mainly consisted of a large percentage of aggravated assaults followed by robberies, rapes and homicides. In order to implement more effective policies to mediate and combat violent crimes, it is crucial to understand its causes. This study aimed to explore different demographic features and crime rates in various communities within not just California, but the entire United States. A Kaggle dataset from the year 2022 was utilized to develop a multiple linear regression (MLR) model to predict the number of violent crimes per population. This dataset contained 146 different variables and 2018 observations (n = 2018), but this study mainly focused on the following variables:

**Predictor variables**: percent of kids born with non-married parents (PctKidsBornNeverMar), median in- come (medIncome), percent of population under poverty (PctPopUnderPov), percent of divorce (TotalPctDiv), median rent (RentMedian), percent of 2 parent families (PctFam2Par), percent of non-high school graduates (PctNotHSGrad), percent of unemployed (PctUnemployed), number of non-violent crimes per population (non- ViolPerPop)
**Outcome variable**: number of violent crimes per population (ViolentCrimesPerPop)

## Methods
- **Data Cleaning**: Data was cleaned by filtering out the variables of interest and removing incomplete cases
- **Variable Correlation**: A correlation matrix was used to determine if there exists a linear relationship between the predictor and outcome variables and to examine any possible multi-collinearity issues
- **Analysis of Initial Linear Model (Diagnostic Plots, Standardized Residuals)**: The initial MLR model assumptions (normality, homoscedasticity, linearity, outliers) were evaluated using summary results, diagnotic plots and standardized residual plots 
- **Box-Cox Transformation**: A box-cox transformation was implemented to address normality violations in the heavily skewed variables
- **Multi-Collinearity and Variable Selection**: VIF, added-variable plots and a backward stepwise regression was used to remove highly correlated or insignificant variables
- **Outliers**: Outliers were removed based on their standardized residual value and cook's distance

## Resources
- **Report.pdf**: Report of the project
- **RegressionProject.R**: Code 
