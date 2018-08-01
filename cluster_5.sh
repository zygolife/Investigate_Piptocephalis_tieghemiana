#!/bin/bash
#SBATCH --ntasks 16 --nodes 1 -p stajichlab --out proteinortho.%A.log -J proteinOrtho --mem 8G

module load proteinortho
CPUS=2
if [ $SLURM_CPUS_ON_NODE ]; then
	CPUS=$SLURM_CPUS_ON_NODE
fi
mkdir -p /scratch/$USER
proteinortho5.pl -selfblast -temp=/scratch/$USER -project=Zoopag -cpus=$CPUS pep/*.fasta
