#! /bin/bash

sbpull bdc admin/sbg-public-data/vcf-to-gds vcf-to-gds-wf.cwl --unpack

sbpull bdc admin/sbg-public-data/null-model null-model-wf.cwl --unpack

sbpull bdc admin/sbg-public-data/single-variant-association-testing assoc-single-wf.cwl --unpack

sbpull bdc admin/sbg-public-data/aggregate-association-testing assoc-aggregate-wf.cwl --unpack

sbpull bdc admin/sbg-public-data/sliding-window-association-testing assoc-window-wf.cwl --unpack

sbpull bdc admin/sbg-public-data/genesis-locuszoom locuszoom.cwl

cp *.steps/* tools/
