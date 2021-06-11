#! /bin/bash

# pull workflow from devel
sbpull bdc smgogarten/genesis-relatedness/ld-pruning-pipeline ld-pruning-wf.cwl --unpack

# push tools to pre-build
sbpack bdc smgogarten/genesis-relatedness-pre-build/check-merged-gds ld-pruning-wf.cwl.steps/check_merged_gds.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/ld-pruning ld-pruning-wf.cwl.steps/ld_pruning.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/merge-gds ld-pruning-wf.cwl.steps/merge_gds.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/subset-gds ld-pruning-wf.cwl.steps/subset_gds.cwl

# pull tools with new app ids from pre-build
sbpull bdc smgogarten/genesis-relatedness-pre-build/check-merged-gds tools/check_merged_gds.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/ld-pruning tools/ld_pruning.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/merge-gds tools/merge_gds.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/subset-gds tools/subset_gds.cwl

# copy tools to workflow steps
cp tools/check_merged_gds.cwl ld-pruning-wf.cwl.steps/check_merged_gds.cwl
cp tools/ld_pruning.cwl ld-pruning-wf.cwl.steps/ld_pruning.cwl
cp tools/merge_gds.cwl ld-pruning-wf.cwl.steps/merge_gds.cwl
cp tools/subset_gds.cwl ld-pruning-wf.cwl.steps/subset_gds.cwl

# push workflow to pre-build
sbpack bdc smgogarten/genesis-relatedness-pre-build/ld-pruning-1 ld-pruning-wf.cwl

# push workflow to commit
sbpack bdc smgogarten/uw-gac-commit/ld-pruning
