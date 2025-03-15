# Holy Crap, a Family Guy Dashboard!

Family Guy is a very popular and successful TV Show, spanning 23 seasons and
over 430 episodes. This makes it very hard for fans to easily find their favourite 
episodes. This dashboard addresses this problem by allowing fans to search for
episodes by season, ratings, and featured character appearances.
When the user selects their preferences, the table will show all
episodes that meet their criteria, Paired with an interactive heatmap of
ratings, so they can see where the show peaked and fell in success across its lifetime. Freakin' sweet!

This dashbard uses the [Family Guy Episode Info](https://www.kaggle.com/datasets/zeesolver/family) 
dataset obtained from Kaggle. It contains data on 400 Family Guy episodes,
including the season and episode number featured characters, writers, IMDB ratings,
viewer counts, and a synopsis.

# View the App

The app can be viewed [here.](https://connect.posit.cloud/bfrizzell01/content/019596dd-edc3-c272-7263-8a2388c1466f)

# Installation and Usage

Alternatively, you can download this repository and run the app locally. To do so:

1. Clone this repository by copying this command into your terminal:

```bash
git clone git@github.com:bfrizzell01/family-guy-dashboard.git
```

2. Open up an R console and install the `renv` package if you don't already have it installed:

```r
install.packages("renv")
```

3. Set the root directory of this repo as your working directory, install the necessary deependencies for the dashboard, and then activate the environment:

```r
renv::restore()
renv::activate()
```

4. Execute the following command in your R console to run the app. This will open a panel to view the app:

```r
shiny::runApp("src/app.R")
```

To view the app in your browswer, copy the URL into your browser to view the dashboard:

```
http://127.0.0.1:8050/
```

![](img/family-guy-happy-dance.gif)
