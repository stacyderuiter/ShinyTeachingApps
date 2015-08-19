library(shiny)
library(markdown)
shinyUI(navbarPage("Probability Distribution Functions",
                   tabPanel("Plots",
                            fluidRow(
                              withMathJax(),
                              column(4, wellPanel(
                                selectInput("dist", label = "Name:",
                                            choices = c("Normal", "Exponential","Gamma",
                                                        "Weibull", "Beta", "Uniform"#, 
                                                        #"t", "F"
                                                        ), selected='Normal'),
                                uiOutput('par1Slider'),
                                conditionalPanel("input.dist != 'Exponential' ",
                                                 uiOutput('par2Slider')
                                ),
                                uiOutput('PDF')

                              )),
                              
                              column(8,
                                     plotOutput("PDFPlot", height = 300,
                                                brush = brushOpts(
                                                   id = "plot_brush"
                                                   )
                                     ),

                                     h4(verbatimTextOutput('reportArea'), align='center')

                              )
                            )),

                   tabPanel("Questions",
                            fluidRow(
                              column(10,
                                     includeMarkdown("questions.md"))
                                    )
                            ),
                   collapsible=TRUE)
)
