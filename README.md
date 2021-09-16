# recoding


### Generating MSA
TODO: some words of intro on the rational behind using OrthoDB 
<br><br>
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
- ``-c`` the percentage of sequence coverage.
- ``-i`` the pecrentage of identity coverage.
