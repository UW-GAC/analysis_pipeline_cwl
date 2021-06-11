cwlVersion: v1.1
class: CommandLineTool
label: pca_byrel
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: EnvVarRequirement
  envDef:
  - envName: NSLOTS
    envValue: ${ return inputs.cpu }
- class: ResourceRequirement
  coresMin: "${ if(inputs.cpu)\n        return inputs.cpu \n    else \n        return\
    \ 4\n}"
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: pca_byrel.config
    writable: false
    entry: |-
      ${

          var cmd_line = ''
          var arguments = []
          
          if(inputs.gds_file)
           arguments.push("gds_file \"" + inputs.gds_file.path + "\"")
          if(inputs.related_file)
              arguments.push("related_file \"" + inputs.related_file.path + "\"")
          
          if(inputs.unrelated_file)
              arguments.push("unrelated_file \"" + inputs.unrelated_file.path + "\"")
              
          if(inputs.variant_include_file)
              arguments.push("variant_include_file \"" + inputs.variant_include_file.path + "\"")
              
          if(inputs.n_pcs)
              arguments.push('n_pcs ' + inputs.n_pcs)
          
          if(inputs.out_prefix) {
              arguments.push(cmd_line +='out_file "' + inputs.out_prefix + '_pca.RData"')
          
              arguments.push('out_file_unrel "' + inputs.out_prefix + '_pca_unrel.RData"')
          }
          
          if(inputs.sample_include_file)
              arguments.push('sample_include_file "' + inputs.sample_include_file.path + '"')
          
          return arguments.join("\n")
      }
- class: InlineJavascriptRequirement

inputs:
- id: gds_file
  label: GDS File
  doc: |-
    Input GDS file used for PCA. It is recommended to use an LD pruned file with all chromosomes.
  type: File
  sbg:category: Input Files
  sbg:fileTypes: GDS
- id: related_file
  label: Related file
  doc: RData file with related subjects.
  type: File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: unrelated_file
  label: Unrelated file
  doc: RData file with unrelated subjects.
  type: File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: sample_include_file
  label: Sample Include file
  doc: |-
    RData file with vector of sample.id to include. If not provided, all samples in the GDS file are included.
  type: File?
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: variant_include_file
  label: Variant include file
  doc: |-
    RData file with vector of variant.id to include. If not provided, all variants in the GDS file are included.
  type: File?
  sbg:category: Input Options
  sbg:fileTypes: RDATA
- id: n_pcs
  label: Number of PCs
  doc: Number of PCs (Principal Components) to return.
  type: int?
  default: 32
  sbg:category: Input Options
  sbg:toolDefaultValue: '32'
- id: out_prefix
  label: Output prefix
  doc: Output prefix.
  type: string?
  sbg:category: Input Options
- id: cpu
  label: cpu
  doc: Number of CPUs used for each job.
  type: int?
  default: 4
  sbg:category: Input Options
  sbg:toolDefaultValue: '4'

outputs:
- id: pcair_output
  label: RData file with PC-AiR PCs for all samples
  type: File?
  outputBinding:
    glob: |-
      ${
        if (!inputs.out_prefix) {
          var comm = "pca.RData"
        } else {
          var comm = inputs.out_prefix + "_pca.RData"
        }
        return comm
      }
  sbg:fileTypes: RDATA
- id: pcair_output_unrelated
  label: PCA byrel unrelated
  doc: RData file with PC-AiR PCs for unrelated samples
  type: File?
  outputBinding:
    glob: |-
      ${
        if (!inputs.out_prefix) {
          var comm = "pca_unrel.RData"
        } else {
          var comm = inputs.out_prefix + "_pca_unrel.RData"
        }
        return comm
      }
  sbg:fileTypes: RDATA
stdout: job.out.log

baseCommand:
- R -q --vanilla
arguments:
- prefix: <
  position: 3
  valueFrom: /usr/local/analysis_pipeline/R/pca_byrel.R
  shellQuote: false
- prefix: --args
  position: 2
  valueFrom: pca_byrel.config
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: pca_byrel.config
