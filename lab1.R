setwd("~/github/local/Social-Network-Analysis-in-R/")
source("http://sna.stanford.edu/setup.R")

sink("outfile.txt")
readLines("http://sna.stanford.edu/setup.R")
sink()

library(igraph)
detach(package:igraph)
library(igraph)

advice_data_frame <- read.table('http://sna.stanford.edu/sna_R_labs/data/Krack-High-Tec-edgelist-Advice.txt')
friendship_data_frame <- read.table('http://sna.stanford.edu/sna_R_labs/data/Krack-High-Tec-edgelist-Friendship.txt')
reports_to_data_frame <- read.table('http://sna.stanford.edu/sna_R_labs/data/Krack-High-Tec-edgelist-ReportsTo.txt')

head(friendship_data_frame)
fix(reports_to_data_frame)

attributes <- read.csv('http://sna.stanford.edu/sna_R_labs/data/Krack-High-Tec-Attributes.csv', header=T)

colnames(advice_data_frame) <- c('ego', 'alter', 'advice_tie')
head(advice_data_frame)

colnames(friendship_data_frame) <- c('ego', 'alter', 'friendship_tie')

colnames(reports_to_data_frame) <- c('ego', 'alter', 'reports_to_tie')
head(reports_to_data_frame)

fix(advice_data_frame)
fix(friendship_data_frame)
fix(reports_to_data_frame)

advice_data_frame$ego == friendship_data_frame$ego

which(advice_data_frame$ego != friendship_data_frame$ego)
which(reports_to_data_frame$alter != friendship_data_frame$alter)
which(reports_to_data_frame$ego != friendship_data_frame$ego)

krack_full_data_frame <- cbind(advice_data_frame,
                               friendship_data_frame$friendship_tie,
                               reports_to_data_frame$reports_to_tie)
head(krack_full_data_frame)

krack_full_data_frame <- data.frame(ego = advice_data_frame[,1],
                                          alter = advice_data_frame[,2],
                                          advice_tie = advice_data_frame[,3],
                                          friendship_tie = friendship_data_frame[,3],
                                          reports_to_tie = reports_to_data_frame[,3])
fix(krack_full_data_frame)

krack_full_non_zero_edges <- subset(krack_full_data_frame, (advice_tie > 0 | friendship_tie > 0 | reports_to_tie > 0))
head(krack_full_non_zero_edges)
head(krack_full_data_frame)

krack_full <- graph.data.frame(krack_full_non_zero_edges)
summary(krack_full)

get.edge.attribute(krack_full, 'advice_tie')
get.edge.attribute(krack_full, 'friendship_tie')
get.edge.attribute(krack_full, 'reports_to_tie')

krack_full_symmetrized <- as.undirected(krack_full, mode='collapse')
summary(krack_full_symmetrized)

names(attributes)

for (i in V(krack_full)) {
  for (j in names(attributes)) {
    krack_full <- set.vertex.attributes(krack_full,
                                        j,
                                        index = i,
                                        attributes[i + 1, j])
  }
}

attributes = cbind(1:length(attributes[,1]), attributes)
krack_full <- graph.data.frame(d = krack_full_non_zero_edges, vertices = attributes)

get.vertex.attribute(krack_full, 'DEPT')

pdf("1.1_Krackhardt_full.pdf")
plot(krack_full)
dev.off()

# reports_to_only
krack_reports_to_only <- delete.edges(krack_full, E(krack_full)[get.edge.attribute(krack_full,         name = "reports_to_tie") == 0])
summary(krack_reports_to_only)
pdf("1.2_krack_reports_to.pdf")
plot(krack_reports_to_only)
dev.off()

reports_to_layout <-
  layout.fruchterman.reingold(krack_reports_to_only)
pdf("1.5krackhard_reports_F_R.pdf")
plot(krack_reports_to_only,
     layout=reports_to_layout)
dev.off()

dept_vertex_colors = get.vertex.attribute(krack_full, "DEPT")
colors = c('Black', 'Red', 'Blue', 'Yellow', 'Green')
dept_vertex_colors[dept_vertex_colors == 0] = colors[1]
dept_vertex_colors[dept_vertex_colors == 1] = colors[2]
dept_vertex_colors[dept_vertex_colors == 2] = colors[3]
dept_vertex_colors[dept_vertex_colors == 3] = colors[4]
dept_vertex_colors[dept_vertex_colors == 4] = colors[5]

pdf("1.6_Krack_reports_color.pdf")
plot(krack_reports_to_only,
     layout=reports_to_layout,
     vertex.color=dept_vertex_colors,
     vertex.label=NA,
     edge.arrow.size=.5)
dev.off()

tenure_vertex_sizes = get.vertex.attribute(krack_full, "TENURE")

pdf("1.7_Krack_reports_color.pdf")
plot(krack_reports_to_only,
     layout=reports_to_layout,
     vertex.color=dept_vertex_colors,
     vertex.label=NA,
     edge.arrow.size=.5,
     vertex.size=tenure_vertex_sizes)
dev.off()

tie_type_colors = c(rgb(1,0,0,.5), rgb(0,0,1,.5), rgb(0,0,0,.5))
E(krack_full)$color[ E(krack_full)$advice_tie==1 ] = tie_type_colors[1]
E(krack_full)$color[ E(krack_full)$friendship_tie==1 ] = tie_type_colors[2]
E(krack_full)$color[ E(krack_full)$reports_to_tie==1 ] = tie_type_colors[3]
E(krack_full)$arrow.size=.5
V(krack_full)$color = dept_vertex_colors
V(krack_full)$frame = dept_vertex_colors

pdf("1.8_Krack_overlayed_ties.pdf")
plot(krack_full,
     layout=reports_to_layout,
     vertex.color=dept_vertex_colors,
     vertex.label=NA,
     edge.arrow.size=.5,
     vertex.size=tenure_vertex_sizes)

# add legend
legend(1,
       1.25,
       legend = c('Advice',
                  'Friendship',
                  'Reports To'),
       col = tie_type_colors,
       lty=1,
       cex = .7)
dev.off()

# Another option for visualizing different network ties relative 
# to one another is to overlay the edges from one tie type on the 
# structure generated by another tie type. Here we can use the
# reports-to layout but show the friendship ties:

# friendship only
krack_friendship_only <- delete.edges(krack_full, 
                                      E(krack_full)[get.edge.attribute(krack_full, 
                                                                       name = "friendship_tie") == 0])
summary(krack_friendship_only)
pdf("1.3_Krackhardt_Friendship.pdf")
plot(krack_friendship_only)
dev.off()

pdf("1.9_krack_overlayed_str.pdf")
plot(krack_friendship_only,
     layout=reports_to_layout,
     vertex.color=dept_vertex_colors,
     vertex.label=NA,
     edge.arrow.size=.5,
     vertex.size=tenure_vertex_sizes,
     main='Krackhardt High-Tech Managers')
dev.off()


write.graph(krack_full, file='krack_full.txt', format="edgelist")