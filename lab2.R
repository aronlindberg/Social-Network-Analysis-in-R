library(igraph)
library(NetData)

data(kracknets, package = "NetData")

krack_full_nonzero_edges <- subset(krack_full_data_frame, (advice_tie > 0 | friendship_tie > 0 | reports_to_tie > 0))
head(krack_full_nonzero_edges)

krack_full <- graph.data.frame(krack_full_nonzero_edges)
summary(krack_full)

# Set vertex attributes
for (i in V(krack_full)) {
  for (j in names(attributes)) {
    krack_full <- set.vertex.attribute(krack_full, j, index=i, attributes[i+1,j])
  }
}
summary(krack_full)

# Create sub-graphs based on edge attributes
krack_advice <- delete.edges(krack_full,
                             E(krack_full)[get.edge.attribute(krack_full, name = "advice_tie")==0])
summary(krack_advice)

krack_friendship <- delete.edges(krack_full,
                             E(krack_full)[get.edge.attribute(krack_full, name = "friendship_tie")==0])
summary(krack_friendship)

krack_reports_to <- delete.edges(krack_full,
                             E(krack_full)[get.edge.attribute(krack_full, name = "reports_to_tie")==0])
summary(krack_reports_to)

### 
# 3. NODE-LEVEL STATISTICS
###

# Compute the indegree and outdegree for each node, first in the 
# full graph (accounting for all tie types) and then in each 
# tie-specific sub-graph. 

deg_full_in <- degree(krack_full, mode="in")
deg_full_out <- degree(krack_full, mode="out")
deg_full_in
deg_full_out

deg_advice_in <- degree(krack_advice, mode="in")
deg_advice_out <- degree(krack_advice, mode="out")
deg_advice_in
deg_advice_out

deg_friendship_in <- degree(krack_friendship, mode="in")
deg_friendship_out <- degree(krack_friendship, mode="out")
deg_friendship_in
deg_friendship_out

deg_reports_to_in <- degree(krack_reports_to, mode="in")
deg_reports_to_out <- degree(krack_reports_to, mode="out")
deg_reports_to_in
deg_reports_to_out

# Reachability can only be computed on one vertex at a time. To
# get graph-wide statistics, change the value of "vertex"
# manually or write a for loop. (Remember that, unlike R objects,
# igraph objects are numbered from 0.)

reachability <- function(g, m) {
  reach_mat = matrix(nrow = vcount(g),
                     ncol = vcount(g))
  for (i in 1:vcount(g)) {
    reach_mat[i,] = 0
    this_node_reach <- subcomponent(g, (i - 1), mode = m)
    
    for (j in 1:(length(this_node_reach))) {
      alter = this_node_reach[j] + 1
      reach_mat[i, alter] = 1
    }
  }
  return(reach_mat)
}

reach_full_in <- reachability(krack_full, 'in')
reach_full_out <- reachability(krack_full, 'out')
reach_full_in
reach_full_out