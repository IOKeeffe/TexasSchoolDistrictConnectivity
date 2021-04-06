library(tidyverse)
connectivity_data <- read.csv("ACSST5Y2019.S2802_data_with_overlays_2021-04-02T110607.csv") %>%
  mutate(NAME = tolower(str_replace(NAME, "Independent School District, Texas", "")))
district_data <- read.csv("Enrollment Report_Statewide_Districts_Gender_2019-2020.csv") %>%
  mutate(DISTRICT.NAME = tolower(str_replace(DISTRICT.NAME, "ISD", "")))

combined_frame <- left_join(connectivity_data, district_data, by=c("NAME"="DISTRICT.NAME")) %>%
  mutate(NAME = str_to_title(NAME))
