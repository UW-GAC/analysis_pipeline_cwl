#! /bin/bash

# pull workflow from devel
sbpull bdc smgogarten/genesis-relatedness/pedigree-check-wf pedigree-check-wf.cwl --unpack

# push tools to pre-build
sbpack bdc smgogarten/genesis-relatedness-pre-build/pedigree-format pedigree-check-wf.cwl.steps/pedigree_format.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/pedigree-check-1 pedigree-check-wf.cwl.steps/pedigree_check.cwl

# pull tools with new app ids from pre-build
sbpull bdc smgogarten/genesis-relatedness-pre-build/pedigree-format pedigree_format.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/pedigree-check-1 pedigree_check.cwl

# copy tools to workflow steps
cp pedigree_format.cwl pedigree-check-wf.cwl.steps/pedigree_format.cwl
cp pedigree_check.cwl pedigree-check-wf.cwl.steps/pedigree_check.cwl

# push workflow to pre-build
sbpack bdc smgogarten/genesis-relatedness-pre-build/pedigree-check-wf pedigree-check-wf.cwl

# push workflow to commit
sbpack bdc smgogarten/uw-gac-commit/pedigree-check pedigree-check-wf.cwl
