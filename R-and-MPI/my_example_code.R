## (1) Setup Environment
# Load libraries 
library(doMPI) # Parallel computation package (also loads: foreach, iterators and parallel)
## (2) Setup Parallel Proccessing
ncores <- detectCores() # get the number of available cores
cl <- startMPIcluster() # start a cluster with default
registerDoMPI(cl) # register cluster to work on all cores
# Document parallel processing variables
print(ncores) # number of cores available and requested
clusterSize(cl)
## (3) Sample process that uses foreach loop.
# 100 000 bootstrap iteration in parallel example
x <- iris[which(iris[,5] != "setosa"), c(1,5)]
trials <- 100000
ptime <- system.time({
					r <- foreach(icount(trials), .combine=cbind) %dopar% {
								ind <- sample(100, 100, replace=TRUE)
								result1 <- glm(x[ind,2]~x[ind,1], family=binomial(logit))
								coefficients(result1)
								}
					})
ptime
## (4) End Run
# Stop the cluster
closeCluster(cl)
mpi.quit()
# Exit R
q()
