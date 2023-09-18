# This script is used to perform regression analyses between delta / theta / alpha_beta FFT power,
# TTA burst power, TTA burst rate and FGR disease status and FGR severity as indexed by UA/MCA PI ratio
# Input file is data frame that contain FFT powers at delta, theta, alpha_beta range, TTA burst power and density, 
# doppler features
# Outputs are AIC values, beta coefficient estimates, confidence intervals for beta coefficients and p values for
# various models tests to predict the effect of FGR disease status and disease severity on various EEG parameters

library(plotrix)
library(dplyr)
library(lm.beta)
library(lmtest)
library(AICcmodavg)
library(tidyverse)

## Regression for DELTA; THETA and ALPHA_BETA absolute power

# Load the data frame FFT_av  - 

data <- FFT_av
attach(data)

# Define model1 (linear PMA) and model2 (quadratic)
model1 <- lm(Delta_abs ~ PMA)
model2 <- lm(Delta_abs ~ PMA + I(PMA^2))  

# Select best fit model based on AIC 
models <- list(model1, model2)
mod.names <- c('model1', 'model2')
aictab(cand.set = models, modnames = mod.names)

# Define model3 (Add PNA to the best fitting model (model1 or model2))
model3 <- lm(Delta_abs ~ PMA + I(PMA^2) + PNA)  

# Determine beta coefficient estimate, CI and p value for the estimate
summary(model3)
matrix_coef<- summary (model3)$coefficients 
ci = matrix(nrow= length(matrix_coef[ ,1]), ncol =4) 
ci[,1] = matrix_coef[,1] 
ci[,2] = ci[,1] - 1.96 * matrix_coef[,2] 
ci[,3] = ci[,1] + 1.96 * matrix_coef[,2]
ci[,4] = matrix_coef[,4]
colnames(ci) <- c("Beta", "Min", "Max", "p") 
# last row of the "ci" matrix contains information for the beta estimate, CI and p value

# Select best fit model based on AIC 
models <- list(model2, model3)
mod.names <- c('model2', 'model3')
aictab(cand.set = models, modnames = mod.names)

# Define model4 (add FGR disease status Y/N to model 3)
Group <- factor(Group)
model4 <- lm (Delta_abs ~ PMA + I(PMA^2) + PNA + Group)

# Determine beta coefficient estimate, CI and p value for the estimate
summary(model4)
matrix_coef<- summary (model4)$coefficients 
ci = matrix(nrow= length(matrix_coef[ ,1]), ncol =4) 
ci[,1] = matrix_coef[,1] 
ci[,2] = ci[,1] - 1.96 * matrix_coef[,2] 
ci[,3] = ci[,1] + 1.96 * matrix_coef[,2]
ci[,4] = matrix_coef[,4]
colnames(ci) <- c("Beta", "Min", "Max", "p") 
# last row of the "ci" matrix has beta coefficient, CIs and p value

# Select best fit model based on AIC 
models <- list(model3, model4)
mod.names <- c('model3', 'model4')
aictab(cand.set = models, modnames = mod.names)

# Define model5 (add to model 3 Doppler_week, i.e. Gestational age at which last Doppler before the birth was 
                                                   # acquired to determine UA/MCA ratio)
rm(data)                                                 
data <- FFT_av [!is.na(FFT_av$UA_MCA), ] 
data <- data [!is.na(data$Delta_abs), ]
attach(data)

model5 <- lm (Delta_abs ~ PMA + I(PMA^2) + PNA + Doppler_week)

# Select best fit model based on AIC 
models <- list(model3, model5)
mod.names <- c('model3', 'model5')
aictab(cand.set = models, modnames = mod.names)

# Define model6 (Add to model5 UA_MCA PI ratio as an index for FGR severity)
model6 <- lm(Delta_abs ~ PMA + I(PMA^2) + PNA + Doppler_week + UA_MCA)

# Determine beta coefficient estimate, CI and p value for the estimate
summary(model6)
matrix_coef<- summary (model6)$coefficients 
ci = matrix(nrow= length(matrix_coef[ ,1]), ncol =4) 
ci[,1] = matrix_coef[,1] 
ci[,2] = ci[,1] - 1.96 * matrix_coef[,2] 
ci[,3] = ci[,1] + 1.96 * matrix_coef[,2]
ci[,4] = matrix_coef[,4]
colnames(ci) <- c("Beta", "Min", "Max", "p") 
# last row of the "ci" matrix has beta coefficient, CIs and p value

# Select best fit model based on AIC 
models <- list(model5, model6)
mod.names <- c('model5', 'model6')
aictab(cand.set = models, modnames = mod.names)

rm(list=setdiff(ls(), "FFT_av")) # to remove everything in the environment except FFT_av data frame for the next analysis
## To perform the regression analyses for THETA and ALPHA_BETA absolute powers 
# simply change to Theta_abs and Alpha_Beta_abs and follow the lines above 

##########################################

## Regression for TTA burst power and TTA burst rate

data <- FFT_av [!is.na(FFT_av$TTA_1_mean), ]
attach(data)

# Define model1 (linear PMA) and model2 (quadratic)
model1 <- lm(TTA_1_mean ~ PMA)
model2 <- lm(TTA_1_mean ~ PMA + I(PMA^2))  

# Select best fit model based on AIC 
models <- list(model1, model2)
mod.names <- c('model1', 'model2')
aictab(cand.set = models, modnames = mod.names)

# Define model3 (Add PNA to the best fitting model (model1 or model2))
model3 <- lm(TTA_1_mean ~ PMA + PNA)  
summary(model3)

# Determine beta coefficient estimate, CI and p value for the estimate
summary(model3)
matrix_coef<- summary (model3)$coefficients 
ci = matrix(nrow= length(matrix_coef[ ,1]), ncol =4) 
ci[,1] = matrix_coef[,1] 
ci[,2] = ci[,1] - 1.96 * matrix_coef[,2] 
ci[,3] = ci[,1] + 1.96 * matrix_coef[,2]
ci[,4] = matrix_coef[,4]
colnames(ci) <- c("Beta", "Min", "Max", "p") 

# Select best fit model based on AIC 
models <- list(model1, model3)
mod.names <- c('model1', 'model3')
aictab(cand.set = models, modnames = mod.names)

# Define model4 (add FGR disease status Y/N to model 3)
Group <- factor(Group) 
model4 <- lm (TTA_1_mean ~ PMA + PNA + Group)

# Determine beta coefficient estimate, CI and p value for the estimate
summary(model4)
matrix_coef<- summary (model4)$coefficients 
ci = matrix(nrow= length(matrix_coef[ ,1]), ncol =4) 
ci[,1] = matrix_coef[,1] 
ci[,2] = ci[,1] - 1.96 * matrix_coef[,2] 
ci[,3] = ci[,1] + 1.96 * matrix_coef[,2]
ci[,4] = matrix_coef[,4]
colnames(ci) <- c("Beta", "Min", "Max", "p") 

# Select best fit model based on AIC 
models <- list(model3, model4)
mod.names <- c('model3', 'model4')
aictab(cand.set = models, modnames = mod.names)

# Define model5 (add to model 3 Doppler_week)
rm(data)
data <- FFT_av [!is.na(FFT_av$UA_MCA), ] 
data <- data [!is.na(data$TTA_1_mean), ]
attach(data)

model5 <- lm(TTA_1_mean ~ PMA + PNA + Doppler_week)

# Select best fit model based on AIC 
models <- list(model3, model5)
mod.names <- c('model3', 'model5')
aictab(cand.set = models, modnames = mod.names)

# Define model6 (Add to model5 UA_MCA PI ratio as an index for FGR severity)
model6 <- lm (TTA_1_mean ~ PMA + PNA + Doppler_week + UA_MCA )
summary (model6)

# Determine beta coefficient estimate, CI and p value for the estimate
summary(model6)
matrix_coef<- summary (model6)$coefficients 
ci = matrix(nrow= length(matrix_coef[ ,1]), ncol =4) 
ci[,1] = matrix_coef[,1] 
ci[,2] = ci[,1] - 1.96 * matrix_coef[,2] 
ci[,3] = ci[,1] + 1.96 * matrix_coef[,2]
ci[,4] = matrix_coef[,4]
colnames(ci) <- c("Beta", "Min", "Max", "p") 

# Select best fit model based on AIC 
models <- list(model5, model6)
mod.names <- c('model5', 'model6')
aictab(cand.set = models, modnames = mod.names)

rm(list=setdiff(ls(), "FFT_av"))

# To perform the regression analyses for TTA burst rate 
# simply change to TTA_density and follow the lines 104 -184
##########################################


####end#######