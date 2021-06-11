#! /bin/bash

# pull workflow from devel
sbpull bdc smgogarten/genesis-relatedness/king-robust-1 king-robust-wf.cwl --unpack

# push tools to pre-build
sbpack bdc smgogarten/genesis-relatedness-pre-build/king-robust king-robust-wf.cwl.steps/king_robust.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/kinship-plots king-robust-wf.cwl.steps/kinship_plots.cwl

# pull tools with new app ids from pre-build
sbpull bdc smgogarten/genesis-relatedness-pre-build/king-robust tools/king_robust.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/kinship-plots tools/kinship_plots.cwl

# copy tools to workflow steps
cp tools/king_robust.cwl king-robust-wf.cwl.steps/king_robust.cwl
cp tools/kinship_plots.cwl king-robust-wf.cwl.steps/kinship_plots.cwl

# push workflow to pre-build
sbpack bdc smgogarten/genesis-relatedness-pre-build/king-robust-1 king-robust-wf.cwl

# push workflow to commit
sbpack bdc smgogarten/uw-gac-commit/king-robust king-robust-wf.cwl
