#!/bin/bash

## RUN CMD:
##    bash compare_dirs.sh path/to/directory1 path/to/directory2

# Set the two directories you want to compare
dir1=$1
dir2=$2

# Get the list of files in each directory and their subdirectories
files1=$(find "$dir1" | sed -z "s|${dir1}/||g" | sed -z "s|${dir1}||g" | sort)
files2=$(find "$dir2" | sed -z "s|${dir2}/||g" | sed -z "s|${dir2}||g" | sort)
#files1=$(find "$dir1" -type f | sort)
#files2=$(find "$dir2" -type f | sort)

# Compare the two lists of files
diff <(echo "$files1") <(echo "$files2") > /dev/null

# Check the exit code of the diff command to see if the lists are different
if [ $? -eq 0 ]; then
    echo "The two directories contain the same files."
else
    # Print the files that are in one location but not the other
    echo "The following files are in $dir1 but not in $dir2:"
    comm -23 <(echo "$files1") <(echo "$files2")
    comm -23 <(echo "$files1") <(echo "$files2") >> remaining_files_in_${dir1}.list
    echo "The following files are in $dir2 but not in $dir1:"
    comm -13 <(echo "$files1") <(echo "$files2")
    comm -13 <(echo "$files1") <(echo "$files2") >> remaining_files_in_${dir2}.list
fi

awk -v DIR="$dir1/" '{print DIR$1}' remaining_files_in_${dir1}.list >> remaining_files.list
awk -v DIR="$dir2/" '{print DIR$1}' remaining_files_in_${dir2}.list >> remaining_files.list

rm remaining_files_in_${dir1}.list
rm remaining_files_in_${dir2}.list
