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
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness-pre-build/king-ibdseg/4/raw/
sbg:appVersion:
- v1.2
sbg:content_hash: af4e54ea60112079238f41d4aad7712f302851f67c82bfa0b313f6ea5660e23d5
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1609451092
sbg:id: smgogarten/genesis-relatedness-pre-build/king-ibdseg/4
sbg:image_url:
sbg:latestRevision: 4
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1623450742
sbg:project: smgogarten/genesis-relatedness-pre-build
sbg:projectName: GENESIS relatedness - Pre-build
sbg:publisher: sbg
sbg:revision: 4
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: c9c8b8d
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609451092
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609451124
  sbg:revision: 1
  sbg:revisionNotes: import to pre-build project
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623444724
  sbg:revision: 2
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: c9c8b8d
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623445039
  sbg:revision: 3
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: c9c8b8d
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623450742
  sbg:revision: 4
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: c9c8b8d
sbg:sbgMaintained: false
sbg:validationErrors: []
