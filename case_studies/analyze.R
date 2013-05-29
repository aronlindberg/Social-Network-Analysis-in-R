setwd("~/github/local/Social-Network-Analysis-in-R/case_studies/")
# source("http://sna.stanford.edu/setup.R")

sink("outfile.txt")
readLines("http://sna.stanford.edu/setup.R")
sink()

library(igraph)