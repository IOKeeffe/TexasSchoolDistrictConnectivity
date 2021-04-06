library(tidyverse)
connectivity_data <- read.csv("ACSST5Y2019.S2802_data_with_overlays_2021-04-02T110607.csv", header=T) %>%
  mutate(NAME = tolower(str_replace(NAME, "Independent School District, Texas", "")))

district_data <- read.csv("Enrollment Report_Statewide_Districts_Gender_2019-2020.csv") %>%
  mutate(DISTRICT.NAME = tolower(str_replace(DISTRICT.NAME, "ISD", "")))

combined_frame <- left_join(connectivity_data, district_data, by=c("NAME"="DISTRICT.NAME")) %>%
  mutate(population_under_18 = S2802_C01_002E) %>%
  mutate(population_with_broadband_under_18 = S2802_C02_002E) %>%
  summarize(population_under_18, population_with_broadband_under_18, REGION)
combined_frame = combined_frame[-1,]
combined_frame <- combined_frame %>%
  group_by(REGION) %>%
  mutate(population_under_18 = sum(as.numeric(population_under_18))) %>%
  mutate(population_with_broadband_under_18 = sum(as.numeric(population_with_broadband_under_18))) %>%
  mutate(population_percent_with_broadband_under_18 = round(population_with_broadband_under_18 / population_under_18 * 100, digits=2)) %>%
  summarize(
    population_percent_with_broadband_under_18,
    population_under_18,
    population_with_broadband_under_18,
    REGION,
    .groups="keep"
  ) %>%
  distinct()

