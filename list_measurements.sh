#!/bin/sh
#
# A short, hacky script for generating the measurement file for the CellPainting gallery
#

for source in $(./mc ls --json s3/cellpainting-gallery/cpg0016-jump/ | jq -r .key); do
    for batch in $(./mc ls --json s3/cellpainting-gallery/cpg0016-jump/${source}images | jq -r .key); do
        for measurement in $(./mc ls --json s3/cellpainting-gallery/cpg0016-jump/${source}images/${batch}images/ | jq -r .key); do
            if [ "$measurement" != "/" ]; then
                echo s3/cellpainting-gallery/cpg0016-jump/${source}images/${batch}images/${measurement}
            fi
        done
    done
done
