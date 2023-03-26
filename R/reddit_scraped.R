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