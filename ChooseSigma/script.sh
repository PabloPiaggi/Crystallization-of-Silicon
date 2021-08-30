# The values of i here correspond to different SIGMA.
# Choose the SIGMA range you would like to explore.
for i in `seq 0.03 0.0025 0.08`
do
	for phase in Solid Liquid
	do
		cd $phase
		sed "s/replace/$i/g" plumed-base.dat > plumed.dat
		timeout 15 plumed --no-mpi driver --plumed plumed.dat --mf_dcd out.dcd > /dev/null
		cd ../
	done
	result=`python script.py`
	echo $i $result
	for phase in Solid Liquid
	do
		cd $phase
		mv histo histo-$i
		rm COLVAR analysis.*
		cd ../
	done
done
