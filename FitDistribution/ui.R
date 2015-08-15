library(shiny)
dat <- read.csv('zc_dive_data.csv', header=T, check.names=F, strip.white=F)

# Define UI for application that draws a histogram
shinyUI(navbarPage('Fitting PDFs to Data',
                   tabPanel('Plots',
                            sidebarLayout(
                              sidebarPanel(
                                selectInput('vari', label = 'Variable:',
                                            choices = names(dat)[5:ncol(dat)], 
                                            selected = 'Dive Depth'),
                                
                                selectInput('dist', label = 'Probability Distribution:',
                                            choices = c('Normal', 'Exponential', 'Gamma',
                                                        'Weibull', 'Beta'), 
                                            selected = 'Normal'),
                                
                                sliderInput('N', 'Sample Size (N):', 
                                            min=10, max=nrow(dat), value=nrow(dat))
                              ),
                              mainPanel(
                               plotOutput('datahist'),
                               br(),
                               br(),
                               plotOutput('simhist')#, 
                               # plotOutput('plot3'),
                                #plotOutput('plot4')
                              )
                            )
                   ),
                   tabPanel('About the Data',
                            fluidRow(
                              column(8,
                                     includeMarkdown('about.md')
                              ),
                              column(2,
                                     img(class='img-rounded',
                                         src='zc.jpg',
                                         width=250)
                                     )
                            )),
                   tabPanel('Questions',
                            fluidRow(
                              column(10,
                                     includeMarkdown('questions.md'))
                                    )
                            ),
                   collapsible=TRUE)
)
