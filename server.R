library(shiny)
library(datasets)
library(raster)
library(rgdal)
library(raster)
library(RColorBrewer)
library(viridis) 
library(glmmTMB)
library(mgcv)

species_list <- list( Black_Fir = "BF", 
                      Black_Spruce = "BS",
                      White_Spruce = "WS"
                      )

climat_list <- list( Precipitation = "PCP30",
                     Mean_temperature = "TMEAN30",
                     Max_temperature = "TMAX30",
                     Min_temperature = "TMIN30"
                     )


load("data_hack.RData")
# PCP   <- stack("DCS_hist_annual_abs_latlon0.086x0.086_PCP_pctl50_P1Y.nc")
# TMax  <- stack("DCS_hist_annual_abs_latlon0.086x0.086_TMAX_pctl50_P1Y.nc")
# TMean <- stack("DCS_hist_annual_abs_latlon0.086x0.086_TMEAN_pctl50_P1Y.nc")
# TMin  <- stack("DCS_hist_annual_abs_latlon0.086x0.086_TMIN_pctl50_P1Y.nc")



shinyServer(function(input, output) {
  
  #head in the main panel for raster
  
  output$dataname <- renderText({
    paste("Image of ", input$species, "combined with ", input$climat, "in ", input$year)
    
  })
  
  
  # image in the sidePanel
  output$myImage <- renderImage({
    # When input$n is 3, filename is ./images/image3.jpeg
    filename <- paste(input$species, ".jpg", sep = "")
    
    # Return a list containing the filename and alt text
    list(src = filename,
         width = 150,
         height = 150,
         alt = paste("Image number", input$species)
         )
    
  }, deleteFile = FALSE)
  
  
  
  # Plot in the mainPanel
  # top plot: altitude + distribution
  output$plot <- renderPlot(
    
    width = "auto", height = "auto",
    
    {
  
    y <- input$year - 1950
    #### DEM is the static lattitude raster
    img_lat <- DEM
    #plot(img_year[[y]])
    plot(img_lat)
    
    #s <- input$species
    img_species <- get(input$species)
    
    trans <- input$transparency

    #windowsFonts(A=windowsFont("Times New Roman")) 
    
    plot(img_lat, col=brewer.pal(n = 8, name = "Blues"), axes=FALSE, legend.shrink=1, box = FALSE,
         horizontal = FALSE, legend.args = list(text= "Altitude", side = 2))
    
    
    plot(img_species, axes=FALSE, legend.shrink=1, box = FALSE,
         horizontal = TRUE, legend.args = list(text= input$species, side = 3 ), 
         alpha=trans, add = TRUE)
  })
  
  
  #second plot: PCP + TMEAN
  output$plot1 <- renderPlot(
    
    width = "auto", height = 300,
    
    {
    
    par(mfrow=c(1,2), mar=c(0,3,3,0))
    
    y <- input$year - 1950
    #### DEM is the static lattitude raster
    img_pcp <- PCP30
    img_tmean <- TMEAN30
    
    
    #windowsFonts(A=windowsFont("Times New Roman")) 
    
    plot(img_pcp, col=brewer.pal(n = 8, name = "Blues"), axes=FALSE, legend.shrink=1, box = FALSE,
         horizontal = TRUE, legend.args = list(text= "precipitation", side = 3))
    
    
    plot(img_tmean, axes=FALSE, legend.shrink=1, box = FALSE,
         horizontal = TRUE, legend.args = list(text= "Mean Temperature", side = 3 ))
  })
  
  
  # #"Quit" button
  # observeEvent(input$done, {
  #   stopApp()
  # })
  # 
  
  
})