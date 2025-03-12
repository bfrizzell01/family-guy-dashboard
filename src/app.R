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
    scale_fill_gradient(low = "red", high = "blue",limit=c(4.1,9.1)) + 
    labs(title = "Average Ratings", y = "Episode", x = "Season",fill='Rating') + 
    scale_x_continuous(breaks = seq(min_season, max_season,1)) +
    scale_y_continuous(breaks=0:30,limits = c(0,31)) + 
    theme(plot.title = element_text(hjust = 0.5))
  
  return(plot)
}

# get table filtered by season,rating, and selected characters
filter_table <- function(min_season,max_season,
                         min_rating,max_rating,
                         selected_characters){
  
  # if no selected characters, don't filter for characters
  if (all(selected_characters == '')){
    filtered_episodes <- episodes |> 
      filter(
        between(season, min_season,max_season),
        between(imdb_rating,min_rating,max_rating)) |> 
      select(imdb_rating,season,no_of_episode_season,title,synopsis) |> 
      rename(
        Rating = imdb_rating,
        Season = season, 
        Episode = no_of_episode_season,
        Title = title,
        Synopsis = synopsis) |> 
      arrange(Season,Episode)
  }
  else {
    
    # get episodes with selected characters
    ep_ids_with_characters <- characters |> 
      filter(characters %in% selected_characters) |> 
      pull(id) |> 
      unique()
    
    # filter and clean episodes characters
    filtered_episodes <- episodes |> 
      filter(
        id %in% ep_ids_with_characters,
        between(season, min_season,max_season),
        between(imdb_rating,min_rating,max_rating)) |> 
      select(imdb_rating,season,no_of_episode_season,title,synopsis) |> 
      rename(
        Rating = imdb_rating,
        Season = season, 
        Episode = no_of_episode_season,
        Title = title,
        Synopsis = synopsis) |> 
      arrange(Season,Episode)
    
  }
  
  filtered_episodes$Episode <- formatC(filtered_episodes$Episode, digits = 2)
  filtered_episodes$Season <- formatC(filtered_episodes$Season, digits = 2)
  
  return(filtered_episodes)
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
    "character_selection",
    "",
    choices = NULL,
    multi=TRUE,
    options = list(
      placeholder = 'Select Character'
      )
    ),
  
    # ratings plot
    plotOutput("ratings_plot", width = "400px"),
  
    # table
    tableOutput('table')

)


# Server side callbacks/reactivity
server <- function(input, output, session) {
  
  # Enables faster server-side processing of character input
  updateSelectizeInput(session, "character_selection",
                       choices = unique_characters,
                       server = TRUE) 
  
  # render ratings plot
  output$ratings_plot <- renderPlot(
    ratings_map(
      input$season_slider[1],input$season_slider[2],
      input$ratings_slider[1],input$ratings_slider[2]
      )
    )
  
  # render episodes table
  output$table <- renderTable(
    filter_table(
      input$season_slider[1],input$season_slider[2],
      input$ratings_slider[1],input$ratings_slider[2],
      input$character_selection
    ),
    digits = 1,
    spacing = 'xs'
  )
  
  
}
  

shinyApp(ui, server)