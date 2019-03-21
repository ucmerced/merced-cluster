#!/usr/bin/python
#$ -j y
#$ -q fast.q
#$ -cwd 
#$ -N py_ser_test
#$ -pe smp 1

import timeit
import numpy as np

# Define the number of random numbers to draw
sz = 1000000*20

# Define start time
start = timeit.default_timer()

# Define function to compute pi
def computePi(N,M):

    # N is the number of points
    # M is the processes number (to keep unique)

    # Define output
    estPi = 0;

    # Set the random seed (otherwise all will be the same!)
    np.random.seed(M)

    # Loop over N
    for i in range(N):
        
        # Draw some random numbers
        x = np.random.rand(1)
        y = np.random.rand(1)

        # If those numbers are inside unit circle, keep
        if (x**2 + y**2)<1:
            estPi = estPi + 1
    
    # Return the number of points inside circle
    return(estPi)

# Define pool size to be 1
poolCount = 1

# Compute single serial output
totOut = computePi(sz,1)

# Compute 4 times the ratio of points inside
totOut = float(4*totOut/(float(sz)))

# Find the total time
stop = timeit.default_timer()

# Report the final approximation
print("Pi estimate using " + str(sz) + " points on " + str(poolCount) + " workers: " + str(totOut))
print("Total time: " + str(stop-start))

