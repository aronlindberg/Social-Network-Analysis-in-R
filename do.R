#Set the working directory
setwd("~/github/local/Social-Network-Analysis-in-R")

# Direct output to a textfile
# sink("Sequence_Output.txt", append=FALSE, split=FALSE)

# Load the igraph & ggplot2 libraries (SNA & plotting respectively)
library(igraph)
library(ggplot2)

# Source functions and the cleaned datafile
source("functions.r")
load("cleaned_data.rdata")

# specify the adjacency matrix
A <- matrix(c(0,1,1,1,1,0,1,0,1,1,0,0,1,0,0,0 ),4,4, byrow= TRUE)
EV <- eigen(A) # compute eigenvalues and eigenvectors
max(EV$values)  # find the maximum eigenvalue

# get the eigenvector associated with the largest eigenvalue
centrality <- data.frame(EV$vectors[,1]) 
names(centrality) <- "Centrality"
print(centrality)

# convert adjacency matrix to an igraph object
G<-graph.adjacency(A, mode=c("undirected"))               

# calculate betweeness & eigenvector centrality 
cent<-data.frame(bet=betweenness(G),eig=evcent(G)$vector)

# calculate residuals
res<-as.vector(lm(eig~bet,data=cent)$residuals)           

# add to centrality data set
cent<-transform(cent,res=res)                             

# save in project folder
write.csv(cent,"r_keyactorcentrality.csv")                

# network visualization
plot(G, layout = layout.fruchterman.reingold)             

# create vertex names and scale by centrality
plot(G, layout = layout.fruchterman.reingold, vertex.size = 20*evcent(G)$vector, vertex.label = as.factor(rownames(cent)), main = 'Network Visualization in R')

# key actor analysis - plot eigenvector centrality vs. betweeness
# and scale by residuals from regression: eig~bet

p<-ggplot(cent,aes(x=bet,y=eig,label=rownames(cent),colour=res, size=abs(res)))+xlab("Betweenness Centrality")+ylab("Eigenvector Centrality")
pdf('key_actor_analysis.pdf')
p+geom_text()+opts(title="Key Actor Analysis")   

dev.off()
