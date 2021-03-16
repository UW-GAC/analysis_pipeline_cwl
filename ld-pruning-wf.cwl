cwlVersion: v1.1
class: Workflow
label: LD Pruning
doc: |-
  This workflow LD prunes variants and creates a new GDS file containing only the pruned variants. Linkage disequilibrium (LD) is a measure of correlation of genotypes between a pair of variants. LD-pruning is the process filtering variants so that those that remain have LD measures below a given threshold. This procedure is typically used to identify a (nearly) independent subset of variants. This is often the first step in evaluating relatedness and population structure to avoid having results driven by clusters of variants in high LD regions of the genome.
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ScatterFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: gds_file
  label: GDS files
  doc: Input GDS files, one per chromosome with string "chr*" in the file name.
  type: File[]
  sbg:fileTypes: GDS
  sbg:x: -440.613037109375
  sbg:y: 21.550386428833008
- id: sample_include_file_pruning
  label: Sample Include file for LD pruning
  doc: |-
    RData file with vector of sample.id to use for LD pruning (unrelated samples are recommended). If not provided, all samples in the GDS files are included.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -482.9205627441406
  sbg:y: -174.98597717285156
- id: variant_include_file
  label: Variant Include file for LD pruning
  doc: |-
    RData file with vector of variant.id to consider for LD pruning. If not provided, all variants in the GDS files are included.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -426.8399658203125
  sbg:y: -303.2926025390625
- id: sample_include_file_gds
  label: Sample include file for output GDS
  doc: |-
    RData file with vector of sample.id to include in the output GDS. If not provided, all samples in the GDS files are included.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -258.4799499511719
  sbg:y: 59.013526916503906
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
  sbg:x: -535.4487915039062
  sbg:y: -42.224388122558594
- id: ld_r_threshold
  label: LD |r| threshold
  doc: '|r| threshold for LD pruning.'
  type: float?
  sbg:exposed: true
- id: ld_win_size
  label: LD window size
  doc: Sliding window size in Mb for LD pruning.
  type: float?
  sbg:exposed: true
- id: maf_threshold
  label: MAF threshold
  doc: |-
    Minimum MAF for variants used in LD pruning. Variants below this threshold are removed.
  type: float?
  sbg:exposed: true
- id: missing_threshold
  label: Missing call rate threshold
  doc: |-
    Maximum missing call rate for variants used in LD pruning. Variants above this threshold are removed.
  type: float?
  sbg:exposed: true
- id: exclude_pca_corr
  label: Exclude PCA corr
  doc: |-
    Exclude variants in genomic regions known to result in high PC-variant correlations when included (HLA, LCT, inversions).
  type: boolean?
  sbg:exposed: true
- id: genome_build
  label: Genome build
  doc: |-
    Genome build, used to define genomic regions to filter for PC-variant correlation.
  type:
  - 'null'
  - name: genome_build
    type: enum
    symbols:
    - hg18
    - hg19
    - hg38
  sbg:exposed: true

outputs:
- id: pruned_gds_output
  label: Pruned GDS output file
  doc: |-
    GDS output file containing sample genotypes at pruned variants from all chromosomes.
  type: File?
  outputSource:
  - merge_gds/merged_gds_output
  sbg:fileTypes: GDS
  sbg:x: 510.43572998046875
  sbg:y: -266.7860412597656
- id: ld_pruning_output
  label: Pruned output file
  doc: RData file with variant.id of pruned variants.
  type: File?
  outputSource:
  - ld_pruning/ld_pruning_output
  sbg:fileTypes: RDATA
  sbg:x: -61.60548782348633
  sbg:y: -287.0057373046875

steps:
- id: ld_pruning
  label: ld_pruning
  in:
  - id: gds_file
    source: gds_file
  - id: ld_r_threshold
    source: ld_r_threshold
  - id: ld_win_size
    source: ld_win_size
  - id: maf_threshold
    source: maf_threshold
  - id: missing_threshold
    source: missing_threshold
  - id: out_prefix
    source: out_prefix
  - id: sample_include_file
    source: sample_include_file_pruning
  - id: variant_include_file
    source: variant_include_file
  - id: exclude_pca_corr
    source: exclude_pca_corr
  - id: genome_build
    source: genome_build
  scatter:
  - gds_file
  run: ld-pruning-wf.cwl.steps/ld_pruning.cwl
  out:
  - id: ld_pruning_output
  sbg:x: -259.3580627441406
  sbg:y: -159.14634704589844
- id: subset_gds
  label: subset_gds
  in:
  - id: gds_file
    source: gds_file
  - id: sample_include_file
    source: sample_include_file_gds
  - id: variant_include_file
    source: ld_pruning/ld_pruning_output
  scatter:
  - gds_file
  - variant_include_file
  scatterMethod: dotproduct
  run: ld-pruning-wf.cwl.steps/subset_gds.cwl
  out:
  - id: output
  sbg:x: -71.82777404785156
  sbg:y: -48.61606216430664
- id: merge_gds
  label: merge_gds
  in:
  - id: gds_file
    source:
    - subset_gds/output
  - id: out_prefix
    source: out_prefix
  run: ld-pruning-wf.cwl.steps/merge_gds.cwl
  out:
  - id: merged_gds_output
  sbg:x: 170.64193725585938
  sbg:y: -207.07080078125
- id: check_merged_gds
  label: check_merged_gds
  in:
  - id: gds_file
    source: subset_gds/output
  - id: merged_gds_file
    source: merge_gds/merged_gds_output
  scatter:
  - gds_file
  run: ld-pruning-wf.cwl.steps/check_merged_gds.cwl
  out: []
  sbg:x: 419.7127380371094
  sbg:y: -23.686861038208008
sbg:appVersion:
- v1.1
sbg:categories:
- GWAS
- Ancestry and Relatedness
sbg:content_hash: a41283ea1d0f289437710d8711dfe933fbd9556d73ceda0c27958c71cb9a23783
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1609462720
sbg:id: smgogarten/uw-gac-commit/ld-pruning/2
sbg:image_url:
sbg:latestRevision: 2
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1612396010
sbg:original_source: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/uw-gac-commit/ld-pruning/2/raw/
sbg:project: smgogarten/uw-gac-commit
sbg:projectName: UW GAC - Commit
sbg:publisher: UWGAC
sbg:revision: 2
sbg:revisionNotes: add categories and toolkit
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609462720
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609462770
  sbg:revision: 1
  sbg:revisionNotes: import from pre-build project
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1612396010
  sbg:revision: 2
  sbg:revisionNotes: add categories and toolkit
sbg:sbgMaintained: false
sbg:toolkit: UW-GAC Ancestry and Relatedness
sbg:validationErrors: []
