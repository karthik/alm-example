library(rAltmetric)
library(tidyverse)
dft5_copy <- read_csv("dft5_copy.csv")

ids <- dft5_copy$pmid

safe_altmetrics <- purrr::safely(altmetrics, otherwise = NULL)
alm <- function(x)  safe_altmetrics(pmid = x)
# Now we make the API call
# requests <- map(ids, alm) 
# This call takes a long time. Since I already ran it for you
# Just run
requests <- readRDS(file = "requests")



results <- requests %>%  
  map("result") %>% 
  compact(.) %>% 
  modify_depth(1, altmetric_data)

data <- bind_rows(results) %>% select(doi, contains("cited"))

write_csv(data, file = "data.csv")
