cwlVersion: v1.1
class: CommandLineTool
label: define_segments.R
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InitialWorkDirRequirement
  listing:
  - entryname: define_segments.config
    writable: false
    entry: |-
      ${
          var argument = [];
          argument.push('out_file "segments.txt"')
          if(inputs.genome_build){
               argument.push('genome_build "' + inputs.genome_build + '"')
          }
          return argument.join('\n')
      }
- class: InlineJavascriptRequirement

inputs:
- id: segment_length
  label: Segment length
  doc: Segment length in kb, used for paralelization.
  type: int?
  inputBinding:
    prefix: --segment_length
    position: 1
    shellQuote: false
  sbg:altPrefix: -s
  sbg:category: Optional parameters
  sbg:toolDefaultValue: '10000'
- id: n_segments
  label: Number of segments
  doc: |-
    Number of segments, used for paralelization (overrides Segment length). Note that this parameter defines the number of segments for the entire genome, so using this argument with selected chromosomes may result in fewer segments than you expect (and the minimum is one segment per chromosome).
  type: int?
  inputBinding:
    prefix: --n_segments
    position: 2
    shellQuote: false
  sbg:altPrefix: -n
  sbg:category: Optional parameters
- id: genome_build
  label: Genome build
  doc: |-
    Genome build for the genotypes in the GDS file (hg19 or hg38). Used to divide the genome into segments for parallel processing.
  type:
  - 'null'
  - name: genome_build
    type: enum
    symbols:
    - hg19
    - hg38
  default: hg38
  sbg:category: Configs
  sbg:toolDefaultValue: hg38

outputs:
- id: config
  label: Config file
  doc: Config file.
  type: File?
  outputBinding:
    glob: '*.config'
  sbg:fileTypes: CONFIG
- id: define_segments_output
  label: Segments file
  doc: Segments txt file.
  type: File?
  outputBinding:
    glob: segments.txt
  sbg:fileTypes: TXT

baseCommand: []
arguments:
- prefix: ''
  position: 100
  valueFrom: define_segments.config
  separate: false
  shellQuote: false
- prefix: ''
  position: 0
  valueFrom: Rscript /usr/local/analysis_pipeline/R/define_segments.R
  shellQuote: false
- prefix: ''
  position: 100
  valueFrom: "${\n    return ' >> job.out.log'\n}"
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
id: boris_majic/genesis-toolkit-demo/define-segments-r/6
sbg:appVersion:
- v1.1
sbg:content_hash: abcb7884a4e9f96eab06afefcfd6ac9a971605d3a26b810578009f05e0f63455d
sbg:contributors:
- dajana_panovic
- boris_majic
sbg:createdBy: boris_majic
sbg:createdOn: 1577360777
sbg:id: h-694d1b5f/h-1a5343c2/h-bf2a9372/0
sbg:image_url:
sbg:latestRevision: 6
sbg:modifiedBy: dajana_panovic
sbg:modifiedOn: 1616077263
sbg:project: boris_majic/genesis-toolkit-demo
sbg:projectName: GENESIS Toolkit - DEMO
sbg:publisher: sbg
sbg:revision: 6
sbg:revisionNotes: Docker updated to uwgac/topmed-master:2.10.0
sbg:revisionsInfo:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577360777
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577360800
  sbg:revision: 1
  sbg:revisionNotes: Import from F4C
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1594132905
  sbg:revision: 2
  sbg:revisionNotes: Docker image update to 2.0.8
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602155769
  sbg:revision: 3
  sbg:revisionNotes: Import from BDC 2.8.1 version
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603798568
  sbg:revision: 4
  sbg:revisionNotes: BDC import
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608907204
  sbg:revision: 5
  sbg:revisionNotes: CWLtool prep
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1616077263
  sbg:revision: 6
  sbg:revisionNotes: Docker updated to uwgac/topmed-master:2.10.0
sbg:sbgMaintained: false
sbg:validationErrors: []
