library(rgdal)
library(raster)


#####################################################################################################################3
#####################################################################################################################3
### Process the downloaded data

#----# Average the last 30 years of the environmental data
PCP30 <- mean(PCP[[25:55]])
PCP30 <- projectRaster(PCP30, crs = crs(r2))
TMAX30 <- mean(TMAX[[25:55]])
TMAX30 <- projectRaster(TMAX30, crs = crs(r2))
TMEAN30 <- mean(TMEAN[[25:55]])
TMEAN30 <- projectRaster(TMEAN30, crs = crs(r2))
TMIN30 <- mean(TMIN[[25:55]])
TMIN30 <- projectRaster(TMIN30, crs = crs(r2))

#----# Aggregate the data to match the resolution between species and environmental data
#BF2 <- resample(BF, PCP30)
#WS2 <- resample(WS, PCP30)
#BS2 <- resample(BS, PCP30)

#----# Save them 
#writeRaster(BF2, filename=paste(path2raster, "BF.grd", sep=""))
#writeRaster(WS2, filename=paste(path2raster, "WS.grd", sep=""))
#writeRaster(BS2, filename=paste(path2raster, "BS.grd", sep=""))

#----# Read the species data again (save time because the resolution is lower)
BF <- raster(paste(path2raster, "BF.grd", sep=""))
WS <- raster(paste(path2raster, "WS.grd", sep=""))
BS <- raster(paste(path2raster, "BS.grd", sep=""))
DEM <- raster(paste(path2raster, "DEM.grd", sep=""))


#----# Resample the data to match the lowest resolution
r1 <- raster(extent(BF),res=20000, crs=crs(BF))

BFrs <- resample(BF, r1)
WSrs <- resample(WS, r1)
BSrs <- resample(BS, r1)

PCP30rs <- resample(PCP30, r1)
TMAX30rs <- resample(TMAX30, r1)
TMEAN30rs <- resample(TMEAN30, r1)
TMIN30rs <- resample(TMIN30, r1)

DEMrs <- resample(DEM, r1)
WINDrs <- resample(WIND, r1)


writeRaster(BFrs, filename=paste(path2raster, "BFrs.grd", sep=""), overwrite=TRUE)
writeRaster(WSrs, filename=paste(path2raster, "WSrs.grd", sep=""), overwrite=TRUE)
writeRaster(BSrs, filename=paste(path2raster, "BSrs.grd", sep=""), overwrite=TRUE)
writeRaster(PCP30rs, filename=paste(path2raster, "PCP30rs.grd", sep=""), overwrite=TRUE)
writeRaster(TMAX30rs, filename=paste(path2raster, "TMAX30rs.grd", sep=""), overwrite=TRUE)
writeRaster(TMEAN30rs, filename=paste(path2raster, "TMEAN30rs.grd", sep=""), overwrite=TRUE)
writeRaster(TMIN30rs, filename=paste(path2raster, "TMIN30rs.grd", sep=""), overwrite=TRUE)
writeRaster(DEMrs, filename=paste(path2raster, "DEMrs.grd", sep=""), overwrite=TRUE)
writeRaster(WINDrs, filename=paste(path2raster, "WINDrs.grd", sep=""), overwrite=TRUE)



##################################################################################################################
#----# Futur 

#----# Aggregate the data to match the lowest resolution
BF <- raster(paste(path2raster, "BF.grd", sep=""))
r1 <- raster(extent(BF),res=20000, crs=crs(BF))

#----# For 2100
					TMINfut <- stack(paste(path2raster, "DCS_rcp4.5_annual_abs_latlon0.086x0.086_TMIN_pctl50_P1Y.nc", sep=""))[[95]]
                   TMINfut <- projectRaster(TMINfut, crs = crs(BF))
                   TMEANfut <- stack(paste(path2raster, "DCS_rcp4.5_annual_abs_latlon0.086x0.086_TMEAN_pctl50_P1Y.nc", sep=""))[[95]]
                   TMEANfut <- projectRaster(TMEANfut, crs = crs(BF))
                   TMAXfut <- stack(paste(path2raster, "DCS_rcp4.5_annual_abs_latlon0.086x0.086_TMAX_pctl50_P1Y.nc", sep=""))[[95]]
                   TMAXfut <- projectRaster(TMAXfut, crs = crs(BF))
                   PCPfut <- stack(paste(path2raster, "DCS_rcp4.5_annual_abs_latlon0.086x0.086_PCP_pctl50_P1Y.nc", sep=""))[[95]]
                   PCPfut <- projectRaster(PCPfut, crs = crs(BF))
                   
                   TMINfutrs <- resample(TMINfut, r1)
                   TMEANfutrs <- resample(TMEANfut, r1)
                   TMAXfutrs <- resample(TMAXfut, r1)
                   PCPfutrs <- resample(PCPfut, r1)
                   
                   writeRaster(PCPfutrs, filename=paste(path2raster, "PCPfutrs.grd", sep=""), overwrite=TRUE)
                   writeRaster(TMAXfutrs, filename=paste(path2raster, "TMAXfutrs.grd", sep=""), overwrite=TRUE)
                   writeRaster(TMEANfutrs, filename=paste(path2raster, "TMEANfutrs.grd", sep=""), overwrite=TRUE)
                   writeRaster(TMINfutrs, filename=paste(path2raster, "TMINfutrs.grd", sep=""), overwrite=TRUE)
                   
                   #----# For 2050
                   TMINfut50 <- stack(paste(path2raster, "DCS_rcp4.5_annual_abs_latlon0.086x0.086_TMIN_pctl50_P1Y.nc", sep=""))[[45]]
                   TMINfut50 <- projectRaster(TMINfut50, crs = crs(BF))
                   TMEANfut50 <- stack(paste(path2raster, "DCS_rcp4.5_annual_abs_latlon0.086x0.086_TMEAN_pctl50_P1Y.nc", sep=""))[[45]]
                   TMEANfut50 <- projectRaster(TMEANfut50, crs = crs(BF))
                   TMAXfut50 <- stack(paste(path2raster, "DCS_rcp4.5_annual_abs_latlon0.086x0.086_TMAX_pctl50_P1Y.nc", sep=""))[[45]]
                   TMAXfut50 <- projectRaster(TMAXfut50, crs = crs(BF))
                   PCPfut50 <- stack(paste(path2raster, "DCS_rcp4.5_annual_abs_latlon0.086x0.086_PCP_pctl50_P1Y.nc", sep=""))[[45]]
                   PCPfut50 <- projectRaster(PCPfut50, crs = crs(BF))
                   
                   TMINfut50rs <- resample(TMINfut50, r1)
                   TMEANfut50rs <- resample(TMEANfut50, r1)
                   TMAXfut50rs <- resample(TMAXfut50, r1)
                   PCPfut50rs <- resample(PCPfut50, r1)
                   
                   writeRaster(PCPfut50rs, filename=paste(path2raster, "PCPfut50rs.grd", sep=""), overwrite=TRUE)
                   writeRaster(TMAXfut50rs, filename=paste(path2raster, "TMAXfut50rs.grd", sep=""), overwrite=TRUE)
                   writeRaster(TMEANfut50rs, filename=paste(path2raster, "TMEANfut50rs.grd", sep=""), overwrite=TRUE)
                   writeRaster(TMINfut50rs, filename=paste(path2raster, "TMINfut50rs.grd", sep=""), overwrite=TRUE)
                   
                   #----# For 2025
                   TMINfut25 <- stack(paste(path2raster, "DCS_rcp4.5_annual_abs_latlon0.086x0.086_TMIN_pctl50_P1Y.nc", sep=""))[[20]]
                   TMINfut25 <- projectRaster(TMINfut25, crs = crs(BF))
                   TMEANfut25 <- stack(paste(path2raster, "DCS_rcp4.5_annual_abs_latlon0.086x0.086_TMEAN_pctl50_P1Y.nc", sep=""))[[20]]
                   TMEANfut25 <- projectRaster(TMEANfut25, crs = crs(BF))
                   TMAXfut25 <- stack(paste(path2raster, "DCS_rcp4.5_annual_abs_latlon0.086x0.086_TMAX_pctl50_P1Y.nc", sep=""))[[20]]
                   TMAXfut25 <- projectRaster(TMAXfut25, crs = crs(BF))
                   PCPfut25 <- stack(paste(path2raster, "DCS_rcp4.5_annual_abs_latlon0.086x0.086_PCP_pctl50_P1Y.nc", sep=""))[[20]]
                   PCPfut25 <- projectRaster(PCPfut25, crs = crs(BF))
                   
                   TMINfut25rs <- resample(TMINfut25, r1)
                   TMEANfut25rs <- resample(TMEANfut25, r1)
                   TMAXfut25rs <- resample(TMAXfut25, r1)
                   PCPfut25rs <- resample(PCPfut25, r1)
                   
                   writeRaster(PCPfut25rs, filename=paste(path2raster, "PCPfut25rs.grd", sep=""), overwrite=TRUE)
                   writeRaster(TMAXfut25rs, filename=paste(path2raster, "TMAXfut25rs.grd", sep=""), overwrite=TRUE)
                   writeRaster(TMEANfut25rs, filename=paste(path2raster, "TMEANfut25rs.grd", sep=""), overwrite=TRUE)
                   writeRaster(TMINfut25rs, filename=paste(path2raster, "TMINfut25rs.grd", sep=""), overwrite=TRUE)
                   
                   #----# For 2075
                   TMINfut75 <- stack(paste(path2raster, "DCS_rcp4.5_annual_abs_latlon0.086x0.086_TMIN_pctl50_P1Y.nc", sep=""))[[70]]
                   TMINfut75 <- projectRaster(TMINfut75, crs = crs(BF))
                   TMEANfut75 <- stack(paste(path2raster, "DCS_rcp4.5_annual_abs_latlon0.086x0.086_TMEAN_pctl50_P1Y.nc", sep=""))[[70]]
                   TMEANfut75 <- projectRaster(TMEANfut75, crs = crs(BF))
                   TMAXfut75 <- stack(paste(path2raster, "DCS_rcp4.5_annual_abs_latlon0.086x0.086_TMAX_pctl50_P1Y.nc", sep=""))[[70]]
                   TMAXfut75 <- projectRaster(TMAXfut75, crs = crs(BF))
                   PCPfut75 <- stack(paste(path2raster, "DCS_rcp4.5_annual_abs_latlon0.086x0.086_PCP_pctl50_P1Y.nc", sep=""))[[70]]
                   PCPfut75 <- projectRaster(PCPfut75, crs = crs(BF))
                   
                   TMINfut75rs <- resample(TMINfut75, r1)
                   TMEANfut75rs <- resample(TMEANfut75, r1)
                   TMAXfut75rs <- resample(TMAXfut75, r1)
                   PCPfut75rs <- resample(PCPfut75, r1)
                   
                   writeRaster(PCPfut75rs, filename=paste(path2raster, "PCPfut75rs.grd", sep=""), overwrite=TRUE)
                   writeRaster(TMAXfut75rs, filename=paste(path2raster, "TMAXfut75rs.grd", sep=""), overwrite=TRUE)
                   writeRaster(TMEANfut75rs, filename=paste(path2raster, "TMEANfut75rs.grd", sep=""), overwrite=TRUE)
                   writeRaster(TMINfut75rs, filename=paste(path2raster, "TMINfut75rs.grd", sep=""), overwrite=TRUE)
                   