#Set the working directory
setwd("~/github/local/Social-Network-Analysis-in-R")

# Direct output to a textfile
# sink("Sequence_Output.txt", append=FALSE, split=FALSE)

# Source functions and the cleaned datafile
source("functions.r")
load("cleaned_data.rdata")