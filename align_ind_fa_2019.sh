#!/bin/bash -l

# This script will align a list of fa files to a reference genome

###############
###  SETUP  ###
###############
list=$1		# A list of all individuals to align (FMT: fa_file | file_prefix)
ref=$2		# Global path to reference genome
out=$3		# Output directory

echo List : ${list}
echo Reference Genome : ${ref}
echo Output Directory : ${out}

cd ${out}
wc=$(wc -l ${list} | awk '{print $1}')
x=1
while [ $x -le $wc ] 
do
	echo "Starting ${x} of ${wc}"
	string="sed -n ${x}p ${list}" 
	str=$($string)

	var=$(echo $str | awk -F"\t" '{print $1, $2}')   
	set -- $var
	c1=$1
	c2=$2

	cat << ALIGN >> ${out}/${c2}.sh
#!/bin/bash -l
#
#SBATCH -e ${c2}.j%j.err
#SBATCH -o ${c2}.j%j.out
#SBATCH -t 08:00:00
#SBATCH -p med
#SBATCH --mem=8G

echo $(date +%D' '%T)  Now aligning ${c2}
bwa mem $ref ${c1} | samtools view -Sb - | samtools sort -n - ${out}/${c2}.sort-n.bam
echo Complete!
echo ""

echo $(date +%D' '%T)  Indexing bam file
samtools index ${out}/${c2}.sort-n.bam
echo Complete!
echo ""
ALIGN

	sbatch ${out}/${c2}.sh
	echo "Submitted ${c2}.sh"
	echo ""
	x=$(( $x + 1 ))
done


