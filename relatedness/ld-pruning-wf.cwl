cwlVersion: v1.2
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
  sbg:toolDefaultValue: 0.32 (r^2 = 0.1)
- id: ld_win_size
  label: LD window size
  doc: Sliding window size in Mb for LD pruning.
  type: float?
  sbg:exposed: true
  sbg:toolDefaultValue: '10'
- id: maf_threshold
  label: MAF threshold
  doc: |-
    Minimum MAF for variants used in LD pruning. Variants below this threshold are removed.
  type: float?
  sbg:exposed: true
  sbg:toolDefaultValue: '0.01'
- id: missing_threshold
  label: Missing call rate threshold
  doc: |-
    Maximum missing call rate for variants used in LD pruning. Variants above this threshold are removed.
  type: float?
  sbg:exposed: true
  sbg:toolDefaultValue: '0.01'
- id: exclude_pca_corr
  label: Exclude PCA corr
  doc: |-
    Exclude variants in genomic regions known to result in high PC-variant correlations when included (HLA, LCT, inversions).
  type: boolean?
  sbg:exposed: true
  sbg:toolDefaultValue: 'TRUE'
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
  sbg:toolDefaultValue: hg38
- id: autosome_only
  label: Autosomes only
  doc: Only include variants on the autosomes.
  type: boolean?
  sbg:exposed: true
  sbg:toolDefaultValue: 'TRUE'

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
  - id: autosome_only
    source: autosome_only
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
- v1.2
sbg:categories:
- GWAS
- Ancestry and Relatedness
sbg:content_hash: a1067e6aa7635b9e07dbf4dad5a8791ae5352c4b3c9ecaacc707e0da14ef47ee6
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1583955707
sbg:id: smgogarten/genesis-relatedness/ld-pruning-pipeline/32
sbg:image_url:
sbg:latestRevision: 32
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1623282603
sbg:original_source: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/ld-pruning-pipeline/32/raw/
sbg:project: smgogarten/genesis-relatedness
sbg:projectName: GENESIS relatedness
sbg:publisher: sbg
sbg:revision: 32
sbg:revisionNotes: document default values
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1583955707
  sbg:revision: 0
  sbg:revisionNotes: Copy of boris_majic/topmed-optimization/ld-pruning-pipeline/8
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1588789261
  sbg:revision: 1
  sbg:revisionNotes: expose selecting RAM for LD pruning at runtime
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606284780
  sbg:revision: 2
  sbg:revisionNotes: new tool versions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606285701
  sbg:revision: 3
  sbg:revisionNotes: fix file types
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606332967
  sbg:revision: 4
  sbg:revisionNotes: update scatter to use multiple arrays
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606333145
  sbg:revision: 5
  sbg:revisionNotes: update input file type to array
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606334881
  sbg:revision: 6
  sbg:revisionNotes: update subset gds
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606339140
  sbg:revision: 7
  sbg:revisionNotes: update tools
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606339665
  sbg:revision: 8
  sbg:revisionNotes: linked wrong gds file in check
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606344955
  sbg:revision: 9
  sbg:revisionNotes: reorder steps in code
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608071735
  sbg:revision: 10
  sbg:revisionNotes: add default labels
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608072202
  sbg:revision: 11
  sbg:revisionNotes: allow separate sample selection for pruning and output GDS
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608072663
  sbg:revision: 12
  sbg:revisionNotes: add more descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608144372
  sbg:revision: 13
  sbg:revisionNotes: upddate documentation
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608599215
  sbg:revision: 14
  sbg:revisionNotes: add default values
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608709552
  sbg:revision: 15
  sbg:revisionNotes: save output file with pruned variant.id
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608712380
  sbg:revision: 16
  sbg:revisionNotes: set output prefix for variant id files
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609294665
  sbg:revision: 17
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609306072
  sbg:revision: 18
  sbg:revisionNotes: specify file name requirements
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609306169
  sbg:revision: 19
  sbg:revisionNotes: update description
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609449531
  sbg:revision: 20
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609449914
  sbg:revision: 21
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615931992
  sbg:revision: 22
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615932296
  sbg:revision: 23
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: ld-pruning-wf.cwl
    commit: 730ce42
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615933415
  sbg:revision: 24
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: ld-pruning-wf.cwl
    commit: 730ce42
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623194481
  sbg:revision: 25
  sbg:revisionNotes: update tools, allow multiple variant_include files
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623195620
  sbg:revision: 26
  sbg:revisionNotes: can't scatter on optional input, since scatter arrays must be
    same length
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623197849
  sbg:revision: 27
  sbg:revisionNotes: document default values
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623279666
  sbg:revision: 28
  sbg:revisionNotes: update tool, expose autosome_only
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623279799
  sbg:revision: 29
  sbg:revisionNotes: document default values
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623281295
  sbg:revision: 30
  sbg:revisionNotes: update tool
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623282020
  sbg:revision: 31
  sbg:revisionNotes: expose autosome_only
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623282603
  sbg:revision: 32
  sbg:revisionNotes: document default values
sbg:sbgMaintained: false
sbg:toolkit: UW-GAC Ancestry and Relatedness
sbg:validationErrors: []
