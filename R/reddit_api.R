# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(jsonlite)

# Data Import and Cleaning
#used fromJSON to read in content from reddit link because listed as a json file in reddit api documentation. 
rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json", flatten = TRUE)

#looking at rstats list, the title, upvotes and comments are listed as element children, extract
rstats_original_tbl <- rstats_list$data$children

#create new tbl selecting the elements we need, used select to pick the specific variables
rstats_tbl <- rstats_original_tbl %>%
  select(post = data.title, 
         upvotes = data.ups,
         comments = data.num_comments)


#Visualizatoin
#uses ggplot to display scatterplot
ggplot(rstats_tbl, aes(x=upvotes, y=comments))+
  geom_smooth()+
  geom_point()

#Analysis
#uses cor.test to calculate the correlation between upvotes and comements, creates an object that can be called later for displaying the publication data
correlationAPI <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)

#Publication
#displays the correlation to specifcations using the object created in previous step, setting the correct number of decimal places. uses paste0 because 
paste0("The correlation between upvotes and comments was r", "(", correlationAPI$parameter[[1]] ,") = ",round(correlationAPI$estimate,2), ", p = ",  round(correlationAPI$p.value,2), ". This test was not statistically significant.")

