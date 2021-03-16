cwlVersion: v1.1
class: CommandLineTool
label: king_robust
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: EnvVarRequirement
  envDef:
  - envName: NSLOTS
    envValue: ${ return runtime.cores }
- class: ResourceRequirement
  coresMin: 8
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: ibd_king.config
    writable: false
    entry: |-
      ${

          var cmd_line = ""
          
          if(inputs.gds_file)
              cmd_line += "gds_file \"" + inputs.gds_file.path + "\"\n"
              
          if(inputs.sample_include_file)
              cmd_line += "sample_include_file \"" + inputs.sample_include_file.path + "\"\n"
              
          if(inputs.variant_include_file){
              cmd_line += "variant_include_file \"" + inputs.variant_include_file.path + "\"\n"
          }
          
          if(inputs.out_prefix){
              cmd_line += 'out_file "' + inputs.out_prefix + '_king_robust.gds"\n'
          } else {
              cmd_line += 'out_file \"king_robust.gds\"\n'
          }
          
              
          return cmd_line
      }
- class: InlineJavascriptRequirement

inputs:
- id: gds_file
  label: GDS file
  doc: Input GDS file.
  type: File
  sbg:category: Input files
  sbg:fileTypes: GDS
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
  label: Variant Include file
  doc: |-
    RData file with vector of variant.id to use for kinship estimation. If not provided, all variants in the GDS file are included.
  type:
  - 'null'
  - File
  sbg:category: Input Files
  sbg:fileTypes: RDATA

outputs:
- id: king_robust_output
  label: KING robust output
  doc: GDS file with matrix of pairwise kinship estimates.
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*.gds'
  sbg:fileTypes: GDS
stdout: job.out.log

baseCommand:
- R -q --vanilla
arguments:
- prefix: --args
  position: 1
  valueFrom: ibd_king.config
  shellQuote: false
- prefix: <
  position: 2
  valueFrom: /usr/local/analysis_pipeline/R/ibd_king.R
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: ibd_king.config
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/king-robust/7/raw/
sbg:appVersion:
- v1.1
sbg:content_hash: a3fbe060f9fdb4be76f99d7fb9255f5ac121900f6bf034caa4108231bd1f6a006
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1607973177
sbg:id: smgogarten/genesis-relatedness/king-robust/7
sbg:image_url:
sbg:latestRevision: 7
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615933723
sbg:project: smgogarten/genesis-relatedness
sbg:projectName: GENESIS relatedness
sbg:publisher: sbg
sbg:revision: 7
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: (uncommitted file)
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1607973177
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1607974376
  sbg:revision: 1
  sbg:revisionNotes: wrapper for king robust R script
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1607974624
  sbg:revision: 2
  sbg:revisionNotes: add resource requirements for parallel computation
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1607974812
  sbg:revision: 3
  sbg:revisionNotes: 'bug fix: switched prefix and value'
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1607974863
  sbg:revision: 4
  sbg:revisionNotes: fix command line order
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609307856
  sbg:revision: 5
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609448005
  sbg:revision: 6
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615933723
  sbg:revision: 7
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
sbg:sbgMaintained: false
sbg:validationErrors: []
