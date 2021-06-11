cwlVersion: v1.2
class: CommandLineTool
label: king_ibdseg
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: |-
    ${
        if (inputs.cpu)
        {
            return inputs.cpu
        }
        else
        {
            return 4
        }
        
    }
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InlineJavascriptRequirement

inputs:
- id: bed_file
  label: BED file
  doc: BED file, prepared by plink
  type: File
  secondaryFiles:
  - pattern: ^.bim
    required: true
  - pattern: ^.fam
    required: true
  inputBinding:
    prefix: -b
    position: 2
    shellQuote: false
  sbg:category: Input Files
  sbg:fileTypes: BED
- id: cpu
  label: Number of CPUs
  doc: Number of CPUs to use.
  type: int?
  default: 4
  inputBinding:
    prefix: --cpus
    position: 3
    shellQuote: false
  sbg:category: Input Options
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
  inputBinding:
    prefix: --prefix
    position: 5
    valueFrom: |-
      ${
          if (inputs.out_prefix)
          {
              return inputs.out_prefix
          }
          else
          {
              return "king_ibdseg"
          }
      }
    shellQuote: false
  sbg:category: Input Options
  sbg:toolDefaultValue: king_ibdseg

outputs:
- id: king_ibdseg_output
  label: KING ibdseg output
  doc: |-
    Text file with pairwise kinship estimates for all sample pairs with any detected IBD segments.
  type: File
  secondaryFiles:
  - pattern: ^.segments.gz
    required: false
  - pattern: ^allsegs.txt
    required: false
  outputBinding:
    glob: '*.seg'
  sbg:fileTypes: SEG
stdout: job.out.log

baseCommand:
- king --ibdseg

hints:
- class: sbg:SaveLogs
  value: job.out.log
