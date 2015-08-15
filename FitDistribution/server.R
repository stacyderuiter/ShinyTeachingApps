library(shiny)
#library(mosaic)
library(RColorBrewer)
library(MASS)

dat <- read.csv("zc_dive_data.csv", header=T, check.names=F, strip.white=F)
colrs <- brewer.pal(8,'Set2')
getDens <- function(x, densfun, pars){
  switch(densfun,
         Normal=dnorm(x, mean=pars[1], sd=pars[2]),
         Exponential=dexp(x, rate=pars),
         Gamma=dgamma(x, shape=pars[1], rate=pars[2]),
         Weibull=dweibull(x,shape=pars[1], scale=pars[2]),
         Beta=dbeta(x, shape1=pars[1], shape2=pars[2]) )
}

getQuant <- function(probs,densfun,pars){
  switch(densfun,
         Normal=qnorm(probs, mean=pars[1], sd=pars[2]),
         Exponential=qexp(probs, rate=pars),
         Gamma=qgamma(probs, shape=pars[1], rate=pars[2]),
         Weibull=qweibull(probs,shape=pars[1], scale=pars[2]),
         Beta=qbeta(probs, shape1=pars[1], shape2=pars[2]) )
}

shinyServer(function(input, output) {
  
  dataInput <- reactive({
    list(d=dat[!is.na(dat[,input$vari]), input$vari],
         dsm=sample(dat[!is.na(dat[,input$vari]), input$vari], input$N, replace=F),
         name=input$vari,
         range=range(dat[!is.na(dat[,input$vari]), input$vari]))
  })
  
  fittedPars <- reactive({
    #fit distribution to data
    if (input$dist == 'Beta'){
      fitdistr(x=dat[,dataInput()$name],
                       densfun=input$dist,
                       start=list(shape1=1, shape2=0.5))$estimate
    }else{
      fitdistr(x=dat[,dataInput()$name],
                       densfun=input$dist)$estimate
    }
  })
  
  expectedDens <- reactive({
    list(x=seq(from=-max(abs(dataInput()$range)),
               to=max(abs(dataInput()$range)), 
               length.out=500),
         y=getDens(seq(from=-max(abs(dataInput()$range)),
                       to=max(abs(dataInput()$range)), 
                       length.out=500),
                   densfun=input$dist,pars=fittedPars()),
         probs=c(1:length(dataInput()$d))/(length(dataInput()$d)+1),
         tq=getQuant(probs=c(1:length(dataInput()$d))/(length(dataInput()$d)+1),
                     densfun=input$dist, pars=fittedPars()),
         name=input$dist)
  })
  
  
  
  output$datahist <- renderPlot({
  #subset data if needed
    if (input$N < length(dataInput()$d)){ 
      d <- dataInput()$dsm
    }else{
        d <- dataInput()$d
      }
    
    #fit distribution to data
    pars <- fittedPars()

    #set up plot area
    par(mfrow=c(1,2), mar=c(4,4,1,1), cex=1.7)
    #histogram
    hist(d , freq=FALSE, breaks=length(d)/10,
         xlab=dataInput()$name, #cex.lab=2, cex.main=1.7,
         ylab='Density', col=colrs[1], border='black',
         ylim=c(0,1.5*max(expectedDens()$y)),
         main='Histogram')
    #draw density line
    lines(expectedDens()$x,expectedDens()$y,lwd=2,col='black')
    legend('topright', bty='n', cex=0.9,
           legend=c('Real Data', paste('Fitted ', expectedDens()$name, ' PDF', sep='')),
           fill=c(colrs[1], 'black'),
           border='white')
    
    #data QQ plot
    if (input$N < length(dataInput()$d)){
      tq <- expectedDens()$tq[seq(from=1, 
                                  to=length(expectedDens()$tq),
                                  length.out=length(d))]
    }else{
      tq <- expectedDens()$tq
    }
    plot(x=tq, y=sort(d), type='p', pch=15, col=colrs[1],
         xlab=paste('Theoretical Quantiles\n from ', expectedDens()$name, ' Distribution'),
         ylab= 'Data Quantiles', main='QQ Plot' )
    abline(a=0, b=1, lty=2, col='grey64', lwd=3.5)
    legend('topleft', legend=c('Observed Data', 'Expected Pattern'),
           col=c(colrs[1], 'grey64') , pch=c(15,NA), bty='n',
           lty=c(NA,2), lwd=2.5)
  })
  
  output$simhist <- renderPlot({
    #simulate data
    pars <- fittedPars()
    s <- switch(expectedDens()$name,
                Normal=rnorm(length(dataInput()$dsm), mean=pars[1], sd=pars[2]),
                Exponential=rexp(length(dataInput()$dsm), rate=pars),
                Gamma=rgamma(length(dataInput()$dsm), shape=pars[1], rate=pars[2]),
                Weibull=rweibull(length(dataInput()$dsm),shape=pars[1], scale=pars[2]),
                Beta=rbeta(length(dataInput()$dsm), shape1=pars[1], shape2=pars[2]) )
    #set up plot area
    par(mfrow=c(1,2), mar=c(4,4,1,1), cex=1.7)
    #histogram
    hist(s , freq=FALSE, breaks=length(s)/10,
         xlab=dataInput()$name, #cex.lab=2, cex.main=1.7,
         ylab='Density', col=colrs[2], border='black',
         ylim=c(0,1.5*max(expectedDens()$y)),
         main='Histogram')
    #draw density line
    lines(expectedDens()$x,expectedDens()$y,lwd=2,col='black')
    legend('topright', bty='n', cex=0.9,
           legend=c('Simulated Data', paste('Fitted ', expectedDens()$name, ' PDF', sep='')),
           fill=c(colrs[2], 'black'),
           border='white')
    
    #qq plot for sim data
    tq <- expectedDens()$tq[seq(from=1, 
                                  to=length(expectedDens()$tq),
                                  length.out=length(s))]
    
    plot(x=tq, y=sort(s), type='p', pch=15, col=colrs[2],
         xlab=paste('Theoretical Quantiles\n from ', expectedDens()$name, ' Distribution'),
         ylab= 'Simulated Data Quantiles', main='QQ Plot' )
    abline(a=0, b=1, lty=2, col='grey64', lwd=3.5)
    legend('topleft', legend=c('Simulated Data', 'Expected Pattern'),
           col=c(colrs[2], 'grey64') , pch=c(15,NA), bty='n',
           lty=c(NA,2), lwd=2.5)
  })
  

})