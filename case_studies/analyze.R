# Setup
setwd("~/github/local/Social-Network-Analysis-in-R/data/django_django/")
# turn on the command below to output to a text-file.
# sink("outfile.txt")
library(igraph)

# open data
read.graph("django_django_2012_05.graphml", format = "graphml")
