## Script Settings and Resources
library(tidyverse)
library(rvest)

## Data Import and Cleaning
#using read_html to read in file
rstats_html <- read_html("https://old.reddit.com/r/rstats/")

#generating text elements using xpaths
post_text <- rstats_html %>%
  html_elements(xpath = "//div[contains(@class, 'even') or contains(@class, 'odd')]//a[contains(@class, 'title may-blank')]") %>%
  html_text()

#generating text elements using xpaths
upvotes_text <- rstats_html %>%
  html_elements(xpath = "//div[contains(@class, 'even') or contains(@class, 'odd')]//div[@class = 'score unvoted']")%>%
  html_text()

#generating text elements using xpaths
comments_text <- rstats_html %>%
  html_elements(xpath = "//div[contains(@class, 'even') or contains(@class, 'odd')]//div[@class = 'entry unvoted']//li[position() = 1]") %>%
  html_text()

#cleaning all of the text elements to go into tbl. 
#post element is good as is
post <- post_text 
#upvotes need to be changed from character to numeric and also have NA values replaced with 0 to go into correlation
upvotes <- upvotes_text %>%
  as.numeric() %>%
  replace_na(0)
#comments needs to be changed from character to numeric and also have NA replaced with 0 to go into correlation
comments <- comments_text%>%
  str_extract(pattern = "\\d+") %>%
  as.numeric() %>%
  replace_na(0)


#putting elements into tbl and converting upvotes and comments into text
rstats_tbl <- tibble(
  post,
  upvotes,
  comments
)


## Visualization
#uses ggplot to display scatterplot
ggplot(rstats_tbl, aes(x=upvotes, y=comments))+
  geom_smooth()+
  geom_point()

## Analysis
#running correlation using cor.test
correlationWEB <- cor.test(rstats_tbl$upvotes, rstats_tbl$comments)

 

## Publication 
#"The correlation between upvotes and comments was r(23) = .07, p = .73. This test was not statistically significant."
#displays the correlation to specifcations using the object created in previous step setting the correct number of decimal places. Edited to added str_remove to remove leading decimal. 
paste0("The correlation between upvotes and comments was r", "(", correlationWEB$parameter[[1]] ,") = ",str_remove(round(correlationWEB$estimate,2),"^0+"), ", p = ",  str_remove(round(correlationWEB$p.value,2),"^0+") , ". This test was not statistically significant.")
