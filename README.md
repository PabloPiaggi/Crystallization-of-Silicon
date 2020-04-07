# Tutorial: Crystallization of Silicon

This repository contains input files for simulating the crystallization of silicon using enhanced sampling methods.
Silicon is described using the Stillinger-Weber potential [Stillinger and Weber,  Phys. Rev. B, v. 31, p. 5262, (1985)](https://journals.aps.org/prb/abstract/10.1103/PhysRevB.31.5262) . A bias potential is constructed using [well tempered metadynamics](https://journals.aps.org/prl/abstract/10.1103/PhysRevLett.100.020603) as a function of the collective variable introduced [in this article](https://aip.scitation.org/doi/abs/10.1063/1.5102104).

## Table of contents

* [Objectives and learning outcomes](#objectives-and-learning-outcomes)
* [Requirements and installation](#requirements-and-installation)
* [Introduction](#introduction)
   * [Well tempered metadynamics](#well-tempered-metadynamics)
   * [Collective variable](#collective-variable)
* [Example](#example)
* [Visualization](#visualization)
* [Assignment](#assignment)


## Objectives and learning outcomes

In this tutorial the student will learn to perform enhanced sampling simulations.
We will study in particular the crystallization of silicon and learn to calculate free energy differences, the equilibrium temperature between two phases, and obtain atomistic insight into a important phase transformation.

## Requirements and installation

This tutorial uses the molecular dynamics engine LAMMPS patched with the PLUMED 2 enhanced sampling plugin.

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
We take as example the case of silicon that crystallizes in the cubic diamond crystal structure.

Below we provide a (very short) summary of the methods that will be employed.

### Well tempered metadynamics

In well tempered metadynamics a bias potential <img src="https://render.githubusercontent.com/render/math?math=V(s)"> is constructed as a function of some collective variable *s*.
The bias potential is constructed as a sum of repulsive Gaussians that discourage frequently visited configurations.
In this way, the simulation explores different regions of the free energy surface <img src="https://render.githubusercontent.com/render/math?math=F(s)"> of the system.
In the long time limit the bias potential converges to,

<img src="https://render.githubusercontent.com/render/math?math=V(s)= - \left ( 1- \frac{1}{\gamma} \right ) F(s)">

where <img src="https://render.githubusercontent.com/render/math?math=\gamma"> is the bias factor.

### Collective variable

<!---
The starting point for the definition of our order parameter is a local atomic density around an atom.
We consider an environment <img src="https://render.githubusercontent.com/render/math?math=\chi"> around an atom and we define the density by,

<img src="https://render.githubusercontent.com/render/math?math=\rho_{\chi}(\mathbf{r})=\sum_{i\in\chi} \exp\left(- \frac{|\mathbf{r}_i-\mathbf{r}|^2} {2\sigma^2} \right),">

where *i* runs over the neighbors in the environment <img src="https://render.githubusercontent.com/render/math?math=\chi"> and <img src="https://render.githubusercontent.com/render/math?math=\mathbf{r}_i"> are the coordinates of the neighbors relative to the central atom.

We now define two reference environments or templates <img src="https://render.githubusercontent.com/render/math?math=\chi_0^1"> and <img src="https://render.githubusercontent.com/render/math?math=\chi_0^2">.
Each contains 4 reference positions <img src="https://render.githubusercontent.com/render/math?math=\{\mathbf{r}^0_1,...,\mathbf{r}^0_4\}"> that describe the two environments that exist in the cubic diamond crystal structure.
-->

The collective variable (CV) that we will use is based on comparing the atomic environments in the simulation with those of a reference crystal structure.
The environments <img src="https://render.githubusercontent.com/render/math?math=\chi"> and <img src="https://render.githubusercontent.com/render/math?math=\chi_0"> are compared using the kernel,
 
<img src="https://render.githubusercontent.com/render/math?math=k_{\chi_0}(\chi)= \int d\mathbf{r} \rho_{\chi}(\mathbf{r}) \rho_{\chi_0}(\mathbf{r}).">

where <img src="https://render.githubusercontent.com/render/math?math=\rho_{\chi}(\mathbf{r})"> is the atomic density around environment <img src="https://render.githubusercontent.com/render/math?math=\chi">.
In this way we obtain one value of the kernel per atom in the system.
We will then use as collective variable the number of <img src="https://render.githubusercontent.com/render/math?math=k_{\chi_0}(\chi)"> that are larger than some threshold.
This is equivalent to counting the number of atoms that have a crystalline environment.
We will also calculate the average of the <img src="https://render.githubusercontent.com/render/math?math=k_{\chi_0}(\chi)">.

You can find more details about the CV [in this article](https://aip.scitation.org/doi/abs/10.1063/1.5102104).

<!---
If we combine the equations above, perform the integration analytically, and normalize we obtain,

<img src="https://render.githubusercontent.com/render/math?math=k_{\chi_0}(\chi) = \frac{1}{n} \sum_{i\in\chi} \sum_{j\in\chi_0} \exp\left( - \frac{|\mathbf{r}_i-\mathbf{r}^0_j|^2} {4\sigma^2} \right).">

This is the per atom collective variable (or multicolvar) that we will employ.
-->

## Example

The folder ```Metadynamics-1700K``` contains the input files to run the simulation.
You can run the example with the command:
```
$lammpsexe < start.lmp > out.lmp
```
This will run a 5 ns long metadynamics simulation at 1700 K and 1 bar.
Several output files will be created.
out.lmp file contains LAMMPS' output.
PLUMED's output files are log.plumed and COLVAR.
Inspect the COLVAR file, this will contain the collective variable, the bias potential, and other interesting quantities as a function of simulation time.

While the simulation is running you can check its progress by plotting the collective variable as a function of time.
Furthermore, you can calculate the FES with the command
```
$plumedexe sum_hills --hills HILLS --mintozero
```
This will create a new file fes.dat.
Plot the contents of this file and track the convergence of the bias potential.

This analysis is performed in the Jupyter Notebook ```Metadynamics-1700K/Results/Analysis.ipynb```

Explore this notebook online! [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/PabloPiaggi/Crystallization-of-Silicon/master?filepath=Metadynamics-1700K%2FResults%2FAnalysis.ipynb)

## Visualization

We recommend using the software [Ovito](https://www.ovito.org/) for the visualization of the trajectories.
Ovito is very user friendly, and you can find instructions and download it from their website.

Once that you have loaded the dump file into Ovito you can color the atoms according to the degree of order around them.
Apply the ```Identify diamond structure``` modifier that can be chosen from the ```Add modification``` dropdown menu.

Below we show liquid and solid configurations colored with the modifier ```Identify diamond structure```.

<div class="row">
  <div class="column">
    <img src="https://github.com/PabloPiaggi/Crystallization-of-Silicon/raw/master/si-liquid.png" alt="Liquid" style="width:100%"> 
  </div>
  <div class="column">
    <img src="https://github.com/PabloPiaggi/Crystallization-of-Silicon/raw/master/si-solid.png" alt="Solid" style="width:100%">
  </div>
</div>

## Assignment

The following tasks are proposed:
* Repeat the simulation at different temperatures, e.g. in steps of 50 o 100 K
* Study the convergence of the free energy surface (FES) as a function of simulation time (a minimum of 2 ns per simulation is required and 5 ns are suggested)
* Plot the FES obtained at different temperatures
* Calculate the liquid-solid free energy difference (one should integrate the FES but the difference in free energy between the minima should be a good approximation) 
* Calculate the melting temperature and discuss finite size effects

