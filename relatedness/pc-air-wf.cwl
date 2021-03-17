cwlVersion: v1.1
class: Workflow
label: PC-AiR
doc: |-
  This workflow uses the PC-AiR algorithm to compute ancestry principal components (PCs) while accounting for kinship.

  Step 1 uses pairwise kinship estimates to assign samples to an unrelated set that is representative of all ancestries in the sample. Step 2 performs Principal Component Analysis (PCA) on the unrelated set, then projects relatives onto the resulting set of PCs. Step 3 plots the PCs, optionally color-coding by a grouping variable. Step 4 calculates the correlation between each PC and variants in the dataset, then plots this correlation to allow screening for PCs that are driven by particular genomic regions.
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ScatterFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: kinship_file
  label: Kinship File
  doc: |-
    Pairwise kinship matrix used to identify unrelated and related sets of samples in Step 1. It is recommended to use KING-IBDseg or PC-Relate estimates.
  type: File
  sbg:fileTypes: RDATA, GDS
  sbg:x: -566.5120849609375
  sbg:y: 182.8510284423828
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
  sbg:x: -665.81005859375
  sbg:y: 56.52513885498047
- id: gds_file
  label: Pruned GDS File
  doc: |-
    Input GDS file for PCA. It is recommended to use an LD pruned file with all chromosomes.
  type: File
  sbg:fileTypes: GDS
  sbg:x: -382.63873291015625
  sbg:y: 334.4525146484375
- id: gds_file_full
  label: Full GDS Files
  doc: GDS files (one per chromosome) used to calculate PC-variant correlations.
  type: File[]
  sbg:fileTypes: GDS
  sbg:x: -261.1378173828125
  sbg:y: 589.2774658203125
- id: divergence_file
  label: Divergence File
  doc: |-
    Pairwise matrix used to identify ancestrally divergent pairs of samples in Step 1. It is recommended to use KING-robust estimates.
  type: File?
  sbg:fileTypes: RDATA, GDS
  sbg:x: -590.9608764648438
  sbg:y: 319.02606201171875
- id: sample_include_file
  label: Sample Include file
  doc: |-
    RData file with vector of sample.id to include. If not provided, all samples in the GDS file are included.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -628.7839965820312
  sbg:y: -77.0744857788086
- id: variant_include_file
  label: Variant include file
  doc: |-
    RData file with vector of variant.id to include. If not provided, all variants in the GDS file are included.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -537.6592407226562
  sbg:y: -221.6741180419922
- id: phenotype_file
  label: Phenotype file
  doc: |-
    RData file with data.frame or AnnotatedDataFrame of phenotypes. Used for color-coding PCA plots by group.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -14.366241455078125
  sbg:y: -274.2578430175781
- id: pc_corr_variant_file
  label: PC correlation variant file
  doc: |-
    RData file with vector of variant.id to include in PC-variant correlation. These variants will be added to the set of randomly selected variants. It is recommended to provide the set of pruned variants used for PCA.
  type: File[]?
  sbg:fileTypes: RDATA
  sbg:x: -415.7858581542969
  sbg:y: 489.8268127441406
- id: kinship_threshold
  label: Kinship threshold
  doc: Minimum kinship estimate to use for identifying relatives.
  type: float?
  sbg:exposed: true
- id: divergence_threshold
  label: Divergence threshold
  doc: |-
    Maximum divergence estimate to use for identifying ancestrally divergent pairs of samples.
  type: float?
  sbg:exposed: true
- id: n_pairs
  label: Number of PCs
  doc: Number of PCs to include in the pairs plot.
  type: int?
  sbg:exposed: true
- id: group
  label: Group
  doc: |-
    Name of column in phenotype_file containing group variable for color-coding plots.
  type: string?
  sbg:exposed: true
- id: n_corr_vars
  label: Number of variants to select
  doc: |-
    Randomly select this number of variants distributed across the entire genome to use for PC-variant correlation. If running on a single chromosome, the variants returned will be scaled by the proportion of that chromosome in the genome.
  type: int?
  sbg:exposed: true
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
- id: n_pcs
  label: Number of PCs
  doc: Number of PCs (Principal Components) to return.
  type: int?
  sbg:exposed: true

outputs:
- id: out_unrelated_file
  label: Unrelated file
  doc: RData file with vector of sample.id of unrelated samples identified in Step
    1
  type: File?
  outputSource:
  - find_unrelated/out_unrelated_file
  sbg:fileTypes: RDATA
  sbg:x: -223.16201782226562
  sbg:y: -296.2215881347656
- id: out_related_file
  label: Related file
  doc: |-
    RData file with vector of sample.id of samples related to the set of unrelated samples identified in Step 1
  type: File?
  outputSource:
  - find_unrelated/out_related_file
  sbg:fileTypes: RDATA
  sbg:x: -200.21041870117188
  sbg:y: -189.47299194335938
- id: pcair_output
  label: RData file with PC-AiR PCs for all samples
  type: File?
  outputSource:
  - pca_byrel/pcair_output
  sbg:fileTypes: RDATA
  sbg:x: 372.57098388671875
  sbg:y: -50.2413215637207
- id: pcair_plots
  label: PC plots
  doc: PC plots
  type: File[]?
  outputSource:
  - pca_plots/pca_plots
  sbg:x: 471.4736022949219
  sbg:y: -205.1788787841797
- id: pc_correlation_plots
  label: PC-variant correlation plots
  doc: PC-variant correlation plots
  type: File[]?
  outputSource:
  - pca_corr_plots/pca_corr_plots
  sbg:fileTypes: PNG
  sbg:x: 511.36871337890625
  sbg:y: 143.69459533691406

steps:
- id: find_unrelated
  label: find_unrelated
  in:
  - id: kinship_file
    source: kinship_file
  - id: divergence_file
    source: divergence_file
  - id: kinship_threshold
    source: kinship_threshold
  - id: divergence_threshold
    source: divergence_threshold
  - id: sample_include_file
    source: sample_include_file
  - id: out_prefix
    source: out_prefix
  run: pc-air-wf.cwl.steps/find_unrelated.cwl
  out:
  - id: out_related_file
  - id: out_unrelated_file
  sbg:x: -343.6015625
  sbg:y: -80.5
- id: pca_byrel
  label: pca_byrel
  in:
  - id: gds_file
    source: gds_file
  - id: related_file
    source: find_unrelated/out_related_file
  - id: unrelated_file
    source: find_unrelated/out_unrelated_file
  - id: sample_include_file
    source: sample_include_file
  - id: variant_include_file
    source: variant_include_file
  - id: n_pcs
    source: n_pcs
  - id: out_prefix
    source: out_prefix
  run: pc-air-wf.cwl.steps/pca_byrel.cwl
  out:
  - id: pcair_output
  - id: pcair_output_unrelated
  sbg:x: -94.60113525390625
  sbg:y: -19.5
- id: pca_plots
  label: pca_plots
  in:
  - id: pca_file
    source: pca_byrel/pcair_output
  - id: phenotype_file
    source: phenotype_file
  - id: n_pairs
    source: n_pairs
  - id: group
    source: group
  - id: out_prefix
    source: out_prefix
  run: pc-air-wf.cwl.steps/pca_plots.cwl
  out:
  - id: pca_plots
  sbg:x: 206.48231506347656
  sbg:y: -174.49720764160156
- id: pca_corr_vars
  label: pca_corr_vars
  in:
  - id: gds_file
    source: gds_file_full
  - id: variant_include_file
    source: pc_corr_variant_file
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
  - variant_include_file
  scatterMethod: dotproduct
  run: pc-air-wf.cwl.steps/pca_corr_vars.cwl
  out:
  - id: pca_corr_vars
  sbg:x: -126.7020492553711
  sbg:y: 225.0484161376953
- id: pca_corr
  label: pca_corr
  in:
  - id: gds_file
    source: gds_file_full
  - id: variant_include_file
    source: pca_corr_vars/pca_corr_vars
  - id: pca_file
    source: pca_byrel/pcair_output_unrelated
  - id: out_prefix
    source: out_prefix
  scatter:
  - gds_file
  - variant_include_file
  run: pc-air-wf.cwl.steps/pca_corr.cwl
  out:
  - id: pca_corr_gds
  sbg:x: 80.39886474609375
  sbg:y: 143.5
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
  run: pc-air-wf.cwl.steps/pca_corr_plots.cwl
  out:
  - id: pca_corr_plots
  sbg:x: 287.39886474609375
  sbg:y: 70.5
sbg:appVersion:
- v1.1
sbg:categories:
- GWAS
- Ancestry and Relatedness
sbg:content_hash: a797c48c4a8a8c4d5b9faff69f139a544ff1028a2eee6d8afa376cacbd7d7322a
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1609463976
sbg:id: smgogarten/uw-gac-commit/pc-air/2
sbg:image_url:
sbg:latestRevision: 2
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1612396189
sbg:original_source: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/uw-gac-commit/pc-air/2/raw/
sbg:project: smgogarten/uw-gac-commit
sbg:projectName: UW GAC - Commit
sbg:publisher: UWGAC
sbg:revision: 2
sbg:revisionNotes: add categories and toolkit
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609463976
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609463999
  sbg:revision: 1
  sbg:revisionNotes: import from pre-build project
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1612396189
  sbg:revision: 2
  sbg:revisionNotes: add categories and toolkit
sbg:sbgMaintained: false
sbg:toolkit: UW-GAC Ancestry and Relatedness
sbg:validationErrors: []
