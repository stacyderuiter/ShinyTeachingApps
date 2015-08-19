require(mosaic)
require(RColorBrewer)

colrs <- brewer.pal(8,'Set2')

shinyServer(function(input, output) {
  output$par1Slider <- renderUI({
    
    sliderPars <- switch(input$dist,
                         'Normal' = list(min=-20, max=20, value=-20,step=0.25),
                         'Exponential' = list(min=0.01, max=25, value=0.25,step=0.025),
                         'Gamma' = list(min=1e-10, max=3, value=0.1, step=0.025),
                         'Weibull' = list(min=1e-10, max=15, value=0.1,step=0.025),
                         'Beta' = list(min=1e-10, max=10, value=0.1,step=0.025),
                         'Uniform' = list(min=-20, max=20, value=-20,step=0.25))
    
    sliderInput("par1", paste(pars()$names[1], ':', sep=''), 
                min = sliderPars$min, max = sliderPars$max, 
                value = sliderPars$value, step = sliderPars$step,
                animate=TRUE)
  })
  
  output$par2Slider <- renderUI({
    
    sliderPars <- switch(input$dist,
                         'Normal' = list(min=0, max=15, value=0.1,step=0.25),
                         'Exponential' = list(min=NA, max=NA, value=NA,step=NA),
                         'Gamma' = list(min=1e-10, max=10, value=0.1,step=0.025),
                         'Weibull' = list(min=1e-10, max=2, value=0.1,step=0.025),
                         'Beta' = list(min=1e-10, max=10, value=0.1,step=0.25),
                         'Uniform' = list(min=-20, max=20, value=20, step=0.25))
    
    sliderInput("par2", paste(pars()$names[2], ':', sep=''), 
                min = sliderPars$min, max = sliderPars$max, 
                value = sliderPars$value, step = sliderPars$step,
                animate=TRUE)
  })
  
      pars <- reactive({
          list(names=switch(input$dist,
                      'Normal' = list('mean', 'standard deviation'),
                      'Exponential' = list('rate'),
                      'Gamma' = list('shape', 'rate'),
                      'Weibull' = list('shape', 'scale'),
                      'Beta' = list('shape1', 'shape2'),
                      'Uniform' = list('a','b')
                      ),
         greek=switch(input$dist,
                            'Normal' = list('\\(\\mu\\)', '\\(\\sigma\\)'),
                            'Exponential' = list('\\(\\lambda\\)'),
                            'Gamma' = list('\\(k\\)', '\\(\\theta\\)'),
                            'Weibull' = list('\\(k\\)', '\\(\\lambda\\)'),
                            'Beta' = list('\\(\\alpha\\)', '\\(\\beta\\)'),
                            'Uniform' = list('a','b')
                      ),
         pdf=switch(input$dist,
                      'Normal' = '$$f(x) = \\frac{1}{\\sigma\\sqrt{2\\pi}} exp({-\\frac{(x-\\mu)^2}{2 \\sigma^2}})$$',
                      'Exponential' = '$$\\lambda exp(-\\lambda x) $$',
                      'Gamma' = '$$f(x) = (\\Gamma(k)\\theta^k)^{-1} x^{k-1} exp(\\frac{-x}{\\theta}) $$',
                      'Weibull' = '$$f(x)= \\frac{k}{\\lambda} (\\frac{x}{\\lambda})^{(k-1)} exp(\\frac{x}{\\lambda})^{k} $$',
                      'Beta' = '$$f(x) = \\frac{x^ {(\\alpha-1)} (1-x)^{(\\beta - 1)}}{B(\\alpha,\\beta)}$$',
                      'Uniform' = '$$f(x) = \\frac{1}{(b-a)}$$'
                    ),
         support=switch(input$dist,
                    'Normal' = '$$(-\\infty, \\infty)$$',
                    'Exponential' = '$$(0, \\infty)$$',
                    'Gamma' = '$$(0, \\infty)$$',
                    'Weibull' = '$$(0, \\infty)$$',
                    'Beta' = '$$(0, 1)$$',
                    'Uniform' = '$$[a,b]$$'
         )
         )
  })

  output$PDFPlot <- renderPlot({
    if (is.null(input$par1))
      return()
    par(cex=1.2, mar=c(4,4,1,1))
    xn <- seq(from=-50, to=50, length.out=2000)
    x <- seq(from=1e-5, to=5, length.out=1000)
    xb <- seq(from=1e-10, to=1-1e-10, length.out=1000)
    xu <- seq(from=-20, to=20, by=0.1)
    den <- switch(input$dist,
                  'Normal' = list(x=xn,
                                  y=dnorm(xn,mean=input$par1, sd=input$par2)),
                  'Exponential' = list(x=x, y=dexp(x, rate=input$par1)),
                  'Gamma' = list(x=x, y=dgamma(x,shape=input$par1, rate=input$par2)),
                  'Weibull' = list(x=x, y=dweibull(x,shape=input$par1, scale=input$par2)),
                  'Beta' = list(x=xb,y=dbeta(xb, shape1=input$par1, shape2=input$par2)),
                  'Uniform' = list(x=xu, y=dunif(xu,min=min(c(input$par1,input$par2)),
                                                 max=max(c(input$par1,input$par2)))))
    plot(den$x,den$y, type='l', lwd=3.5, 
         xlab='x = Value of Random Variable',
         ylab='f(x) = Probability Density',
         ylim=c(0,max(c(0.01,den$y[is.finite(den$y)]))),
         xlim=c(min(den$x), max(den$x)))
  })
  
    output$reportArea <- renderText({
      if(is.null(input$plot_brush)){
        ar <- '(Nothing selected)'
      }else{
        ar <- switch(input$dist,
                     'Normal' = round(pnorm(input$plot_brush$xmax, 
                                            mean=input$par1, sd=input$par2) -
                                        pnorm(input$plot_brush$xmin, 
                                              mean=input$par1, sd=input$par2), 
                                      digits=2),
                     'Exponential' = round(pexp(input$plot_brush$xmax, 
                                                 rate=input$par1) -
                                             pnorm(input$plot_brush$xmin, 
                                                   rate=input$par1), 
                                           digits=2),
                     'Gamma' = round(pgamma(input$plot_brush$xmax, 
                                           shape=input$par1, rate=input$par2) -
                                       pgamma(input$plot_brush$xmin, 
                                             shape=input$par1, rate=input$par2), 
                                     digits=2),
                     'Weibull' = round(pweibull(input$plot_brush$xmax, 
                                             shape=input$par1, scale=input$par2) -
                                         pweibull(input$plot_brush$xmin, 
                                               shape=input$par1, scale=input$par2), 
                                       digits=2),
                     'Beta' = round(pbeta(input$plot_brush$xmax, 
                                          shape1=input$par1, shape2=input$par2) -
                                      pbeta(input$plot_brush$xmin, 
                                            shape1=input$par1, shape2=input$par2), 
                                    digits=2),
                     'Uniform' = round(punif(input$plot_brush$xmax, 
                                          min=min(c(input$par1,input$par2)),
                                          max=max(c(input$par1,input$par2))) -
                                      punif(input$plot_brush$xmin, 
                                            min=min(c(input$par1,input$par2)),
                                            max=max(c(input$par1,input$par2))), 
                                    digits=2)
                     )
      }
                   
      paste('Select a section of the plot to compute the area under the curve.\n Area: ', ar, '.')
    })
    
    output$PDF <- renderUI({
      withMathJax(
        h5(paste('The ', input$dist, ' distribution has parameter(s) ', sep='')),
        h5(pars()$names[1]),
        h1(pars()$greek[1]),
        h5(pars()$names[2]),
        h1(pars()$greek[2]),
        h5('and probability density function:'),
        h1(pars()$pdf),
        h5(ifelse(input$dist=='Beta',
                  'where B is the beta function.',
                  '')),
        h5(ifelse(input$dist=='Gamma',
                'where \\(\\Gamma\\) is the gamma function.',
                '')),
        h5('For x in the interval'),
        h1(pars()$support))

    })
})