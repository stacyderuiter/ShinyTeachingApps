library(shiny)
library(markdown)
library(httpuv)
library(Rcpp)

dat <- read.csv("HaDiveParameters.csv", header=T, check.names=F, strip.white=F)

# Define UI for application that draws a histogram
shinyUI(navbarPage("Center and Spread of Distributions",
                   tabPanel("Plots",
                            sidebarLayout(
                              sidebarPanel(
                                selectInput("vari", label = "Variable:",
                                            choices = names(dat)[4:ncol(dat)]),
                                
                                checkboxGroupInput("stats", label="Summary Statistics",
                                                   choices=c("Mean", "Median", 
                                                             "Standard Deviation",
                                                             "Inter-Quartile Range"), 
                                                   selected = "Mean", inline = FALSE)
                              ),
                              mainPanel(
                                plotOutput("plot1"),
                                plotOutput("plot2")
                              )
                            )
                   ),
                   tabPanel("About the Data",
                            fluidRow(
                              column(8,
                                     includeMarkdown("about.md")
                              )#,
#                               column(2,
#                                      img(class="img-rounded",
#                                          src="AriBlue.jpg",
#                                          width=250)
#                                      )
                            )),
                   tabPanel("Questions",
                            fluidRow(
                              column(10,
                                     includeMarkdown("questions.md"))
                                    )
                            ),
                   collapsible=TRUE)
)
