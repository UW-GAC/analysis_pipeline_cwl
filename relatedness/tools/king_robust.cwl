cwlVersion: v1.2
class: CommandLineTool
label: king_robust
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: 8
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
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
- class: EnvVarRequirement
  envDef:
  - envName: NSLOTS
    envValue: ${ return runtime.cores }
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
  type: string?
  sbg:category: Input Options
- id: sample_include_file
  label: Sample Include file
  doc: |-
    RData file with vector of sample.id to include. If not provided, all samples in the GDS file are included.
  type: File?
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: variant_include_file
  label: Variant Include file
  doc: |-
    RData file with vector of variant.id to use for kinship estimation. If not provided, all variants in the GDS file are included.
  type: File?
  sbg:category: Input Files
  sbg:fileTypes: RDATA

outputs:
- id: king_robust_output
  label: KING robust output
  doc: GDS file with matrix of pairwise kinship estimates.
  type: File?
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
