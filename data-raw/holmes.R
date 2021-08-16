## code to prepare `holmes` dataset goes here

library(tidyverse)
library(rvest)

text <- read_lines("https://sherlock-holm.es/stories/plain-text/cnus.txt")

toc <- text[13:72]

books <- toc %>%
  str_subset("^               [:alnum:]") %>%
  str_trim() %>%
  str_subset("Preface", TRUE)

first_true <- function(x) {
  rle_x <- rle(x)
  c(1, cumsum(rle_x$lengths) + 1)[rle_x$values]
}

holmes <- tibble(text = text) %>%
  slice(-(1:80)) %>%
  slice(-min(which((str_trim(text)) == "HIS LAST BOW"))) %>%
  mutate(book = cumsum((str_trim(text)) %in% str_to_upper(books))) %>%
  filter(book > 0) %>%
  mutate(text = str_trim(text)) %>%
  slice(-setdiff(which(text == ""), first_true(text == ""))) %>%
  mutate(book = books[book])

usethis::use_data(holmes, overwrite = TRUE)
