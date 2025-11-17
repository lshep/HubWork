#!/usr/bin/env bash

# Output file
OUTFILE="hub_ids.txt"

# Fetch highest AnnotationHub ID
AH_MAX=$(curl -s https://annotationhub.bioconductor.org/metadata/highest_id)

# Fetch highest ExperimentHub ID
EH_MAX=$(curl -s https://experimenthub.bioconductor.org/metadata/highest_id)

# Clear output file
> "$OUTFILE"

# Generate AnnotationHub entries
for ((i=1; i<=AH_MAX; i++)); do
    echo "AnnotationHub AH$i" >> "$OUTFILE"
done

# Generate ExperimentHub entries
for ((i=1; i<=EH_MAX; i++)); do
    echo "ExperimentHub EH$i" >> "$OUTFILE"
done

echo "Done. Output written to $OUTFILE"
