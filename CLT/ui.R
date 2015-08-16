require(shiny)
shinyUI(navbarPage(strong('Sampling Distribution of the Sample Mean'),
                   tabPanel('Plots',
                            sidebarLayout(
                              sidebarPanel(radioButtons('dist', label = h3('Select population'),
                                                        choices = list('population 1' = 'dist1', 
                                                                       'population 2' = 'dist2',
                                                                       'population 3' = 'dist3', 
                                                                       'population 4' = 'dist4',
                                                                       'population 5' = 'dist5'),
                                                        selected = 'dist1'),
                                           sliderInput('n', 'Sample Size (N):', round=TRUE,
                                                       min=5, max=300, value=50),
                                           br(),
                                           plotOutput('distPlot', width='100%',height='200px')),
                              mainPanel(
                                plotOutput('nullDistPlot'),# width='74%',height='300px'),
                                h4(textOutput('text1'), align='center'),
                                br(),
                                plotOutput('qqPlot') # width='90%',height='300px'),
                                #textOutput('text2')
                              )
                            )
                   ),
        tabPanel('Questions',
                 fluidRow(
                   column(10,
                          includeMarkdown('questions.md'))
                 )
        ),
        collapsible=TRUE)
)
