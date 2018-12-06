#server.R
library(shiny)

server <- function(input, output) {
  
  observe({
    file1 = input$file1
    file2 = input$file2
    file3 = input$file3
    file4 = input$file4
    file5 = input$file5
    file6 = input$file6
    if (is.null(file1) || is.null(file2) || is.null(file3) ||
        is.null(file4) || is.null(file5) || is.null(file6)) {
      return(NULL)
    }

    result <- MutSig(file1$datapath, file2$datapath, file3$datapath,
                     file4$datapath, file5$datapath, file6$datapath)
    
    signatures1 <- result[[1]][[2]]
    sige1 <- c()
    for (signature in signatures1){
      sige1 <- c(sige1, sigProposedEtiology(signature))
    }
    signatures2 <- result[[2]][[2]]
    sige2 <- c()
    for (signature in signatures2){
      sige2 <- c(sige2, sigProposedEtiology(signature))
    }

    plot1 <- result[[1]][[1]]
    plot2 <- result[[2]][[1]]

    output$plotgraph1 = renderPlot({plot1})
    output$plotgraph2 = renderPlot({plot2})

    
    output$click_info <- renderPrint({
      cat("sample 1:\n")
      sige1
    })
    output$dbclick_info <- renderPrint({
      cat("sample 2:\n")
      sige2
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
      fileInput('file2', 'Select the changepoints.txt file'),
      fileInput('file3', 'Select the phis.txt file'),
      fileInput('file4', 'Select the mixtures.csv file'),
      fileInput('file5', 'Select the changepoints.txt file'),
      fileInput('file6', 'Select the phis.txt file'), width = 2
    ),
    mainPanel(fluidRow(splitLayout(plotOutput("plotgraph1", click = "click_info"), 
                                   plotOutput("plotgraph2", 
                                              dblclick = dblclickOpts(id = "dblclick_info"))
                                  )
              )
    )
  ),
  fluidRow(
    column(width = 5,
           verbatimTextOutput("click_info")
          ),
    column(width = 5,
           verbatimTextOutput("dblclick_info")
          )
  )
)


shinyApp(ui = ui, server = server)

# [END]
