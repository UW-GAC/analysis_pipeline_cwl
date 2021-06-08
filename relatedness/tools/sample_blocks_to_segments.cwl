cwlVersion: v1.1
class: CommandLineTool
label: sample blocks to segments
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: InlineJavascriptRequirement

inputs:
- id: n_sample_blocks
  label: Number of sample blocks
  doc: |-
    Number of blocks to divide samples into for parallel computation. Adjust depending on computer memory and number of samples in the analysis.
  type: int?
  default: 1
  sbg:category: Input Options
  sbg:toolDefaultValue: '1'

outputs:
- id: segments
  type: int[]?
  outputBinding:
    outputEval: |-
      ${ 
          var blocks = [];
          var N = inputs.n_sample_blocks;
          for (var i = 1; i <= N; i++) {
              for (var j = i; j <= N; j++) {
                  blocks.push([i, j]);
              }
          }
          
          var segments = [];
          for (var i = 1; i <= blocks.length; i++)
              segments.push(i)
              
          return segments;
      }

baseCommand: []
id: smgogarten/genesis-relatedness-pre-build/sample-blocks-to-segments/1
sbg:appVersion:
- v1.1
sbg:content_hash: af7325b6f64510e4d102db9ba5fde34bdc69604e198b648ba451a5bd9557974ae
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1609451972
sbg:id: smgogarten/genesis-relatedness-pre-build/sample-blocks-to-segments/1
sbg:image_url:
sbg:latestRevision: 1
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1609451996
sbg:project: smgogarten/genesis-relatedness-pre-build
sbg:projectName: GENESIS relatedness - Pre-build
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: import to pre-build project
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609451972
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609451996
  sbg:revision: 1
  sbg:revisionNotes: import to pre-build project
sbg:sbgMaintained: false
sbg:validationErrors: []
