#! /bin/bash

# pull workflow from devel
sbpull bdc smgogarten/genesis-relatedness/king-robust-1 king-robust-wf.cwl --unpack

# push tools to pre-build
sbpack bdc smgogarten/genesis-relatedness-pre-build/pcrelate-beta pc-relate-wf.cwl.steps/pcrelate_beta.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/sample-blocks-to-segments pc-relate-wf.cwl.steps/sample_blocks_to_segments.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/pcrelate pc-relate-wf.cwl.steps/pcrelate.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/pcrelate-correct pc-relate-wf.cwl.steps/pcrelate_correct.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/kinship-plots pc-relate-wf.cwl.steps/kinship_plots.cwl

# pull tools with new app ids from pre-build
sbpull bdc smgogarten/genesis-relatedness-pre-build/pcrelate-beta pcrelate_beta.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/sample-blocks-to-segments sample_blocks_to_segments.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/pcrelate pcrelate.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/pcrelate-correct pcrelate_correct.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/kinship-plots kinship_plots.cwl

# copy tools to workflow steps
cp pcrelate_beta.cwl pc-relate-wf.cwl.steps/pcrelate_beta.cwl
cp sample_blocks_to_segments.cwl pc-relate-wf.cwl.steps/sample_blocks_to_segments.cwl
cp pcrelate.cwl pc-relate-wf.cwl.steps/pcrelate.cwl
cp pcrelate_correct.cwl pc-relate-wf.cwl.steps/pcrelate_correct.cwl
cp kinship_plots.cwl pc-relate-wf.cwl.steps/kinship_plots.cwl

# push workflow to pre-build
sbpack bdc smgogarten/genesis-relatedness-pre-build/pc-relate pc-relate-wf.cwl

# push workflow to commit
sbpack bdc smgogarten/uw-gac-commit/pc-relate pc-relate-wf.cwl
