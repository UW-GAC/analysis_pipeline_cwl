cwlVersion: v1.1
class: Workflow
label: PC-Relate
doc: |-
  This workflow estimates kinship and IBD sharing probabilities between all pairs of samples using the PC-Relate method, which accounts for population structure by conditioning on ancestry PCs.
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ScatterFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: pca_file
  label: PCA file
  doc: |-
    RData file with PCA results from PC-AiR workflow; used to adjust for population structure.
  type: File
  sbg:fileTypes: RDATA
  sbg:x: -189.6508026123047
  sbg:y: 53.30672836303711
- id: gds_file
  label: GDS File
  doc: Input GDS file. It is recommended to use an LD pruned file with all chromosomes.
  type: File
  sbg:fileTypes: GDS
  sbg:x: -205.0176544189453
  sbg:y: 181.32745361328125
- id: sample_include_file
  label: Sample Include file
  doc: |-
    RData file with vector of sample.id to include. If not provided, all samples in the GDS file are included.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -175.52853393554688
  sbg:y: -72.8362808227539
- id: n_pcs
  label: Number of PCs
  doc: |-
    Number of PCs (Principal Components) in `pca_file` to use in adjusting for ancestry.
  type: int?
  sbg:toolDefaultValue: '3'
  sbg:x: -61.75441360473633
  sbg:y: 284.0424499511719
- id: variant_include_file
  label: Variant include file
  doc: |-
    RData file with vector of variant.id to include. If not provided, all variants in the GDS file are included.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -169.77308654785156
  sbg:y: -226.9329071044922
- id: variant_block_size
  label: Variant block size
  doc: Number of variants to read in a single block.
  type: int?
  sbg:toolDefaultValue: '1024'
  sbg:x: -60.2248649597168
  sbg:y: -132.0818634033203
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
  sbg:x: -65.81759643554688
  sbg:y: 105.9605941772461
- id: n_sample_blocks
  label: Number of sample blocks
  doc: |-
    Number of blocks to divide samples into for parallel computation. Adjust depending on computer memory and number of samples in the analysis.
  type: int?
  sbg:toolDefaultValue: '1'
  sbg:x: 49.20663070678711
  sbg:y: -341.2738037109375
- id: phenotype_file
  label: Phenotype File
  doc: |-
    RData file with data.frame or AnnotatedDataFrame of phenotypes. Used for plotting kinship estimates separately by group.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: 645.658203125
  sbg:y: 169.88719177246094
- id: sparse_threshold
  label: Sparse threshold
  doc: |-
    Threshold for making the output kinship matrix sparse. A block diagonal matrix will be created such that any pair of samples with a kinship estimate greater than the threshold is in the same block; all pairwise estimates within a block are kept, and pairwise estimates between blocks are set to 0.
  type: float?
  sbg:exposed: true
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
- id: pcrelate_plots
  label: Kinship plots
  doc: |-
    Hexbin plots of estimated kinship coefficients vs. IBS0. If "group" is provided, additional plots will be generated within each group and across groups.
  type: File[]?
  outputSource:
  - kinship_plots/kinship_plots
  sbg:fileTypes: PDF
  sbg:x: 1051.3870849609375
  sbg:y: 166.4375457763672
- id: pcrelate_output
  label: PC-Relate output file
  doc: PC-Relate output file with all samples
  type: File?
  outputSource:
  - pcrelate_correct/pcrelate_output
  sbg:fileTypes: RDATA
  sbg:x: 931.4324951171875
  sbg:y: -263.4626159667969
- id: pcrelate_matrix
  label: Kinship matrix
  doc: |-
    A block diagonal matrix of pairwise kinship estimates with sparsity set by sparse_threshold. Samples are clustered into blocks of relatives based on `sparse_threshold`; all kinship estimates within a block are kept, and kinship estimates between blocks are set to 0. When `sparse_threshold` is 0, this is a dense matrix with all pairwise kinship estimates.
  type: File?
  outputSource:
  - pcrelate_correct/pcrelate_matrix
  sbg:fileTypes: RDATA
  sbg:x: 927.3430786132812
  sbg:y: -108.06597900390625

steps:
- id: pcrelate_beta
  label: pcrelate_beta
  in:
  - id: gds_file
    source: gds_file
  - id: pca_file
    source: pca_file
  - id: n_pcs
    source: n_pcs
  - id: out_prefix
    source: out_prefix
  - id: sample_include_file
    source: sample_include_file
  - id: variant_include_file
    source: variant_include_file
  - id: variant_block_size
    source: variant_block_size
  run: pc-relate-wf.cwl.steps/pcrelate_beta.cwl
  out:
  - id: beta
  sbg:x: 111.58096313476562
  sbg:y: 18
- id: sample_blocks_to_segments
  label: sample blocks to segments
  in:
  - id: n_sample_blocks
    source: n_sample_blocks
  run: pc-relate-wf.cwl.steps/sample_blocks_to_segments.cwl
  out:
  - id: segments
  sbg:x: 195.43441772460938
  sbg:y: -185.92086791992188
- id: pcrelate
  label: pcrelate
  in:
  - id: gds_file
    source: gds_file
  - id: pca_file
    source: pca_file
  - id: beta_file
    source: pcrelate_beta/beta
  - id: n_pcs
    source: n_pcs
  - id: out_prefix
    source: out_prefix
  - id: variant_include_file
    source: variant_include_file
  - id: variant_block_size
    source: variant_block_size
  - id: sample_include_file
    source: sample_include_file
  - id: n_sample_blocks
    source: n_sample_blocks
  - id: segment
    source: sample_blocks_to_segments/segments
  scatter:
  - segment
  run: pc-relate-wf.cwl.steps/pcrelate.cwl
  out:
  - id: pcrelate
  sbg:x: 406.9648742675781
  sbg:y: 4.164716720581055
- id: pcrelate_correct
  label: pcrelate_correct
  in:
  - id: n_sample_blocks
    source: n_sample_blocks
  - id: pcrelate_block_files
    source:
    - pcrelate/pcrelate
  - id: sparse_threshold
    source: sparse_threshold
  run: pc-relate-wf.cwl.steps/pcrelate_correct.cwl
  out:
  - id: pcrelate_output
  - id: pcrelate_matrix
  sbg:x: 610.6256713867188
  sbg:y: -144.12290954589844
- id: kinship_plots
  label: kinship_plots
  in:
  - id: kinship_file
    source: pcrelate_correct/pcrelate_output
  - id: kinship_method
    default: pcrelate
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
  run: pc-relate-wf.cwl.steps/kinship_plots.cwl
  out:
  - id: kinship_plots
  sbg:x: 801.525146484375
  sbg:y: 40.709495544433594
sbg:appVersion:
- v1.1
sbg:categories:
- GWAS
- Ancestry and Relatedness
sbg:content_hash: ade45be0723dfd86c1bd575431e1fcb0b3051838501f7f96673b67250d5e25764
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1609464055
sbg:id: smgogarten/uw-gac-commit/pc-relate/2
sbg:image_url:
sbg:latestRevision: 2
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1612396239
sbg:original_source: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/uw-gac-commit/pc-relate/2/raw/
sbg:project: smgogarten/uw-gac-commit
sbg:projectName: UW GAC - Commit
sbg:publisher: UWGAC
sbg:revision: 2
sbg:revisionNotes: add categories and toolkit
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609464055
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609464095
  sbg:revision: 1
  sbg:revisionNotes: import from pre-build project
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1612396239
  sbg:revision: 2
  sbg:revisionNotes: add categories and toolkit
sbg:sbgMaintained: false
sbg:toolkit: UW-GAC Ancestry and Relatedness
sbg:validationErrors: []
