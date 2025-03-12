library(shiny)
library(ggplot2)
library(tidyr)
library(bslib)

options(shiny.port = 8050, shiny.autoreload = TRUE)

# read in data
episodes <- read_csv('../data/clean/episodes.csv')
characters <- read_csv('../data/clean/characters.csv')
unique_characters <- unique(characters$characters)

# episode rating plot function
ratings_map <- function(min_season,max_season,min_rating,max_rating) {
  plot <- episodes |> 
    filter(between(season, min_season,max_season),
           between(imdb_rating,min_rating,max_rating)) |> 
    ggplot(aes(x=season,y=no_of_episode_season,fill = imdb_rating)) +
    geom_tile() + 
    scale_fill_gradient(low = "red", high = "blue",limit=c(4,9.5)) + 
    labs(title = "Average Ratings", y = "Episode", x = "Season",fill='Rating') + 
    scale_x_continuous(breaks = seq(min_season, max_season,1)) +
    scale_y_continuous(breaks=0:30,limits = c(0,31)) + 
    theme(plot.title = element_text(hjust = 0.5))
  
  return(plot)
}




# page layout
ui <- page_fluid(
  theme = bs_theme(),
  
  # season slider
  sliderInput("season_slider", 
              "Season", 
              min = 1, max = 21, 
              value = c(1,21),
              step = 1,
              ticks = FALSE),
  
  # ratings slider
  sliderInput("ratings_slider", 
              "IMDb Rating", 
              min = 4.0, max = 9.5, 
              value = c(4.0,9.5),
              step = 0.1,
              ticks = FALSE),
  
  
  # character search dropdown
  selectizeInput(
    "character_input",
    "",
    choices = NULL, ,
    multi=TRUE,
    options = list(
      placeholder = 'Select Character'
      )
    ),
    plotOutput("ratings_plot", width = "400px"),
  
  
  
  
  
  
  
  
)


# Server side callbacks/reactivity
server <- function(input, output, session) {
  
  # Enables faster server-side processing of character input
  updateSelectizeInput(session, "character_input",
                       choices = unique_characters,
                       server = TRUE) 
  
  output$ratings_plot <- renderPlot({
    return(
    ratings_map(
      input$season_slider[1],input$season_slider[2],
      input$ratings_slider[1],input$ratings_slider[2]
    ))
  })
  
}
  

shinyApp(ui, server)