cwlVersion: v1.2
class: CommandLineTool
label: gds2bed
doc: For larger files, increase memory requirement to 32 GBs.
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InitialWorkDirRequirement
  listing:
  - entryname: gds2bed.config
    writable: false
    entry: |-
      ${

      cmd_line = ""

      if(inputs.gds_file)
              cmd_line += "gds_file \"" + inputs.gds_file.path + "\"\n"
         
      if(inputs.variant_include_file)
              cmd_line += "variant_include_file \"" + inputs.variant_include_file.path + "\"\n"
         
      if(inputs.bed_file)
              cmd_line += "bed_file \"" + inputs.bed_file + "\"\n"
      else
              cmd_line += "bed_file \"" + inputs.gds_file.nameroot + "\"\n"
              
      if(inputs.sample_include_file)
              cmd_line += "sample_include_file \"" + inputs.sample_include_file.path + "\"\n"



       return cmd_line
      }
- class: InlineJavascriptRequirement

inputs:
- id: gds_file
  label: GDS File
  doc: Input GDS file.
  type: File
  sbg:category: Input Files
  sbg:fileTypes: GDS
- id: bed_file
  label: BED file prefix
  doc: BED file prefix. If not provided, will be set to GDS file prefix.
  type:
  - 'null'
  - string
  sbg:category: Input files
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
  label: Variant Include File
  doc: |-
    RData file with vector of variant.id to include. If not provided, all variants in the GDS file are included.
  type:
  - 'null'
  - File
  sbg:category: Input Files
  sbg:fileTypes: RDATA

outputs:
- id: processed_bed
  label: Processed BED
  doc: BED generated from GDS file
  type: File
  secondaryFiles:
  - pattern: ^.bim
    required: true
  - pattern: ^.fam
    required: true
  outputBinding:
    glob: '*.bed'
  sbg:fileTypes: BED
stdout: job.out.log

baseCommand:
- R -q --vanilla
arguments:
- prefix: <
  position: 2
  valueFrom: /usr/local/analysis_pipeline/R/gds2bed.R
  shellQuote: false
- prefix: --args
  position: 1
  valueFrom: gds2bed.config
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: gds2bed.config
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness-pre-build/gds2bed/4/raw/
sbg:appVersion:
- v1.2
sbg:content_hash: a3fae5d47ec40471588fecbda09301b3cf9d55d22822cc7dc09d339c7b9e3ae78
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1609451033
sbg:id: smgogarten/genesis-relatedness-pre-build/gds2bed/4
sbg:image_url:
sbg:latestRevision: 4
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1623450740
sbg:project: smgogarten/genesis-relatedness-pre-build
sbg:projectName: GENESIS relatedness - Pre-build
sbg:publisher: sbg
sbg:revision: 4
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: c9c8b8d
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609451033
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609451062
  sbg:revision: 1
  sbg:revisionNotes: import to pre-build project
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623444722
  sbg:revision: 2
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: c9c8b8d
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623445036
  sbg:revision: 3
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: c9c8b8d
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623450740
  sbg:revision: 4
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: c9c8b8d
sbg:sbgMaintained: false
sbg:validationErrors: []
