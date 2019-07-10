library(rgdal)
library(raster)
library(RColorBrewer)
library(viridis) 



load("data_hack.RData")
PCP   <- stack("DCS_hist_annual_abs_latlon0.086x0.086_PCP_pctl50_P1Y.nc")
TMax  <- stack("DCS_hist_annual_abs_latlon0.086x0.086_TMAX_pctl50_P1Y.nc")
TMean <- stack("DCS_hist_annual_abs_latlon0.086x0.086_TMEAN_pctl50_P1Y.nc")
TMin  <- stack("DCS_hist_annual_abs_latlon0.086x0.086_TMIN_pctl50_P1Y.nc")


PCPresampled <- projectRaster(PCP,BF,method = 'ngb')

# 
# plot(BF, col = "black")
# image(BS, add = TRUE, col=rev(terrain.colors(100)))
#windowsFonts(A=windowsFont("Times New Roman")) 
plot(TMIN30, col=brewer.pal(n = 8, name = "Blues"), axes=FALSE, legend.shrink=1, box=FALSE,
      legend.args = list( text='Temp min (\u00B0C)', side =2 ))



plot(BS, axes=FALSE, legend.shrink=1, add = TRUE, horizontal = TRUE, box=FALSE,
      legend.args = list(text='Black spruce (%)', side =3), alpha = 0.5)
