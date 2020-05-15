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
  select(-c(besondere_grunde, andere_auffalligkeiten, id)) %>% 
  filter(time != "t0_periop")

repetitive %>% dplyr::select(matches("pat|time|ibu|pcm|nova|nalbu|dipi|Analgetika")) %>%
  rename(analgetics_home = analgetika) %>% 
  select(sort(tidyselect::peek_vars())) %>% 
  select(pat, time, everything()) %>% 
  mutate_at(vars(matches("home")), ~ ifelse(. == "NA", 1, .))
  
  mutate_all(~na_if(., "NA")) %>% mutate_all(~ replace_na(.,0)) %>% 
  mutate_at(vars(-pat, - time), ~ ifelse(. == 0, 0, 1)) %>% 
  rowwise() %>% 
  mutate(
    dipidolor = dipidolor_13 + dipidolor_27,
    nalbuphin = nalbuphin_11 + nalbuphin_28 + nalbuphin_38,
    ibuprofen = ibu_oral_22 + ibu_oral_43 + ibu_oral_7 + ibu_rekt_23 + ibu_rekt_8 + ibu_rektal,
    novalgin = novalgin_12 + novalgin_26,
    paracetamol = pcm_oral_24 + pcm_oral_45 + pcm_oral_9 + pcm_rekt_10 + pcm_rekt_25 + pcm_rektal
         ) %>% 
  select(pat, time, ibuprofen, novalgin, paracetamol, nalbuphin, dipidolor) ->
analgetics

analgetics %>% group_by(pat) %>% summarise_at(vars(ibuprofen:dipidolor), list(sum))
  
