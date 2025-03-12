options(shiny.port = 8050, shiny.autoreload = TRUE)

# read in data
episodes <- read_csv('../data/clean/episodes.csv')
characters <- read_csv('../data/clean/episodes.csv')

# episode rating plot function
ratings_map <- function(min_season,max_season) {
  plot <- episodes |> 
    filter(between(season, min_season,max_season)) |> 
    ggplot(aes(x=season,y=no_of_episode_season,fill = imdb_rating)) +
    geom_tile() + 
    scale_fill_gradient(low = "red", high = "blue",limit=c(4,9.5)) + 
    labs(title = "Average Ratings", y = "Episode", x = "Season",fill='Rating') + 
    theme(plot.title = element_text(hjust = 0.5))
  
  return(plot)
}





# page layout
ui <- page_fluid(
  theme = bs_theme(),
  
  
  
  
  
)


# Server side callbacks/reactivity
server <- function(input, output, session) {}

shinyApp(ui, server)