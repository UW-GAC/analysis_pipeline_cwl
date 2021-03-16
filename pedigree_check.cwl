cwlVersion: v1.1
class: CommandLineTool
label: pedigree_check
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-devel:latest
- class: InitialWorkDirRequirement
  listing:
  - entryname: pedigree_check.config
    writable: false
    entry: |-
      ${
          var cmd_line = ""

          if(inputs.kinship_file)
              cmd_line += "kinship_file \"" + inputs.kinship_file.path + "\"\n"

          if(inputs.kinship_method){
              if(inputs.kinship_method == "king_robust"){
                  cmd_line +='kinship_method "king"\n'
              } else {
                  cmd_line +='kinship_method "' + inputs.kinship_method + '"\n'
              }
          }

          if(inputs.out_prefix) {
              var out_prefix = inputs.out_prefix
          } else {
              var out_prefix = "kinship"
          }
          cmd_line += 'out_file "' + out_prefix + '_obs.RData"\n'
          cmd_line += 'out_plot "' + out_prefix + '_obs_exp.pdf"\n'

          if(inputs.exp_rel_file)
              cmd_line += 'exp_rel_file "' + inputs.exp_rel_file.path + '"\n'

          if(inputs.phenotype_file)
              cmd_line += 'phenotype_file "' + inputs.phenotype_file.path + '"\n'

          if(inputs.subjectID)
          cmd_line += 'subjectID "' + inputs.subjectID + '"\n'

          if(inputs.sample_include_file)
              cmd_line += 'sample_include_file "' + inputs.sample_include_file.path + '"\n'

          return cmd_line
      }
- class: InlineJavascriptRequirement

inputs:
- id: kinship_file
  label: Kinship File
  doc: File with estimated kinship from KING or PC-Relate.
  type: File
  sbg:category: Input
  sbg:fileTypes: RDATA, SEG, KIN, GDS
- id: kinship_method
  label: Kinship method
  doc: |-
    Method used to generate kinship estimates (KING IBDseg, KING robust, or PC-Relate).
  type:
    name: kinship_method
    type: enum
    symbols:
    - king_ibdseg
    - pcrelate
    - king_robust
  sbg:category: Input Options
- id: exp_rel_file
  label: Expected relatives file
  doc: RData file with data.frame of expected relative pairs.
  type: File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: phenotype_file
  label: Phenotype File
  doc: |-
    RData file with data.frame or AnnotatedDataFrame of phenotypes. Must include a sample.id column and a column of subject identifiers.
  type: File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: subjectID
  label: Subject ID column name
  doc: Name of column in phenotype_file containing subject identifier variable.
  type: string?
  sbg:category: Input Options
  sbg:toolDefaultValue: submitted_subject_id
- id: sample_include_file
  label: Sample Include File
  doc: RData file with vector of sample.id to include.
  type: File?
  sbg:category: Input Options
  sbg:fileTypes: RDATA
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
  sbg:category: Input Options
  sbg:toolDefaultValue: kinship

outputs:
- id: kinship_plots
  label: Kinship plots
  doc: |-
    Plots of estimated kinship coefficients vs. IBS0. Expected and unexpected relatives will be plotted in separate panels.
  type: File?
  outputBinding:
    glob: '*.pdf'
  sbg:fileTypes: PDF
- id: observed_relatives
  label: Observed relatives
  doc: |-
    RData file with data.frame of pairwise relationships annotated with expected and observed relationship categories. Kinship estimates are included for observed relationships. Pairs expected to be related based on the pedigree but absent from the kinship file will be included with missing values for kinship estimates.
  type: File?
  outputBinding:
    glob: '*.RData'
  sbg:fileTypes: RDATA
stdout: job.out.log

baseCommand:
- R -q --vanilla
arguments:
- prefix: <
  position: 2
  valueFrom: /usr/local/analysis_pipeline/R/pedigree_check.R
  shellQuote: false
- prefix: --args
  position: 1
  valueFrom: pedigree_check.config
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: pedigree_check.config
id: smgogarten/genesis-relatedness-pre-build/pedigree-check-1/1
sbg:appVersion:
- v1.1
sbg:content_hash: ab6db38940d7291559506a407aa37bbf5477763773da662ca2903098214c8b228
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1614922194
sbg:id: smgogarten/genesis-relatedness-pre-build/pedigree-check-1/1
sbg:image_url:
sbg:latestRevision: 1
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1614922238
sbg:project: smgogarten/genesis-relatedness-pre-build
sbg:projectName: GENESIS relatedness - Pre-build
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: import from devel
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1614922194
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1614922238
  sbg:revision: 1
  sbg:revisionNotes: import from devel
sbg:sbgMaintained: false
sbg:validationErrors: []
