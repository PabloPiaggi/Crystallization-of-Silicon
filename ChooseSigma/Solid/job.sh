#!/bin/bash
#SBATCH --ntasks=4             # total number of tasks across all nodes
#SBATCH --nodes=1               # number of nodes
#SBATCH --cpus-per-task=1       # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=300M      # memory per cpu-core (4G is default)
#SBATCH --time=24:00:00         # total run time limit (HH:MM:SS)
#SBATCH --job-name="Si" 
#SBATCH --constraint=haswell|broadwell|skylake|cascade   # exclude ivy nodes

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export PLUMED_NUM_THREADS=$SLURM_CPUS_PER_TASK

pwd; hostname; date

module purge
module load intel-mpi intel

############################################################################
# Variables definition
############################################################################
LAMMPS_HOME=/home/ppiaggi/Programs/Lammps/lammps-git-cpu/build6
LAMMPS_EXE=${LAMMPS_HOME}/lmp_della
cycles=1
partitions=1
############################################################################

############################################################################
# Run
############################################################################

#########################################################################
# First run
#########################################################################
nn=1
# Number of partitions
srun $LAMMPS_EXE -sf omp -in start.lmp
#########################################################################

date
