# ORTHO

## Introduction
_TODO: some words of intro on the rational behind using OrthoDB_

## Generating the MSA
As a prerequisite you should install [HMMER](http://hmmer.org/documentation.html) and the [HH-suite](https://github.com/soedinglab/hh-suite).
You will also need to download the [database of orthologous genes](https://v101.orthodb.org/download/odb10v1_all_og_fasta.tab.gz) (8.5 GB), 
a FASTA file of all species and proteins in OrthoDB orthologous groups.
<br><br>
For an input FASTA file of proteins all from the same species, featuring both the Uniprotd ids and AA sequences,
and for a chosen taxonomic level of orthology (set by default to *bacteria*), the following command:
 - returns the mapping betwen the Uniprot ids and OrthoDB ids (saved as *species_ids.txt*);
 - downloads the FASTA files of orthologous proteins (saved as *uniprot_orthologs.fasta*).

``bash download_orthologs.sh -f input_file.fasta -o orthologs -d odb10v1_all_og_fasta.tab -s target_species
``
 
``download_orthologs.sh`` has flags that specify:
- ``-f`` the input FASTA file. AA sequences must all be from the same species.
- ``-o`` the output directory where the FASTA files of orthologs are saved.
- ``-d`` the database searched.
- ``-s`` the target species, ie 'ecoli' (*Escherichia coli*). Current other options are 'pprotegens' (*Pseudomonas protegens*) and 'pputida'
(*Pseudomonas putida*). 

<br>
Build the MSAs with the following command:

``bash generate_msa.sh -f species_ids.txt -o msa -r orthologs -c 90 -i 90
``

``generate_msa.sh`` has flags that determine:
- ``-f`` the input file, which is the mapping between the Uniprot ids and OrthoDB ids.
- ``-o`` the output directory where the MSAs are saved.
- ``-r`` the directory where the FASTA files of orthologs are saved.
- ``-c`` the percentage of sequence coverage [optional, default=90].
- ``-i`` the percentage of identity coverage [optional, default=90].
- ``-d`` keep at least this seqs in each block of length 50 [optional, default=512].
- ``-s`` skip the final filtering step (`hhfilter`)

## License

Ortho is released as part of the [GENTANGLE](https://github.com/BiosecSFA/gentangle) pipeline ([LLNL](https://www.llnl.gov/)-CODE-845475) and is distributed under the terms of the MIT License (see LICENSE). 

SPDX-License-Identifier: MIT

## Funding

This work is supported by the U.S. Department of Energy, Office of Science, Office of Biological and Environmental Research, Lawrence Livermore National Laboratory Secure Biosystems Design SFA “From Sequence to Cell to Population: Secure and Robust Biosystems Design for Environmental Microorganisms”.  Work at LLNL is performed under the auspices of the U.S. Department of Energy at Lawrence Livermore National Laboratory under Contract DE-AC52-07NA27344. 

___

If you use ORTHO in your research, please cite the following papers. Thanks!

Allen JE, _et al._ **GENTANGLE: integrated computational design of gene entanglements**. _In preparation_. 2022. 

Blazejewski T, Ho HI, Wang HH. **Synthetic sequence entanglement augments stability and containment of genetic information in cells**. _Science_. 2019 Aug 9;365(6453):595-8. https://doi.org/10.1126/science.aav5477
___
