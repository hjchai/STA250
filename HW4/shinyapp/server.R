library(shiny)

# From a future version of Shiny
# Copy from @jcheng5

observeEvent <- function(eventExpr, callback, env=parent.frame(), quoted=FALSE) {
  eventFunc <- exprToFunction(eventExpr, env, quoted)
  
  initialized <- FALSE
  invisible(observe({
    eventVal <- eventFunc()
    if (!initialized)
      initialized <<- TRUE
    else
      isolate(callback())
  }))
}

shinyServer(function(input,output, session){
  
  # Observe for changes to row and update the numeric input
  observeEvent(input$row, function(){
    updateNumericInput(session, "row", value = input$row)
  })
  # Plot the "Fundamental diagram"
  output$plot <- renderPlot({
    location <- read.table("~/Desktop/STA250/HW4/location.txt", sep = ",")
    loc_id <- location[input$row]
    file = paste("~/Desktop/STA250/HW4/data/",loc_id,".txt", sep = "")
    data_file <- read.table(file, sep = "\t", header = F, skip = 1)
    plot(data_file[,2],data_file[,3],main = "Fundmental Diagram", xlab = "Occupancy", ylab = "Speed", pch = 19)
  })
  # Plot the speed profile over a day
  output$plot2 <- renderPlot({
    location <- read.table("~/Desktop/STA250/HW4/location.txt", sep = ",")
    loc_id <- location[input$row]
    file = paste("~/Desktop/STA250/HW4/data/",loc_id,"_speed.txt", sep = "")
    data_file <- read.table(file, sep = "\t", header = F, skip = 1)
    plot(data_file[,1],data_file[,3],main = "Speed in a day", xlab = "Time", ylab = "Speed", pch = 19)
  })
  # Plot the flow profile over a week
  output$plot3 <- renderPlot({
    location <- read.table("~/Desktop/STA250/HW4/location.txt", sep = ",")
    loc_id <- location[input$row]
    file = paste("~/Desktop/STA250/HW4/data/",loc_id,"_speed.txt", sep = "")
    data_file <- read.table(file, sep = "\t", header = F, skip = 1)
    plot(data_file[,1],data_file[,2],main = "Traffic flow", xlab = "Time", ylab = "Flow", pch = 19)
  })
  
})