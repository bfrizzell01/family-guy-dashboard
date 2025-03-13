library(shiny)
library(ggplot2)
library(tidyverse)
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
    labs(y = "Episode", x = "Season",fill='Rating') + 
    scale_x_continuous(breaks = seq(min_season, max_season,1)) +
    scale_y_continuous(breaks=0:30,limits = c(0,31)) 
  
    return(plot)
}

# get table filtered by season,rating, and selected characters
filter_table <- function(min_season,max_season,
                         min_rating,max_rating,
                         selected_characters,
                         sort_option){
  
  # if no selected characters, don't filter for characters
  if (all(selected_characters == '')){
    filtered_episodes <- episodes |> 
      filter(
        between(season, min_season,max_season),
        between(imdb_rating,min_rating,max_rating)) |> 
      select(imdb_rating,season,no_of_episode_season,title) |> 
      rename(
        Rating = imdb_rating,
        Season = season, 
        Episode = no_of_episode_season,
        Title = title)
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
      select(imdb_rating,season,no_of_episode_season,title) |> 
      rename(
        Rating = imdb_rating,
        Season = season, 
        Episode = no_of_episode_season,
        Title = title) 
  }
  
  # format episode and season
  filtered_episodes$Episode <- formatC(filtered_episodes$Episode, digits = 2)
  filtered_episodes$Season <- formatC(filtered_episodes$Season, digits = 2)
  
  # sort by option
  if (sort_option == 'Rating (Best to Worst)'){
    filtered_episodes <- filtered_episodes |> arrange(desc(Rating))
    
  } else if (sort_option == 'Rating (Worst to Best)') {
    filtered_episodes <- filtered_episodes |> arrange(Rating)
  } else {
    filtered_episodes <- filtered_episodes |> arrange(Season,Episode)
  }
  
  return(filtered_episodes)
}

# card component for settings
settings_card <- card(
  card_header('Settings'),
  card_body(
    layout_column_wrap(
      width = 1,
      gap = "5px",
      # Dropdowns on top
      layout_columns(
        widths = c(6, 6),  # Equal width for dropdowns
        selectizeInput(
          "character_selection",
          "Character",
          choices = NULL,
          multi=TRUE,
          options = list(placeholder = 'Select Character')
        ),
        selectizeInput(
          "sorting_selection",
          "Sort By",
          choices = c('','Season','Rating (Best to Worst)','Rating (Worst to Best)'),
          multi = FALSE,
          options = list(placeholder = 'Sort Table By:')
        )
      ),
      
      # Sliders on bottom
      layout_columns(
        widths = c(6, 6),  # Equal width for both sliders
        sliderInput(
          "season_slider", 
          "Season", 
          min = 1, max = 21, 
          value = c(1,21),
          step = 1,
          ticks = FALSE
        ),
        sliderInput(
          "ratings_slider", 
          "IMDb Rating", 
          min = 4.0, max = 9.5, 
          value = c(4.0,9.5),
          step = 0.1,
          ticks = FALSE
        )
      )
    
    )
  )
)


# card component for ratings heatmap
heatmap_card <- card(
  card_header('IMDb Ratings'),
  plotOutput("ratings_plot")
)


# card component for table
table_card <- card(
  card_header('Episodes'),
  div(
    style = "overflow-y: auto; height: 800px;",  # Set height and enable scrolling
    tableOutput('table')
  )
)

# page layout
ui <- fluidPage(
  theme = bs_theme(),
  titlePanel('A Freakin\' Sweet Family Guy Dashboard!'),
  
  layout_column_wrap(
    width = 1/2,
    table_card,
    layout_column_wrap(
      width = 1,
      heights_equal = "row",
      heatmap_card,settings_card
    )
  )

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
      input$season_slider[1], input$season_slider[2],
      input$ratings_slider[1], input$ratings_slider[2],
      input$character_selection,
      input$sorting_selection
    ),
    digits = 1
  )
  
}


shinyApp(ui, server)