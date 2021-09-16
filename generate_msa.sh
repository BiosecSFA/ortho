#!/bin/bash

# This script builds MSA for target proteins for chosen sequence coverage and sequence identity percentages.
# Takes as inputs the mapping between the target proteins' Uniprot ids and OrthoDB ids.


# arguments passed to script
while getopts f:i:o:h:c:i: arg
do
    case "${arg}" in
    f) # Specify input file (Uniprot ids <> orthoDB ids)
	    infile=${OPTARG};;
    o) # Specify output directory, where MSA are saved
	    outdir=${OPTARG};;
	r) # Specify directory to FASTA files of orthologous sequences
	    orthologs_dir=${OPTARG};;
    c) # Specify sequence coverage
	    cov=${OPTARG};;
	i) # Specify sequence identity %
	    id=${OPTARG};;
    esac
done


while IFS=$',' read -r -a myArray
do
    uniprot_id="${myArray[0]}"
    orthodb_id="${myArray[1]}"
    echo "Building MSA for ${uniprot_id}."

    # download reference fasta file from Uniprot
    uniprot_url="https://www.uniprot.org/uniprot/${uniprot_id}.fasta"
    wget "$uniprot_url"

    orthologs_file="${orthologs_dir}/${uniprot_id}_orthologs.fasta"

    # align sequences
    jackhmmer --noali --notextw --cpu 1 --incT 100 -T 100 -N 4 -A "${uniprot_id}.sto" "${uniprot_id}.fasta" "${orthologs_file}"

    # convert sto file to fas file
    perl s2f.pl "${uniprot_id}.sto" "${uniprot_id}.fas"

    # filter sequences by identity and coverage
    hhfilter -i "${uniprot_id}.fas" -o "${outdir}/${uniprot_id}.i${id}c${cov}.diff512.a3m" -i "$id" -c "$cov" -M first -diff 512 

    # remove tmp files
    rm "${uniprot_id}.fasta" "${uniprot_id}.sto" "${uniprot_id}.fas"

done < "$infile"
