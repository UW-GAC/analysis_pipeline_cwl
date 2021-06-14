cwlVersion: v1.2
class: Workflow
label: PC-AiR
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: SubworkflowFeatureRequirement
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
  sbg:x: -381.15753173828125
  sbg:y: 127.77397155761719
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
- id: kinship_threshold
  label: Kinship threshold
  doc: Minimum kinship estimate to use for identifying relatives.
  type: float?
  sbg:exposed: true
  sbg:toolDefaultValue: 2^(-9/2) (third-degree relatives and closer)
- id: divergence_threshold
  label: Divergence threshold
  doc: |-
    Maximum divergence estimate to use for identifying ancestrally divergent pairs of samples.
  type: float?
  sbg:exposed: true
  sbg:toolDefaultValue: -2^(-9/2)
- id: n_pairs
  label: Number of PCs
  doc: Number of PCs to include in the pairs plot.
  type: int?
  sbg:exposed: true
  sbg:toolDefaultValue: '6'
- id: group
  label: Group
  doc: |-
    Name of column in phenotype_file containing group variable for color-coding plots.
  type: string?
  sbg:exposed: true
- id: n_pcs
  label: Number of PCs
  doc: Number of PCs (Principal Components) to return.
  type: int?
  sbg:toolDefaultValue: '32'
  sbg:x: -427.1446533203125
  sbg:y: -333.2216796875
- id: gds_file_full
  label: Full GDS Files
  doc: GDS files (one per chromosome) used to calculate PC-variant correlations.
  type: File[]
  sbg:fileTypes: GDS
  sbg:x: -283.20037841796875
  sbg:y: 376.7168273925781
- id: n_corr_vars
  label: Number of variants to select
  doc: |-
    Randomly select this number of variants distributed across the entire genome to use for PC-variant correlation. If running on a single chromosome, the variants returned will be scaled by the proportion of that chromosome in the genome.
  type: int?
  sbg:exposed: true
  sbg:toolDefaultValue: '10e6'
- id: n_pcs_plot
  label: Number of PCs to plot
  doc: Number of PCs to plot.
  type: int?
  sbg:exposed: true
  sbg:toolDefaultValue: '20'
- id: n_perpage
  label: Number of plots per page
  doc: |-
    Number of PC-variant correlation plots to stack in a single page. The number of png files generated will be ceiling(n_pcs_plot/n_perpage).
  type: int?
  sbg:exposed: true
  sbg:toolDefaultValue: '4'
- id: run_correlation
  label: Run PC-variant correlation
  doc: |-
    For pruned variants as well as a random sample of additional variants, compute correlation between the variants and PCs, and generate plots. This step can be computationally intensive, but is useful for verifying that PCs are not driven by small regions of the genome.
  type: boolean
  sbg:x: -405.8658447265625
  sbg:y: 275.1279296875

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
  - pc_variant_correlation/pc_correlation_plots
  sbg:fileTypes: PNG
  sbg:x: 332.8373107910156
  sbg:y: 208.7924346923828
- id: pca_corr_gds
  label: PC-variant correlation
  doc: GDS file with PC-variant correlation results
  type: File[]?
  outputSource:
  - pc_variant_correlation/pca_corr_gds
  sbg:fileTypes: GDS
  sbg:x: 285.73321533203125
  sbg:y: 85.907958984375

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
- id: variant_id_from_gds
  label: variant id from gds
  in:
  - id: gds_file
    source: gds_file
  - id: run_correlation
    source: run_correlation
  run: pc-air-wf.cwl.steps/variant_id_from_gds.cwl
  when: $(inputs.run_correlation)
  out:
  - id: output_file
  sbg:x: -172.29623413085938
  sbg:y: 209.59246826171875
- id: pc_variant_correlation
  label: PC-variant correlation
  in:
  - id: out_prefix
    source: out_prefix
  - id: gds_file_full
    source:
    - gds_file_full
  - id: variant_include_file
    source: variant_id_from_gds/output_file
  - id: pca_file
    source: pca_byrel/pcair_output_unrelated
  - id: n_corr_vars
    source: n_corr_vars
  - id: n_pcs
    source: n_pcs
  - id: n_pcs_plot
    source: n_pcs_plot
  - id: n_perpage
    source: n_perpage
  - id: run_correlation
    source: run_correlation
  run: pc-air-wf.cwl.steps/pc_variant_correlation.cwl
  when: $(inputs.run_correlation)
  out:
  - id: pc_correlation_plots
  - id: pca_corr_gds
  sbg:x: 85.90345764160156
  sbg:y: 199.70834350585938
sbg:appVersion:
- v1.2
sbg:categories:
- GWAS
- Ancestry and Relatedness
sbg:content_hash: af321deb824c9b35cf44c03c00654771fc666a34afdb00425fa98a687183ddd1c
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1583955835
sbg:id: smgogarten/genesis-relatedness/pc-air/28
sbg:image_url:
sbg:latestRevision: 28
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1623704475
sbg:original_source: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/pc-air/28/raw/
sbg:project: smgogarten/genesis-relatedness
sbg:projectName: GENESIS relatedness
sbg:publisher: sbg
sbg:revision: 28
sbg:revisionNotes: add tool default values
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1583955835
  sbg:revision: 0
  sbg:revisionNotes: Copy of boris_majic/topmed-optimization/pc-air/0
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1588639097
  sbg:revision: 1
  sbg:revisionNotes: optional divergence matrix, no LD pruning
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606343846
  sbg:revision: 2
  sbg:revisionNotes: update with new tools
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606344271
  sbg:revision: 3
  sbg:revisionNotes: add phenotype file input for plots
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606344722
  sbg:revision: 4
  sbg:revisionNotes: remove instance requirement
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606345377
  sbg:revision: 5
  sbg:revisionNotes: reorder steps in code
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606354475
  sbg:revision: 6
  sbg:revisionNotes: try changing input/output IDs to solve "workflow contains a cycle"
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606356625
  sbg:revision: 7
  sbg:revisionNotes: redo all inputs and outputs
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608622358
  sbg:revision: 8
  sbg:revisionNotes: app description and default labels
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608709762
  sbg:revision: 9
  sbg:revisionNotes: add step to randomly select variants for correlation
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608709848
  sbg:revision: 10
  sbg:revisionNotes: pca_corr needs to scatter on both gds file and variant include
    file
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608712636
  sbg:revision: 11
  sbg:revisionNotes: make pruned variant file an array input
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608745358
  sbg:revision: 12
  sbg:revisionNotes: fix chrom input for pca_corr_vars - need to use input name internal
    to the tool
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608745834
  sbg:revision: 13
  sbg:revisionNotes: fix order of workflow steps in code
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609370912
  sbg:revision: 14
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609370946
  sbg:revision: 15
  sbg:revisionNotes: update output name
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609450203
  sbg:revision: 16
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609456529
  sbg:revision: 17
  sbg:revisionNotes: add n_pcs_plot as parameter
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609461865
  sbg:revision: 18
  sbg:revisionNotes: update pca_byrel
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615936411
  sbg:revision: 19
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623389311
  sbg:revision: 20
  sbg:revisionNotes: extract pruned variant.ids automatically instead of providing
    as input
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623456187
  sbg:revision: 21
  sbg:revisionNotes: 'bug fix: n_pcs needs to be passed to pca_corr as well as pca_byrel'
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623460383
  sbg:revision: 22
  sbg:revisionNotes: replace pc-variant correlation tools with workflow
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623461607
  sbg:revision: 23
  sbg:revisionNotes: update pc-variant correlation workflow
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623461845
  sbg:revision: 24
  sbg:revisionNotes: add PC-variant correlation file as output
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623462589
  sbg:revision: 25
  sbg:revisionNotes: update correlation workflow
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623703491
  sbg:revision: 26
  sbg:revisionNotes: add run condition for PC-variant correlation
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623704061
  sbg:revision: 27
  sbg:revisionNotes: update name of conditional input
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623704475
  sbg:revision: 28
  sbg:revisionNotes: add tool default values
sbg:sbgMaintained: false
sbg:toolkit: UW-GAC Ancestry and Relatedness
sbg:validationErrors: []
