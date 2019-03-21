#!/usr/bin/python

import multiprocessing as mp
import timeit
import numpy as np
import sys

# Get the number of processors available
# poolCount = mp.cpu_count()
if len(sys.argv)>1:
    poolCount = int(sys.argv[1])
else:
    poolCount = 1


# Define the number of random numbers to draw # This indicates the number of jobs that a single core will be doing. Since there are 20 cores in this example, we use 1000000.
sz = 2_000_000 // poolCount

# Define start time
start = timeit.default_timer()

# Define function to compute pi
def computePi(N,M):
    assert type(N) == int
    assert type(M) == int

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

# Create poolCount number of workers
pool = mp.Pool(poolCount)

# Write the number of workers to output
print ("Started pool with "+str(poolCount)+" workers.")

# Loop and create tasks
tasks = []
for i in range(poolCount):
    tasks.append( (sz, i) )

results = []
for t in tasks:
    results.append( pool.apply_async(computePi,t) )

# Gather the results
totOut = 0
for result in results:
    output = result.get()
    totOut = totOut + output

# Compute 4 times the ratio of points inside
totOut = float(4*totOut/(float(sz)*float(poolCount)))

# Find the total time
stop = timeit.default_timer()

# Report the final approximation
print("Pi estimate using " + str(sz) + " points on " + str(poolCount) + " workers: " + str(totOut))
print("Total time: " + str(stop-start))
print("Total COMPUTE time: ",  (stop-start)*poolCount)

