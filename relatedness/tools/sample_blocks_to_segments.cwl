cwlVersion: v1.2
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
