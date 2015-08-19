require(mosaic)
require(RColorBrewer)

colrs <- brewer.pal(8,'Set2')

shinyServer(function(input, output) {

  ppln <- reactive({
    list(d=switch(input$dist,
           dist1 = rnorm(1000, mean=17, sd=5), # normal population
           dist2 = rgamma(1000,shape=2,scale=2), # gamma population
           dist3 = c(rexp(500,0.07),rnorm(300,-65,25), runif(200,-10,150)), # bimodal population
           dist4 = rexp(1000,0.01) ,# exponential population
           dist5 = runif(1000, 9,26.5)), # uniform population
         name=switch(input$dist,
                     dist1 = 'Distribution 1', # normal population
                     dist2 = 'Distribution 2', # gamma population
                     dist3 = 'Distribution 3', # bimodal population
                     dist4 = 'Distribution 4', #exponential population
                     dist5 = 'Distribution 5') # uniform population
        )
  })

  manyXBars <- reactive({
    do(500) * mean(~ resample(ppln()$d, input$n))
  })
  
  expectedDens <- reactive({
    list(range=range(manyXBars()$result),
         x=seq(from=-max(abs(range(manyXBars()$result))),
               to=max(abs(range(manyXBars()$result))), 
               length.out=500),
         y=dnorm(seq(from=-max(abs(range(manyXBars()$result))),
                       to=max(abs(range(manyXBars()$result))), 
                       length.out=500),
                 mean=mean(manyXBars()$result),
                 sd=sd(manyXBars()$result)),
         probs=c(1:length(manyXBars()$result))/(length(manyXBars()$result)+1),
         tq=qnorm(p=c(1:length(manyXBars()$result))/(length(manyXBars()$result)+1),
                  mean=mean(manyXBars()$result),
                  sd=sd(manyXBars()$result)),
         name='Normal')
  })
    
  output$distPlot <- renderPlot({
    par(cex=1.2, mar=c(4,4,1,1))
    #histogram of parent population
    hist(ppln()$d, freq=FALSE, breaks=length(ppln()$d)/30,
         xlab=ppln()$name, #cex.lab=2, cex.main=1.7,
         ylab='Density', col=colrs[1], border='black',
         main='Parent Population')
  })

  output$nullDistPlot <- renderPlot({
    par(cex=1.5, mar=c(4,4,4,1))
    #hist of sampling dist
    hist(manyXBars()$result, freq=FALSE, breaks=length(manyXBars()$result)/30,
         xlab='Sample Means', #cex.lab=2, cex.main=1.7,
         ylab='Density', col=colrs[2], border='black',
         ylim=c(0,2*max(expectedDens()$y)),
         main='Sampling distribution of 500 sample means\n (Each is mean of a sample (size = n) from Population)')
    #add Normal density
    lines(expectedDens()$x,expectedDens()$y,lwd=3,col='black')
    #add lines for true mean and sample mean
    abline(v=mean(ppln()$d), lty=1, lwd=3, col=colrs[3])
    abline(v=mean(manyXBars()$result), lty=2, lwd=3, col=colrs[4])
    #add legend
    legend('topright', bty='n', cex=0.85,
           legend=c('Sample Means', 
                    paste('Fitted ', expectedDens()$name, ' PDF', sep=''),
                    paste('Parent Population\nMean = ', round(mean(ppln()$d), digits=2), sep=''),
                    paste('Sampling Distribution\n Mean = ', round(mean(manyXBars()$result), digits=2), sep='')),
           fill=c(colrs[2], 'black', colrs[3], colrs[4]), 
           y.intersp=1.3, border='white')
                        
  })
  
  output$qqPlot <- renderPlot({
    par(cex=1.5, mar=c(4,4,3,1))
    axl <- c(min(c(min(expectedDens()$tq), min(manyXBars()$result))),
             max(c(max(expectedDens()$tq), max(manyXBars()$result))))
    plot(x=expectedDens()$tq, y=sort(manyXBars()$result), type='p', pch=15, col=colrs[2],
         xlab=paste('Theoretical Quantiles\n from ', expectedDens()$name, ' Distribution'),
         ylab= 'Sampling Distribution Quantiles', 
         xlim=axl, ylim=axl, main='Normal QQ Plot' )
    abline(a=0, b=1, lty=2, col='grey64', lwd=3.5)
    legend('topleft', legend=c('Observed Data', 'Expected Pattern (if normal dist. fits)'),
           col=c(colrs[2], 'grey64') , pch=c(15,NA), bty='n',
           lty=c(NA,2), lwd=2.5)
    
#     qqmath(~result, data=manyXBars(), xlab='Normal quantile',
#            pch=19, cex=0.4,
#            ylab=expression(paste(bar(x), ' values')),
#            main='Normal Q-Q plot of sampling dist.')
  })
  output$text1 <- renderText({
    approxStdErr <- round(sd(~result,data=manyXBars()), digits=3)
    paste('Standard deviation of the 500 sample means is ',
          approxStdErr, '.')
  })
#   output$text2 <- renderText({
#     actualStdErr <- round(sd(ppln())/sqrt(input$n), digits=4)
#     paste('The true standard error is ', actualStdErr)
#   })
})