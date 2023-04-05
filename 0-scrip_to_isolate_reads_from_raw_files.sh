#!/bin/bash

# ----script to convert .fq.gz to .fasta and isolate reads from raw files----
# author: Richard Thomas Sanchez
# coautor: Juan E. Arboleda
# date: 20/03/2023

# values to replace
# file_name
# dir_file
# dir_database
# file_database

# define variables

dataset="file_path_dataset"
dir_tsv="file_path_tsv"
dir_txt="file_path_txt"
dir_fasta="file_path_fasta"
database="file_path_database"
seqtk="seqtk_program_path"

# funtions to check directories and files

function check_file {
    local dir="$1"
    local file="$2"

    while [ ! -f "$dir/$file" ] || [ ! "$dir/$file" ]; do
        sleep 5s
    done

    if [ ! -s "$dir/$file" ]; then
        echo "The file $file is empty, all processes will stop and the task will be completed"
        exit 1
    fi
}

time

# bucle to convert .fq.gz to .fasta and unify

for file in file_name_*.fq.gz; do
    "$seqtk"/seqtk seq -a "$file" > "${file%.fq.gz}".fasta
done

cat file_name_*fasta > file_name.fasta

# check and verify that the .fasta final file has been written

check_file "$dataset/dir_file" "file_name.fasta"

# run blast

module load BLAST/2.11.0-Linux_x86_64

blastn -query "$dataset/dir_file/file_name.fasta" -db "$database/dir_database/file_database.fasta" -evalue 1e-6 -outfmt 6 \
-out "$dir_tsv/file_name.tsv"

# check and verify that the .tsv file has been written

check_file "$dir_tsv" "file_name.tsv"

# run cut

cut -f 1 "$dir_tsv/file_name.tsv" | sort | uniq > "$dir_txt/file_name.txt"

# check and verify that the .txt file as been written

check_file "$dir_txt" "file_name.txt"

# writte the .fasta file

"$seqtk"/seqtk subseq "$dataset/dir_database/file_name.fasta" "$dir_txt/file_name.txt" > "$dir_fasta/file_name.fasta"