cwlVersion: v1.2
class: CommandLineTool
label: kinship_plots
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InitialWorkDirRequirement
  listing:
  - entryname: kinship_plots.config
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

      if(inputs.kinship_threshold)
          cmd_line +='kinship_threshold "' + inputs.kinship_threshold + '\n'

      if(inputs.out_prefix) {
          cmd_line += 'out_file_all "' + inputs.out_prefix + '_all.pdf"\n'
          cmd_line += 'out_file_cross "' + inputs.out_prefix + '_cross_group.pdf"\n'
          cmd_line += 'out_file_study "' + inputs.out_prefix + '_within_group.pdf"\n'
      }

      if(inputs.phenotype_file)
          cmd_line += 'phenotype_file "' + inputs.phenotype_file.path + '"\n'

      if(inputs.group)
          cmd_line += 'study "' + inputs.group + '"\n'

      if(inputs.sample_include_file)
          cmd_line += 'sample_include_file "' + inputs.sample_include_file.path + '"\n'

      return cmd_line
      }
- class: InlineJavascriptRequirement

inputs:
- id: kinship_file
  label: Kinship File
  doc: Kinship file
  type: File
  sbg:category: Input
  sbg:fileTypes: RDATA, SEG, KIN, GDS
- id: kinship_method
  label: Kinship method
  doc: Method used to generate kinship estimates.
  type:
    name: kinship_method
    type: enum
    symbols:
    - king_ibdseg
    - pcrelate
    - king_robust
  sbg:category: Input Options
- id: kinship_plot_threshold
  label: Kinship plotting threshold
  doc: Minimum kinship for a pair to be included in the plot.
  type:
  - 'null'
  - float
  sbg:category: Input Options
  sbg:toolDefaultValue: 2^(-9/2) (third-degree relatives and closer)
- id: phenotype_file
  label: Phenotype File
  doc: |-
    RData file with data.frame or AnnotatedDataFrame of phenotypes. Used for plotting kinship estimates separately by group.
  type:
  - 'null'
  - File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: group
  label: Group column name
  doc: |-
    Name of column in phenotype_file containing group variable (e.g., study) for plotting.
  type:
  - 'null'
  - string
  sbg:category: Input Options
  sbg:toolDefaultValue: NA
- id: sample_include_file
  label: Sample Include File
  doc: RData file with vector of sample.id to include.
  type:
  - 'null'
  - File
  sbg:category: Input Options
  sbg:fileTypes: RDATA
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type:
  - 'null'
  - string
  sbg:category: Input Options
  sbg:toolDefaultValue: kinship

outputs:
- id: kinship_plots
  label: Kinship plots
  doc: |-
    Hexbin plots of estimated kinship coefficients vs. IBS0. If "group" is provided, additional plots will be generated within each group and across groups.
  type:
  - 'null'
  - type: array
    items: File
  outputBinding:
    glob: '*.pdf'
  sbg:fileTypes: PDF
stdout: job.out.log

baseCommand:
- R -q --vanilla
arguments:
- prefix: <
  position: 2
  valueFrom: /usr/local/analysis_pipeline/R/kinship_plots.R
  shellQuote: false
- prefix: --args
  position: 1
  valueFrom: kinship_plots.config
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: kinship_plots.config
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness-pre-build/kinship-plots/5/raw/
sbg:appVersion:
- v1.2
sbg:content_hash: a586cdf67e8e0be1aeaeab6ed15ecfb56784ef6a8d036943890fd8032e98f8744
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1609451320
sbg:id: smgogarten/genesis-relatedness-pre-build/kinship-plots/5
sbg:image_url:
sbg:latestRevision: 5
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1623450748
sbg:project: smgogarten/genesis-relatedness-pre-build
sbg:projectName: GENESIS relatedness - Pre-build
sbg:publisher: sbg
sbg:revision: 5
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: c9c8b8d
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609451320
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609451341
  sbg:revision: 1
  sbg:revisionNotes: import to pre-build project
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623444403
  sbg:revision: 2
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: 878723c
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623444726
  sbg:revision: 3
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: c9c8b8d
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623445046
  sbg:revision: 4
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: c9c8b8d
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623450748
  sbg:revision: 5
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: c9c8b8d
sbg:sbgMaintained: false
sbg:validationErrors: []
