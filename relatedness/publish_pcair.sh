#! /bin/bash

# pull workflow from devel
sbpull bdc smgogarten/genesis-relatedness/pc-air pc-air-wf.cwl --unpack

# push tools to pre-build
sbpack bdc smgogarten/genesis-relatedness-pre-build/find-unrelated pc-air-wf.cwl.steps/find_unrelated.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/pca-byrel pc-air-wf.cwl.steps/pca_byrel.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/pca-plots pc-air-wf.cwl.steps/pca_plots.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/pca-corr-vars pc-air-wf.cwl.steps/pca_corr_vars.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/pca-corr pc-air-wf.cwl.steps/pca_corr.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/pca-corr-plots pc-air-wf.cwl.steps/pca_corr_plots.cwl

# pull tools with new app ids from pre-build
sbpull bdc smgogarten/genesis-relatedness-pre-build/find-unrelated find_unrelated.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/pca-byrel pca_byrel.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/pca-plots pca_plots.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/pca-corr-vars pca_corr_vars.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/pca-corr pca_corr.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/pca-corr-plots pca_corr_plots.cwl

# copy tools to workflow steps
cp find_unrelated.cwl pc-air-wf.cwl.steps/find_unrelated.cwl
cp pca_byrel.cwl pc-air-wf.cwl.steps/pca_byrel.cwl
cp pca_plots.cwl pc-air-wf.cwl.steps/pca_plots.cwl
cp pca_corr_vars.cwl pc-air-wf.cwl.steps/pca_corr_vars.cwl
cp pca_corr.cwl pc-air-wf.cwl.steps/pca_corr.cwl
cp pca_corr_plots.cwl pc-air-wf.cwl.steps/pca_corr_plots.cwl

# push workflow to pre-build
sbpack bdc smgogarten/genesis-relatedness-pre-build/pc-air pc-air-wf.cwl

# push workflow to commit
sbpack smgogarten/uw-gac-commit/pc-air pc-air-wf.cwl
