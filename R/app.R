init <- function(manifest = c('epic','450k')){
    manifest <- match.arg(manifest)
    pkg1 <- 'IlluminaHumanMethylationEPICanno.ilm10b2.hg19'
    pkg2 <- 'IlluminaHumanMethylation450kanno.ilmn12.hg19'
    loaded <- loadedNamespaces()
    if(pkg1 %in% loaded & pkg2 %in% loaded){
        switch(manifest,
            # Detach 450k
            'epic' = detach(paste0('package:', pkg1), character.only = TRUE),
            # Detach EPIC
            '450k' = detach(paste0('package:', pkg2), character.only = TRUE)
        )
    }
    switch(manifest,
        'epic' =
            if(requireNamespace(pkg1)){
            Locations <- minfi::getAnnotation(pkg1, "Locations")
            Islands.UCSC <- minfi::getAnnotation(pkg1, "Islands.UCSC")
            Other <- minfi::getAnnotation(pkg1, "Other")
        },
        '450k' =
            if(requireNamespace(pkg2)){
            Locations <- minfi::getAnnotation(pkg2, "Locations")
            Islands.UCSC <- minfi::getAnnotation(pkg2, "Islands.UCSC")
            Other <- minfi::getAnnotation(pkg2, "Other")
        }

    )
    shinyApp(ui, server)
}

ui <- function() fluidPage(
    title = 'Illumina HumanMethylation Array Manifest',
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
