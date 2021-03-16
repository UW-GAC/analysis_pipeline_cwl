cwlVersion: v1.1
class: Workflow
label: KING robust
doc: |-
  This workflow uses the KING-robust method to estimate kinship coefficients, and returns results for all pairs of samples. Due to the negative bias of these kinship estimates for samples of different ancestry, they can be used as a measure of ancestry divergence in PC-AiR.
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: gds_file
  label: GDS file
  doc: Input GDS file. It is recommended to use an LD pruned file with all chromosomes.
  type: File
  sbg:fileTypes: GDS
  sbg:x: -289
  sbg:y: 70
- id: sample_include_file
  label: Sample Include file
  doc: |-
    RData file with vector of sample.id to include. If not provided, all samples in the GDS file are included.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -353.2032470703125
  sbg:y: -120
- id: variant_include_file
  label: Variant Include file
  doc: |-
    RData file with vector of variant.id to use for kinship estimation. If not provided, all variants in the GDS file are included.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -294.2032470703125
  sbg:y: -242.32879638671875
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
  sbg:x: -397.2032470703125
  sbg:y: 0.6711986660957336
- id: phenotype_file
  label: Phenotype File
  doc: |-
    RData file with data.frame or AnnotatedDataFrame of phenotypes. Used for plotting kinship estimates separately by group.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -117
  sbg:y: 117
- id: kinship_plot_threshold
  label: Kinship plotting threshold
  doc: Minimum kinship for a pair to be included in the plot.
  type: float?
  sbg:exposed: true
- id: group
  label: Group column name
  doc: |-
    Name of column in phenotype_file containing group variable (e.g., study) for plotting.
  type: string?
  sbg:exposed: true

outputs:
- id: king_robust_output
  label: KING robust output
  doc: GDS file with matrix of pairwise kinship estimates.
  type: File?
  outputSource:
  - king_robust/king_robust_output
  sbg:fileTypes: GDS
  sbg:x: 98
  sbg:y: -235
- id: king_robust_plots
  label: Kinship plots
  doc: |-
    Hexbin plots of estimated kinship coefficients vs. IBS0. If "group" is provided, additional plots will be generated within each group and across groups.
  type: File[]?
  outputSource:
  - kinship_plots/kinship_plots
  sbg:fileTypes: PDF
  sbg:x: 312
  sbg:y: -108

steps:
- id: king_robust
  label: king_robust
  in:
  - id: gds_file
    source: gds_file
  - id: out_prefix
    source: out_prefix
  - id: sample_include_file
    source: sample_include_file
  - id: variant_include_file
    source: variant_include_file
  run: king-robust-wf.cwl.steps/king_robust.cwl
  out:
  - id: king_robust_output
  sbg:x: -168
  sbg:y: -76
- id: kinship_plots
  label: kinship_plots
  in:
  - id: kinship_file
    source: king_robust/king_robust_output
  - id: kinship_method
    default: king_robust
  - id: kinship_plot_threshold
    source: kinship_plot_threshold
  - id: phenotype_file
    source: phenotype_file
  - id: group
    source: group
  - id: sample_include_file
    source: sample_include_file
  - id: out_prefix
    source: out_prefix
  run: king-robust-wf.cwl.steps/kinship_plots.cwl
  out:
  - id: kinship_plots
  sbg:x: 30
  sbg:y: -9
sbg:appVersion:
- v1.1
sbg:categories:
- GWAS
- Ancestry and Relatedness
sbg:content_hash: a7ac209ffcca13996ce609b928175e576b00bfb4f8d2acb1b66dcd00c4da7d6ac
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1609462848
sbg:id: smgogarten/uw-gac-commit/king-robust/2
sbg:image_url: |-
  https://platform.sb.biodatacatalyst.nhlbi.nih.gov/ns/brood/images/smgogarten/uw-gac-commit/king-robust/2.png
sbg:latestRevision: 2
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1612396124
sbg:original_source: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/uw-gac-commit/king-robust/2/raw/
sbg:project: smgogarten/uw-gac-commit
sbg:projectName: UW GAC - Commit
sbg:publisher: UWGAC
sbg:revision: 2
sbg:revisionNotes: add categories and toolkit
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609462848
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609462875
  sbg:revision: 1
  sbg:revisionNotes: import from pre-build project
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1612396124
  sbg:revision: 2
  sbg:revisionNotes: add categories and toolkit
sbg:sbgMaintained: false
sbg:toolkit: UW-GAC Ancestry and Relatedness
sbg:validationErrors: []
