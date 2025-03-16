# Load necessary libraries
library(tidyverse)
library(igraph)
library(tidytext)
library(tm)
library(widyr)

# Load the dataset
data <- read.csv("nobel-prize-winners-1.csv", stringsAsFactors = FALSE)

# Data Cleaning
# Remove empty rows and duplicates
data <- data %>% distinct() %>% na.omit(subset = c("motivation"))

# Standardize text columns
data$name <- str_trim(data$name)
data$category <- str_to_lower(data$category)
data$motivation <- str_to_lower(data$motivation)

# Convert date columns to Date format
data$born <- as.Date(data$born, format="%Y-%m-%d")
data$died <- as.Date(data$died, format="%Y-%m-%d")

# Network Text Analysis
# Tokenization
tokens <- data %>%
  unnest_tokens(word, motivation) %>%
  anti_join(stop_words, by="word") # Remove common stop words

# Create word co-occurrence matrix
word_pairs <- tokens %>%
  pairwise_count(word, name, sort = TRUE)

# Build network graph
graph <- graph_from_data_frame(word_pairs, directed = FALSE)

# Plot the network
plot(graph, vertex.size=4, 
     vertex.color = "#0046B8", 
     vertex.label.color = 'lightgray',
     vertex.label.cex = 0.5,
     edge.arrow.size = 0.5,
     edge.color = '#272727', 
     asp = 0)
