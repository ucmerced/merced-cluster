## (1) Setup Environment
# Load libraries 
library(doMPI) # Parallel computation package. Also loads 'foreach' package
## (2) Setup Parallel Proccessing
cl <- startMPIcluster() # start a cluster with defaults (uses all available cores)
registerDoMPI(cl)
clusterSize(cl) # Print size for documentation.
## (3) Sample process that uses foreach loop.
# 1000 bootstrap iteration in parallel example
x <- iris[which(iris[,5] != "setosa"), c(1,5)]
trials <- 1000
ptime <- system.time({
					r <- foreach(icount(trials), .combine=cbind) %dopar% {
								ind <- sample(100, 100, replace=TRUE)
								result1 <- glm(x[ind,2]~x[ind,1], family=binomial(logit))
								coefficients(result1)
								}
					})
ptime
## (4) Stop cluster and Exit.
closeCluster(cl)
mpi.quit()
q()
