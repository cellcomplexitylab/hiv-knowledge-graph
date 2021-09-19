#!/usr/bin/env python3

"""
Invoke as shown below:
python3 refseq.py Homo_sapiens.gene_info.gz > Homo_sapiens.gene_info.json
"""

import gzip
import json
import os
import sys

from datetime import datetime

def format_date(string):
    "Transform 20210611 into 2021-06-11."
    return datetime.strptime(string, "%Y%m%d").strftime("%Y-%m-%d")

def external_identifiers(string):
    "Extract identifiers from string and return a dict."
    # MIM:138670|HGNC:HGNC:5|Ensembl:ENSG00000121410
    IDs = dict()
    for entry in string.split("|"):
        if entry.startswith("MIM:"): IDs["OMIM_ID"] = int(entry[4:])
        if entry.startswith("Ensembl:"): IDs["Ensembl_ID"] = entry[8:]
        if entry.lower().startswith("flybase:"): IDs["FlyBase_ID"] = entry[8:]
    return IDs


if __name__ == "__main__":
    json_data = list()
    with gzip.open(sys.argv[1]) as f:
        next(f) # Skip 1-line header.
        for line in f:
            line = line.decode('ascii') # Required for zipped files.
            items = line.split('\t')
            entry = {
                "tax_id": int(items[0]),
                "NCBI_gene_ID": int(items[1]),
                "symbol": items[2],
                "syonyms": [] if items[4] == "-" else items[4].split("|"),
                "full_name": items[8], 
                "updated": format_date(items[14])
            }
            entry.update(external_identifiers(items[5]))
            json_data.append(entry)
    # Output to stdout.        
    json.dump(json_data, sys.stdout, indent=4)
