cwlVersion: v1.1
class: CommandLineTool
label: pcrelate_beta
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: pcrelate_beta.config
    writable: false
    entry: |-
      ${
          var config = ""

          if (inputs.gds_file) 
            config += "gds_file \"" + inputs.gds_file.path + "\"\n"
            
          if (inputs.pca_file) 
            config += "pca_file \"" + inputs.pca_file.path + "\"\n"
            
          if (inputs.variant_include_file) 
            config += "variant_include_file \"" + inputs.variant_include_file.path + "\"\n"

          if (inputs.out_prefix)
            config += "out_prefix \"" + inputs.out_prefix  + "_pcrelate_beta\"\n"
        	
        	if (inputs.n_pcs)
            config += "n_pcs " + inputs.n_pcs + "\n"
          
          if (inputs.sample_include_file) 
            config += "sample_include_file \"" + inputs.sample_include_file.path + "\"\n"
            
        	if (inputs.variant_block_size) 
            config += "variant_block_size " + inputs.variant_block_size + "\n"
            
          return config
      }
- class: InlineJavascriptRequirement

inputs:
- id: gds_file
  label: GDS File
  doc: Input GDS file. It is recommended to use an LD pruned file with all chromosomes.
  type: File
  sbg:category: Input Files
  sbg:fileTypes: GDS
- id: pca_file
  label: PCA file
  doc: |-
    RData file with PCA results from PC-AiR workflow; used to adjust for population structure.
  type: File
  sbg:fileTypes: RDATA
- id: n_pcs
  label: Number of PCs
  doc: Number of PCs (Principal Components) to use in adjusting for ancestry.
  type:
  - 'null'
  - int
  default: 3
  sbg:category: Input Options
  sbg:toolDefaultValue: '3'
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type:
  - 'null'
  - string
  sbg:category: Input Options
- id: sample_include_file
  label: Sample Include file
  doc: |-
    RData file with vector of sample.id to include. If not provided, all samples in the GDS file are included.
  type:
  - 'null'
  - File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: variant_include_file
  label: Variant include file
  doc: |-
    RData file with vector of variant.id to include. If not provided, all variants in the GDS file are included.
  type:
  - 'null'
  - File
  sbg:category: Input Options
  sbg:fileTypes: RDATA
- id: variant_block_size
  label: Variant block size
  doc: Number of variants to read in a single block.
  type:
  - 'null'
  - int
  default: 1024
  sbg:category: Input Options
  sbg:toolDefaultValue: '1024'

outputs:
- id: beta
  label: ISAF beta values
  doc: RData file with ISAF beta values
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*.RData'
  sbg:fileTypes: RDATA
stdout: job.out.log

baseCommand:
- R -q --vanilla
arguments:
- prefix: <
  position: 2
  valueFrom: /usr/local/analysis_pipeline/R/pcrelate_beta.R
  shellQuote: false
- prefix: --args
  position: 0
  valueFrom: pcrelate_beta.config
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: pcrelate_beta.config
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/pcrelate-beta/5/raw/
sbg:appVersion:
- v1.1
sbg:content_hash: af9ca028190cac4c70860686db3dfef3c14958c64f4a0b3dac87669f68df1506b
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1606765290
sbg:id: smgogarten/genesis-relatedness/pcrelate-beta/5
sbg:image_url:
sbg:latestRevision: 5
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615937210
sbg:project: smgogarten/genesis-relatedness
sbg:projectName: GENESIS relatedness
sbg:publisher: sbg
sbg:revision: 5
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: (uncommitted file)
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606765290
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606766179
  sbg:revision: 1
  sbg:revisionNotes: start tool for pcrelate betas
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606770739
  sbg:revision: 2
  sbg:revisionNotes: add config file
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606773311
  sbg:revision: 3
  sbg:revisionNotes: always use pcrelate_beta in output prefix
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609449371
  sbg:revision: 4
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615937210
  sbg:revision: 5
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
sbg:sbgMaintained: false
sbg:validationErrors: []
