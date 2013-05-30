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
      alter = this_node_reach[j]
      reach_mat[i, alter] = 1
    }
  }
  return(reach_mat)
}

reach_full_in <- reachability(krack_full, 'in')
reach_full_out <- reachability(krack_full, 'out')
reach_full_in
reach_full_out

# Often we want to know path distances between individuals in a network. 
# This is often done by calculating geodesics, or shortest paths between
# each ij pair. One can symmetrize the data to do this (see lab 1), or 
# calculate it for outward and inward ties separately. Averaging geodesics 
# for the entire network provides an average distance or sort of cohesiveness
# score. Dichotomizing distances reveals reach, and an average of reach for 
# a network reveals what percent of a network is connected in some way.

# Compute shortest paths between each pair of nodes. 
sp_full_in <- shortest.paths(krack_full, mode='in')
sp_full_out <- shortest.paths(krack_full, mode='out')
sp_full_in
sp_full_out

# Assemble node-level stats into single data frame for export as CSV.

# First, we have to compute average values by node for reachability and
# shortest path. (We don't have to do this for degree because it is 
# already expressed as a node-level value.)

reach_full_in_vec <- vector()
reach_full_out_vec <- vector()
reach_advice_in_vec <- vector()
reach_advice_out_vec <- vector()
reach_friendship_in_vec <- vector()
reach_friendship_out_vec <- vector()
reach_reports_to_in_vec <- vector()
reach_reports_to_out_vec <- vector()

sp_full_in_vec <- vector()
sp_full_out_vec <- vector()
sp_advice_in_vec <- vector()
sp_advice_out_vec <- vector()
sp_friendship_in_vec <- vector()
sp_friendship_out_vec <- vector()
sp_reports_to_in_vec <- vector()
sp_reports_to_out_vec <- vector()

for (i in 1:vcount(krack_full)) {
  reach_full_in_vec[i] <- mean(reach_full_in[i,])
  reach_full_out_vec[i] <- mean(reach_full_out[i,])
  reach_advice_in_vec[i] <- mean(reach_advice_in[i,])
  reach_advice_out_vec[i] <- mean(reach_advice_out[i,])
  reach_friendship_in_vec[i] <- mean(reach_friendship_in[i,])
  reach_friendship_out_vec[i] <- mean(reach_friendship_out[i,])
  reach_reports_to_in_vec[i] <- mean(reach_reports_to_in[i,])
  reach_reports_to_out_vec[i] <- mean(reach_reports_to_out[i,])
  
  sp_full_in_vec[i] <- mean(sp_full_in[i,])
  sp_full_out_vec[i] <- mean(sp_full_out[i,])
  sp_advice_in_vec[i] <- mean(sp_advice_in[i,])
  sp_advice_out_vec[i] <- mean(sp_advice_out[i,])
  sp_friendship_in_vec[i] <- mean(sp_friendship_in[i,])
  sp_friendship_out_vec[i] <- mean(sp_friendship_out[i,])
  sp_reports_to_in_vec[i] <- mean(sp_reports_to_in[i,])
  sp_reports_to_out_vec[i] <- mean(sp_reports_to_out[i,])
}

# Next, we assemble all of the vectors of node-level values into a 
# single data frame, which we can export as a CSV to our working
# directory.

node_stats_df <- cbind(deg_full_in,
                       deg_full_out,
                       deg_advice_in,
                       deg_advice_out,
                       deg_friendship_in,
                       deg_friendship_out,
                       deg_reports_to_in,
                       deg_reports_to_out, 
                       
                       reach_full_in_vec, 
                       reach_full_out_vec, 
                       reach_advice_in_vec, 
                       reach_advice_out_vec, 
                       reach_friendship_in_vec, 
                       reach_friendship_out_vec, 
                       reach_reports_to_in_vec, 
                       reach_reports_to_out_vec, 
                       
                       sp_full_in_vec, 
                       sp_full_out_vec, 
                       sp_advice_in_vec, 
                       sp_advice_out_vec, 
                       sp_friendship_in_vec, 
                       sp_friendship_out_vec, 
                       sp_reports_to_in_vec, 
                       sp_reports_to_out_vec)

write.csv(node_stats_df, 'krack_node_stats.cv')

# Question #1 - What do these statistics tell us about
# each network and its individuals in general? 

### 
# 3. NETWORK-LEVEL STATISTICS
###

# Many initial analyses of networks begin with distances and reach, 
# and then move towards global summary statistics of the network. 
#
# As a reminder, entering a question mark followed by a function 
# name (e.g., ?graph.density) pulls up the help file for that function.
# This can be helpful to understand how, exactly, stats are calculated.

# Degree
mean(deg_full_in)
sd(deg_full_in)

# Shortest paths
# ***Why do in and out come up with the same results?
# In and out shortest paths are simply transposes of one another; 
# thus, when we compute statistics across the whole network they have to be the same.

mean(sp_full_in[which(sp_full_in != Inf)])

# Density
graph.density(krack_full)

# Reciprocity
reciprocity(krack_full)

# Transitivity (clustering coefficient)
transitivity(krack_full)

# Triad census. Here we'll first build a vector of labels for 
# the different triad types. Then we'll combine this vector
# with the triad censuses for the different networks, which 
# we'll export as a CSV.

census_labels = c('003',
                  '012',
                  '102',
                  '021D',
                  '021U',
                  '021C',
                  '111D',
                  '111U',
                  '030T',
                  '030C',
                  '201',
                  '120D',
                  '120U',
                  '120C',
                  '210',
                  '300')

tc_full <- triad.census(krack_full)
tc_advice <- triad.census(krack_advice)
tc_friendship <- triad.census(krack_friendship)
tc_reports_to <- triad.census(krack_reports_to)

triad_df <- data.frame(census_labels,
                       tc_full,
                       tc_advice,
                       tc_friendship,
                       tc_reports_to)
triad_df

# To export any of these vectors to a CSV for use in another program, simply
# use the write.csv() command:
write.csv(triad_df, 'krack_triads.csv')

#R code for generating random graphs:
#requires packages ergm, intergraph

library(ergm)
library(intergraph)

#set up weighting vectors for clustering and hierarchy
clust.mask <- rep(0,16)
clust.mask[c(1,3,16)] <- 1
hier.mask <- rep(1,16)
hier.mask[c(6:8,10:11)] <- 0

#compute triad count and triad proportion for a given weighting vector
mask.stat <- function(my.graph, my.mask){
  n.nodes <- vcount(my.graph)
  n.edges <- ecount(my.graph)
  #set probability of edge formation in random graph to proportion of possible  edges present in original
  p.edge <- n.edges/(n.nodes*(n.nodes +1)/2)  
  r.graph <- as.network.numeric(n.nodes, desnity = p.edge)
  r.igraph <- as.igraph(r.graph)
  tc.graph <- triad.census(r.igraph)
  clust <- sum(tc.graph*my.mask)
  clust.norm <- clust/sum(tc.graph)
  return(c(clust,clust.norm))
}

#build 100 random graphs and compute their clustering and hierarchy measurements to create an empirical null distribution
emp.distro <- function(this.graph){
  clust <- matrix(rep(0,200), nrow=2)
  hier <- matrix(rep(0,200), nrow=2)
  for(i in c(1:100)){
    clust[,i] <- mask.stat(this.graph, clust.mask)
    hier[,i] <- mask.stat(this.graph, hier.mask)
  }
  my.mat <- rbind(clust, hier)
  rownames(my.mat) <- c("clust.ct", "clust.norm", "hier.ct", "hier.ct.norm")
  return(my.mat)
}

#fix randomization if desired so results are replicable
set.seed(3123)
#compute empirical distributions for each network
hc_advice <- emp.distro(krack_advice)

----------------------------------------

#find empirical p-value
get.p <- function(val, distro)
{
  distro.n <- sort(distro)
  distro.n <- distro.n - median(distro.n)
  val.n <- val - median(distro.n)
  p.val <- sum(abs(distro.n) > abs(val.n))/100
  return(p.val)
}
get.p(198, hc_full[1,])
get.p(194, hc_advice[1,])
get.p(525, hc_friend[1,])
get.p(1003, hc_report[1,])
get.p(979, hc_full[3,])
get.p(1047, hc_advice[3,])
get.p(1135, hc_friend[3,])
get.p(1314, hc_report[3,])

#generate  95% empirical confidence intervals for triad counts

#clustering
c(sort(hc_advice[1,])[5], sort(hc_advice[1,])[95])
c(sort(hc_friend[1,])[5], sort(hc_friend[1,])[95])
c(sort(hc_report[1,])[5], sort(hc_report[1,])[95])

#hierarchy
c(sort(hc_advice[3,])[5], sort(hc_advice[3,])[95])
c(sort(hc_friend[3,])[5], sort(hc_friend[3,])[95])
c(sort(hc_report[3,])[5], sort(hc_report[3,])[95])