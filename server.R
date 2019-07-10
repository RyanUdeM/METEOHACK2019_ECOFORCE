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
load("rasters_final.RData")

BF <- BF/100
BS <- BS/100
WS <- WS/100


Balsam_Fir <- stack(BF, BF25, BF50, BF75, BF100)
Black_Spruce <- stack(BS, BS25, BS50, BS75, BS100)
White_Spruce <- stack(WS, WS25, WS50, WS75, WS100)
PCP <- stack(PCP, PCP25, PCP50, PCP75, PCP100)
TMEAN <- stack(TMEAN, TMEAN25, TMEAN50, TMEAN75, TMEAN100 )

#prepare data to standarlize color gradien of the plots
TMEANmx <- round(max(maxValue(TMEAN), maxValue(TMEAN25), maxValue(TMEAN50), 
               maxValue(TMEAN75), maxValue(TMEAN100)),digits = 0)
TMEANmn <- round(min(minValue(TMEAN), minValue(TMEAN25), minValue(TMEAN50), 
               minValue(TMEAN75), minValue(TMEAN100)), digits = 0)

PCPmx <- round( max(maxValue(PCP), maxValue(PCP25), maxValue(PCP50), 
               maxValue(PCP75), maxValue(PCP100)) , digits = 0)
PCPmn <- round( min(minValue(PCP), minValue(PCP25), minValue(PCP50), 
               minValue(PCP75), minValue(PCP100)), digits= 0)


# BFmx <- round( max(maxValue(BF), maxValue(BF25), maxValue(BF50), 
#                     maxValue(BF75), maxValue(BF100)) , digits = 0)
# BFmn <- round( min(minValue(BF), minValue(BF25), minValue(BF50), 
#                     minValue(BF75), minValue(BF100)), digits= 0)


shinyServer(function(input, output) {
  
  #head in the main panel for raster
  
  output$dataname <- renderText({
    paste( input$species, "distribution ", "in ", input$year)
    
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
  
    y <- (input$year - 2000)/25 + 1
    #### DEM is the static lattitude raster
    img_alti <- DEM
    #plot(img_year[[y]])
    plot(img_alti)
    
    #s <- input$species
    img_species <- get(input$species)
    
    trans <- (1 - input$transparency)

    #windowsFonts(A=windowsFont("Times New Roman")) 
    
    plot(img_alti, col=gray.colors(100), axes=FALSE, legend.shrink=1, box = FALSE,
         horizontal = FALSE, legend.args = list(text= "Altitude (m)", side = 2))
    
    
    plot(img_species[[y]],
         breaks=seq(0, 1, 0.005), 
         #col= terrain.colors(length(seq(0, 0.6, 0.01))), 
         axes=FALSE, legend.shrink=1, box = FALSE,
         horizontal = TRUE,
         legend.args = list(text= paste(input$species, " (Probability of occurence)",sep=" "), side = 3 ), 
         axis.args = list(at = seq(0,1, 0.1), labels=seq(0,1,0.1)),
         alpha=trans, add = TRUE)
  })
  
  
  #second plot: PCP + TMEAN
  output$plot1 <- renderPlot(
    
    width = "auto", height = 300,
    
    {
    
    y <- (input$year - 2000)/25 + 1
      
    par(mfrow=c(1,2), mar=c(0,3,3,0))
    
    #prepare precipitation and mean temperature rasters
    img_pcp <- PCP[[y]]
    img_tmean <- TMEAN[[y]]
    
    
    #windowsFonts(A=windowsFont("Times New Roman")) 
    
    plot(img_pcp, breaks=seq(PCPmn, PCPmx, 200), 
         col=paste(colorRampPalette(c("white", "darkblue"))(length(seq(PCPmn, PCPmx, 200))), 90, sep=""),
         axes=FALSE, legend.shrink=0.8, box = FALSE,
         horizontal = TRUE, 
         legend.args = list(text= "Annual Precipitation (mm)", side = 3),
         axis.args = list(at = seq(PCPmn,PCPmx,400), labels=seq(PCPmn,PCPmx,400))
         )
    
    
    plot(img_tmean, breaks=seq(TMEANmn, TMEANmx, 0.5), 
         col=paste(colorRampPalette(c( "white", "red"))(length(seq(TMEANmn, TMEANmx, 0.5))), 90, sep=""),
         axes=FALSE, legend.shrink=0.8, box = FALSE,
         horizontal = TRUE, 
         legend.args = list( text= "Mean annual Temperature (\u00B0C)", side = 3 ),
         axis.args = list(at = seq(TMEANmn,TMEANmx,5), labels=seq(TMEANmn,TMEANmx,5))
         )
    
    
        
  })
  
  
  # #"Quit" button
  # observeEvent(input$done, {
  #   stopApp()
  # })
  # 
  
  
})