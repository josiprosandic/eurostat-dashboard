#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(DT)
library(readxl)
library(plotly)
library(wesanderson)
library(readr)

#data_gdp <- read_excel("./DashboardData/GDP.xlsx")
#data_unemployment <- read_excel("./DashboardData/Unemployment.xlsx")
#data_inflation <- read_excel("./DashboardData/Inflation.xlsx")
#data_debt <- read_excel("./DashboardData/Debt.xlsx")
#data_sentiment <- read_excel("./DashboardData/Sentiment.xlsx")
#data_registration <- read_excel("./DashboardData/Registration.xlsx")
#data_bankruptcy <- read_excel("./DashboardData/Bankruptcy.xlsx")
#data_surplus <- read_excel("./DashboardData/SurplusDeficit.xlsx")


data_gdp <- read_excel("./DashboardData/GDP.xlsx")
data_unemployment <- read_excel("./DashboardData/Unemployment.xlsx")
data_inflation <- read_excel("./DashboardData/Inflation.xlsx")
data_debt <- read_excel("./DashboardData/Debt.xlsx")
data_sentiment <- read_excel("./DashboardData/Sentiment.xlsx")
data_registration <- read_excel("./DashboardData/Registration.xlsx")
data_bankruptcy <- read_excel("./DashboardData/Bankruptcy.xlsx")
data_surplus <- read_excel("./DashboardData/SurplusDeficit.xlsx")

# Define UI for application 
ui <- dashboardPage(skin = "black",

    # Application title
    dashboardHeader(title="EU Recovery Dashboard",titleWidth = 200),

    # Sidebar
    dashboardSidebar(width = 200,
        sidebarMenu(
            menuItem("Select the data", tabName = "item1",icon = icon("filter")),
            menuItem("GDP", tabName = "item2",icon = icon("money-bill")),
            menuItem("Unemployment", tabName = "item3",icon = icon("briefcase")),
            menuItem("Inflation", tabName = "item4",icon = icon("coins")),
            menuItem("Economic Sentiment", tabName = "item5",icon = icon("smile-beam")),
            menuItem("Debt", tabName = "item6",icon = icon("search-dollar")),
            menuItem("Registration", tabName = "item7",icon = icon("handshake")),
            menuItem("Bankruptcy", tabName = "item8",icon = icon("chart-area")),
            menuItem("Surplus deficit", tabName = "item9",icon = icon("chart-line"))
        )
    ),
    dashboardBody(
        
        tabItems(
          # Tab select the data
          # ---------------------------------------------------------------------
            tabItem("item1",
                img(src = "https://www.sfcg.org/wp-content/uploads/2015/09/European-Union-Flag.png", height = 80, width = 130),
                img(src = "data:image/png;base64,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",height = 80, width = 90),
                h1("Welcome to EURD"),
                h3("Welcome to our dashboard!"),
                h3("Please, select the parameters for filtering the data in order to get your expected results."),
                p(em("Default choice: European Union")),
                br(),
                br(),
                box(title = "Input parameters", status = "primary", solidHeader = TRUE,
                  selectInput(inputId = "country",
                              label = "Choose one or more countries in order to observe the results:",
                              choices = c(data_gdp$Country),
                              multiple = TRUE,
                              selected = "European Union",
                              width = 800),    
                  sliderInput("years", "Choose a year range in order to get the results for that range:",
                              min(2000), max(2021),
                              step = 1,
                              value = c(2000,2021),
                              width = 800)
                ),
                #airDatepickerInput(
                #  "date_picker_from",
                #  label = "Select the date from:",
                #  dateFormat = "yyyy-mm",
                #  minView = "years",
                #  view = "years"
                #),
                #airDatepickerInput(
                #  "date_picker_to",
                #  label = "Select the date to:",
                #  dateFormat = "yyyy-mm",
                #  minView = "years",
                #  view = "years"
                #),
               
                
                #DT::DTOutput("data_table")
                
                
            
            ),
            # Tab GDP
            #--------------------------------------------------------------------
            tabItem("item2",
                    # Tabovi
                    h1("Gross Domestic Product (GDP)"),
                    h4("Quarterly change in %"),
                    tabsetPanel(type="tabs",
                                
                                
                      tabPanel("Line chart",
                      fluidRow(
                        valueBoxOutput("avg_gdp_growth",width = 3),
                        valueBoxOutput("medial_growth",width = 3),
                        valueBoxOutput("highest_growth",width = 3),
                        valueBoxOutput("lowest_growth",width = 3)
                      ),
                      plotly::plotlyOutput("lines")
                      
                      ),
                      tabPanel("Bar chart",
                               plotly::plotlyOutput("bars"),
                               
                      ),
                      tabPanel("About",
                               h2("Gross Domestic Product (GDP)"),
                               h4("Gross domestic product (GDP) is the most commonly used measure for the size of an economy. The GDP is the total of all value added created in an economy.
The indicator is expressed as a percentage change of the current quarter compared with the previous quarter and as an index with base year 2015.")
                               
                      )
                    )
            ),
            # Tab Unemployment
            #-------------------------------------------------------------------
            tabItem("item3",
                    
              h1("Unemployment"),
              h4("Labour force (15 - 74) in %"),
              tabsetPanel(type="tabs",
                tabPanel("Line chart",
                 fluidRow(
                        valueBoxOutput("avg_unemployment",width = 3),
                        valueBoxOutput("medial_unemployment",width = 3),
                        valueBoxOutput("highest_unemployment",width = 3),
                        valueBoxOutput("lowest_unemployment",width = 3)
                 ),
                  plotly::plotlyOutput("lines_unemployment")
                ),
                tabPanel("Bar chart",
                        plotly::plotlyOutput("bars_unemployment")       
                ),
                tabPanel("About",
                         h2("Unemployment rate"),
                         h4("Unemployment rate is based on a harmonised definition recommended by the International Labour Organisation (ILO), and mainly on a harmonised data source, the European Union Labour Force Survey (LFS). Unemployed persons are defined as the percentage of active population constituted by persons aged 15 to 74 who: are without work; are available to start work within the next two weeks; and have actively sought employment at some time during the previous four weeks.")
                )
              )
            ),
          # Tab Inflation
          #-------------------------------------------------------------------
            tabItem("item4",
              h1("Inflation"),
              h4("Monthly change rate in %"),
              tabsetPanel(type="tabs",
                tabPanel("Line chart",
                 fluidRow(
                   valueBoxOutput("avg_inflation",width = 3),
                   valueBoxOutput("medial_inflation",width = 3),
                   valueBoxOutput("highest_inflation",width = 3),
                   valueBoxOutput("lowest_inflation",width = 3)
                 ),
                 plotly::plotlyOutput("lines_inflation")
                 
                ),
                tabPanel("Bar chart",
                         plotly::plotlyOutput("bars_inflation"),
                         
                ),
                tabPanel("About",
                         h2("Inflation"),
                         h4("Annual inflation is the change of the price level between the current month and the same month of the previous year. This is calculated using the Harmonised Index of Consumer Prices (HICP), a set of consumer price indices calculated according to a harmonised approach and to definitions laid down in Regulations.")
                         )
              )
            ),
          # Tab Sentiment
          #-------------------------------------------------------------------
            tabItem("item5",
                    
              h1("Economic Sentiment"),
              h4("Economic Sentiment index with long-term mean 100"),
              tabsetPanel(type="tabs",
                tabPanel("Line chart", 
                 fluidRow(
                   valueBoxOutput("avg_sentiment",width = 3),
                   valueBoxOutput("medial_sentiment",width = 3),
                   valueBoxOutput("highest_sentiment",width = 3),
                   valueBoxOutput("lowest_sentiment",width = 3)
                 ),
                 plotly::plotlyOutput("lines_sentiment")
                         
                ),
                tabPanel("Bar chart",
                         plotly::plotlyOutput("bars_sentiment"),
                         
                ),
                tabPanel("About",
                         h2("Economic sentiment indicator"),
                         h4("The economic sentiment indicator (ESI) is a composite indicator with the objective of tracking GDP growth. The ESI is a weighted average of the balances of replies to selected questions addressed to firms in industry (weight 40%), services (30%), consumers (20%), retail (5%) and construction (5%).
The ESI is scaled to a long-term mean of 100 and a standard deviation of 10. Thus, values above 100 indicate above-average economic sentiment and vice versa.")
                )
              )
            ),
          # Tab Debt
          #-------------------------------------------------------------------
            tabItem("item6",
                    h1("Debt"),
                    h4("Part of the GDP in %"),
              tabsetPanel(type="tabs",
                          
                          tabPanel("Line chart",
                                   fluidRow(
                                     valueBoxOutput("avg_debt",width = 3),
                                     valueBoxOutput("medial_debt",width = 3),
                                     valueBoxOutput("highest_debt",width = 3),
                                     valueBoxOutput("lowest_debt",width = 3)
                                   ),
                                   plotly::plotlyOutput("lines_debt")
                          ),
                          tabPanel("Bar chart",
                                   plotly::plotlyOutput("bars_debt")
                          ),
                          tabPanel("About",
                                   h2("Government debt"),
                                   h4("Government gross debt is defined as outstanding liabilities of the general government sector at face value at the end of the quarter in the following categories of liabilities: currency and deposits, debt securities and loans. Data are consolidated.
The indicator is expressed as a percentage of GDP (rolling four quarter sum of quarterly GDP).")
                          ) 
                    )       
            ),
          # Tab Registration
          #-------------------------------------------------------------------
            tabItem("item7",
            h1("Registration"),
            h4("Change of the current quarter compared with the previous quarter in %"),
              tabsetPanel(type="tabs",
                tabPanel("Line chart",
                         fluidRow(
                           valueBoxOutput("avg_registration",width = 3),
                           valueBoxOutput("medial_registration",width = 3),
                           valueBoxOutput("highest_registration",width = 3),
                           valueBoxOutput("lowest_registration",width = 3)
                         ),
                         plotly::plotlyOutput("lines_registration")
                         
                ),
                tabPanel("Bar chart",
                         plotly::plotlyOutput("bars_registration"),
                         
                ),
                tabPanel("About",
                         h2("Business registrations"),
                         h4("The quarterly index of registrations of new businesses measures the evolution of entered legal units in the business register at any time during the reference quarter. Number of registrations is an early indicator to measure business intentions. The index is based on all businesses in industry, construction and services (except public services).
The indicator is expressed as an index with base year 2015 and as a percentage change of the current quarter compared with the previous quarter.")
                )
              )
            ),
          # Tab Bankruptcy
          #-------------------------------------------------------------------
            tabItem("item8",
                    h1("Bankruptcy"),
                    h4("Change of the current quarter compared with the previous quarter in %"),
              tabsetPanel(type="tabs",
                tabPanel("Line chart", 
                         fluidRow(
                           valueBoxOutput("avg_bankruptcy",width = 3),
                           valueBoxOutput("medial_bankruptcy",width = 3),
                           valueBoxOutput("highest_bankruptcy",width = 3),
                           valueBoxOutput("lowest_bankruptcy",width = 3)
                         ),
                         plotly::plotlyOutput("lines_bankruptcy")
                         
                ),
                tabPanel("Bar chart",
                         plotly::plotlyOutput("bars_bankruptcy"),
                         
                ),
                tabPanel("About",
                         h2("Bankruptcy declarations"),
                         h4("The quarterly index of bankruptcy declarations measures the evolution of businesses that have started the procedure of being declared bankrupt, by issuing a court declaration at any time during the reference quarter. This declaration is often provisional and does not always mean cessation of an activity. The bankruptcies indicator is an early sign to measure the sentiment in business environment. The index is based on all businesses in industry, construction and services (except public services).
The indicator is expressed as an index with base year 2015 and as a percentage change of the current quarter compared with the previous quarter.")
                
                )
              )
            ),
          # Tab Surplus deficit
          #-------------------------------------------------------------------
            tabItem("item9",
                    h1("Surplus deficit"),
                    h4("Part of the GDP in %"),
              tabsetPanel(type="tabs",
                tabPanel("Line chart",
                 fluidRow(
                   valueBoxOutput("avg_surplus",width = 3),
                   valueBoxOutput("medial_surplus",width = 3),
                   valueBoxOutput("highest_surplus",width = 3),
                   valueBoxOutput("lowest_surplus",width = 3)
                 ),
                  plotly::plotlyOutput("lines_surplus")       
                ),
                tabPanel("Bar chart",    
                  plotly::plotlyOutput("bars_surplus")
                ),
                tabPanel("About",
                         h2("Government surplus/deficit"),
                         h4("Government surplus/deficit is defined as general government net lending (+) / borrowing (-) according to the European System of Accounts (ESA 2010).
The indicator is expressed as a percentage of GDP.")
                ) 
              )        
            )
        )
    )
)



# Define server logic 
server <- function(input, output) {
    
    
    # GDP
    # -------------------------------------------------------------------------- 
    output$lines <- plotly::renderPlotly({
        
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
        
        
        lines_data <- 
            subset(data_gdp, 
                   Country %in% country_selected &
                   substr(Date,0,4) >= year_from &
                   substr(Date,0,4) <= year_to
            )
        
        lines_data_eu <- 
          subset(data_gdp, 
                 Country == "European Union" &
                   substr(Date,0,4) >= year_from &
                   substr(Date,0,4) <= year_to
          )
        
        h1 <- lines_data %>%
            ggplot(aes(x = Date, y = GDP, color = Country)) +
            geom_line(size = 0.8,aes(group=1))+
            geom_point(size = 1.8)+
            scale_color_manual(values = rev(wes_palette("Darjeeling1", 
                                                       length(unique(lines_data$Country)), 
                                                       type = "continuous"))) +
          theme(axis.text.x = element_text(angle = 75, hjust = 1)) +
          geom_hline(yintercept=mean(lines_data_eu$GDP), linetype="dashed", color = "red")
            
            
            
            
        ggplotly(h1, height = 650)%>%
            layout(legend = list(orientation = "h", x = 0.3, y =-0.1))
    
    })
    
    output$bars <- plotly::renderPlotly({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      bars_data <- 
        subset(data_gdp, 
               Country %in% country_selected &
                   substr(Date,0,4) >= year_from &
                   substr(Date,0,4) <= year_to
        ) 
      
      bars_data_agg_gdp <- aggregate(bars_data[,3], list(bars_data$Country), mean)
      
      h2 <- bars_data_agg_gdp%>%
        ggplot(aes(x = reorder(Group.1, GDP), y = GDP,fill = Group.1,
                   text = paste0(Group.1, " ", GDP))) +
      geom_bar(stat = "identity", width = 0.5)
      
      ggplotly(h2, tooltip = "text", height = 600)
    })
    
    # Value boxes
    output$avg_gdp_growth <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_gdp, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
        round(mean(lines_data$GDP),digits = 2) %>%
        valueBox(subtitle = "Average GDP growth",color = "blue")
        
    })
    
    output$highest_growth <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_gdp, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
        max(lines_data$GDP) %>%
        valueBox(subtitle = "Highest GDP growth",color = "green")
      
    })
    
    output$lowest_growth <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_gdp, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      min(lines_data$GDP) %>%
        valueBox(subtitle = "Lowest GDP growth",color = "red")
      
    })
    
    output$medial_growth <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_gdp, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      median(lines_data$GDP) %>%
        valueBox(subtitle = "Medial GDP growth",color = "yellow")
      
    })
    
    
   
    
    # Unemployment
    # ---------------------------------------------------------------------------
    # -------------------------------------------------------------------------- 
    output$lines_unemployment <- plotly::renderPlotly({
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_unemployment, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        ) 
      
      lines_data_eu <- 
        subset(data_unemployment, 
               Country == "European Union" &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      h1 <- lines_data %>%
        ggplot(aes(x = Date, y = Unemployment, color = Country)) +
        geom_line(size = 0.8,aes(group=1))+
        geom_point(size = 1.8)+
        scale_color_manual(values = rev(wes_palette("Darjeeling1", 
                                                    length(unique(lines_data$Country)), 
                                                    type = "continuous"))) +
        theme(axis.text.x = element_text(angle = 75, hjust = 1)) +
      geom_hline(yintercept=mean(lines_data_eu$Unemployment), linetype="dashed", color = "red")
      
      
      
      
      ggplotly(h1, height = 650)%>%
        layout(legend = list(orientation = "h", x = 0.3, y =-0.1))
    })
    
    output$bars_unemployment <- plotly::renderPlotly({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      bars_data <- 
        subset(data_unemployment, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      bars_data_agg <- aggregate(bars_data[,3], list(bars_data$Country), mean)
      
      h2 <- bars_data_agg %>%
        ggplot(aes(x = reorder(Group.1, Unemployment), y = Unemployment,fill = Group.1,
                   text = paste0(Group.1, " ", Unemployment))) +
        geom_bar(stat = "identity", width = 0.5)
      
      ggplotly(h2, tooltip = "text", height = 700)
    })
    
    output$avg_unemployment <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_unemployment, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      round(mean(lines_data$Unemployment), digits=2) %>%
        valueBox(subtitle = "Average unemployment percentage",color = "blue")
      
    })
    
    output$highest_unemployment <- renderValueBox({
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_unemployment, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      max(lines_data$Unemployment) %>%
        valueBox(subtitle = "Highest unemployment percentage",color = "red")
    })
    
    output$medial_unemployment <- renderValueBox({
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_unemployment, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      median(lines_data$Unemployment) %>%
        valueBox(subtitle = "Medial unemployment percentage",color = "yellow")
    })
    
    output$lowest_unemployment <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_unemployment, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
     
      
      min(lines_data$Unemployment) %>%
        valueBox(subtitle = "Lowest unemployment percentage",color = "green")
      
    })
    
    #output$plot_country_data <- plotly::renderPlotly({
    #    country_filter()
    #})
    
    output$data_table <- DT::renderDT(DT::datatable(data_gdp))
    #output$plot_trendy_names <- renderPlot(mtcars$qsec)
    
    # Inflation (Petra)
    # ---------------------------------------------------------------------------ž
    output$lines_inflation <- plotly::renderPlotly({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_inflation, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        ) 
      
      lines_data_eu <- 
        subset(data_inflation, 
               Country == "European Union" &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      h1 <- lines_data %>%
        ggplot(aes(x = Date, y = Inflation, color = Country)) +
        geom_line(size = 0.8,aes(group=1))+
        geom_point(size = 1.8)+
        scale_color_manual(values = rev(wes_palette("Darjeeling1", 
                                                    length(unique(lines_data$Country)), 
                                                    type = "continuous"))) +
        theme(axis.text.x = element_text(angle = 75, hjust = 1)) +
        geom_hline(yintercept=mean(lines_data_eu$Inflation), linetype="dashed", color = "red")
      
      
      
      
      ggplotly(h1, height = 700)%>%
        layout(legend = list(orientation = "h", x = 0.3, y =-0.2))
      
    })
    
    

    
    output$bars_inflation <- plotly::renderPlotly({
      
      
      country_selected <- input$country
      year_from <- input$years[1]
      year_to <- input$years[2]
      
      
      bars_data <- 
        subset(data_inflation, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        ) 
      
      bars_data_agg_inflation <- aggregate(bars_data[,3], list(bars_data$Country), mean)
      
      h2 <- bars_data_agg_inflation%>%
        ggplot(aes(x = reorder(Group.1, Inflation), y = Inflation, fill = Group.1,
                   text = paste0(Group.1, " ", Inflation))) +
        geom_bar(stat = "identity", width = 0.5)
      
      ggplotly(h2, tooltip = "text", height = 600)
    })
    
    output$avg_inflation <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_inflation, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      round(mean(lines_data$Inflation), digits=2) %>%
        valueBox(subtitle = "Average inflation rate",color = "blue")
      
    })
    
    output$highest_inflation <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_inflation, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      max(lines_data$Inflation) %>%
        valueBox(subtitle = "Highest inflation rate",color = "red")
      
    })
    
    output$medial_inflation <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_inflation, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      median(lines_data$Inflation) %>%
        valueBox(subtitle = "Medial inflation rate",color = "yellow")
      
    })
    
    output$lowest_inflation <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_inflation, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      min(lines_data$Inflation) %>%
        valueBox(subtitle = "Lowest inflation rate",color = "green")
      
    })
    
    output$table_inflation <- DT::renderDT(DT::datatable(data_inflation))
    
    
    # Sentiment  (Petra)
    # ---------------------------------------------------------------------------
    
    output$lines_sentiment <- plotly::renderPlotly({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_sentiment, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        ) 
      
      lines_data_eu <- 
        subset(data_sentiment, 
               Country == "European Union" &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      h1 <- lines_data %>%
        ggplot(aes(x = Date, y = Sentiment, color = Country)) +
        geom_line(size = 0.8,aes(group=1))+
        geom_point(size = 1.8)+
        scale_color_manual(values = rev(wes_palette("Darjeeling1", 
                                                    length(unique(lines_data$Country)), 
                                                    type = "continuous"))) +
        theme(axis.text.x = element_text(angle = 75, hjust = 1)) +
        geom_hline(yintercept=100, linetype="dashed", color = "red")
      
      
      
      
      ggplotly(h1, height = 650)%>%
        layout(legend = list(orientation = "h", x = 0.3, y =-0.1))
      
    })
    
    # Value boxes
    output$avg_sentiment <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_sentiment, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      round(mean(lines_data$Sentiment), digits=2) %>%
        valueBox(subtitle = "Average sentiment", color = "blue")
      
    })
    
    output$bars_sentiment <- plotly::renderPlotly({
      
      
      country_selected <- input$country
      year_from <- input$years[1]
      year_to <- input$years[2]
      
      
      bars_data <- 
        subset(data_sentiment, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        ) 
      
      bars_data_agg_sentiment <- aggregate(bars_data[,3], list(bars_data$Country), mean)
      
      h2 <- bars_data_agg_sentiment%>%
        ggplot(aes(x = reorder(Group.1, Sentiment), y = Sentiment, fill = Group.1,
                   text = paste0(Group.1, " ", Sentiment))) +
        geom_bar(stat = "identity", width = 0.5) 
      
      ggplotly(h2, tooltip = "text", height = 600)
    })
    
    output$highest_sentiment <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_sentiment, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      max(lines_data$Sentiment) %>%
        valueBox(subtitle = "Highest sentiment",color = "green")
      
    })
    
    output$medial_sentiment <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_sentiment, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      median(lines_data$Sentiment) %>%
        valueBox(subtitle = "Medial sentiment",color = "yellow")
      
    })
    
    output$lowest_sentiment <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_sentiment, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      min(lines_data$Sentiment) %>%
        valueBox(subtitle = "Lowest sentiment",color = "red")
      
    })
    output$table_sentiment <- DT::renderDT(DT::datatable(data_sentiment))
    
    
    # Debt
    # ---------------------------------------------------------------------------
    output$lines_debt <- plotly::renderPlotly({
        
        year_from <- input$years[1]
        year_to <- input$years[2]
        country_selected <- input$country
        
        
        lines_data <- 
            subset(data_debt, 
                   Country %in% country_selected &
                       substr(Date,0,4) >= year_from &
                       substr(Date,0,4) <= year_to
            ) 
        
        lines_data_eu <- 
          subset(data_debt, 
                 Country == "European Union" &
                   substr(Date,0,4) >= year_from &
                   substr(Date,0,4) <= year_to
          )
        
        h1 <- lines_data %>%
            ggplot(aes(x = Date, y = Debt, color = Country)) +
            geom_line(size = 0.8,aes(group=1))+
            geom_point(size = 1.8)+
            scale_color_manual(values = rev(wes_palette("Darjeeling1", 
                                                        length(unique(lines_data$Country)), 
                                                        type = "continuous"))) +
            theme(axis.text.x = element_text(angle = 75, hjust = 1)) +
          geom_hline(yintercept=mean(lines_data_eu$Debt), linetype="dashed", color = "red")
        
        
        
        
        ggplotly(h1, height = 700)%>%
            layout(legend = list(orientation = "h", x = 0.3, y =-0.2))
        
    })
    
    output$bars_debt <- plotly::renderPlotly({
        
        
        country_selected <- input$country
        year_from <- input$years[1]
        year_to <- input$years[2]
        
        
        bars_data <- 
            subset(data_debt, 
                   Country %in% country_selected &
                       substr(Date,0,4) >= year_from &
                       substr(Date,0,4) <= year_to
            ) 
        
        bars_data_agg_debt <- aggregate(bars_data[,3], list(bars_data$Country), mean)
        
        h2 <- bars_data_agg_debt%>%
            ggplot(aes(x = reorder(Group.1, Debt), y = Debt, fill = Group.1,
                       text = paste0(Group.1, " ", Debt))) +
            geom_bar(stat = "identity", width = 0.5)
        
        ggplotly(h2, tooltip = "text", height = 600)
    })
    
    output$avg_debt <- renderValueBox({
        
        year_from <- input$years[1]
        year_to <- input$years[2]
        country_selected <- input$country
        
        
        lines_data <- 
            subset(data_debt, 
                   Country %in% country_selected &
                       substr(Date,0,4) >= year_from &
                       substr(Date,0,4) <= year_to
            )
        
        round(mean(lines_data$Debt), digits=2) %>%
            valueBox(subtitle = "Average debt", color = "blue")
        
    })
    
    output$highest_debt <- renderValueBox({
        
        year_from <- input$years[1]
        year_to <- input$years[2]
        country_selected <- input$country
        
        
        lines_data <- 
            subset(data_debt, 
                   Country %in% country_selected &
                       substr(Date,0,4) >= year_from &
                       substr(Date,0,4) <= year_to
            )
        
        max(lines_data$Debt) %>%
            valueBox(subtitle = "Highest debt",color = "red")
        
    })
    
    output$medial_debt <- renderValueBox({
        
        year_from <- input$years[1]
        year_to <- input$years[2]
        country_selected <- input$country
        
        
        lines_data <- 
            subset(data_debt, 
                   Country %in% country_selected &
                       substr(Date,0,4) >= year_from &
                       substr(Date,0,4) <= year_to
            )
        
        median(lines_data$Debt) %>%
            valueBox(subtitle = "Medial debt",color = "yellow")
        
    })
    
    output$lowest_debt <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_debt, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      min(lines_data$Debt) %>%
        valueBox(subtitle = "Lowest debt",color = "green")
      
    })
    # Registration  (Petra)
    # ---------------------------------------------------------------------------
    
    output$lines_registration <- plotly::renderPlotly({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_registration, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        ) 
      
      lines_data_eu <- 
        subset(data_registration, 
               Country == "European Union" &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      h1 <- lines_data %>%
        ggplot(aes(x = Date, y = Registration, color = Country)) +
        geom_line(size = 0.8,aes(group=1))+
        geom_point(size = 1.8)+
        scale_color_manual(values = rev(wes_palette("Darjeeling1", 
                                                    length(unique(lines_data$Country)), 
                                                    type = "continuous"))) +
        theme(axis.text.x = element_text(angle = 75, hjust = 1)) +
        geom_hline(yintercept=mean(lines_data_eu$Registration), linetype="dashed", color = "red")
      
      
      
      
      ggplotly(h1, height = 650)%>%
        layout(legend = list(orientation = "h", x = 0.3, y =-0.1))
      
    })
    
    # Value boxes
    output$avg_registration <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_registration, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      round(mean(lines_data$Registration), digits = 2) %>%
        valueBox(subtitle = "Average registration rate", color = "blue")
      
    })
    
    output$bars_registration <- plotly::renderPlotly({
      
      
      country_selected <- input$country
      year_from <- input$years[1]
      year_to <- input$years[2]
      
      
      bars_data <- 
        subset(data_registration, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        ) 
      
      bars_data_agg_registration <- aggregate(bars_data[,3], list(bars_data$Country), mean)
      
      h2 <- bars_data_agg_registration%>%
        ggplot(aes(x = reorder(Group.1, Registration), y = Registration, fill = Group.1,
                   text = paste0(Group.1, " ", Registration))) +
        geom_bar(stat = "identity", width = 0.5)
      
      ggplotly(h2, tooltip = "text", height = 600)
    })
    
    output$highest_registration <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_registration, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      max(lines_data$Registration) %>%
        valueBox(subtitle = "Highest registration rate",color = "green")
      
    })
    
    output$medial_registration <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_registration, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      median(lines_data$Registration) %>%
        valueBox(subtitle = "Medial registration rate",color = "yellow")
      
    })
    
    output$lowest_registration <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_registration, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      min(lines_data$Registration) %>%
        valueBox(subtitle = "Lowest registration rate",color = "red")
      
    })
    output$table_registration <- DT::renderDT(DT::datatable(data_registration))
    # Bankruptcy  (Petra)
    # ---------------------------------------------------------------------------
    
    output$lines_bankruptcy <- plotly::renderPlotly({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_bankruptcy, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        ) 
      
      lines_data_eu <- 
        subset(data_bankruptcy, 
               Country == "European Union" &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      h1 <- lines_data %>%
        ggplot(aes(x = Date, y = Bankruptcy, color = Country)) +
        geom_line(size = 0.8,aes(group=1))+
        geom_point(size = 1.8)+
        scale_color_manual(values = rev(wes_palette("Darjeeling1", 
                                                    length(unique(lines_data$Country)), 
                                                    type = "continuous"))) +
        theme(axis.text.x = element_text(angle = 75, hjust = 1)) + 
        geom_hline(yintercept=mean(lines_data_eu$Bankruptcy), linetype="dashed", color = "red")
      
      
      
      
      ggplotly(h1, height = 650)%>%
        layout(legend = list(orientation = "h", x = 0.3, y =-0.1))
      
    })
    
    # Value boxes
    output$avg_bankruptcy <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_bankruptcy, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
    
      
      round(mean(lines_data$Bankruptcy), digits = 2) %>%
        valueBox(subtitle = "Average bankruptcy rate", color = "blue")
      
    })
    
    output$bars_bankruptcy <- plotly::renderPlotly({
      
      
      country_selected <- input$country
      year_from <- input$years[1]
      year_to <- input$years[2]
      
      
      bars_data <- 
        subset(data_bankruptcy, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        ) 
      
      bars_data_agg_bankruptcy <- aggregate(bars_data[,3], list(bars_data$Country), mean)
      
      h2 <- bars_data_agg_bankruptcy%>%
        ggplot(aes(x = reorder(Group.1, Bankruptcy), y = Bankruptcy, fill = Group.1,
                   text = paste0(Group.1, " ", Bankruptcy))) +
        geom_bar(stat = "identity", width = 0.5)
      
      ggplotly(h2, tooltip = "text", height = 600)
    })
    
    output$highest_bankruptcy <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_bankruptcy, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      max(lines_data$Bankruptcy) %>%
        valueBox(subtitle = "Highest bankruptcy rate",color = "red")
      
    })
    
    output$medial_bankruptcy <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_bankruptcy, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      median(lines_data$Bankruptcy) %>%
        valueBox(subtitle = "Medial bankruptcy rate",color = "yellow")
      
    })
    
    output$lowest_bankruptcy <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_bankruptcy, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      min(lines_data$Bankruptcy) %>%
        valueBox(subtitle = "Lowest bankruptcy rate",color = "green")
      
    })
    output$table_bankruptcy <- DT::renderDT(DT::datatable(data_bankruptcy))
    # Surplus deficit
    # ---------------------------------------------------------------------------
    output$lines_surplus <- plotly::renderPlotly({
        
        year_from <- input$years[1]
        year_to <- input$years[2]
        country_selected <- input$country
        
        
        lines_data <- 
            subset(data_surplus, 
                   Country %in% country_selected &
                       substr(Date,0,4) >= year_from &
                       substr(Date,0,4) <= year_to
            ) 
        
        lines_data_eu <- 
          subset(data_surplus, 
                 Country == "European Union" &
                   substr(Date,0,4) >= year_from &
                   substr(Date,0,4) <= year_to
          )
        
        h1 <- lines_data %>%
            ggplot(aes(x = Date, y = SurplusDeficit, color = Country)) +
            geom_line(size = 0.8,aes(group=1))+
            geom_point(size = 1.8)+
            scale_color_manual(values = rev(wes_palette("Darjeeling1", 
                                                        length(unique(lines_data$Country)), 
                                                        type = "continuous"))) +
            theme(axis.text.x = element_text(angle = 75, hjust = 1)) +
          geom_hline(yintercept=mean(lines_data_eu$SurplusDeficit), linetype="dashed", color = "red")
        
        
        
        
        ggplotly(h1, height = 650)%>%
            layout(legend = list(orientation = "h", x = 0.3, y =-0.1))
        
    })
    
    output$bars_surplus<- plotly::renderPlotly({
        
        
        country_selected <- input$country
        year_from <- input$years[1]
        year_to <- input$years[2]
        
        
        bars_data <- 
            subset(data_surplus, 
                   Country %in% country_selected &
                       substr(Date,0,4) >= year_from &
                       substr(Date,0,4) <= year_to
            ) 
        
        bars_data_agg_surplus <- aggregate(bars_data[,3], list(bars_data$Country), mean)
        
        h2 <- bars_data_agg_surplus%>%
            ggplot(aes(x = reorder(Group.1, SurplusDeficit), y = SurplusDeficit, fill = Group.1,
                       text = paste0(Group.1, " ", SurplusDeficit))) +
            geom_bar(stat = "identity", width = 0.5)
        
        ggplotly(h2, tooltip = "text", height = 600)
    })
    
    output$avg_surplus <- renderValueBox({
        
        year_from <- input$years[1]
        year_to <- input$years[2]
        country_selected <- input$country
        
        
        lines_data <- 
            subset(data_surplus, 
                   Country %in% country_selected &
                       substr(Date,0,4) >= year_from &
                       substr(Date,0,4) <= year_to
            )
        
        round(mean(lines_data$SurplusDeficit), digits=2) %>%
            valueBox(subtitle = "Average surplus deficit", color = "blue")
        
    })
    
    output$highest_surplus <- renderValueBox({
        
        year_from <- input$years[1]
        year_to <- input$years[2]
        country_selected <- input$country
        
        
        lines_data <- 
            subset(data_surplus, 
                   Country %in% country_selected &
                       substr(Date,0,4) >= year_from &
                       substr(Date,0,4) <= year_to
            )
        
        max(lines_data$SurplusDeficit) %>%
            valueBox(subtitle = "Highest surplus deficit",color = "green")
        
    })
    
    output$medial_surplus <- renderValueBox({
        
        year_from <- input$years[1]
        year_to <- input$years[2]
        country_selected <- input$country
        
        
        lines_data <- 
            subset(data_surplus, 
                   Country %in% country_selected &
                       substr(Date,0,4) >= year_from &
                       substr(Date,0,4) <= year_to
            )
        
        median(lines_data$SurplusDeficit) %>%
            valueBox(subtitle = "Medial surplus deficit",color = "yellow")
        
    })
    
    output$lowest_surplus <- renderValueBox({
      
      year_from <- input$years[1]
      year_to <- input$years[2]
      country_selected <- input$country
      
      
      lines_data <- 
        subset(data_surplus, 
               Country %in% country_selected &
                 substr(Date,0,4) >= year_from &
                 substr(Date,0,4) <= year_to
        )
      
      min(lines_data$SurplusDeficit) %>%
        valueBox(subtitle = "Lowest surplus deficit",color = "red")
      
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
