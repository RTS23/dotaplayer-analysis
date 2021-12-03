library(tidyverse)
library(dplyr)
library(ggplot2)
library(lubridate)
library(readr)

#importing match data from opendota
matchdata <- read_csv("database/merged_data.csv")

#importing heroes data from opendota
heroes <- read_csv("database/heroes.csv")

#importing game mode data from opendota
game_mode <- read_csv("database/game_mode.csv")

#importing game ID data from opendota
item_id <- read_csv("database/item_id.csv")

#changing column names on data for merging
colnames(heroes)[1] <- "hero_id"
colnames(game_mode)[2] <- "lobby_type"

#getting heroes name, heroes attribute, attack type and roles from heroes data
mergedheroes <- merge(x=matchdata,y=heroes[ ,c("hero_id","localized_name","primary_attr","attack_type","roles/0")],by="hero_id",all.x = TRUE)

#getting game mode name
mergedheroes <- merge(x=mergedheroes,y=game_mode[ ,c('lobby_type','localized_name')],by="lobby_type",all.x = TRUE)

#getting item id
mergedheroes <- left_join(mergedheroes,item_id,by=c("item_0" = "item_id"))
mergedheroes <- left_join(mergedheroes,item_id,by=c("item_1" = "item_id"))
mergedheroes <- left_join(mergedheroes,item_id,by=c("item_2" = "item_id"))
mergedheroes <- left_join(mergedheroes,item_id,by=c("item_3" = "item_id"))
mergedheroes <- left_join(mergedheroes,item_id,by=c("item_4" = "item_id"))
mergedheroes <- left_join(mergedheroes,item_id,by=c("item_5" = "item_id"))

#dropping unused matchdata
mergedheroes <- mergedheroes[,-c(1,2,3,7,12:19)]

#changing column names to avoid confusion on column names
colnames(mergedheroes)[16] <- "game_mode"
colnames(mergedheroes)[12] <- "hero_name"
colnames(mergedheroes)[15] <- "role"
colnames(mergedheroes)[17] <- "item_1"
colnames(mergedheroes)[18] <- "item_2"
colnames(mergedheroes)[19] <- "item_3"
colnames(mergedheroes)[20] <- "item_4"
colnames(mergedheroes)[21] <- "item_5"
colnames(mergedheroes)[22] <- "item_6"

#changing duration to minutes
mergedheroes$duration <- mergedheroes$duration/60
mergedheroes$duration <- format(round(mergedheroes$duration, 2), nsmall = 2)

#defining side
mergedheroes <- mutate(mergedheroes, side = ifelse(player_slot <= 127, "Radiant","Dire"))

#defining win lose based on radiant_win and lobby type variable
mergedheroes <- mutate(mergedheroes,winlose = ifelse(player_slot <= 127 & radiant_win,"Win",ifelse(player_slot > 127 & radiant_win == FALSE,"Win","Lose")),player_slot = NULL,radiant_win = NULL)

#checking if there is NA value in the data
sum(is.na(mergedheroes))

#Since there are NA values, we check which column contain NA
colnames(mergedheroes)[colSums(is.na(mergedheroes))>0]

#Because item column indicates NA, this is because there are no item bought
#we can change all NA to no_item
mergedheroes[is.na(mergedheroes)] <- "no_item"

#recheck if there is NA value in the data
sum(is.na(mergedheroes))

#writing cleaned data to csv
write.csv(mergedheroes,"database/cleaned_data.csv")
