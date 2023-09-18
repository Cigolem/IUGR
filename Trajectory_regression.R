
# This script is used to perform regression analyses between developmental features (body weight, height circumferance,
# doppler features) and FGR disease status (early and late onset FGR compared to control group)
# Input files are data frames that contain values for these trajectories; i.e. BW, HC and Doppler data frames
# Outputs are AIC values, beta coefficient estimates, confidence intervals for beta coefficients and p values for
# various models to predict the effect of FGR disease status on various trajectories


library(plotrix)
library(dplyr)
library(lm.beta)
library(lmtest)
library(AICcmodavg)
library(tidyverse)


## BODY WEIGHT ~ CGA

# Load BW_LMER data frame
data <- BW_LMER
attach(data)

# Define model1. model2 and model3 (linear, quadratic and cubic models)
model1 <- lm(Weight ~ Week.c)  # mean centered week (Week.c) 
model2 <- lm(Weight ~ Week.c + Week.c_sq)
model3 <- lm(Weight ~ Week.c + Week.c_sq + Week.c_cu)

# Select best fit model based on AIC 
models <- list(model1, model2, model3)
mod.names <- c('model1', 'model2', 'model3')
aictab(cand.set = models, modnames = mod.names)

# Define model4 (Add group; i.e. Control, early onset FGR and late onset FGR to the best fitting model (model1, 2 or 3))
Subgroup <- factor(Subgroup)
model4 <- lm (Weight ~ Week.c + Week.c_sq + Week.c_cu + Subgroup)

# Determine beta coefficient estimate, CI and p value for the estimate
summary(model4)
matrix_coef<- summary (model4)$coefficients 
ci = matrix(nrow= length(matrix_coef[ ,1]), ncol =4) 
ci[,1] = matrix_coef[,1] 
ci[,2] = ci[,1] - 1.96 * matrix_coef[,2] 
ci[,3] = ci[,1] + 1.96 * matrix_coef[,2]
ci[,4] = matrix_coef[,4]
colnames(ci) <- c("Beta", "Min", "Max", "p") 
# last two rows of the "ci" matrix contains information for beta estimate, CIs and p value for 
# the late and early onset groups (as compared to control group)

# Select best fit model based on AIC (models with and without group added)
models <- list(model3, model4)
mod.names <- c('model3', 'model4')
aictab(cand.set = models, modnames = mod.names)

rm(list=ls())  # remove all variables in the environment
#################################################

## HEAD CIRCUMFERENCE ~ CGA

# Load HC_Weight_LMER data frame

data <- HC_Weight_LMER [!is.na(HC_Weight_LMER$HC), ] # if there is any observation point with missing data, remove them 
attach(data)

# Define model1. model2 and model3 (linear, quadratic and cubic models)
model1 <- lm(HC ~ Week.c)  
model2 <- lm(HC ~ Week.c + Week.c_sq)
model3 <- lm(HC ~ Week.c + Week.c_sq + Week.c_cu)

# Select best fit model based on AIC 
models <- list(model1, model2, model3)
mod.names <- c('model1', 'model2', 'model3')
aictab(cand.set = models, modnames = mod.names)

# Define model4
Subgroup <- factor(Subgroup)
model4 <- lm (HC ~ Week.c + Week.c_sq + Subgroup)

# Determine beta coefficient estimate, CI and p value for the estimate
summary(model4)
matrix_coef<- summary (model4)$coefficients 
ci = matrix(nrow= length(matrix_coef[ ,1]), ncol =4) 
ci[,1] = matrix_coef[,1] 
ci[,2] = ci[,1] - 1.96 * matrix_coef[,2] 
ci[,3] = ci[,1] + 1.96 * matrix_coef[,2]
ci[,4] = matrix_coef[,4]
colnames(ci) <- c("Beta", "Min", "Max", "p") 

# Select best fit model based on AIC (models with and without group added)
models <- list(model2, model4)
mod.names <- c('model2', 'model4')
aictab(cand.set = models, modnames = mod.names)


###############################################

rm(list=setdiff(ls(), "HC_Weight_LMER")) # removes all variables from the environment except HC_Weight_LMER

## HC / BW ~ CGA
data <- HC_Weight_LMER [!is.na(HC_Weight_LMER$HC_Weight), ]
attach(data)

# Define model1. model2 and model3 and select the best fit
model1 <- lm(HC_Weight ~ Week.c)  
model2 <- lm(HC_Weight ~ Week.c + Week.c_sq)
model3 <- lm(HC_Weight ~ Week.c + Week.c_sq + Week.c_cu)

models <- list(model1, model2, model3)
mod.names <- c('model1', 'model2', 'model3')
aictab(cand.set = models, modnames = mod.names)

# Define model4; Determine beta coefficient estimate, CI and p value for the estimate; select best fit
Subgroup <- factor(Subgroup)
model4 <- lm (HC_Weight ~ Week.c + Week.c_sq + Week.c_cu + Subgroup)
summary(model4)
matrix_coef<- summary (model4)$coefficients 
ci = matrix(nrow= length(matrix_coef[ ,1]), ncol =4) 
ci[,1] = matrix_coef[,1] 
ci[,2] = ci[,1] - 1.96 * matrix_coef[,2] 
ci[,3] = ci[,1] + 1.96 * matrix_coef[,2]
ci[,4] = matrix_coef[,4]
colnames(ci) <- c("Beta", "Min", "Max", "p") 

models <- list(model3, model4)
mod.names <- c('model3', 'model4')
aictab(cand.set = models, modnames = mod.names)

###############################################

rm(list=setdiff(ls(), "HC_Weight_LMER"))

## BW / HC ~ CGA
data <- HC_Weight_LMER [!is.na(HC_Weight_LMER$BW_HC), ]
attach(data)

# Define model1. model2 and model3 and select the best fit
model1 <- lm(BW_HC ~ Week.c)  
model2 <- lm(BW_HC ~ Week.c + Week.c_sq)
model3 <- lm(BW_HC ~ Week.c + Week.c_sq + Week.c_cu)

models <- list(model1, model2, model3)
mod.names <- c('model1', 'model2', 'model3')
aictab(cand.set = models, modnames = mod.names)

# Define model4; Determine beta coefficient estimate, CI and p value for the estimate; select best fit
Subgroup <- factor(Subgroup)
model4 <- lm (BW_HC ~ Week.c + Week.c_sq + Week.c_cu + Subgroup)
summary(model4)
matrix_coef<- summary (model4)$coefficients 
ci = matrix(nrow= length(matrix_coef[ ,1]), ncol =4) 
ci[,1] = matrix_coef[,1] 
ci[,2] = ci[,1] - 1.96 * matrix_coef[,2] 
ci[,3] = ci[,1] + 1.96 * matrix_coef[,2]
ci[,4] = matrix_coef[,4]
colnames(ci) <- c("Beta", "Min", "Max", "p") 

models <- list(model3, model4)
mod.names <- c('model3', 'model4')
aictab(cand.set = models, modnames = mod.names)

rm(list=ls()) 
###############################################

## MCA PI ~ CGA

# Load data frame Doppler_LMER

data <- Doppler_LMER [!is.na(Doppler_LMER$MCA), ]
attach(data)

# Define model1. model2 and model3 and select the best fit
model1 <- lm(MCA ~ Week.c)  
model2 <- lm(MCA ~ Week.c + Week.c_sq)
model3 <- lm(MCA ~ Week.c + Week.c_sq + Week.c_cu)

models <- list(model1, model2, model3)
mod.names <- c('model1', 'model2', 'model3')
aictab(cand.set = models, modnames = mod.names)

# Define model4; Determine beta coefficient estimate, CI and p value for the estimate; select best fit
Subgroup <- factor(Subgroup)
model4 <- lm (MCA ~ Week.c + Week.c_sq + Subgroup)
summary(model4)
matrix_coef<- summary (model4)$coefficients 
ci = matrix(nrow= length(matrix_coef[ ,1]), ncol =4) 
ci[,1] = matrix_coef[,1] 
ci[,2] = ci[,1] - 1.96 * matrix_coef[,2] 
ci[,3] = ci[,1] + 1.96 * matrix_coef[,2]
ci[,4] = matrix_coef[,4]
colnames(ci) <- c("Beta", "Min", "Max", "p") 

models <- list(model2, model4)
mod.names <- c('model2', 'model4')
aictab(cand.set = models, modnames = mod.names)

##########################################

rm(list=setdiff(ls(), "Doppler_LMER"))

## UA PI ~ CGA
data <- Doppler_LMER [!is.na(Doppler_LMER$UA), ]
attach(data)

# Define model1. model2 and model3 and select the best fit
model1 <- lm(UA ~ Week.c)  
model2 <- lm(UA ~ Week.c + Week.c_sq)
model3 <- lm(UA ~ Week.c + Week.c_sq + Week.c_cu)

models <- list(model1, model2, model3)
mod.names <- c('model1', 'model2', 'model3')
aictab(cand.set = models, modnames = mod.names)

# Define model4; Determine beta coefficient estimate, CI and p value for the estimate; select best fit
Subgroup <- factor(Subgroup)
model4 <- lm (UA ~ Week.c + Week.c_sq + Subgroup)
summary(model4)
matrix_coef<- summary (model4)$coefficients 
ci = matrix(nrow= length(matrix_coef[ ,1]), ncol =4) 
ci[,1] = matrix_coef[,1] 
ci[,2] = ci[,1] - 1.96 * matrix_coef[,2] 
ci[,3] = ci[,1] + 1.96 * matrix_coef[,2]
ci[,4] = matrix_coef[,4]
colnames(ci) <- c("Beta", "Min", "Max", "p") 

models <- list(model2, model4)
mod.names <- c('model2', 'model4')
aictab(cand.set = models, modnames = mod.names)

#####################################

rm(list=setdiff(ls(), "Doppler_LMER"))

## MCA /UA PI ~ CGA
data <- Doppler_LMER [!is.na(Doppler_LMER$MCA_UA), ]
attach(data)

# Define model1. model2 and model3 and select the best fit
model1 <- lm(MCA_UA ~ Week.c)  
model2 <- lm(MCA_UA ~ Week.c + Week.c_sq)
model3 <- lm(MCA_UA ~ Week.c + Week.c_sq + Week.c_cu)

models <- list(model1, model2, model3)
mod.names <- c('model1', 'model2', 'model3')
aictab(cand.set = models, modnames = mod.names)

# Define model4; Determine beta coefficient estimate, CI and p value for the estimate; select best fit
Subgroup <- factor(Subgroup)
model4 <- lm (MCA_UA ~ Week.c + Subgroup)
summary(model4)
matrix_coef<- summary (model4)$coefficients 
ci = matrix(nrow= length(matrix_coef[ ,1]), ncol =4) 
ci[,1] = matrix_coef[,1] 
ci[,2] = ci[,1] - 1.96 * matrix_coef[,2] 
ci[,3] = ci[,1] + 1.96 * matrix_coef[,2]
ci[,4] = matrix_coef[,4]
colnames(ci) <- c("Beta", "Min", "Max", "p") 

models <- list(model1, model4)
mod.names <- c('model1', 'model4')
aictab(cand.set = models, modnames = mod.names)

#############################

rm(list=setdiff(ls(), "Doppler_LMER"))

## UA/MCA PI ~ CGA
data <- Doppler_LMER [!is.na(Doppler_LMER$UA_MCA), ]
attach(data)

# Define model1. model2 and model3 and select the best fit
model1 <- lm(UA_MCA ~ Week.c)  
model2 <- lm(UA_MCA ~ Week.c + Week.c_sq)
model3 <- lm(UA_MCA ~ Week.c + Week.c_sq + Week.c_cu)

models <- list(model1, model2, model3)
mod.names <- c('model1', 'model2', 'model3')
aictab(cand.set = models, modnames = mod.names)

# Define model4; Determine beta coefficient estimate, CI and p value for the estimate; select best fit
Subgroup <- factor(Subgroup)
model4 <- lm (UA_MCA ~ Week.c + Subgroup)
summary(model4)
matrix_coef<- summary (model4)$coefficients 
ci = matrix(nrow= length(matrix_coef[ ,1]), ncol =4) 
ci[,1] = matrix_coef[,1] 
ci[,2] = ci[,1] - 1.96 * matrix_coef[,2] 
ci[,3] = ci[,1] + 1.96 * matrix_coef[,2]
ci[,4] = matrix_coef[,4]
colnames(ci) <- c("Beta", "Min", "Max", "p") 

models <- list(model1, model4)
mod.names <- c('model1', 'model4')
aictab(cand.set = models, modnames = mod.names)

rm(list=ls())

## end ##

