library(rgdal)
library(raster)
library(RColorBrewer)
library(viridis)
library(glmmTMB)
library(mgcv)


#*************************************************************************************************************************************************************************************
###################################################################################################################################################################################################v
# TREE SPECIES DISTRIBUTION MODELLING
###################################################################################################################################################################################################v
#*************************************************************************************************************************************************************************************

###################################################################################################################################################################################################v
###################################################################################################################################################################################################v
###################################################################################################################################################################################################v
###################################################################################################################################################################################################v
#-----# BF
###################################################################################################################################################################################################v
###################################################################################################################################################################################################v
###################################################################################################################################################################################################v

#----# Path to the directory
path2raster <- "D:/Google Drive/hack/raster_files/"

#----# Read the data
BF <- raster(paste(path2raster, "BFrs.grd", sep=""))
WS <- raster(paste(path2raster, "WSrs.grd", sep=""))
BS <- raster(paste(path2raster, "BSrs.grd", sep=""))
DEM <- raster(paste(path2raster, "DEMrs.grd", sep=""))
WIND <- raster(paste(path2raster, "WINDrs.grd", sep=""))
TMAX30 <- raster(paste(path2raster, "TMAX30rs.grd", sep=""))
TMIN30 <- raster(paste(path2raster, "TMIN30rs.grd", sep=""))
TMEAN30 <- raster(paste(path2raster, "TMEAN30rs.grd", sep=""))
PCP30 <- raster(paste(path2raster, "PCP30rs.grd", sep=""))


PCPfut100 <- raster(paste(path2raster, "PCPfutrs.grd", sep=""))
TMEANfut100 <- raster(paste(path2raster, "TMEANfutrs.grd", sep=""))
TMINfut100 <- raster(paste(path2raster, "TMINfutrs.grd", sep=""))
TMAXfut100 <- raster(paste(path2raster, "TMAXfutrs.grd", sep=""))

PCPfut75 <- raster(paste(path2raster, "PCPfut75rs.grd", sep=""))
TMEANfut75 <- raster(paste(path2raster, "TMEANfut75rs.grd", sep=""))
TMINfut75 <- raster(paste(path2raster, "TMINfut75rs.grd", sep=""))
TMAXfut75 <- raster(paste(path2raster, "TMAXfut75rs.grd", sep=""))

PCPfut50 <- raster(paste(path2raster, "PCPfut50rs.grd", sep=""))
TMEANfut50 <- raster(paste(path2raster, "TMEANfut50rs.grd", sep=""))
TMINfut50 <- raster(paste(path2raster, "TMINfut50rs.grd", sep=""))
TMAXfut50 <- raster(paste(path2raster, "TMAXfut50rs.grd", sep=""))

PCPfut25 <- raster(paste(path2raster, "PCPfut25rs.grd", sep=""))
TMEANfut25 <- raster(paste(path2raster, "TMEANfut25rs.grd", sep=""))
TMINfut25 <- raster(paste(path2raster, "TMINfut25rs.grd", sep=""))
TMAXfut25 <- raster(paste(path2raster, "TMAXfut25rs.grd", sep=""))

#----# Put NA where no data
BF[is.na(TMAX30)] <- NA
TMAX30[is.na(BF)] <- NA
TMIN30[is.na(BF)] <- NA
TMEAN30[is.na(BF)] <- NA
PCP30[is.na(BF)] <- NA
DEM[is.na(BF)] <- NA

PCPfut100[is.na(BF)] <- NA
TMEANfut100[is.na(BF)] <- NA
TMINfut100[is.na(BF)] <- NA
TMAXfut100[is.na(BF)] <- NA

PCPfut75[is.na(BF)] <- NA
TMEANfut75[is.na(BF)] <- NA
TMINfut75[is.na(BF)] <- NA
TMAXfut75[is.na(BF)] <- NA

PCPfut50[is.na(BF)] <- NA
TMEANfut50[is.na(BF)] <- NA
TMINfut50[is.na(BF)] <- NA
TMAXfut50[is.na(BF)] <- NA

PCPfut25[is.na(BF)] <- NA
TMEANfut25[is.na(BF)] <- NA
TMINfut25[is.na(BF)] <- NA
TMAXfut25[is.na(BF)] <- NA

#----# Divide by 100 to get the proportion and not anymore the %
BF <- BF/100

#----# Convert it to matrix as needed by the gam function
BFm <- as.matrix(as.data.frame(rasterToPoints(BF, spatial=TRUE)))[,1]
TMAX30m <- as.matrix(as.data.frame(rasterToPoints(TMAX30, spatial=TRUE)))[,1]
PCP30m <- as.matrix(as.data.frame(rasterToPoints(PCP30, spatial=TRUE)))[,1]
TMIN30m <- as.matrix(as.data.frame(rasterToPoints(TMIN30, spatial=TRUE)))[,1]
TMEAN30m <- as.matrix(as.data.frame(rasterToPoints(TMEAN30, spatial=TRUE)))[,1]
DEMm <- as.matrix(as.data.frame(rasterToPoints(DEM, spatial=TRUE)))[,1]
longitude <- as.matrix(as.data.frame(rasterToPoints(BF, spatial=TRUE)))[,2]
latitude <- as.matrix(as.data.frame(rasterToPoints(BF, spatial=TRUE)))[,3]

PCPfut100m <- as.matrix(as.data.frame(rasterToPoints(PCPfut100, spatial=TRUE)))[,1]
TMEANfut100m <- as.matrix(as.data.frame(rasterToPoints(TMEANfut100, spatial=TRUE)))[,1]
TMINfut100m <- as.matrix(as.data.frame(rasterToPoints(TMINfut100, spatial=TRUE)))[,1]
TMAXfut100m <- as.matrix(as.data.frame(rasterToPoints(TMAXfut100, spatial=TRUE)))[,1]

PCPfut75m <- as.matrix(as.data.frame(rasterToPoints(PCPfut75, spatial=TRUE)))[,1]
TMEANfut75m <- as.matrix(as.data.frame(rasterToPoints(TMEANfut75, spatial=TRUE)))[,1]
TMINfut75m <- as.matrix(as.data.frame(rasterToPoints(TMINfut75, spatial=TRUE)))[,1]
TMAXfut75m <- as.matrix(as.data.frame(rasterToPoints(TMAXfut75, spatial=TRUE)))[,1]

PCPfut50m <- as.matrix(as.data.frame(rasterToPoints(PCPfut50, spatial=TRUE)))[,1]
TMEANfut50m <- as.matrix(as.data.frame(rasterToPoints(TMEANfut50, spatial=TRUE)))[,1]
TMINfut50m <- as.matrix(as.data.frame(rasterToPoints(TMINfut50, spatial=TRUE)))[,1]
TMAXfut50m <- as.matrix(as.data.frame(rasterToPoints(TMAXfut50, spatial=TRUE)))[,1]

PCPfut25m <- as.matrix(as.data.frame(rasterToPoints(PCPfut25, spatial=TRUE)))[,1]
TMEANfut25m <- as.matrix(as.data.frame(rasterToPoints(TMEANfut25, spatial=TRUE)))[,1]
TMINfut25m <- as.matrix(as.data.frame(rasterToPoints(TMINfut25, spatial=TRUE)))[,1]
TMAXfut25m <- as.matrix(as.data.frame(rasterToPoints(TMAXfut25, spatial=TRUE)))[,1]

#----# Check if there is the same number of pixel
sum(!is.na(as.matrix(TMAX30)))
sum(!is.na(as.matrix(TMIN30)))


############################
#----# GAM model

#gamBF <- gam(BFm ~ TMEAN30m + PCP30m + DEMm, family="betar")
#summary(gamBF)

gamBF_ll <- gam(BFm ~ TMEAN30m + PCP30m + DEMm + s(latitude, longitude, bs = "gp", m = 2), family="betar")
sum_BF <- summary(gamBF_ll)
sum_BF$r.sq 
#0.8108829

#----# Create the new DF for 2100
nwd_BF100 <- data.frame(TMEAN30m=TMEANfut100m, PCP30m=PCPfut100m, DEMm=DEMm, latitude=latitude, longitude=longitude)

#----# Predict 2100
prdct_BF100 <- predict.gam(gamBF_ll, nwd_BF100, type="response")

#----# Convert the prediction to a new raster and resample it to the original extent and resolution
prdct_BF100m <- cbind.data.frame(as.matrix(as.data.frame(rasterToPoints(PCPfut100, spatial=TRUE)))[,2:3], prdct_BF100)
prdct_BF100r <- rasterFromXYZ(prdct_BF100m)
prdct_BF100r <- resample(prdct_BF100r, WS)


#----# Create the new DF for 2075
nwd_BF75 <- data.frame(TMEAN30m=TMEANfut75m, PCP30m=PCPfut75m, DEMm=DEMm, latitude=latitude, longitude=longitude)

#----# Predict 2050
prdct_BF75 <- predict.gam(gamBF_ll, nwd_BF75, type="response")

#----# Convert the prediction to a new raster and resample it to the original extent and resolution
prdct_BF75m <- cbind.data.frame(as.matrix(as.data.frame(rasterToPoints(PCPfut75, spatial=TRUE)))[,2:3], prdct_BF75)
prdct_BF75r <- rasterFromXYZ(prdct_BF75m)
prdct_BF75r <- resample(prdct_BF75r, WS)

#----# Create the new DF for 2050
nwd_BF50 <- data.frame(TMEAN30m=TMEANfut50m, PCP30m=PCPfut50m, DEMm=DEMm, latitude=latitude, longitude=longitude)

#----# Predict 2050
prdct_BF50 <- predict.gam(gamBF_ll, nwd_BF50, type="response")

#----# Convert the prediction to a new raster and resample it to the original extent and resolution
prdct_BF50m <- cbind.data.frame(as.matrix(as.data.frame(rasterToPoints(PCPfut50, spatial=TRUE)))[,2:3], prdct_BF50)
prdct_BF50r <- rasterFromXYZ(prdct_BF50m)
prdct_BF50r <- resample(prdct_BF50r, WS)

#----# Create the new DF for 2025
nwd_BF25 <- data.frame(TMEAN30m=TMEANfut25m, PCP30m=PCPfut25m, DEMm=DEMm, latitude=latitude, longitude=longitude)

#----# Predict 2025
prdct_BF25 <- predict.gam(gamBF_ll, nwd_BF25, type="response")

#----# Convert the prediction to a new raster and resample it to the original extent and resolution
prdct_BF25m <- cbind.data.frame(as.matrix(as.data.frame(rasterToPoints(PCPfut25, spatial=TRUE)))[,2:3], prdct_BF25)
prdct_BF25r <- rasterFromXYZ(prdct_BF25m)
prdct_BF25r <- resample(prdct_BF25r, WS)


#----# Define the font
windowsFonts(A=windowsFont("Times New Roman")) 

par(mfrow=c(2,3), mar=c(2,1,2,1))
plot(BF, axes=FALSE, legend.shrink=1, horizontal = TRUE, legend.args = list(text='Balsam fir', family="A", line=0.3))
plot(prdct_BF25r, axes=FALSE, legend.shrink=1, horizontal = TRUE, legend.args = list(text='2025 predicted Balsam fir', family="A", line=0.3))
plot(prdct_BF50r, axes=FALSE, legend.shrink=1, horizontal = TRUE, legend.args = list(text='2050 predicted Balsam fir', family="A", line=0.3))
plot(prdct_BF75r, axes=FALSE, legend.shrink=1, horizontal = TRUE, legend.args = list(text='2075 predicted Balsam fir', family="A", line=0.3))
plot(prdct_BF100r, axes=FALSE, legend.shrink=1, horizontal = TRUE, legend.args = list(text='2100 predicted Balsam fir', family="A", line=0.3))


writeRaster(prdct_BF25r, filename=paste(path2raster, "prdct_BF25r.grd", sep=""), overwrite=TRUE)
writeRaster(prdct_BF50r, filename=paste(path2raster, "prdct_BF50r.grd", sep=""), overwrite=TRUE)
writeRaster(prdct_BF75r, filename=paste(path2raster, "prdct_BF75r.grd", sep=""), overwrite=TRUE)
writeRaster(prdct_BF100r, filename=paste(path2raster, "prdct_BF100r.grd", sep=""), overwrite=TRUE)




###################################################################################################################################################################################################v
###################################################################################################################################################################################################v
###################################################################################################################################################################################################v
###################################################################################################################################################################################################v
#-----# BS
###################################################################################################################################################################################################v
###################################################################################################################################################################################################v
###################################################################################################################################################################################################v
library(rgdal)
library(raster)
library(RColorBrewer)
library(viridis)
library(glmmTMB)
library(mgcv)

#----# Path to the directory
path2raster <- "D:/Google Drive/hack/raster_files/"

#----# Read the data
BF <- raster(paste(path2raster, "BFrs.grd", sep=""))
WS <- raster(paste(path2raster, "WSrs.grd", sep=""))
BS <- raster(paste(path2raster, "BSrs.grd", sep=""))
DEM <- raster(paste(path2raster, "DEMrs.grd", sep=""))
WIND <- raster(paste(path2raster, "WINDrs.grd", sep=""))
TMAX30 <- raster(paste(path2raster, "TMAX30rs.grd", sep=""))
TMIN30 <- raster(paste(path2raster, "TMIN30rs.grd", sep=""))
TMEAN30 <- raster(paste(path2raster, "TMEAN30rs.grd", sep=""))
PCP30 <- raster(paste(path2raster, "PCP30rs.grd", sep=""))


PCPfut100 <- raster(paste(path2raster, "PCPfutrs.grd", sep=""))
TMEANfut100 <- raster(paste(path2raster, "TMEANfutrs.grd", sep=""))
TMINfut100 <- raster(paste(path2raster, "TMINfutrs.grd", sep=""))
TMAXfut100 <- raster(paste(path2raster, "TMAXfutrs.grd", sep=""))

PCPfut75 <- raster(paste(path2raster, "PCPfut75rs.grd", sep=""))
TMEANfut75 <- raster(paste(path2raster, "TMEANfut75rs.grd", sep=""))
TMINfut75 <- raster(paste(path2raster, "TMINfut75rs.grd", sep=""))
TMAXfut75 <- raster(paste(path2raster, "TMAXfut75rs.grd", sep=""))

PCPfut50 <- raster(paste(path2raster, "PCPfut50rs.grd", sep=""))
TMEANfut50 <- raster(paste(path2raster, "TMEANfut50rs.grd", sep=""))
TMINfut50 <- raster(paste(path2raster, "TMINfut50rs.grd", sep=""))
TMAXfut50 <- raster(paste(path2raster, "TMAXfut50rs.grd", sep=""))

PCPfut25 <- raster(paste(path2raster, "PCPfut25rs.grd", sep=""))
TMEANfut25 <- raster(paste(path2raster, "TMEANfut25rs.grd", sep=""))
TMINfut25 <- raster(paste(path2raster, "TMINfut25rs.grd", sep=""))
TMAXfut25 <- raster(paste(path2raster, "TMAXfut25rs.grd", sep=""))

#----# Put NA where no data
BS[is.na(TMAX30)] <- NA
TMAX30[is.na(BS)] <- NA
TMIN30[is.na(BS)] <- NA
TMEAN30[is.na(BS)] <- NA
PCP30[is.na(BS)] <- NA
DEM[is.na(BS)] <- NA

PCPfut100[is.na(BS)] <- NA
TMEANfut100[is.na(BS)] <- NA
TMINfut100[is.na(BS)] <- NA
TMAXfut100[is.na(BS)] <- NA

PCPfut75[is.na(BS)] <- NA
TMEANfut75[is.na(BS)] <- NA
TMINfut75[is.na(BS)] <- NA
TMAXfut75[is.na(BS)] <- NA

PCPfut50[is.na(BS)] <- NA
TMEANfut50[is.na(BS)] <- NA
TMINfut50[is.na(BS)] <- NA
TMAXfut50[is.na(BS)] <- NA

PCPfut25[is.na(BS)] <- NA
TMEANfut25[is.na(BS)] <- NA
TMINfut25[is.na(BS)] <- NA
TMAXfut25[is.na(BS)] <- NA

#----# Divide by 100 to get the proportion and not anymore the %
BS <- BS/100

#----# Convert it to matrix as needed by the gam function
BSm <- as.matrix(as.data.frame(rasterToPoints(BS, spatial=TRUE)))[,1]
TMAX30m <- as.matrix(as.data.frame(rasterToPoints(TMAX30, spatial=TRUE)))[,1]
PCP30m <- as.matrix(as.data.frame(rasterToPoints(PCP30, spatial=TRUE)))[,1]
TMIN30m <- as.matrix(as.data.frame(rasterToPoints(TMIN30, spatial=TRUE)))[,1]
TMEAN30m <- as.matrix(as.data.frame(rasterToPoints(TMEAN30, spatial=TRUE)))[,1]
DEMm <- as.matrix(as.data.frame(rasterToPoints(DEM, spatial=TRUE)))[,1]
longitude <- as.matrix(as.data.frame(rasterToPoints(BS, spatial=TRUE)))[,2]
latitude <- as.matrix(as.data.frame(rasterToPoints(BS, spatial=TRUE)))[,3]

PCPfut100m <- as.matrix(as.data.frame(rasterToPoints(PCPfut100, spatial=TRUE)))[,1]
TMEANfut100m <- as.matrix(as.data.frame(rasterToPoints(TMEANfut100, spatial=TRUE)))[,1]
TMINfut100m <- as.matrix(as.data.frame(rasterToPoints(TMINfut100, spatial=TRUE)))[,1]
TMAXfut100m <- as.matrix(as.data.frame(rasterToPoints(TMAXfut100, spatial=TRUE)))[,1]

PCPfut75m <- as.matrix(as.data.frame(rasterToPoints(PCPfut75, spatial=TRUE)))[,1]
TMEANfut75m <- as.matrix(as.data.frame(rasterToPoints(TMEANfut75, spatial=TRUE)))[,1]
TMINfut75m <- as.matrix(as.data.frame(rasterToPoints(TMINfut75, spatial=TRUE)))[,1]
TMAXfut75m <- as.matrix(as.data.frame(rasterToPoints(TMAXfut75, spatial=TRUE)))[,1]

PCPfut50m <- as.matrix(as.data.frame(rasterToPoints(PCPfut50, spatial=TRUE)))[,1]
TMEANfut50m <- as.matrix(as.data.frame(rasterToPoints(TMEANfut50, spatial=TRUE)))[,1]
TMINfut50m <- as.matrix(as.data.frame(rasterToPoints(TMINfut50, spatial=TRUE)))[,1]
TMAXfut50m <- as.matrix(as.data.frame(rasterToPoints(TMAXfut50, spatial=TRUE)))[,1]

PCPfut25m <- as.matrix(as.data.frame(rasterToPoints(PCPfut25, spatial=TRUE)))[,1]
TMEANfut25m <- as.matrix(as.data.frame(rasterToPoints(TMEANfut25, spatial=TRUE)))[,1]
TMINfut25m <- as.matrix(as.data.frame(rasterToPoints(TMINfut25, spatial=TRUE)))[,1]
TMAXfut25m <- as.matrix(as.data.frame(rasterToPoints(TMAXfut25, spatial=TRUE)))[,1]

#----# Check if there is the same number of pixel
sum(!is.na(as.matrix(TMAX30)))
sum(!is.na(as.matrix(TMIN30)))


############################
#----# GAM model

#gamBF <- gam(BFm ~ TMEAN30m + PCP30m + DEMm, family="betar")
#summary(gamBF)

gamBS_ll <- gam(BSm ~ TMEAN30m + PCP30m + DEMm + s(latitude, longitude, bs = "gp", m = 2), family="betar")
sum_BS <- summary(gamBS_ll)
sum_BS$r.sq 
# 0.5680788

#----# Create the new DF for 2100
nwd_BS100 <- data.frame(TMEAN30m=TMEANfut100m, PCP30m=PCPfut100m, DEMm=DEMm, latitude=latitude, longitude=longitude)

#----# Predict 2100
prdct_BS100 <- predict.gam(gamBS_ll, nwd_BS100, type="response")

#----# Convert the prediction to a new raster and resample it to the original extent and resolution
prdct_BS100m <- cbind.data.frame(as.matrix(as.data.frame(rasterToPoints(PCPfut100, spatial=TRUE)))[,2:3], prdct_BS100)
prdct_BS100r <- rasterFromXYZ(prdct_BS100m)
prdct_BS100r <- resample(prdct_BS100r, WS)


#----# Create the new DF for 2050
nwd_BS50 <- data.frame(TMEAN30m=TMEANfut50m, PCP30m=PCPfut50m, DEMm=DEMm, latitude=latitude, longitude=longitude)

#----# Predict 2050
prdct_BS50 <- predict.gam(gamBS_ll, nwd_BS50, type="response")

#----# Convert the prediction to a new raster and resample it to the original extent and resolution
prdct_BS50m <- cbind.data.frame(as.matrix(as.data.frame(rasterToPoints(PCPfut50, spatial=TRUE)))[,2:3], prdct_BS50)
prdct_BS50r <- rasterFromXYZ(prdct_BS50m)
prdct_BS50r <- resample(prdct_BS50r, WS)

#----# Create the new DF for 2075
nwd_BS75 <- data.frame(TMEAN30m=TMEANfut75m, PCP30m=PCPfut75m, DEMm=DEMm, latitude=latitude, longitude=longitude)

#----# Predict 2075
prdct_BS75 <- predict.gam(gamBS_ll, nwd_BS75, type="response")

#----# Convert the prediction to a new raster and resample it to the original extent and resolution
prdct_BS75m <- cbind.data.frame(as.matrix(as.data.frame(rasterToPoints(PCPfut75, spatial=TRUE)))[,2:3], prdct_BS75)
prdct_BS75r <- rasterFromXYZ(prdct_BS75m)
prdct_BS75r <- resample(prdct_BS75r, WS)

#----# Create the new DF for 2025
nwd_BS25 <- data.frame(TMEAN30m=TMEANfut25m, PCP30m=PCPfut25m, DEMm=DEMm, latitude=latitude, longitude=longitude)

#----# Predict 2075
prdct_BS25 <- predict.gam(gamBS_ll, nwd_BS25, type="response")

#----# Convert the prediction to a new raster and resample it to the original extent and resolution
prdct_BS25m <- cbind.data.frame(as.matrix(as.data.frame(rasterToPoints(PCPfut25, spatial=TRUE)))[,2:3], prdct_BS25)
prdct_BS25r <- rasterFromXYZ(prdct_BS25m)
prdct_BS25r <- resample(prdct_BS25r, WS)

#----# Define the font
windowsFonts(A=windowsFont("Times New Roman")) 

par(mfrow=c(2,3), mar=c(2,1,2,1))
plot(BS, axes=FALSE, legend.shrink=1, horizontal = TRUE, legend.args = list(text='Black spruce', family="A", line=0.4))
plot(prdct_BS25r, axes=FALSE, legend.shrink=1, horizontal = TRUE, legend.args = list(text='2025 predicted Black spruce', family="A", line=0.4))
plot(prdct_BS50r, axes=FALSE, legend.shrink=1, horizontal = TRUE, legend.args = list(text='2050 predicted Black spruce', family="A", line=0.4))
plot(prdct_BS75r, axes=FALSE, legend.shrink=1, horizontal = TRUE, legend.args = list(text='2075 predicted Black spruce', family="A", line=0.4))
plot(prdct_BS100r, axes=FALSE, legend.shrink=1, horizontal = TRUE, legend.args = list(text='2100 predicted Black spruce', family="A", line=0.4))


writeRaster(prdct_BS25r, filename=paste(path2raster, "prdct_BS25r.grd", sep=""), overwrite=TRUE)
writeRaster(prdct_BS50r, filename=paste(path2raster, "prdct_BS50r.grd", sep=""), overwrite=TRUE)
writeRaster(prdct_BS75r, filename=paste(path2raster, "prdct_BS75r.grd", sep=""), overwrite=TRUE)
writeRaster(prdct_BS100r, filename=paste(path2raster, "prdct_BS100r.grd", sep=""), overwrite=TRUE)



###################################################################################################################################################################################################v
###################################################################################################################################################################################################v
###################################################################################################################################################################################################v
###################################################################################################################################################################################################v
#-----# WS
###################################################################################################################################################################################################v
###################################################################################################################################################################################################v
###################################################################################################################################################################################################v

library(rgdal)
library(raster)
library(RColorBrewer)
library(viridis)
library(glmmTMB)
library(mgcv)

#----# Path to the directory
path2raster <- "D:/Google Drive/hack/raster_files/"

#----# Read the data
BF <- raster(paste(path2raster, "BFrs.grd", sep=""))
WS <- raster(paste(path2raster, "WSrs.grd", sep=""))
BS <- raster(paste(path2raster, "BSrs.grd", sep=""))
DEM <- raster(paste(path2raster, "DEMrs.grd", sep=""))
WIND <- raster(paste(path2raster, "WINDrs.grd", sep=""))
TMAX30 <- raster(paste(path2raster, "TMAX30rs.grd", sep=""))
TMIN30 <- raster(paste(path2raster, "TMIN30rs.grd", sep=""))
TMEAN30 <- raster(paste(path2raster, "TMEAN30rs.grd", sep=""))
PCP30 <- raster(paste(path2raster, "PCP30rs.grd", sep=""))


PCPfut100 <- raster(paste(path2raster, "PCPfutrs.grd", sep=""))
TMEANfut100 <- raster(paste(path2raster, "TMEANfutrs.grd", sep=""))
TMINfut100 <- raster(paste(path2raster, "TMINfutrs.grd", sep=""))
TMAXfut100 <- raster(paste(path2raster, "TMAXfutrs.grd", sep=""))

PCPfut75 <- raster(paste(path2raster, "PCPfut75rs.grd", sep=""))
TMEANfut75 <- raster(paste(path2raster, "TMEANfut75rs.grd", sep=""))
TMINfut75 <- raster(paste(path2raster, "TMINfut75rs.grd", sep=""))
TMAXfut75 <- raster(paste(path2raster, "TMAXfut75rs.grd", sep=""))

PCPfut50 <- raster(paste(path2raster, "PCPfut50rs.grd", sep=""))
TMEANfut50 <- raster(paste(path2raster, "TMEANfut50rs.grd", sep=""))
TMINfut50 <- raster(paste(path2raster, "TMINfut50rs.grd", sep=""))
TMAXfut50 <- raster(paste(path2raster, "TMAXfut50rs.grd", sep=""))

PCPfut25 <- raster(paste(path2raster, "PCPfut25rs.grd", sep=""))
TMEANfut25 <- raster(paste(path2raster, "TMEANfut25rs.grd", sep=""))
TMINfut25 <- raster(paste(path2raster, "TMINfut25rs.grd", sep=""))
TMAXfut25 <- raster(paste(path2raster, "TMAXfut25rs.grd", sep=""))

#----# Put NA where no data
WS[is.na(TMAX30)] <- NA
TMAX30[is.na(WS)] <- NA
TMIN30[is.na(WS)] <- NA
TMEAN30[is.na(WS)] <- NA
PCP30[is.na(WS)] <- NA
DEM[is.na(WS)] <- NA

PCPfut100[is.na(WS)] <- NA
TMEANfut100[is.na(WS)] <- NA
TMINfut100[is.na(WS)] <- NA
TMAXfut100[is.na(WS)] <- NA

PCPfut75[is.na(WS)] <- NA
TMEANfut75[is.na(WS)] <- NA
TMINfut75[is.na(WS)] <- NA
TMAXfut75[is.na(WS)] <- NA

PCPfut50[is.na(WS)] <- NA
TMEANfut50[is.na(WS)] <- NA
TMINfut50[is.na(WS)] <- NA
TMAXfut50[is.na(WS)] <- NA

PCPfut25[is.na(WS)] <- NA
TMEANfut25[is.na(WS)] <- NA
TMINfut25[is.na(WS)] <- NA
TMAXfut25[is.na(WS)] <- NA

#----# Divide by 100 to get the proportion and not anymore the %
WS <- WS/100

#----# Convert it to matrix as needed by the gam function
WSm <- as.matrix(as.data.frame(rasterToPoints(WS, spatial=TRUE)))[,1]
TMAX30m <- as.matrix(as.data.frame(rasterToPoints(TMAX30, spatial=TRUE)))[,1]
PCP30m <- as.matrix(as.data.frame(rasterToPoints(PCP30, spatial=TRUE)))[,1]
TMIN30m <- as.matrix(as.data.frame(rasterToPoints(TMIN30, spatial=TRUE)))[,1]
TMEAN30m <- as.matrix(as.data.frame(rasterToPoints(TMEAN30, spatial=TRUE)))[,1]
DEMm <- as.matrix(as.data.frame(rasterToPoints(DEM, spatial=TRUE)))[,1]
longitude <- as.matrix(as.data.frame(rasterToPoints(WS, spatial=TRUE)))[,2]
latitude <- as.matrix(as.data.frame(rasterToPoints(WS, spatial=TRUE)))[,3]

PCPfut100m <- as.matrix(as.data.frame(rasterToPoints(PCPfut100, spatial=TRUE)))[,1]
TMEANfut100m <- as.matrix(as.data.frame(rasterToPoints(TMEANfut100, spatial=TRUE)))[,1]
TMINfut100m <- as.matrix(as.data.frame(rasterToPoints(TMINfut100, spatial=TRUE)))[,1]
TMAXfut100m <- as.matrix(as.data.frame(rasterToPoints(TMAXfut100, spatial=TRUE)))[,1]

PCPfut75m <- as.matrix(as.data.frame(rasterToPoints(PCPfut75, spatial=TRUE)))[,1]
TMEANfut75m <- as.matrix(as.data.frame(rasterToPoints(TMEANfut75, spatial=TRUE)))[,1]
TMINfut75m <- as.matrix(as.data.frame(rasterToPoints(TMINfut75, spatial=TRUE)))[,1]
TMAXfut75m <- as.matrix(as.data.frame(rasterToPoints(TMAXfut75, spatial=TRUE)))[,1]

PCPfut50m <- as.matrix(as.data.frame(rasterToPoints(PCPfut50, spatial=TRUE)))[,1]
TMEANfut50m <- as.matrix(as.data.frame(rasterToPoints(TMEANfut50, spatial=TRUE)))[,1]
TMINfut50m <- as.matrix(as.data.frame(rasterToPoints(TMINfut50, spatial=TRUE)))[,1]
TMAXfut50m <- as.matrix(as.data.frame(rasterToPoints(TMAXfut50, spatial=TRUE)))[,1]

PCPfut25m <- as.matrix(as.data.frame(rasterToPoints(PCPfut25, spatial=TRUE)))[,1]
TMEANfut25m <- as.matrix(as.data.frame(rasterToPoints(TMEANfut25, spatial=TRUE)))[,1]
TMINfut25m <- as.matrix(as.data.frame(rasterToPoints(TMINfut25, spatial=TRUE)))[,1]
TMAXfut25m <- as.matrix(as.data.frame(rasterToPoints(TMAXfut25, spatial=TRUE)))[,1]

#----# Check if there is the same number of pixel
sum(!is.na(as.matrix(TMAX30)))
sum(!is.na(as.matrix(TMIN30)))


############################
#----# GAM model

#gamBF <- gam(BFm ~ TMEAN30m + PCP30m + DEMm, family="betar")
#summary(gamBF)

gamWS_ll <- gam(WSm ~ TMEAN30m + PCP30m + DEMm + s(latitude, longitude, bs = "gp", m = 2), family="betar")
sum_WS <- summary(gamWS_ll)
sum_WS$r.sq 
#0.8108829

#----# Create the new DF for 2100
nwd_WS100 <- data.frame(TMEAN30m=TMEANfut100m, PCP30m=PCPfut100m, DEMm=DEMm, latitude=latitude, longitude=longitude)

#----# Predict 2100
prdct_WS100 <- predict.gam(gamWS_ll, nwd_WS100, type="response")

#----# Convert the prediction to a new raster and resample it to the original extent and resolution
prdct_WS100m <- cbind.data.frame(as.matrix(as.data.frame(rasterToPoints(PCPfut100, spatial=TRUE)))[,2:3], prdct_WS100)
prdct_WS100r <- rasterFromXYZ(prdct_WS100m)
prdct_WS100r <- resample(prdct_WS100r, WS)


#----# Create the new DF for 2050
nwd_WS50 <- data.frame(TMEAN30m=TMEANfut50m, PCP30m=PCPfut50m, DEMm=DEMm, latitude=latitude, longitude=longitude)

#----# Predict 2050
prdct_WS50 <- predict.gam(gamWS_ll, nwd_WS50, type="response")

#----# Convert the prediction to a new raster and resample it to the original extent and resolution
prdct_WS50m <- cbind.data.frame(as.matrix(as.data.frame(rasterToPoints(PCPfut50, spatial=TRUE)))[,2:3], prdct_WS50)
prdct_WS50r <- rasterFromXYZ(prdct_WS50m)
prdct_WS50r <- resample(prdct_WS50r, WS)

#----# Create the new DF for 2075
nwd_WS75 <- data.frame(TMEAN30m=TMEANfut75m, PCP30m=PCPfut75m, DEMm=DEMm, latitude=latitude, longitude=longitude)

#----# Predict 2075
prdct_WS75 <- predict.gam(gamWS_ll, nwd_WS75, type="response")

#----# Convert the prediction to a new raster and resample it to the original extent and resolution
prdct_WS75m <- cbind.data.frame(as.matrix(as.data.frame(rasterToPoints(PCPfut75, spatial=TRUE)))[,2:3], prdct_WS75)
prdct_WS75r <- rasterFromXYZ(prdct_WS75m)
prdct_WS75r <- resample(prdct_WS75r, WS)

#----# Create the new DF for 2025
nwd_WS25 <- data.frame(TMEAN30m=TMEANfut25m, PCP30m=PCPfut25m, DEMm=DEMm, latitude=latitude, longitude=longitude)

#----# Predict 2025
prdct_WS25 <- predict.gam(gamWS_ll, nwd_WS25, type="response")

#----# Convert the prediction to a new raster and resample it to the original extent and resolution
prdct_WS25m <- cbind.data.frame(as.matrix(as.data.frame(rasterToPoints(PCPfut25, spatial=TRUE)))[,2:3], prdct_WS25)
prdct_WS25r <- rasterFromXYZ(prdct_WS25m)
prdct_WS25r <- resample(prdct_WS25r, WS)

#----# Define the font
windowsFonts(A=windowsFont("Times New Roman")) 

mx <- max(maxValue(WS), maxValue(prdct_WS25r), maxValue(prdct_WS50r), maxValue(prdct_WS75r), maxValue(prdct_WS100r))
mn <- min(minValue(TMEAN), minValue(TMEAN25), minValue(TMEAN50), minValue(TMEAN75), minValue(TMEAN100))

par(mfrow=c(2,3), mar=c(2,1,2,1))
plot(WS, axes=FALSE, legend.shrink=1, horizontal = TRUE, legend.args = list(text='White spruce', family="A", line=0.4))
plot(prdct_WS25r, axes=FALSE, legend.shrink=1, horizontal = TRUE, legend.args = list(text='2025 predicted White spruce', family="A", line=0.4))
plot(prdct_WS50r, axes=FALSE, legend.shrink=1, horizontal = TRUE, legend.args = list(text='2050 predicted White spruce', family="A", line=0.4))
plot(prdct_WS75r, axes=FALSE, legend.shrink=1, horizontal = TRUE, legend.args = list(text='2075 predicted White spruce', family="A", line=0.4))
plot(prdct_WS100r, axes=FALSE, legend.shrink=1, horizontal = TRUE, legend.args = list(text='2100 predicted White spruce', family="A", line=0.4))


writeRaster(prdct_WS25r, filename=paste(path2raster, "prdct_WS25r.grd", sep=""), overwrite=TRUE)
writeRaster(prdct_WS50r, filename=paste(path2raster, "prdct_WS50r.grd", sep=""), overwrite=TRUE)
writeRaster(prdct_WS75r, filename=paste(path2raster, "prdct_WS75r.grd", sep=""), overwrite=TRUE)
writeRaster(prdct_WS100r, filename=paste(path2raster, "prdct_WS100r.grd", sep=""), overwrite=TRUE)

