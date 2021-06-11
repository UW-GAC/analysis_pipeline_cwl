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
