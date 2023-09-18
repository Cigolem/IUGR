## This script is used to generate line plots for EEG features (FFT powers and TTA burst rate / power) against CGA
## (Corrected Gestational Age)
# Input file is data frame that contain FFT powers at delta, theta, alpha_beta range, TTA burst power and density,CGA 
# Outputs are line plots of EEG features against CGA in control and FGR group

library(ggplot2)
library(cowplot)

# Load FFT_av data frame
data <- FFT_av

# Plot data with the best fitting regression line - Delta FFT power

sample_plot <- ggplot(data, aes(x=PMA, y=Delta_abs)) +
  geom_point(aes(fill=Group),pch=21,size=2) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), se = FALSE, col="red", lwd=2)+
  facet_wrap(~Group)+
  theme_classic() +
  scale_x_continuous (name = "Corrected Gestational Age (CGA)") +
  scale_y_continuous (name = "Delta Power (uV2)", limits=c(0,11000),expand = c(0,0), breaks = seq(0,11000,2000)) +
  scale_fill_manual(values = c( "grey", "black")) +             
  theme(axis.text=element_text(size=16, color="black"),
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        strip.text=element_text(size=16, face="bold"),
        legend.position="none") 

sample_plot  


# Plot data with the best fitting regression line - Theta FFT power

sample_plot <- ggplot(data, aes(x=PMA, y=Theta_abs)) +
  geom_point(aes(fill=Group),pch=21,size=2) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), se = FALSE, col="red", lwd=2)+
  facet_wrap(~Group)+
  theme_classic() +
  scale_x_continuous (name = "CGA") +
  scale_y_continuous (name = "Theta Power (uV2)", limits=c(20,120),expand = c(0,0), breaks = seq(20,120,20)) +
  scale_fill_manual(values = c( "grey", "black")) +             
  theme(axis.text=element_text(size=16, color="black"),
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        strip.text=element_text(size=16, face="bold"),
        legend.position="none") 
  
sample_plot


# Plot data with the best fitting regression line - Alpha_beta FFT power

sample_plot <- ggplot(data, aes(x=PMA, y=Alpha_Beta_abs)) +
  geom_point(aes(fill=Group),pch=21,size=2) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 1), se = FALSE, col="red", lwd=2)+
  facet_wrap(~Group)+
  theme_classic() +
  scale_x_continuous (name = "CGA") +
  scale_y_continuous (name = "Alpha-Beta Power (uV2)", limits=c(10,100),expand = c(0,0), breaks = seq(10,100,10)) +
  scale_fill_manual(values = c( "grey", "black")) +             
  theme(axis.text=element_text(size=16, color="black"),
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        strip.text=element_text(size=16, face="bold"),
        legend.position="none") 
  
sample_plot


# Plot data with the best fitting regression line - TTA burst rate

sample_plot <- ggplot(data, aes(x=PMA, y=TTA_density)) +
  geom_point(aes(fill=Group),pch=21,size=2) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), se = FALSE, col="red", lwd=2)+
  facet_wrap(~Group)+
  theme_classic() +
  scale_x_continuous (name = "Corrected Gestational Age") +
  scale_y_continuous (name = "TTA Density (number/min)", limits=c(-0.1,1.6),expand = c(0,0), breaks = seq(0,1.6,0.5)) +
  scale_fill_manual(values = c( "grey", "black")) +             
  theme(axis.text=element_text(size=16, color="black"),
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        strip.text=element_text(size=16, face="bold"),
        legend.position="none") 

sample_plot


# Plot data with the best fitting regression line
rm(data)
data <- FFT_av [!is.na(FFT_av$TTA_1_mean), ] # some data points in the FFT_av df does not have any value for TTA burst 
                                             # power because the subject does not have any TTA event; these rows are 
                                            # removed from the df. 

sample_plot <- ggplot(data, aes(x=PMA, y=TTA_1_mean)) +
  geom_point(aes(fill=Group),pch=21,size=2) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 1), se = FALSE, col="red", lwd=2)+
  facet_wrap(~Group)+
  theme_classic() +
  scale_x_continuous (name = "Corrected Gestational Age") +
  scale_y_continuous (name = "TTA Mean Power", limits=c(0,60),expand = c(0,0), breaks = seq(0,60,10)) +
  scale_fill_manual(values = c( "grey", "black")) +             
  theme(axis.text=element_text(size=16, color="black"),
        axis.title=element_text(size=16, face="bold"),
        plot.title=element_text(size=16, face="bold", hjust=0.5),
        strip.text=element_text(size=16, face="bold"),
        legend.position="none") 

sample_plot

#### end ####
