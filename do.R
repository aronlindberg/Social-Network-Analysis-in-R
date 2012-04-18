#Set the working directory
setwd("~/github/local/VOSS-Sequencing-Toolkit")

# Direct output to a textfile
# sink("Sequence_Output.txt", append=FALSE, split=FALSE)

# Source functions and the cleaned datafile
source("functions.r")
load("cleaned_data.rdata")

#Load the TraMineR and cluster libraries
library(TraMineR)
library(cluster)

#Load the dataset
github <- read.csv(file = "GitSequences.csv", header = TRUE)

#Display summary statistics
summary(github)

#Convert to compressed format
github.comp <- seqconc(github)

# Display summary
summary(github.comp)

# Create a sequence object
github.seq<-seqdef(github)

#Display summary
summary(github.seq)

#Define costs and create a distance matrix
costs <- seqsubm(github.seq, method="TRATE")
github.om <- seqdist(github.seq, method="OM", indel=1, sm=costs)

# Display the output in rounded format
round(github.om)

# Plot a dendrogram
clusterward <- agnes(github.om, diss = TRUE, method = "ward")
plot(clusterward, which.plots = 2)
