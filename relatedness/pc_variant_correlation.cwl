cwlVersion: v1.2
class: Workflow
label: PC-variant correlation
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ScatterFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
  sbg:x: -58
  sbg:y: 30
- id: gds_file_full
  label: Full GDS Files
  doc: GDS files (one per chromosome) used to calculate PC-variant correlations.
  type: File[]
  sbg:fileTypes: GDS
  sbg:x: -25.0925350189209
  sbg:y: 187.01194763183594
- id: variant_include_file
  label: Variant include file
  doc: |-
    RData file with vector of variant.id to include. These variants will be added to the set of randomly selected variants. It is recommended to provide the set of pruned variants used for PCA.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -106
  sbg:y: -85
- id: pca_file
  label: PCA file
  doc: RData file with PCA results for unrelated samples
  type: File
  sbg:fileTypes: RDATA
  sbg:x: 11.241790771484375
  sbg:y: -188.33731079101562
- id: n_corr_vars
  label: Number of variants to select
  doc: |-
    Randomly select this number of variants distributed across the entire genome to use for PC-variant correlation. If running on a single chromosome, the variants returned will be scaled by the proportion of that chromosome in the genome.
  type: int?
  sbg:exposed: true
- id: n_pcs
  label: Number of PCs
  doc: Number of PCs (Principal Components) to return.
  type: int?
  sbg:x: -67.57342529296875
  sbg:y: -311.5232849121094
- id: n_pcs_plot
  label: Number of PCs to plot
  doc: Number of PCs to plot.
  type: int?
  sbg:exposed: true
- id: n_perpage
  label: Number of plots per page
  doc: |-
    Number of PC-variant correlation plots to stack in a single page. The number of png files generated will be ceiling(n_pcs_plot/n_perpage).
  type: int?
  sbg:exposed: true

outputs:
- id: pc_correlation_plots
  label: PC-variant correlation plots
  doc: PC-variant correlation plots
  type: File[]?
  outputSource:
  - pca_corr_plots/pca_corr_plots
  sbg:fileTypes: PNG
  sbg:x: 678.9522094726562
  sbg:y: -9.483582496643066
- id: pca_corr_gds
  label: PC-variant correlation
  doc: GDS file with PC-variant correlation results
  type: File[]?
  outputSource:
  - pca_corr/pca_corr_gds
  sbg:fileTypes: GDS
  sbg:x: 581.6796875
  sbg:y: 159

steps:
- id: pca_corr_vars
  label: pca_corr_vars
  in:
  - id: gds_file
    source: gds_file_full
  - id: variant_include_file
    source: variant_include_file
  - id: out_prefix
    source: out_prefix
  - id: n_corr_vars
    source: n_corr_vars
  - id: chromosome
    valueFrom: |-
      ${
          if (inputs.gds_file.nameroot.includes('chr')) {
              var parts = inputs.gds_file.nameroot.split('chr')
              var chrom = parts[1]
          } else {
              var chrom = "NA"
          }
          return chrom
      }
  scatter:
  - gds_file
  scatterMethod: dotproduct
  run: pc_variant_correlation.cwl.steps/pca_corr_vars.cwl
  out:
  - id: pca_corr_vars
  sbg:x: 121
  sbg:y: -8
- id: pca_corr
  label: pca_corr
  in:
  - id: gds_file
    source: gds_file_full
  - id: variant_include_file
    source: pca_corr_vars/pca_corr_vars
  - id: pca_file
    source: pca_file
  - id: n_pcs_corr
    source: n_pcs
  - id: out_prefix
    source: out_prefix
  scatter:
  - gds_file
  - variant_include_file
  run: pc_variant_correlation.cwl.steps/pca_corr.cwl
  out:
  - id: pca_corr_gds
  sbg:x: 350
  sbg:y: 30
- id: pca_corr_plots
  label: pca_corr_plots
  in:
  - id: n_pcs_plot
    source: n_pcs_plot
  - id: corr_file
    source:
    - pca_corr/pca_corr_gds
  - id: n_perpage
    source: n_perpage
  - id: out_prefix
    source: out_prefix
  run: pc_variant_correlation.cwl.steps/pca_corr_plots.cwl
  out:
  - id: pca_corr_plots
  sbg:x: 489.2178955078125
  sbg:y: -117.57015228271484
