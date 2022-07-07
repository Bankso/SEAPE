#!/usr/bin/bash

#SBATCH --job-name=DIO	    		 	### Job Name
#SBATCH --output=scripts/logs/run.out           ### File in which to store job output DO NOT EDIT
#SBATCH --error=scripts/logs/run.err            ### File in which to store job error messages DO NOT EDIT
#SBATCH --time=0-00:20:00           		### Wall clock time limit in Days-HH:MM:SS
#SBATCH --nodes=1                   		### Number of nodes needed for the job
#SBATCH --ntasks-per-node=1         		### Number of tasks to be launched per Node
#SBATCH --cpus-per-task=8	    		### Number of CPU's used to complete submitted tasks within each requested node
#SBATCH --mem=4GB		    		### Amount of preallocated memory for submitted job
#SBATCH --account=mcknightlab       		### Account used for job submission

## Be sure to edit the above to fit your HPC job submisssion framework
## For example of output structure, see the README at https://github.com/Bankso/DIO
## Usage: sbatch run.sh 1 2 3 4
## Requires 4 inputs at the command line:
		## First input - peak set directory with three BED formatted raw peak files derived from SpLiT-ChEC or other datasets
		## Second input - path to the directory you want to work from and from which all file paths are relative to in programs
		## Third input - lead tag name for all outputs; usually the first identifier in file paths as well
		## Fourth input - secondary tag for all outputs; ff for full frag peaks or sf for small fragment peaks
	## Builds directories for and outputs:
		## a set of BED files with distances adjusted to 2*input, which is defined in a Python list below
		## adjsted BEDs merged with bedtools
		## Merge BEDs adjusted to new dyads and "footprints" (equal to the size of regions applied to the set before merging)
		## Footprints compared to original unified dyad entry, which produces records of dyads overlapped by each footprint in each set
		## The number of dyads cpatured by each footprint
## err and log files are moved to the raw dyads directory after processing

module load bedtools

indir="$1" #Directory containing three peak sets from three timepoints for the same factor relative to wdir
wdir="$2" #The name of the home directory for processing files, same as used for SCAR
name="$3" #a protein name for total peak set, which will be used to create files and directories
type="$4" #ff or sf peaks were present in the indir

cd ${wdir}
echo $PWD
pfall="${name}_${type}_all_peaks.bed"
cat ${indir}/* > "${indir}/${pfall}"
srted="${name}_${type}_all_peaks_sorted.bed"
srtout="${indir}/${srted}"
sort -k1,1 -k2,2n "${indir}/${pfall}" > "${srtout}"
intdir="${indir}/intervals"
merdir="${indir}/merges"
dydir="${indir}/dyads"
fpdir="${indir}/prints"
ovdir="${indir}/DIPcalc"
ctdir="${indir}/DIPcounts"

mkdir -p "${intdir}"
python scripts/tools/dio_pro/bulk_ranged_BED_builder.py "${srtout}" "${intdir}" "FALSE" 0 1 2 3 4 5 6 7 8 9 10 15 20 25 30 35 40 45 50 60 75 100 125 150 200 250 300 400 500
#outname format is name_type_all_peaks_sorted_mv.bed
mkdir -p "${merdir}"
bash scripts/tools/dio_pro/bulk_interval_merge.sh "${name}" "${type}" "${intdir}" "${merdir}"
#outname format is name_type_all_peaks_sorted_mv_merged.bed
mkdir -p "${dydir}" "${fpdir}"
python scripts/tools/dio_pro/mixed_intervals_to_dyads_and_fp.py "${merdir}" "${dydir}" "${fpdir}"
#outname formats are name_type_all_mv_dyads.bed and name_type_all_mv_fps.bed
ndy="${dydir}/${name}_${type}_all_0_dyads.bed"
mkdir -p "${ovdir}" "${ctdir}"
bash scripts/tools/dio_pro/dyads_in_prints_calc.sh "${fpdir}" "${ovdir}" "${ndy}" "${ctdir}"
#outname formats are name_type_all_mv_fps_dyad_ovlp.tsv and name_type_all_mv_fps_dyad_ovlp.counts
python scripts/tools/dio_pro/dyad_in_fps_histo_stats_calc.py "${ctdir}" "${type}"

echo "Run complete - happy plotting!"

mv scripts/logs/run.out "${indir}/${name}_${type}.out"
mv scripts/logs/run.err "${indir}/${name}_${type}.err"
scripts/logs/run.err
exit
