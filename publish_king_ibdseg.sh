#! /bin/bash

# pull workflow from devel
sbpull bdc smgogarten/genesis-relatedness/king-pipeline king-robust-wf.cwl --unpack

# push tools to pre-build
sbpack bdc smgogarten/genesis-relatedness-pre-build/gds2bed king-ibdseg-wf.cwl.steps/gds2bed.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/plink-make-bed king-ibdseg-wf.cwl.steps/plink_make_bed.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/king-ibdseg king-ibdseg-wf.cwl.steps/king_ibdseg.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/king-to-matrix king-ibdseg-wf.cwl.steps/king_to_matrix.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/kinship-plots king-ibdseg-wf.cwl.steps/kinship_plots.cwl

# pull tools with new app ids from pre-build
sbpull bdc smgogarten/genesis-relatedness-pre-build/gds2bed gds2bed.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/plink-make-bed plink_make_bed.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/king-ibdsg king_ibdseg.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/king-to-matrix king_to_matrix.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/kinship-plots kinship_plots.cwl

# copy tools to workflow steps
cp gds2bed.cwl king-ibdseg-wf.cwl.steps/gds2bed.cwl
cp plink_make_bed.cwl king-ibdseg-wf.cwl.steps/plink_make_bed.cwl
cp king_ibdseg.cwl king-ibdseg-wf.cwl.steps/king_ibdseg.cwl
cp king_to_matrix.cwl king-ibdseg-wf.cwl.steps/king_to_matrix.cwl
cp kinship_plots.cwl king-ibdseg-wf.cwl.steps/kinship_plots.cwl

# push workflow to pre-build
sbpack bdc smgogarten/genesis-relatedness-pre-build/king-ibdseg-1 king-ibdseg-wf.cwl

# push workflow to commit
sbpack bdc smgogarten/uw-gac-commit/king-ibdseg king-ibdseg-wf.cwl
