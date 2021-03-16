cwlVersion: v1.1
class: CommandLineTool
label: pedigree_format
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-devel:latest
- class: InitialWorkDirRequirement
  listing:
  - entryname: pedigree_format.config
    writable: false
    entry: |
      ${
          var cmd_line = ""

          if(inputs.pedigree_file)
              cmd_line += "pedigree_file \"" + inputs.pedigree_file.path + "\"\n"

          if(inputs.out_prefix) {
              var out_prefix = inputs.out_prefix + "_"
          } else {
              var out_prefix = ""
          }
          cmd_line += 'out_file "' + out_prefix + 'pedigree_exp_rels.RData"\n'
          cmd_line += 'err_file "' + out_prefix + 'pedigree_err.RData"\n'
          
          if(inputs.concat_family_individ){
              cmd_line += 'concat_family_individ TRUE'
          }

          return cmd_line
      }
- class: InlineJavascriptRequirement

inputs:
- id: pedigree_file
  label: Pedigree file
  doc: |-
    Text file with pedigree data. Columns should be "FAMILY_ID", "SUBJECT_ID", "FATHER", "MOTHER", "SEX". A header line is expected unless the file extension is ".fam".
  type: File
  sbg:category: Input Files
  sbg:fileTypes: TXT, CSV, FAM
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
  sbg:category: Input Options
- id: concat_family_individ
  label: Concatenate family and individual IDs
  doc: |-
    In some pedigree files, the individual ID is unique only within a family. If that is true, set this value to "True" to concatenate family and individual IDs to create a unique subject identifier.
  type: boolean?

outputs:
- id: exp_rels_file
  label: Expected relatives file
  doc: |-
    RData file with data.frame of pairwise expected relatives according to the pedigree
  type: File?
  outputBinding:
    glob: '*rels.RData'
  sbg:fileTypes: RDATA
- id: err_file
  label: Pedigree error file
  doc: RData file with the output of the GWASTools::pedigreeCheck function.
  type: File?
  outputBinding:
    glob: '*err.RData'
  sbg:fileTypes: RDATA
stdout: job.out.log

baseCommand:
- R -q --vanilla
arguments:
- prefix: <
  position: 2
  valueFrom: /usr/local/analysis_pipeline/R/pedigree_format.R
  shellQuote: false
- prefix: --args
  position: 1
  valueFrom: pedigree_format.config
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: pedigree_format.config
id: smgogarten/genesis-relatedness-pre-build/pedigree-format/1
sbg:appVersion:
- v1.1
sbg:content_hash: aa3494bdfacdf440803843e81dbbc741c1aae2012601279050e6f3daa25087742
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1615236079
sbg:id: smgogarten/genesis-relatedness-pre-build/pedigree-format/1
sbg:image_url:
sbg:latestRevision: 1
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615236119
sbg:project: smgogarten/genesis-relatedness-pre-build
sbg:projectName: GENESIS relatedness - Pre-build
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: import from devel
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615236079
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615236119
  sbg:revision: 1
  sbg:revisionNotes: import from devel
sbg:sbgMaintained: false
sbg:validationErrors: []
