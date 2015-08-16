library(shiny)
library(mosaic)
library(RColorBrewer)

dat <- read.csv("HaDiveParameters.csv", header=T, check.names=F, strip.white=F)
vlinecols <- brewer.pal(4,'Set1')
vlinecols[3:4] <- 'white'

shinyServer(function(input, output) {
  
  inputData <- reactive({
    list(d=na.omit(dat[,input$vari]),
         name=input$vari)
  })
  
  output$plot1 <- renderPlot({
    #compute summary stats
    sumStats <- data.frame(name = c("Mean", "Median", "Standard Deviation", "Inter-Quartile Range"),
                           val= c(round(mean(inputData()$d), digits=1),
                                  round(median(inputData()$d), digits=1),
                                  round(sd(inputData()$d), digits=1),
                                  round(IQR(inputData()$d), digits=1)),
                           stringsAsFactors=FALSE
    )
    #figure out which stats are requested
    whichSumStats <- sumStats$name %in% input$stats
    #set up plot area
    par(mfrow=c(1,1), mar=c(4,4,1,1), cex=1.7)
    #data for density line
    den <- density(inputData()$d, n=150)
    #histogram
    hist(inputData()$d , freq=FALSE,
         xlab=inputData()$name, #cex.lab=2, cex.main=1.7,
         ylab="Density", col='grey64', border='black',
         ylim=c(0,1.3*max(den$y)),
         main='')
    #draw density line
    lines(den$x,den$y,lwd=2,col='black')
    moc <- whichSumStats & grepl('Me', sumStats$name)
    abline(v=sumStats[moc, 'val'],
           col=vlinecols[moc], lty=2, lwd=2)
    legend('topright', bty='n', cex=0.9,
           legend=c('Histogram', 'Density Plot',
                    paste(sumStats[whichSumStats,'name'], 
                          sumStats[whichSumStats,'val'],
                          sep=': ')),
           fill=c('grey64', 'black', vlinecols[whichSumStats]),
           border='white')
  })
  
  output$plot2 <- renderPlot({
    #set up plot area
    par(mfrow=c(1,1), mar=c(4,4,1,1), cex=1.7)
    #boxplot
    boxplot(inputData()$d, xlab=inputData()$name, horizontal=TRUE,
            col='grey64', outpch=20, outcex=0.75, 
            outcol='grey64', whisklwd=2, staplelwd=2) 
    
  })
})