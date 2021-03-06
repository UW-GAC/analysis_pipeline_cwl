cwlVersion: v1.2
class: CommandLineTool
label: pca_plots
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
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
  type: File?
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: n_pairs
  label: Number of PCs
  doc: Number of PCs to include in the pairs plot.
  type: int?
  sbg:category: Input Options
  sbg:toolDefaultValue: '6'
- id: group
  label: Group
  doc: |-
    Name of column in phenotype_file containing group variable for color-coding plots.
  type: string?
  sbg:category: Input Options
  sbg:toolDefaultValue: NA
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
  sbg:category: Input Options

outputs:
- id: pca_plots
  label: PC plots
  doc: PC plots
  type: File[]?
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
