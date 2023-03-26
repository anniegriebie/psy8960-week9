# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(jsonlite)

# Data Import and Cleaning
#used fromJSON to read in content from reddit link because listed as a json file in reddit api documentation. 
rstats_list <- fromJSON("https://www.reddit.com/r/rstats/.json", flatten = TRUE)
