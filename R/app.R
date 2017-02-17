init <- function(manifest = c('epic','450k')){
    switch(match.arg(manifest),
        'epic' = function(){
            pkgname = 'IlluminaHumanMethylationEPICanno.ilm10b2.hg19'
            data(package = pkgname, Locations)
            data(package = pkgname, Islands.UCSC)
            data(package = pkgname, Other)
        },
        '450k' = function(){
            pkgname = 'IlluminaHumanMethylation450kanno.ilmn12.hg19'
            data(package = pkgname, Locations)
            data(package = pkgname, Islands.UCSC)
            data(package = pkgname, Other)
        }
    )
    shinyApp(ui, server)
}

ui <- fluidPage(
    title = 'Illumina EPIC Array Manifest',
    sidebarLayout(
        sidebarPanel(
            conditionalPanel(
                'input.dataset === "Locations" ',
                checkboxGroupInput(
                    'show_vars',
                    'Columns',
                    names(Locations),
                    selected = names(Locations)
                )
            ),
            conditionalPanel(
                'input.dataset === "Islands.UCSC" ',
                checkboxGroupInput(
                    'show_vars2',
                    'Columns',
                    names(Islands.UCSC),
                    selected = names(Islands.UCSC)
                )
            ),
            conditionalPanel(
                'input.dataset === "Other" ',
                checkboxGroupInput(
                    'show_vars3',
                    'Columns',
                    names(Other),
                    selected = NULL)
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
        cbind(
            as.data.table(rownames(Locations)),
            Locations[, input$show_vars, drop = FALSE]
        )
    })
    output$mytable2 <- renderDataTable({
        cbind(
            as.data.table(rownames(Islands.UCSC)),
            Islands.UCSC[, input$show_vars2, drop = FALSE])
    })
    output$mytable3 <- renderDataTable({
        cbind(
            as.data.table(rownames(Other)),
            Other[,input$show_vars3, drop = FALSE])
    }, options = list(
        autoWidth = TRUE,
        ColumnDefs = list(
                list(width = "50px", targets = c(1:28) )
            )
        )
    )
    output$outtable <- renderDataTable({
        cbind(
            as.data.table(rownames(Locations)),
            Locations[, input$show_vars, drop = FALSE],
            Islands.UCSC[, input$show_vars2, drop = FALSE],
            Other[, input$show_vars3, drop = FALSE])
    })
}
