# This script is used to:
          # generate violin plots of z-scored residuals for delta, theta, alpha_beta FFT power; 
                # TTA burst rate and burst power after controlling for CGA and PNA in FGR vs. controls; 
          # generate line plots of z-scored residuals for the same EEG features against UA/MCA ratio  
                # after controlling for CGA, PNA and GA_Doppler.
# Input file is data frame that contain FFT powers at delta, theta, alpha_beta range, TTA burst power and density, 
# doppler features

# Outputs are violin and line plots of z-scored residuals

library(ggplot2)
library(plotrix)
library(dplyr)
library(lm.beta)
library(lmtest)

######### Delta/ Theta / Alpha_beta FFT absolute power ~ PMA and PNA ###############

# Load FFT_av data frame

data <- FFT_av
attach(data)

# Define model1 (to correct for PMA and PNA)
model1 <-lm(Delta_abs ~ PMA + I(PMA^2) + PNA) # from the analysis using EEG_regression script we know which of the 
                                              # model (linear vs quadratic) fits data better for the given EEG parameter

# Extract residuals from the model  
Residuals <- model1$residuals
av_res <- mean(Residuals)
dev_res <- sd(Residuals)

# Generate z-scores for residuals
z_residuals <- NaN
for(i in 1:nrow(data)){
  z_residuals [i] <-(Residuals[i]-av_res)/dev_res
} 

# Add a column to the data frame "data" for z-scored residuals
data$z_residuals <- z_residuals 

## Generate Violin plot for residuals for control and FGR groups 

p <- ggplot(data, aes(x=Group, y=z_residuals, color=Group)) + 
  geom_violin(size = 1.25, trim=FALSE)+
  geom_boxplot(width=0.2) +  # Add median and quartile
  geom_dotplot(binaxis='y', stackdir='center', binwidth = 0.2)+
  scale_y_continuous (name = "z-score Residuals", limits=c(-4,6),expand = c(0,0), breaks = seq(-4,6,2) ) +
  ggtitle("Delta Residuals - CGA and PNA Controlled ") +
  xlab(NULL) +
  scale_color_manual(values = c( "grey", "black")) +
  theme_classic()+
  theme(axis.text=element_text(size=16, color="black"),
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        strip.text=element_text(size=16, face="bold"),
        legend.position="none") 
p  

## Plot Residuals against UA/MCA PI ratio
rm(data) #remove data frame "data" to generate new data frame
data <- FFT_av [!is.na(FFT_av$UA_MCA), ] 
data <- data [!is.na(data$Delta_abs), ]

# Define model1 (to correct for PMA and PNA (if present in the model) and GA_Doppler)
model2 <- lm (Delta_abs ~ PMA + I(PMA^2) + Doppler_week) # from the analysis with EEG_regression script we know whether 
                                                         # adding PNA to the model improves the fit
# GA_Doppler - Gestational age at which last Doppler before the birth was acquired to determine UA/MCA ratio

# Extract residuals from the model
Residuals <- model2$residuals
av_res <- mean(Residuals)
dev_res <- sd(Residuals)

# Generate z-scores for residuals
z_residuals <- NaN
for(i in 1:nrow(data)){
  z_residuals [i] <-(Residuals[i]-av_res)/dev_res
} 

# Add a column to the data frame "data" for z-scored residuals
data$z_residuals <- z_residuals

## Generate Line plot for Residuals against UA/MCA PI ratio

sample_plot <- ggplot(data, aes(x=UA_MCA, y=z_residuals)) +
  geom_point(aes(fill=Group),pch=21,size=2) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 1), se = FALSE, col="red", lwd=2)+
  facet_wrap(~Group)+
  scale_x_continuous (name = "UA/MCA Ratio") +
  scale_y_continuous (name = "z Score Residuals (Delta)") +
  #ggtitle("Delta Residuals ") +
  scale_fill_manual(values = c( "grey", "black")) + 
  theme_classic()+
  theme(axis.text=element_text(size=16, color="black"),
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        strip.text=element_text(size=16, face="bold"),
        legend.position="none") 
sample_plot
  
## To perform the regression analyses for THETA, ALPHA_BETA absolute powers, TTA burst rate and power 
## simply change to relevant column names and follow the lines above 

##### end ########

