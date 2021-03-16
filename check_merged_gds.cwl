cwlVersion: v1.1
class: CommandLineTool
label: check_merged_gds
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: check_merged_gds.config
    writable: false
    entry: |
      ${
          var config = "";
          
          if(inputs.gds_file)
              var gds_name = "";
              var gds_file = [].concat(inputs.gds_file)
              var gds = gds_file[0].path;
              var gds_first_part = gds.split('chr')[0];
              var gds_second_part = gds.split('chr')[1].split('.');
              gds_second_part.shift();
              gds_name = gds_first_part + 'chr .' + gds_second_part.join('.');
              config += "gds_file \"" + gds_name + "\"\n"

          if (inputs.merged_gds_file)
              config += "merged_gds_file \"" + inputs.merged_gds_file.path + "\"\n"

          return config
      }
- class: InlineJavascriptRequirement

inputs:
- id: gds_file
  label: GDS File
  doc: Base reference file for comparison.
  type: File
  sbg:category: Inputs
  sbg:fileTypes: GDS
- id: merged_gds_file
  label: Merged GDS file
  doc: |-
    Output of merge_gds script. This file is being checked against starting gds file.
  type: File
  sbg:category: Inputs
  sbg:fileTypes: GDS

outputs: []
stdout: job.out.log

baseCommand:
- R -q --vanilla
arguments:
- prefix: <
  position: 3
  valueFrom: /usr/local/analysis_pipeline/R/check_merged_gds.R
  shellQuote: false
- prefix: --chromosome
  position: 2
  valueFrom: "${\n    return inputs.gds_file.path.split('chr')[1].split('.')[0]\n}"
  shellQuote: false
- prefix: --args
  position: 1
  valueFrom: check_merged_gds.config
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: check_merged_gds.config
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/check-merged-gds/4/raw/
sbg:appVersion:
- v1.1
sbg:content_hash: a43d50c93312f68a5066485ef9af71011f01f9c239b0b51e4b299a2aa1f64ead8
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1601922349
sbg:id: smgogarten/genesis-relatedness/check-merged-gds/4
sbg:image_url:
sbg:latestRevision: 4
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615931958
sbg:project: smgogarten/genesis-relatedness
sbg:projectName: GENESIS relatedness
sbg:publisher: sbg
sbg:revision: 4
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: (uncommitted file)
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1601922349
  sbg:revision: 0
  sbg:revisionNotes: Copy of boris_majic/topmed-optimization/check_merged_gds/15
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606256250
  sbg:revision: 1
  sbg:revisionNotes: revise check_merged_gds
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606269035
  sbg:revision: 2
  sbg:revisionNotes: gds_file input is a single file, not an array
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615931560
  sbg:revision: 3
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615931958
  sbg:revision: 4
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
sbg:sbgMaintained: false
sbg:validationErrors: []
