#!/usr/bin/env python3

# Reads hmmersearch output table and saves query id to output file.

import pandas as pd
import sys

input_file=sys.argv[1]
output_file=sys.argv[2]

columns = ['target_name', 'accession', 'query_name', 'accession', 'E-value', 'score', 'bias', 'E-value', 'score', 'bias', 'exp', 'reg', 'clu', 'ov', 'env', 'dom', 'rep', 'inc', 'description_of_target']

with open(input_file, 'r') as f:
	lines = [l.split() for l in f.readlines()]

data = pd.DataFrame(lines[3:])
data.columns = columns

with open(output_file,'a') as f:
    f.write(data.query_name[0] + ',' + data.target_name[0])
    f.write('\n')
