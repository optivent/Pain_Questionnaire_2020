# prepare Github
# library(usethis)
# ?use_github
# edit_r_environ()
# use_github(protocol = 'https', auth_token = Sys.getenv("GITHUB_PAT"))
##

#import data
library(tidyverse)
library(readxl)
library(here) 
library(janitor)

repetitive <- read_xlsx(path = here("input/Datenerfassung.xlsx"), range = cell_cols("A:CZ")) %>% 
  rename(Pat = 'Nr.') %>% 
  dplyr::select(-matches("Freitext|sonstige")) %>% 
  janitor::clean_names() %>% 
  select(-c(besondere_grunde, andere_auffalligkeiten))

pat1 <- data %>% filter(Pat == 1)
pat1 %>% View()
