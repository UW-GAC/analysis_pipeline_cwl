cwlVersion: v1.1
class: CommandLineTool
label: kinship_plots
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-devel:latest
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
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/kinship-plots/17/raw/
sbg:appVersion:
- v1.1
sbg:content_hash: aa3558b6ecfa4a381f4df71bb28ecb2357152a9630241f1a8d5f3920f723da9a3
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1588805474
sbg:id: smgogarten/genesis-relatedness/kinship-plots/17
sbg:image_url:
sbg:latestRevision: 17
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615933724
sbg:project: smgogarten/genesis-relatedness
sbg:projectName: GENESIS relatedness
sbg:publisher: sbg
sbg:revision: 17
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: (uncommitted file)
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1588805474
  sbg:revision: 0
  sbg:revisionNotes: Copy of boris_majic/topmed-optimization/kinship-plots/2
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1588805584
  sbg:revision: 1
  sbg:revisionNotes: fix typo in input name
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1588806046
  sbg:revision: 2
  sbg:revisionNotes: make app setting lowercase for consistency
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1603305357
  sbg:revision: 3
  sbg:revisionNotes: update input types - add king_robust and pcrelate, remove king_related
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1603399138
  sbg:revision: 4
  sbg:revisionNotes: update file type
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1603478228
  sbg:revision: 5
  sbg:revisionNotes: use out_prefix instead of separate out_file inputs
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1603478818
  sbg:revision: 6
  sbg:revisionNotes: fix output file names
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1603483570
  sbg:revision: 7
  sbg:revisionNotes: save stdout to log file
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1603485339
  sbg:revision: 8
  sbg:revisionNotes: update input types
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605575482
  sbg:revision: 9
  sbg:revisionNotes: save full R output and config as logs
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1607987432
  sbg:revision: 10
  sbg:revisionNotes: allow GDS file as input
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608621808
  sbg:revision: 11
  sbg:revisionNotes: default label
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608667388
  sbg:revision: 12
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609308035
  sbg:revision: 13
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609308363
  sbg:revision: 14
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609374219
  sbg:revision: 15
  sbg:revisionNotes: update description
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609449055
  sbg:revision: 16
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615933724
  sbg:revision: 17
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
sbg:sbgMaintained: false
sbg:validationErrors: []
