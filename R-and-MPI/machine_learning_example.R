## Machine Learning In Parallel With caret Example
## Load libraries (must be installed beforehand)
library(doMPI) ## Parallel computation package
library(plyr) ## required for model
library(caret) ## platform for training.
library(randomForest) ## model
#
## (1) Create synthetic data, 500 rows, 3 predictor variables and 1 output variable
n.rows = 500
n.cols = 4
syn_data <- array(data = 0, dim = c(n.rows, n.cols))
# Synthesize predictors
syn_data[,2] <- c(seq(1, n.rows)/50) + rnorm(n.rows, mean = 0, sd = 0.1) # increaseing with normal errors added
syn_data[,3] <- sin(syn_data[,2]) # sin 
syn_data[,4] <- c(runif(n.rows, 1, 5)) # random variable
# calculate the output variable
syn_data[,1] <- syn_data[,2] * syn_data[,3] + syn_data[,4]
syn_data <- data.frame(syn_data)
#
## (2) Tune model with caret package
# Define tuning parameters for model
rfm_grid <- expand.grid(mtry = c(2,3))
# Define training control methods
ctrl_tr <- trainControl(method = "repeatedcv",
                        number = 10,
                        repeats = 3,
                        returnResamp = "all")

## (3) Setup parallel proccessing
cl <- startMPIcluster() # start a cluster with defaults (uses all available cores)
registerDoMPI(cl) 
clusterSize(cl) # Print size for documentation.

## (4) Run model training
rfm_fit <- caret::train(X1~., data = syn_data,
                        method = "rf",
                        tuneGrid = rfm_grid,
                        trControl = ctrl_tr,
                        verbose = FALSE)          
#
## (5) Save  model
saveRDS(rfm_fit, file = "my_rfm_model.rds")
#
## (6) Visualize Performance
# Best Model Summary
print(rfm_fit$finalModel)
# Plot Model vs. Data
syn_data$Predicted_X1 = predict(rfm_fit, newdata = syn_data)
p <- ggplot(data=syn_data) +
        geom_point(aes(seq_along(X1), X1), color="red", size = 1.5)+
        geom_path(aes(seq_along(X1), Predicted_X1))+
        labs(x = "Sequence", y = "Value")
        
        
ggsave(plot = p, "Predicted_vs_data.pdf", device = "pdf")
## (6) Stop cluster and Exit
closeCluster(cl)
mpi.quit()
q()
