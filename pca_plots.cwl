cwlVersion: v1.1
class: CommandLineTool
label: pca_plots
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-devel:latest
- class: InitialWorkDirRequirement
  listing:
  - entryname: pca_plots.config
    writable: false
    entry: |-
      ${
       var cmd_line = ""

      if(inputs.pca_file)
          cmd_line += "pca_file \"" + inputs.pca_file.path + "\"\n"

      if(inputs.n_pairs)
          cmd_line += "n_pairs \"" + inputs.n_pairs + "\"\n"
          

      if(inputs.out_prefix) {
           cmd_line += "out_file_scree \"" + inputs.out_prefix + "_pca_scree.pdf\"\n"
          
           cmd_line += "out_file_pc12 \"" + inputs.out_prefix + "_pca_pc12.pdf\"\n"
         
           cmd_line += "out_file_parcoord \"" + inputs.out_prefix + "_pca_parcoord.pdf\"\n"
         
          cmd_line += 'out_file_pairs "' + inputs.out_prefix + '_pca_pairs.png"\n'
      }

      if(inputs.group)
          cmd_line += 'group "' + inputs.group + '"\n'

      if(inputs.phenotype_file)
          cmd_line += 'phenotype_file "' + inputs.phenotype_file.path + '"\n'


       return cmd_line 
      }
- class: InlineJavascriptRequirement

inputs:
- id: pca_file
  label: PCA File
  doc: RData file containing pcair object (output by pca_byrel tool)
  type: File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: phenotype_file
  label: Phenotype file
  doc: |-
    RData file with data.frame or AnnotatedDataFrame of phenotypes. Used for color-coding PCA plots by group.
  type:
  - 'null'
  - File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: n_pairs
  label: Number of PCs
  doc: Number of PCs to include in the pairs plot.
  type:
  - 'null'
  - int
  sbg:category: Input Options
  sbg:toolDefaultValue: '6'
- id: group
  label: Group
  doc: |-
    Name of column in phenotype_file containing group variable for color-coding plots.
  type:
  - 'null'
  - string
  sbg:category: Input Options
  sbg:toolDefaultValue: NA
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type:
  - 'null'
  - string
  sbg:category: Input Options

outputs:
- id: pca_plots
  label: PC plots
  doc: PC plots
  type:
  - 'null'
  - type: array
    items: File
  outputBinding:
    glob: '*.p*'
stdout: job.out.log

baseCommand:
- R -q --vanilla
arguments:
- prefix: <
  position: 2
  valueFrom: /usr/local/analysis_pipeline/R/pca_plots.R
  shellQuote: false
- prefix: --args
  position: 1
  valueFrom: pca_plots.config
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: pca_plots.config
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/pca-plots/6/raw/
sbg:appVersion:
- v1.1
sbg:content_hash: a646fcb270f0f29782798216695abecb5ac192022d6cd57c2e221857bed030d66
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1604988656
sbg:id: smgogarten/genesis-relatedness/pca-plots/6
sbg:image_url:
sbg:latestRevision: 6
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615936347
sbg:project: smgogarten/genesis-relatedness
sbg:projectName: GENESIS relatedness
sbg:publisher: sbg
sbg:revision: 6
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: (uncommitted file)
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1604988656
  sbg:revision: 0
  sbg:revisionNotes: Copy of boris_majic/topmed-optimization/pca-plots/0
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605574521
  sbg:revision: 1
  sbg:revisionNotes: update to new format
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605576107
  sbg:revision: 2
  sbg:revisionNotes: specify docker version
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606356113
  sbg:revision: 3
  sbg:revisionNotes: update input and output labels
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609370862
  sbg:revision: 4
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609449160
  sbg:revision: 5
  sbg:revisionNotes: use devel docker image to allow data.frame input for phenotype
    file
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615936347
  sbg:revision: 6
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
sbg:sbgMaintained: false
sbg:validationErrors: []
