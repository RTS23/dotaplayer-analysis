library(tidyverse)
library(dplyr)
library(ggplot2)
library(lubridate)
library(readr)


bachelor_raw <- read_csv("database/bachelor_raw.csv")
povidone_raw <- read_csv("database/povidone_raw.csv")

bachelor_raw$start_time <- 
  bachelor_raw$start_time %>% 
  as.POSIXct(origin="1970-01-01") %>% 
  as.Date()

povidone_raw$start_time <-
  povidone_raw$start_time %>% 
  as.POSIXct(origin = "1970-01-01") %>% 
  as.Date()

subset_povidone <- subset(povidone_raw, start_time > "2020-01-01")
subset_bachelor <- subset(bachelor_raw, start_time > "2021-09-01")

merged_data <- rbind(subset_bachelor,subset_povidone)

write.csv(merged_data,"Database/merged_data.csv")