# Social Network Analysis in R #

The purpose of this repository is to learn how to run SNA in R during the summer of 2012.

## Characteristics of the Network Data at GitHub ##

The network data consists of the following edges:

* Coders following other coders
* Coders watching repositories
* Repositories being forked off of other repositories
* Coders connected to repositories through commits, comments etc.
* Coders connected to coders through committing or commenting on the same repository, branch, or the same file/commit/issue etc.
* Coders who are on the same team/organization

Hence, there are both directed and undirected graphs, as well as multidimensional since there are both human (coders) and non-human (repositories and their constituent parts) vertices.

N.B. The graph package cannot mix directed and undirected graphs in the same model. Can we work around this within the package or do we need a different package?

Anything else?

## Potentially Interesting Measures That We Could Correlate With Various Sequence Characteristics ##

* The density (actual ties/possible ties) of a repository network
* Size of network
* Cohesion/Geodesics, i.e. the number of direct paths in the network
* How many other repositories do the coders contribute to?
* Dispersion of code contribution
* Are there cliques in the repository network?
* Centrality of actors in relation to sequences or sequence aspects
* Changes in any of these measures over time

## Resources ##

Here are some resources to get us started:

* [The R Podcast](http://www.r-podcast.org/)
* [RStudio IDE](http://rstudio.org/)
* [Social Network Analyis Labs - Stanford](http://sna.stanford.edu/rlabs.php)
* [Brief Introduction to SNA](http://www.orgnet.com/sna.html)
* [igraph package - tutorial](http://igraph.sourceforge.net/igraphbook/)
* [Introduction to Social Network Methods](http://faculty.ucr.edu/~hanneman/networks/nettext.pdf)
* [An Introduction to Social Network Analysis with R and NetDraw](http://econometricsense.blogspot.com/2012/04/introduction-to-social-network-analysis.html)
* [Social Network Analysis with sna](http://www.jstatsoft.org/v24/i06/paper)