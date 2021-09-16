#!/bin/bash

# For a given input FASTA file of proteins all from the same species and for a given taxonomic level of orthology,
# this script does:
# 1) find and save the mapping between the proteins' Uniprot ids and their respective OrthoDB ids in a text file;
# 2) downloads the FASTA files of orthologous sequences for all target proteins and given the chosen orthology level.
# Here, the orthology level is set to bacteria (in ODB, this corresponds to level=2 and species=2).


### Argument parser
while getopts f:o:d:s: arg
do
    case "${arg}" in
        f) # Specify input fasta file of target proteins
	    infile=${OPTARG};;
        o) # Specify output directory for orthologs fasta files
	    outdir=${OPTARG};;
        d)  # Specify database file to be searched
	    database=${OPTARG};;
        s)  # Specify target species
	    species=${OPTARG};;
    esac
done


### Mapping between specie names and NCBI taxonomic ids
if [[ "$species" == "ecoli" ]];
then
    regex="562_0\|562_1\|562_2\|562_3"
elif [[ "$species" == "pprotegens" ]];
then
    regex="220664_0"
elif [[ "$species" == "pputida" ]];
then
    regex="351746_0"
fi


### Search against database
ids_file="${species}_ids.txt"
while read -r string; do

    if [[ "$string" == '>'* ]];
    then
        echo "$string"
        uniprot=$(echo "$string" | cut -d "|" -f 1)
        uniprot="${uniprot:1:-1}"

    elif [[ "$string" != '>'* ]];
    then
        sequence="$string"
        # grep sequence across all possible genome assemblies and keep 1st match
        result=$(ls -l | grep -w -B 1 "$sequence" "$database" | grep -w "$regex" | head -1)

        # if no result grep across all species in database and keep 1st match
        if [[ -z "$result" ]];
        then
            result=$(ls -l | grep -w -B 1 "$sequence" "$database" | head -1)

            # if no match across database, do hmmer search to find closest sequence
            if [[ -z "$result" ]];
            then
		echo "$uniprot"
		printf ">${uniprot}\n${sequence}" >> "no_hit.fasta"
		jackhmmer --noali --notextw --tblout "tmp_tblout.txt" -N 3 "no_hit.fasta" "${database}"

		# read hmmer search output table and save top hit
		python process_hmmer_output.py "tmp_tblout.txt" "$destdir"

		# remove tmp files
		rm "no_hit.fasta" "tmp_tblout.txt"
            else
                result=$(echo "$result" | cut -f 1)
                result="${result:1}"
                echo "${uniprot},${result}" >> "$ids_file"
            fi
        else
            result=$(echo "$result" | cut -f 1)
            result="${result:1}"
	    echo "${uniprot},${result}" >> "$ids_file"
        fi
    fi
done < "$infile"


### download fasta file of orthologous sequences from OrthoDB
echo "Downloading fasta files of orthologs from OrthoDB."

while IFS=$',' read -r -a myArray
do
    uniprot_id="${myArray[0]}"
    orthodb_id="${myArray[1]}"
    # level=2 and species=2 set the orthology level to bacteria
    url="https://v101.orthodb.org/fasta?query=${orthodb_id}&level=2&species=2"
    filename="${outdir}/${uniprot_id}_orthologs.fasta"
    wget "$url" -O "$filename"
done < "$ids_file"
