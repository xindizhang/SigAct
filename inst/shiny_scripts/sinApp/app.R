#server.R
library(shiny)

server <- function(input, output) {
  
  observe({
    file1 <- input$file1
    file2 <- input$file2
    file3 <- input$file3
    if (is.null(file1) || is.null(file2) || is.null(file3)) {
      return(NULL)
    }
    result <- MutSig(file1$datapath, file2$datapath, file3$datapath)
    plot <- result[[1]]
    
    signatures <- result[[3]]
    sige <- c()
    for (signature in signatures){
      sige <- c(sige, sigProposedEtiology(signature))
    }
    output$plot <- renderPlot({
      plot(plot)
    })
    
    output$click_info <- renderPrint({
      cat("input$plot_click:\n")
      sige
    })
  })
  
}

#ui.R
# Define UI for random distribution application 
ui <- fluidPage(
  
  # Application title
  titlePanel("Mutational signature activity"),
  
  # Sidebar with controls to select the random distribution type
  # and number of observations to generate. Note the use of the
  # br() element to introduce extra vertical spacing
  sidebarLayout(
    sidebarPanel(
      fileInput('file1', 'Select the mixtures.csv file'),
      tags$hr(),
      fileInput('file2', 'Select the changepoints.txt file'),
      tags$hr(),
      fileInput('file3', 'Select the phis.txt file')
    ),
    mainPanel(plotOutput("plot", click = "plot_click", 
                         dblclick = dblclickOpts(id = "plot_dblclick"))
    )
  ),
  
  fluidRow(
    column(width = 5,
           verbatimTextOutput("click_info")
    )
  )
  
)


shinyApp(ui = ui, server = server)

# [END]
