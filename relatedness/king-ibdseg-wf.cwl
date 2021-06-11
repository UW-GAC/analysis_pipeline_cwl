cwlVersion: v1.2
class: Workflow
label: KING IBDseg
doc: |-
  This workflow uses the KING --ibdseg method to estimate kinship coefficients, and returns results for pairs of related samples. These kinship estimates can be used as measures of kinship in PC-AiR.
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
  sbg:x: -526.7666015625
  sbg:y: 339.0399475097656
- id: sample_include_file
  label: Sample Include file
  doc: |-
    RData file with vector of sample.id to include. If not provided, all samples in the GDS file are included.
  type: File
  sbg:fileTypes: RDATA
  sbg:x: -539.3945922851562
  sbg:y: 150.5880126953125
- id: variant_include_file
  label: Variant Include file
  doc: |-
    RData file with vector of variant.id to use for kinship estimation. If not provided, all variants in the GDS file are included.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -553.8265380859375
  sbg:y: -59.5318489074707
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
  sbg:x: -428.742919921875
  sbg:y: -223.19976806640625
- id: phenotype_file
  label: Phenotype File
  doc: |-
    RData file with data.frame or AnnotatedDataFrame of phenotypes. Used for plotting kinship estimates separately by group.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: 128.62420654296875
  sbg:y: -225.0599365234375
- id: kinship_plot_threshold
  label: Kinship plotting threshold
  doc: Minimum kinship for a pair to be included in the plot.
  type: float?
  sbg:exposed: true
  sbg:toolDefaultValue: 2^(-9/2) (third-degree relatives and closer)
- id: group
  label: Group column name
  doc: |-
    Name of column in phenotype_file containing group variable (e.g., study) for plotting.
  type: string?
  sbg:exposed: true
- id: sparse_threshold
  label: Sparse threshold
  doc: |-
    Threshold for making the output kinship matrix sparse. A block diagonal matrix will be created such that any pair of samples with a kinship estimate greater than the threshold is in the same block; all pairwise estimates within a block are kept, and pairwise estimates between blocks are set to 0.
  type: float?
  sbg:exposed: true
  sbg:toolDefaultValue: 2^(-11/2) (~0.022, 4th degree)
- id: cpu
  label: Number of CPUs
  doc: Number of CPUs to use.
  type: int?
  sbg:exposed: true
  sbg:toolDefaultValue: '4'

outputs:
- id: king_ibdseg_matrix
  label: Kinship matrix
  doc: |-
    A block-diagonal matrix of pairwise kinship estimates. Samples are clustered into blocks of relatives based on `sparse_threshold`; all kinship estimates within a block are kept, and kinship estimates between blocks are set to 0. When `sparse_threshold` is 0, all kinship estimates are included in the output matrix.
  type: File?
  outputSource:
  - king_to_matrix/king_matrix
  sbg:fileTypes: RDATA
  sbg:x: 697.8175659179688
  sbg:y: 228.99623107910156
- id: king_ibdseg_plots
  label: Kinship plots
  doc: |-
    Hexbin plots of estimated kinship coefficients vs. IBS0. If "group" is provided, additional plots will be generated within each group and across groups.
  type: File[]?
  outputSource:
  - kinship_plots/kinship_plots
  sbg:fileTypes: PDF
  sbg:x: 681.037353515625
  sbg:y: -157.67169189453125
- id: king_ibdseg_output
  label: KING ibdseg output
  doc: |-
    Text file with pairwise kinship estimates for all sample pairs with any detected IBD segments.
  type: File
  secondaryFiles:
  - pattern: ^.segments.gz
    required: false
  - pattern: ^allsegs.txt
    required: false
  outputSource:
  - king_ibdseg/king_ibdseg_output
  sbg:fileTypes: SEG
  sbg:x: 683.8013916015625
  sbg:y: 10.052401542663574

steps:
- id: gds2bed
  label: gds2bed
  in:
  - id: gds_file
    source: gds_file
  - id: sample_include_file
    source: sample_include_file
  - id: variant_include_file
    source: variant_include_file
  run: king-ibdseg-wf.cwl.steps/gds2bed.cwl
  out:
  - id: processed_bed
  sbg:x: -377
  sbg:y: -24
- id: plink_make_bed
  label: plink_make-bed
  in:
  - id: bedfile
    source: gds2bed/processed_bed
  run: king-ibdseg-wf.cwl.steps/plink_make_bed.cwl
  out:
  - id: bed_file
  sbg:x: -140
  sbg:y: -20
- id: king_ibdseg
  label: king_ibdseg
  in:
  - id: bed_file
    source: plink_make_bed/bed_file
  - id: cpu
    source: cpu
  - id: out_prefix
    source: out_prefix
  run: king-ibdseg-wf.cwl.steps/king_ibdseg.cwl
  out:
  - id: king_ibdseg_output
  sbg:x: 105
  sbg:y: -15
- id: king_to_matrix
  label: king_to_matrix
  in:
  - id: king_file
    source: king_ibdseg/king_ibdseg_output
  - id: sample_include_file
    source: sample_include_file
  - id: sparse_threshold
    default: 0.01104854
    source: sparse_threshold
  - id: out_prefix
    valueFrom: "${ \n    return inputs.out_prefix + \"_king_ibdseg_matrix\"\n}"
    source: out_prefix
  - id: kinship_method
    default: king_ibdseg
  run: king-ibdseg-wf.cwl.steps/king_to_matrix.cwl
  out:
  - id: king_matrix
  sbg:x: 276.39886474609375
  sbg:y: 91.5
- id: kinship_plots
  label: kinship_plots
  in:
  - id: kinship_file
    source: king_ibdseg/king_ibdseg_output
  - id: kinship_method
    default: king_ibdseg
  - id: kinship_plot_threshold
    source: kinship_plot_threshold
  - id: phenotype_file
    source: phenotype_file
  - id: group
    source: group
  - id: sample_include_file
    source: sample_include_file
  - id: out_prefix
    valueFrom: ${ return inputs.out_prefix + "_king_ibdseg" }
    source: out_prefix
  run: king-ibdseg-wf.cwl.steps/kinship_plots.cwl
  out:
  - id: kinship_plots
  sbg:x: 337.3957824707031
  sbg:y: -168.27590942382812
sbg:appVersion:
- v1.2
sbg:categories:
- GWAS
- Ancestry and Relatedness
sbg:content_hash: ac4421e0278f471efcc695bb067a2d910adb245932183f934be9e9e44598613dd
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1583955734
sbg:id: smgogarten/genesis-relatedness/king-pipeline/31
sbg:image_url:
sbg:latestRevision: 31
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1623276406
sbg:original_source: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/king-pipeline/31/raw/
sbg:project: smgogarten/genesis-relatedness
sbg:projectName: GENESIS relatedness
sbg:publisher: sbg
sbg:revision: 31
sbg:revisionNotes: add ibdseg string to matrix output filename
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1583955734
  sbg:revision: 0
  sbg:revisionNotes: Copy of boris_majic/topmed-optimization/king-pipeline/2
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1588634638
  sbg:revision: 1
  sbg:revisionNotes: remove king_related, only run king_ibdseg
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1588807142
  sbg:revision: 2
  sbg:revisionNotes: revise inputs and outputs
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1601930483
  sbg:revision: 3
  sbg:revisionNotes: new version of gds2bed
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1601944311
  sbg:revision: 4
  sbg:revisionNotes: new version of plink_make-bed
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1601964691
  sbg:revision: 5
  sbg:revisionNotes: updated plink_make-bed
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1603229838
  sbg:revision: 6
  sbg:revisionNotes: use current tools from this project
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1603254161
  sbg:revision: 7
  sbg:revisionNotes: use revised plink_make_bed with suffix
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1603479524
  sbg:revision: 8
  sbg:revisionNotes: new tool versions, output prefix
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1603485667
  sbg:revision: 9
  sbg:revisionNotes: fix .seg output mapping
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1603491626
  sbg:revision: 10
  sbg:revisionNotes: add phenotype file as an input
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1604986255
  sbg:revision: 11
  sbg:revisionNotes: add suffixes to output_prefix, include ibdseg results in workflow
    output
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605577182
  sbg:revision: 12
  sbg:revisionNotes: update all tools
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608074003
  sbg:revision: 13
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608600161
  sbg:revision: 14
  sbg:revisionNotes: add app description
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608619419
  sbg:revision: 15
  sbg:revisionNotes: expose threshold for plotting kinship
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609311199
  sbg:revision: 16
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609311243
  sbg:revision: 17
  sbg:revisionNotes: remove _1 suffix for steps
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609311494
  sbg:revision: 18
  sbg:revisionNotes: set defaults
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609311762
  sbg:revision: 19
  sbg:revisionNotes: add _1 suffix to kinship_plots to address "workflow contains
    a cycle"
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609312623
  sbg:revision: 20
  sbg:revisionNotes: updated tool
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609367777
  sbg:revision: 21
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609367832
  sbg:revision: 22
  sbg:revisionNotes: fix broken connection
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609371288
  sbg:revision: 23
  sbg:revisionNotes: expose plotting parameters
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609371562
  sbg:revision: 24
  sbg:revisionNotes: show tool default
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609374452
  sbg:revision: 25
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609449636
  sbg:revision: 26
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609450034
  sbg:revision: 27
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615934680
  sbg:revision: 28
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623274735
  sbg:revision: 29
  sbg:revisionNotes: update tools and label descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623276248
  sbg:revision: 30
  sbg:revisionNotes: add king_ibdseg string to output plot filename
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623276406
  sbg:revision: 31
  sbg:revisionNotes: add ibdseg string to matrix output filename
sbg:sbgMaintained: false
sbg:toolkit: UW-GAC Ancestry and Relatedness
sbg:validationErrors: []
