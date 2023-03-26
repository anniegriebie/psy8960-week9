#Script Settings and Resources
library(tidyverse)
library(rvest)

#Data Import and Cleaning
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

