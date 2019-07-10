library(rgdal)
library(raster)
library(ncdf4)
library(RColorBrewer)
library(elevatr)
library(ncdf4)
library(rWind)

#####################################################################################################################3
#####################################################################################################################3
########################## Download and read the environmental data automatically and interactively

r2 <- raster(xmn=-3725282,xmx=3523918,ymn=5634935,ymx=10644495, res=20000, crs="+proj=lcc +lat_1=49 +lat_2=77 +lat_0=0 +lon_0=-95 +x_0=0 +y_0=0
+datum=NAD83 +units=m +no_defs +ellps=GRS80 +towgs84=0,0,0")

variables <- character(0)
more <- "Y"
while (more == "Y"){
  variable <- readline(prompt="Which environmental variable do you want?
                     (enter one among: TMAX, TMIN, TMEAN, PCP, DEM, WIND)")
  variables <- c(variables, variable)
  more <- readline(prompt="Do you want another variable? (Y/N)")
}

msceccc <- c("TMAX", "TMIN", "TMEAN", "PCP")
match <- msceccc[msceccc %in% variables]
if (length(match)>0){
  for (i in 1:length(match)){
    download.file(paste("http://dd.weather.gc.ca/climate/dcs/netcdf/historical/annual/absolute/DCS_hist_annual_abs_latlon0.086x0.086_",
                        match[i],"_pctl50_P1Y.nc", sep=""), paste(match[i],".nc",sep=""), mode="wb")
    assign(paste(match[i]),stack(paste(match[i],".nc",sep="")))
  }
}

if ("DEM" %in% variables){
  DEM <- get_elev_raster(PCP, z = 6)
  DEM2 <- projectRaster(DEM, crs = crs(r2))
  DEM3 <- resample(DEM2, r2)
  DEM <- DEM
}

if ("WIND" %in% variables){
year <- readline(prompt="Pick a year (yyyy)  ")
month <- readline(prompt="Pick a month (mm)  ")

WIND_tot <- stack()

for (i in 1:28) {

  wind <- wind.dl(as.numeric(year), as.numeric(month), i, 12,  extent(PCP)[1], extent(PCP)[2], extent(PCP)[3], extent(PCP)[4], type = "read-data", trace = 1)
  wind <- wind2raster(wind)[[2]] 
  
  WIND_tot <- stack(WIND_tot, wind)
}  

WIND_mean <- mean(WIND_tot)
WIND <- projectRaster(WIND_mean, crs = crs(r2))
}

#----# Read the species data
# We could easily bring more species data from the OGSL, GBIF, OBIS, ... with more time
# We used the data available on open.canada from the national forest inventory.

speciess <- character(0)
more <- "Y"
while (more == "Y"){
species <- readline(prompt="What is the scientific name of the tree species that interests you?  ")
  speciess <- c(speciess, species)
  more <- readline(prompt="Do you want another species? (Y/N)  ")
}

simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
        sep="", collapse=" ")
}

for (i in 1:length(speciess)){
  upspecies <- simpleCap(speciess[i])
#  substr(strsplit(upspecies, " ")[[1]][1], 1, 4)
#  substr(strsplit(upspecies, " ")[[1]][2], 1, 4)
  download.file(paste("http://ftp.maps.canada.ca/pub/nrcan_rncan/Forests_Foret/canada-forests-attributes_attributs-forests-canada/2011-attributes_attributs-2011/NFI_MODIS250m_2011_kNN_Species_", substr(strsplit(upspecies, " ")[[1]][1], 1, 4),
                      "_", substr(strsplit(upspecies, " ")[[1]][2], 1, 3), "_v1.tif", sep=""),
                paste(paste(substr(strsplit(upspecies, " ")[[1]][1], 1, 4),
                            "_", substr(strsplit(upspecies, " ")[[1]][2], 1, 3), sep=""),".tif", sep=""), mode="wb")
  assign(paste(substr(strsplit(upspecies, " ")[[1]][1], 1, 4),
               "_", substr(strsplit(upspecies, " ")[[1]][2], 1, 3), sep=""),
         raster(paste(paste(substr(strsplit(upspecies, " ")[[1]][1], 1, 4),
                            "_", substr(strsplit(upspecies, " ")[[1]][2], 1, 3), sep=""),".tif",sep="")))
}



                   
                   
                   