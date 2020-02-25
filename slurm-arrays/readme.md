# Slurm Arrays. 


Slurm arrays are way to run "almost the same tings" a large number of time.
They make more efficient usage of the scheduler, and also let you tune how many
of each array item can be run in parallel. This let you for example run 200 000
task with a maximum of 10 at a time for a two weeks period, without putting
your next simulation at the end of the queue.

The slurm documentation is [way more
exhaustive](https://slurm.schedmd.com/job_array.html), but it is sometime
difficult to see how one's job could be done as arrays.

## Job array submission

Job arrays are submitted like classical jobs, but with the extra `--array=` flag, for example :

```
$ sbatch --array=1-1000 simulation.sub 
```

`simulation.sub` will now be scheduled as job 1000 time, but with the
`$SLURM_ARRAY_TASK_ID` varying from `1` to `1000`. AS a user it is your
responsibility  to use that to run the right simulation. 

Let's try to simulate all combinaison of rock-paper-scisor-lizard-spock

Let's have a file `input.txt` with all the pairs: 

```
rock --vs rock
rock --vs paper
rock --vs scisor
rock --vs lizard
rock --vs spock
paper --vs rock
paper --vs paper
...
```

We can get a specific entry using `head` and `tail`, here the 4th entry:

```
$ 
rock --vs lizard
```

We can use that to execute our program with these parameters in out Slurm submission scrips.

```
PARAMETERS=$(cat input.txt | head -n $SLURM_ARRAY_TASK_ID | tail -n1)
./program $PARAMETERS
```
