library(shiny)
library(datasets)
library(raster)
library(rgdal)
library(raster)
library(RColorBrewer)
library(viridis) 
library(glmmTMB)
library(mgcv)

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
         width = 80,
         height = 80,
         alt = paste("Image number", input$species))
    
  }, deleteFile = FALSE)
  
  
  
  # Plot in the mainPanel 
  output$plot <- renderPlot({
    
  
    
    y <- input$year - 1950
    img_year <- get(input$climat)
    #plot(img_year[[y]])
    plot(img_year)
    
    s <- input$species
    img_species <- get(input$species)
    
    trans <- input$transparency

    #windowsFonts(A=windowsFont("Times New Roman")) 
    
    plot(img_year, col=brewer.pal(n = 8, name = "Blues"), axes=FALSE, legend.shrink=1, box = FALSE,
         horizontal = FALSE, legend.args = list(text= input$climat, side = 2))
    
    
    plot(img_species, axes=FALSE, legend.shrink=1, box = FALSE,
         horizontal = TRUE, legend.args = list(text= input$species, side = 3 ), 
         alpha=trans, add = TRUE)
  })
  
  
  
  # #"Quit" button
  # observeEvent(input$done, {
  #   stopApp()
  # })
  # 
  
  
})