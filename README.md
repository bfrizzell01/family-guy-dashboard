# Holy Crap, a Family Guy Dashboard!

Family Guy is a very popular and successful TV Show, spanning 23 seasons and
over 430 episodes. This makes it very hard for fans to easily find their favourite 
episodes. This dashboard addresses this problem by allowing fans to find their
favourite episodes by filtering by season, ratings, and featured character
appearances. When the user selects their preferences, the table will show all
episodes that meet their criteria, with a brief synopsis. They can also see a time series of
ratings, so they can watch the best episodes. Freakin' sweet!

This dashbard uses the [Family Guy Episode Info](https://www.kaggle.com/datasets/zeesolver/family) 
dataset obtained from Kaggle. It contains data on 400 Family Guy episodes,
including the season and episode number featured characters, writers, IMDB ratings,
viewer counts, and a synopsis.

# App Demo

# Installation and Usage

1. Clone this repository by copying this command into your terminal:

```bash
git clone git@github.com:bfrizzell01/family-guy-dashboard.git
```

2. Open up an R console and install the `renv` package if you don't already have it installed:

```r
install.packages("renv")
```
3. Set the root directory of this repo as your working directory, and install the necessary deependencies for the dashboard:

```r
renv::restore()
```

4. Execute the following command in your R console to run the app:

```r
shiny::runApp("src/app.R")
```

5. Copy the URL into your browser to view the dashboard:

![](img/family-guy-happy-dance.gif)
