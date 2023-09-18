
## This script is used to generate plots for trajectories for different variables including body weight, 
# head circumference and Doppler parameters. 
# Input files are data frames that contain HC, BW and Doppler data 
# Outputs are line plots of developmental trajectories against weeks since conception (antenatal / postnatal weeks)
# in control and FGR group

library(ggplot2)
library(cowplot)

## Plot Body weight trajectory 

# Load BW_LMER data frame and run the code to generate the trajectory - select lines 10 to 29 and click "Run"
data <- BW_LMER
attach(data)

sample_plot <- ggplot(data, aes(x=Week, y=Weight_kg)) +
  geom_line(aes(group=Baby), col="black", alpha=0.8)+
  coord_fixed(11) +
  geom_point(aes(fill=Environment_orig),pch=21,size=3) +
  facet_wrap(~Subgroup_orig)+
  geom_smooth(method = "lm", formula = y ~ poly(x,3), se = FALSE, col="red", lwd=2)+
  scale_x_continuous (name = "Weeks Since Conception (AN and PN)") +
  scale_y_continuous (name = "Body Weight (kg)", limits=c(0,7),expand = c(0,0), breaks = seq(0,7,1)) +
  scale_fill_manual(values = c( "blue", "grey"))+             
  theme_classic() +
  theme(axis.text=element_text(size=16, color="black"),
        axis.line=element_line(size=1, colour = "black"),
        axis.title=element_text(size=14, face="bold"),
        strip.text=element_text(size=14, face="bold"),
        legend.position="none") 
  
sample_plot  

# Run the line 32 to remove all variables in the global environment
rm(list=ls()) 

## Plot HC trajectory  

# Load HC_Weight_LMER DF and run the code to generate the trajectory - select lines 38 to 58 and click "Run"

rm(list=setdiff(ls(), "HC_Weight_LMER"))
data <- HC_Weight_LMER [!is.na(HC_Weight_LMER$HC), ]
attach(data)

sample_plot <- ggplot(data, aes(x=Week, y=HC)) +
  geom_line(aes(group=Baby), col="black", alpha=0.8)+
  coord_fixed(2.5) +
  geom_point(aes(fill=Environment_orig),pch=21,size=3) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), se = FALSE, col="red", lwd=2)+
  facet_wrap(~Subgroup_orig)+
  scale_x_continuous (name = "Weeks Since Conception (AN and PN)") +
  scale_y_continuous (name = "Head Circumference (cm)", limits=c(10,45),expand = c(0,0), breaks = seq(10,45,5)) +
  scale_fill_manual(values = c( "blue", "grey")) +  
  theme_classic() +
  theme(axis.text=element_text(size=16, color="black"),
        axis.line=element_line(size=1, colour = "black"),
        axis.title=element_text(size=14, face="bold"),
        strip.text=element_text(size=14, face="bold"),
        legend.position="none") 

sample_plot  

# Run the line 61 to remove all variables except HC_Weight_LMER in the global environment
rm(list=setdiff(ls(), "HC_Weight_LMER")) 

###################################

## Plot HC / BW trajectory 

# Select lines 38 to 58 and click "Run"

data <- HC_Weight_LMER [!is.na(HC_Weight_LMER$HC_Weight), ]
attach(data)

sample_plot <- ggplot(data, aes(x=Week, y=HC_Weight)) +
geom_line(aes(group=Baby), col="black", alpha=0.8)+
  coord_fixed (700) +
  geom_point(aes(fill=Environment_orig),pch=21,size=2) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 3), se = FALSE, col="red", lwd=2)+
  facet_wrap(~Subgroup_orig)+
  scale_x_continuous (name = "Weeks Since Conception (AN and PN)") +
  scale_y_continuous (name = "HC/BW Ratio (cm/gr)", limits=c(0,0.12),expand = c(0,0), breaks = seq(0,0.12,0.02)) +
  scale_fill_manual(values = c( "blue", "grey")) +             
  theme_classic() +
  theme(axis.text=element_text(size=16, color="black"),
        axis.line=element_line(size=1, colour = "black"),
        axis.title=element_text(size=14, face="bold"),
        strip.text=element_text(size=14, face="bold"),
        legend.position="none") 

sample_plot  

# Run the line 90 to remove all variables except HC_Weight_LMER in the global environment
rm(list=setdiff(ls(), "HC_Weight_LMER")) 

#####################################

# plot BW/HC trajectories

# Select lines 98 to 117 and click "Run"
data <- HC_Weight_LMER [!is.na(HC_Weight_LMER$BW_HC), ]
attach(data)

sample_plot <- ggplot(data, aes(x=Week, y=BW_HC)) +
  geom_line(aes(group=Baby), col="black", alpha=0.8)+
  coord_fixed(0.7) +
  geom_point(aes(fill=Environment_orig),pch=21,size=2) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 3), se = FALSE, col="red", lwd=2)+
  facet_wrap(~Subgroup_orig)+
  scale_x_continuous (name = "Weeks Since Conception (AN and PN)") +
  scale_y_continuous (name = "BW/HC Ratio (gr/cm)", limits=c(0,125),expand = c(0,0), breaks = seq(0,125,25)) +
  scale_fill_manual(values = c( "blue", "grey")) +             
  theme_classic() +
  theme(axis.text=element_text(size=16, color="black"),
        axis.line=element_line(size=1, colour = "black"),
        axis.title=element_text(size=14, face="bold"),
        strip.text=element_text(size=14, face="bold"),
        legend.position="none") 

sample_plot  

# Run the line 129 to remove all variables in the global environment
rm(list=ls()) 
##################################### 

# plot MCA PI (Middle cerebral artery pulsatility index)

# Load Doppler_LMER DF and run the code to generate the trajectory - select lines 127 to 145 and click "Run"

data <- Doppler_LMER [!is.na(Doppler_LMER$MCA), ]
attach(data)

sample_plot <- ggplot(data, aes(x=Week, y=MCA)) +
  coord_fixed(6) +
  geom_point(aes(fill=Subgroup_orig),pch=21,size=2) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), se = FALSE, col="red", lwd=2)+
  facet_wrap(~Subgroup_orig)+
  scale_x_continuous (name = "Weeks Since Conception (Antenatal)") +
  scale_y_continuous (name = "MCA PI",limits=c(0,7),expand = c(0,0), breaks = seq(0,7,2)) +
  scale_fill_manual(values = c( "blue", "blue", "blue")) +             
  theme_classic() +
  theme(axis.text=element_text(size=16, color="black"),
        axis.line=element_line(size=1, colour = "black"),
        axis.title=element_text(size=14, face="bold"),
        strip.text=element_text(size=14, face="bold"),
        legend.position="none") 

sample_plot  

# Run the line 148 to remove all variables except Doppler_LMER in the global environment
rm(list=setdiff(ls(), "Doppler_LMER")) 

#####
# plot UA PI (Uterine artery)

# Select lines 98 to 117 and click "Run"

data <- Doppler_LMER [!is.na(Doppler_LMER$UA), ]
attach(data)

sample_plot <- ggplot(data, aes(x=Week, y=UA)) +
  coord_fixed(6) +
  geom_point(aes(fill=Subgroup_orig),pch=21,size=2) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2), se = FALSE, col="red", lwd=2)+
  facet_wrap(~Subgroup_orig)+
  scale_x_continuous (name = "Weeks Since Conception (Antenatal)") +
  scale_y_continuous (name = "UA PI",limits=c(0,7),expand = c(0,0), breaks = seq(0,7,2)) +
  scale_fill_manual(values = c( "blue", "blue", "blue")) +             
  theme_classic() +
  theme(axis.text=element_text(size=16, color="black"),
        axis.line=element_line(size=1, colour = "black"),
        axis.title=element_text(size=14, face="bold"),
        strip.text=element_text(size=14, face="bold"),
        legend.position="none") 

sample_plot   

# Run the line 176 to remove all variables except Doppler_LMER in the global environment
rm(list=setdiff(ls(), "Doppler_LMER")) 

##############

## Plot MCA/UA PI

# Select lines 184 to 202 and click "Run"

data <- Doppler_LMER [!is.na(Doppler_LMER$MCA_UA), ]
attach(data)

sample_plot <- ggplot(data, aes(x=Week, y=MCA_UA)) +
  coord_fixed(8) +
  geom_point(aes(fill=Subgroup_orig),pch=21,size=2) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 1), se = FALSE, col="red", lwd=2)+
  facet_wrap(~Subgroup_orig)+
  scale_x_continuous (name = "Weeks Since Conception (Antenatal)") +
  scale_y_continuous (name = "MCA / UA PI Ratio",limits=c(0,5),expand = c(0,0), breaks = seq(0,5,1)) +
  scale_fill_manual(values = c( "blue", "blue", "blue")) +             
  theme_classic() +
  theme(axis.text=element_text(size=16, color="black"),
        axis.line=element_line(size=1, colour = "black"),
        axis.title=element_text(size=14, face="bold"),
        strip.text=element_text(size=14, face="bold"),
        legend.position="none") 

sample_plot  

# Run the line 205 to remove all variables except Doppler_LMER in the global environment
rm(list=setdiff(ls(), "Doppler_LMER")) 

################

## Plot  UA/MCA PI
# Select lines 212 to 230 and click "Run"

data <- Doppler_LMER [!is.na(Doppler_LMER$UA_MCA), ]
attach(data)

sample_plot <- ggplot(data, aes(x=Week, y=UA_MCA)) +
  coord_fixed(10) +
  geom_point(aes(fill=Subgroup_orig),pch=21,size=2) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 1), se = FALSE, col="red", lwd=1)+
  facet_wrap(~Subgroup_orig)+
  scale_x_continuous (name = "Weeks Since Conception (Antenatal)") +
  scale_y_continuous (name = "UA / MCA  PI Ratio",limits=c(0,5),expand = c(0,0), breaks = seq(0,5,1)) +
  scale_fill_manual(values = c( "blue", "blue", "blue")) +             
  theme_classic() +
  theme(axis.text=element_text(size=16, color="black"),
        axis.line=element_line(size=1, colour = "black"),
        axis.title=element_text(size=14, face="bold"),
        strip.text=element_text(size=14, face="bold"),
        legend.position="none") 

sample_plot  

# Run the line 233 to remove all variables in the global environment
rm(list=ls()) 

##END
