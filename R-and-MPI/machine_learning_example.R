## Machine Learning In Parallel With caret Example
## Load libraries (must be installed beforehand)
library(doMPI) ## Parallel computation package
library(plyr) ## required for gbm
library(caret) ## platform for training.
library(gbm) ## gbm model
#
## (1) Create synthetic data, 5,000 rows, 3 predictor variables and 1 output variable
n.rows = 5000
n.cols = 4
syn_data <- array(data = 0, dim = c(n.rows, n.cols))
# Synthesize predictors
syn_data[,2] <- c(seq(1, n.rows)) + rnorm(n.rows, mean = 0, sd = 20) # increaseing with normal errors added
syn_data[,3] <- c(sin(rnorm(n.rows, sd = 20))) # decreasing with normal errors added
syn_data[,4] <- c(runif(n.rows, 1, 50)) # random variable
# calculate the output variable
syn_data[,1] <- syn_data[,2] * syn_data[,3] + syn_data[,4]
#
## (2) Tune model with caret package
# Define tuning parameters for GBM model
gbm_grid <- expand.grid(interaction.depth = 2:100,
                        n.trees = floor((5:100)*50),
                        shrinkage = .1,
                        n.minobsinnode = 10)
# Define training control methods
ctrl_tr <- trainControl(method = "repeatedcv",
                        number = 10,
                        repeats = 5,
                        returnResamp = "all")

## (3) Setup parallel proccessing
cl <- startMPIcluster() # start a cluster with defaults (uses all available cores)
registerDoMPI(cl) 
clusterSize(cl) # Print size for documentation.

## (4) Run model training
gbm_fit <- train(V1~., data = syn_data,
                 method = "gbm",
                 tuneGrid = gbm_grid,
                 trControl = ctrl_tr,
                 verbose = FALSE)          
#
## (5) Save  model
saveRDS(gbm_fit, file = "my_gbm_model.rds")
#
## (6) Stop cluster and Exit
closeCluster(cl)
mpi.quit()
q()
