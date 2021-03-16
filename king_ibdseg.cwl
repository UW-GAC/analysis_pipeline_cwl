cwlVersion: v1.1
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
  dockerPull: uwgac/topmed-master:2.8.1
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
  type:
  - 'null'
  - int
  default: 4
  inputBinding:
    prefix: --cpus
    position: 3
    shellQuote: false
  sbg:category: Input Options
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type:
  - 'null'
  - string
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
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/king_ibdseg/10/raw/
sbg:appVersion:
- v1.1
sbg:content_hash: a6b16ce8c6986076067867fe20674336aa11a8c9f335eb1c854859370a9cd4e63
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1601922394
sbg:id: smgogarten/genesis-relatedness/king_ibdseg/10
sbg:image_url:
sbg:latestRevision: 10
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615934590
sbg:project: smgogarten/genesis-relatedness
sbg:projectName: GENESIS relatedness
sbg:publisher: sbg
sbg:revision: 10
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: (uncommitted file)
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1601922394
  sbg:revision: 0
  sbg:revisionNotes: Copy of boris_majic/topmed-optimization/king_ibdseg/7
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1603229404
  sbg:revision: 1
  sbg:revisionNotes: new docker image
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1603255368
  sbg:revision: 2
  sbg:revisionNotes: remove requirement for .nosex file
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1603299014
  sbg:revision: 3
  sbg:revisionNotes: remove instance hint
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1603484717
  sbg:revision: 4
  sbg:revisionNotes: save stdout as log file
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1603485141
  sbg:revision: 5
  sbg:revisionNotes: specify KING output format
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605574936
  sbg:revision: 6
  sbg:revisionNotes: use base command
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608073210
  sbg:revision: 7
  sbg:revisionNotes: add default CPU value
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609309145
  sbg:revision: 8
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609364902
  sbg:revision: 9
  sbg:revisionNotes: update description
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615934590
  sbg:revision: 10
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
sbg:sbgMaintained: false
sbg:validationErrors: []
