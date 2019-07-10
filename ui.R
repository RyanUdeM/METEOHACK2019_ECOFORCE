library(shiny)

# Define UI for dataset viewer application
shinyUI(fluidPage(
  
  # Application title.
  
  
  titlePanel("ECOFORCE: demonstrate how climate shapes the distribution of species"),
  
  
  sidebarPanel(
    

    
    # selectInput widget for the selection of dataset
    selectInput("climat", "climat Variable:", 
                choices = c("PCP30", "TMAX30", "TMIN30", "TMEAN30")),

    
    
    # numericInput for selection of the number of observation that user wants to view
    selectInput("species", "species:", 
                choices = c("BF", "BS")),
    
    
    
    # select input year
    sliderInput("year", "Observation year:", 1951,2005, 1951),
    
    p("some explication here"),
    br(),
    
    
    
    # select transparency
    sliderInput("transparency", "climat   v.s.    species:", 0, 1, 0),
    
    p("some explication here"),
    br()
    
    
    # # quit button   ### has problem, one user click quit, app will down for all users, need to reload.
    # actionButton("done", "Quit")
  
  ),
  
  mainPanel(
    
    
    # just a header for the heading
    h4(textOutput("dataname")),
    # display the structure of the selected dataset
    verbatimTextOutput("structure"),
    
    # plot
    plotOutput("plot"),
    
    # just a header for the heading
    h4(textOutput("observation")),
    # display the observations of the selected dataset - note that this is driven by the triggering of the button event - check in server.r
    tableOutput("view")
  )
))