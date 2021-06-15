#! /bin/bash

# pull workflow from devel
sbpull bdc smgogarten/genesis-relatedness/pc-air pc-air-wf.cwl --unpack

# push tools to pre-build
sbpack bdc smgogarten/genesis-relatedness-pre-build/find-unrelated pc-air-wf.cwl.steps/find_unrelated.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/pca-byrel pc-air-wf.cwl.steps/pca_byrel.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/pca-plots pc-air-wf.cwl.steps/pca_plots.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/variant_id_from_gds pc-air-wf.cwl.steps/variant_id_from_gds.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/pca-corr-vars pc-air-wf.cwl.steps/pc_variant_correlation.cwl.steps/pca_corr_vars.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/pca-corr pc-air-wf.cwl.steps/pc_variant_correlation.cwl.steps/pca_corr.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/pca-corr-plots pc-air-wf.cwl.steps/pc_variant_correlation.cwl.steps/pca_corr_plots.cwl

# pull tools with new app ids from pre-build
sbpull bdc smgogarten/genesis-relatedness-pre-build/find-unrelated tools/find_unrelated.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/pca-byrel tools/pca_byrel.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/pca-plots tools/pca_plots.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/variant_id_from_gds tools/variant_id_from_gds.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/pc-variant-correlation pc_variant_correlation.cwl --unpack
sbpull bdc smgogarten/genesis-relatedness-pre-build/pca-corr-vars tools/pca_corr_vars.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/pca-corr tools/pca_corr.cwl
sbpull bdc smgogarten/genesis-relatedness-pre-build/pca-corr-plots tools/pca_corr_plots.cwl

# copy tools to workflow steps
cp tools/find_unrelated.cwl pc-air-wf.cwl.steps/find_unrelated.cwl
cp tools/pca_byrel.cwl pc-air-wf.cwl.steps/pca_byrel.cwl
cp tools/pca_plots.cwl pc-air-wf.cwl.steps/pca_plots.cwl
cp tools/variant_id_from_gds.cwl pc-air-wf.cwl.steps/variant_id_from_gds.cwl
cp pc_variant_correlation.cwl pc-air-wf.cwl.steps/pc_variant_correlation.cwl
cp tools/pca_corr_vars.cwl pc-air-wf.cwl.steps/pc_variant_correlation.cwl.steps/pca_corr_vars.cwl
cp tools/pca_corr.cwl pc-air-wf.cwl.steps/pc_variant_correlation.cwl.steps/pca_corr.cwl
cp tools/pca_corr_plots.cwl pc-air-wf.cwl.steps/pc_variant_correlation.cwl.steps/pca_corr_plots.cwl

# push workflow to pre-build
sbpack bdc smgogarten/genesis-relatedness-pre-build/pc-variant-correlation pc_variant_correlation.cwl
sbpack bdc smgogarten/genesis-relatedness-pre-build/pc-air pc-air-wf.cwl

# push workflow to commit
sbpack bdc smgogarten/uw-gac-commit/pc-air pc-air-wf.cwl
