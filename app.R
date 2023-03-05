library(shiny)
library(tidyverse)
library(plotly)
library(dplyr)

uah <- read.delim("UAH-lower-troposphere-long.csv.bz2")

ui <- fluidPage(
  titlePanel("PS6"),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Description",
               p("\nThis app uses and describes satellite temperature data from UAH.\n"),
               p("\nThe data has been examined between the years of 1991-2020 and is
                 measured in degrees celsius (C).\n"),
               p("\nThe following are several samples of observations in the data set.\n"),
               tableOutput("sample")),
      
      tabPanel("Plot",
               sidebarLayout(
                 sidebarPanel(
                   sliderInput("n", "Number of Observations:",
                               min = 10,
                               max = 1000,
                               value = 300),
                   radioButtons("color", "Choose color:",
                                choices = c("magenta", "orangered", "darkgreen",
                                                     "darkblue", "purple2"))
                 ),
                 mainPanel(
                   plotOutput("plot")
                 )
               )),
      
      tabPanel("Table",
               sidebarLayout(
                 sidebarPanel(
                   sliderInput("k", "Number of Observations:",
                               min = 10,
                               max = 500,
                               value = 25)
                 ),
                 mainPanel(
                   tableOutput("table")
                 )
               ))
    )
  )
  
)

server <- function(input, output) {
  output$plot <- renderPlot({
    uah %>% 
      sample_n(input$n) %>% 
      ggplot(aes(year, temp)) +
      geom_point(col=input$color) +
      labs(title = "Temperature in Regions based on Year",
           x = "Year",
           y = "Temperature (in degrees celsius)")
  })
  
  output$table <- renderTable({
    uah %>% 
      sample_n(input$k)
  })
  
  output$sample <- renderTable({
    uah %>% 
      sample_n(5)
  })
  
}


shinyApp(ui = ui, server = server)
