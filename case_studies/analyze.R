# Setup
setwd("~/github/local/Social-Network-Analysis-in-R/data/django_django/")
# turn on the command below to output to a text-file.
# sink("outfile.txt")
library(igraph)

# open data
test_graph <- read.graph("django_django_2012_05.graphml", format = "graphml")
social_layout <- layout.fruchterman.reingold(test_graph)
plot(test_graph, layout=social_layout, edge.arrow.size=.5)