# Tutorial: Crystallization of Silicon

This repository contains input files for simulating the crystallization of silicon using enhanced sampling methods.
Silicon is described using the Stillinger-Weber potential [Stillinger and Weber,  Phys. Rev. B, v. 31, p. 5262, (1985)](https://journals.aps.org/prb/abstract/10.1103/PhysRevB.31.5262) . A bias potential is constructed using [well tempered metadynamics](https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.100.020603) as a function of the collective variable introduced [in this article](https://aip.scitation.org/doi/abs/10.1063/1.5102104).

## Requirements

This tutorial uses the molecular dynamics engine LAMMPS patched with the PLUMED 2 enhanced sampling plugin.

## Installation

<!--
PLUMED can be installed with the following commands:
```
mkdir plumed2-install
installfolder=$(pwd)/plumed2-install
wget https://github.com/plumed/plumed2/releases/download/v2.6.0/plumed-2.6.0.tgz
tar -xf plumed-2.6.0.tgz
cd plumed-2.6.0/
./configure --prefix=$installfolder
make -j 2
make install
cd ..
```
If the previous commands are succesful, you can proceed to install LAMMPS:
-->

LAMMPS and PLUMED can be installed with the following commands:

```
wget https://github.com/lammps/lammps/archive/stable_3Mar2020.tar.gz
tar -xf stable_3Mar2020.tar.gz
cd lammps-stable_3Mar2020/src
make lib-plumed args="-b"
make yes user-plumed
make yes-manybody
make yes-molecule
make mpi # or make serial if you don't have an MPI library
lammpsexe=$(pwd)/lmp_mpi # or lammpsexe=$(pwd)/lmp_serial if you don't have an MPI library
cd ../lib/plumed/plumed2/bin/
plumedexe=$(pwd)/plumed
```

Now you should be able to use *$lammpsexe* and *$plumedexe* to execute LAMMPS and PLUMED, respectively.
If you close the shell these variables will be lost.
A better alternative for more experienced users would be to include the appropriate folders in the *PATH* environment variable by adding a line in your ```~/.bashrc```.

## Introduction

During crystallization the disordered atoms of a liquid spontaneously organized into periodic patterns with long range order.
The time and lengthscales involved are often too short to be studied with experiments.
In this tutorial we will see how we can study this fascinating process using enhanced sampling molecular dynamics simulations.

### Collective variable

The starting point for the definition of our order parameter is a local atomic density around an atom.
We consider an environment <img src="https://render.githubusercontent.com/render/math?math=\chi"> around an atom and we define the density by,

<img src="https://render.githubusercontent.com/render/math?math=\rho_{\chi}(\mathbf{r})=\sum_{i\in\chi} \exp\left(- \frac{|\mathbf{r}_i-\mathbf{r}|^2} {2\sigma^2} \right),">

where *i* runs over the neighbors in the environment <img src="https://render.githubusercontent.com/render/math?math=\chi"> and <img src="https://render.githubusercontent.com/render/math?math=\mathbf{r}_i"> are the coordinates of the neighbors relative to the central atom.

## Example

The folder ```Metadynamics-1700K``` contains the input files to run the simulation.
You can run the example with the command:
```
$lammpsexe < start.lmp > out.lmp
```
This will run a 5 ns long metadynamics simulation at 1700 K and 1 bar.
Several output files will be created.
out.lmp file contains LAMMPS' output.
PLUMED's output files are plumed.out and COLVAR.
Inspect the COLVAR file, this will contain the collective variable, the bias potential, and other interesting quantities as a function of simulation time.

## Objectives

The following tasks are proposed:
* Repeat the simulation at different temperatures, e.g. in steps of 50 o 100 K
* Study the convergence of the free energy surface (FES) as a function of simulation time (a minimum of 2 ns per simulation is required and 5 ns are suggested)
* Plot the FES obtained at different temperatures
* Calculate the liquid-solid free energy difference (one should integrate the FES but the difference in free energy between the minima should be a good approximation) 
* Calculate the melting temperature and discuss finite size effects

