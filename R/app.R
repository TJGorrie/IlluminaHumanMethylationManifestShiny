init <- function(){
    data(Locations)
    data(Islands.UCSC)
    data(Other)
    shinyApp(ui, server)
}
ui <- fluidPage(
  title = 'Illumina EPIC Array Manifest',
  sidebarLayout(
    sidebarPanel(
    conditionalPanel(
      'input.dataset === "Locations" ',
      checkboxGroupInput('show_vars', 'Columns', names(Locations), selected = names(Locations))
    ),
    conditionalPanel(
      'input.dataset === "Islands.UCSC" ',
      checkboxGroupInput('show_vars2', 'Columns', names(Islands.UCSC), selected = names(Islands.UCSC))
    ),
    conditionalPanel(
      'input.dataset === "Other" ',
      checkboxGroupInput('test', 'Columns', names(Other), selected = NULL)
    )
),
mainPanel(
  tabsetPanel(
    id = 'dataset',
    tabPanel('Locations', dataTableOutput('mytable1')),
    tabPanel('Islands.UCSC', dataTableOutput('mytable2')),
    tabPanel('Other', dataTableOutput('mytable3')),
    tabPanel('Combo', dataTableOutput('outtable'))
)
)
)
)

server <- function(input, output){
output$mytable1 <- renderDataTable({
  cbind(as.data.table(rownames(Locations)),Locations[,input$show_vars, drop=F])
})
output$mytable2 <- renderDataTable({
  cbind(as.data.table(rownames(Islands.UCSC)),Islands.UCSC[, input$show_vars2, drop=F])
})
output$mytable3 <- renderDataTable({
  cbind(as.data.table(rownames(Other)), Other[,input$test])
}, options = list(autoWidth = TRUE, ColumnDefs = list(list(width="50px", targets = c(1:28)))))
output$outtable <- renderDataTable({
    cbind(as.data.table(rownames(Locations)),
          Locations[,input$show_vars, drop=F],
          Islands.UCSC[, input$show_vars2, drop=F],
          Other[,input$test, drop=F])
    })
}
