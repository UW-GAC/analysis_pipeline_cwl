cwlVersion: v1.1
class: CommandLineTool
label: SBG Prepare Segments
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InlineJavascriptRequirement

inputs:
- id: input_gds_files
  label: GDS files
  doc: GDS files.
  type: File[]
  sbg:category: Inputs
  sbg:fileTypes: GDS
- id: segments_file
  label: Segments file
  doc: Segments file.
  type: File
  sbg:category: Inputs
  sbg:fileTypes: TXT
- id: aggregate_files
  label: Aggregate files
  doc: Aggregate files.
  type: File[]?
  sbg:category: Inputs
  sbg:fileTypes: RDATA
- id: variant_include_files
  label: Variant Include Files
  doc: RData file containing ids of variants to be included.
  type: File[]?
  sbg:category: Inputs
  sbg:fileTypes: RData

outputs:
- id: gds_output
  label: GDS files
  doc: GDS files.
  type: File[]?
  outputBinding:
    glob: '*.txt'
    outputEval: |-
      ${
           function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("chr")[1];
              
              if(isNumeric(chrom_num.charAt(1)))
              {
                  chr_array.push(chrom_num.substr(0,2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(0,1))
              }
              return chr_array.toString()
          }
          
          
          
          function pair_chromosome_gds(file_array){
              var gdss = {};
              for(var i=0; i<file_array.length; i++){
                  gdss[find_chromosome(file_array[i].path)] = file_array[i]
              }
              return gdss
          }

          var input_gdss = pair_chromosome_gds(inputs.input_gds_files)
          var output_gdss = [];
          var segments = self[0].contents.split('\n');
          var chr;
          
          segments = segments.slice(1)
          for(var i=0;i<segments.length;i++){
              chr = segments[i].split('\t')[0]
              if(chr in input_gdss){
                  output_gdss.push(input_gdss[chr])
              }
          }
          return output_gdss
      }
    loadContents: true
  sbg:fileTypes: GDS
- id: segments
  label: Segments
  doc: Segments.
  type: int[]?
  outputBinding:
    glob: '*.txt'
    outputEval: |-
      ${
           function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("chr")[1];
              
              if(isNumeric(chrom_num.charAt(1)))
              {
                  chr_array.push(chrom_num.substr(0,2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(0,1))
              }
              return chr_array.toString()
          }
          
          function pair_chromosome_gds(file_array){
              var gdss = {};
              for(var i=0; i<file_array.length; i++){
                  gdss[find_chromosome(file_array[i].path)] = file_array[i]
              }
              return gdss
          }
          
          var input_gdss = pair_chromosome_gds(inputs.input_gds_files)
          var output_segments = []
          var segments = self[0].contents.split('\n');
          segments = segments.slice(1)
          var chr;
          
          for(var i=0;i<segments.length;i++){
              chr = segments[i].split('\t')[0]
              if(chr in input_gdss){
                  output_segments.push(i+1)
              }
          }
          return output_segments
          
      }
    loadContents: true
- id: aggregate_output
  label: Aggregate output
  doc: Aggregate output.
  type:
  - 'null'
  - type: array
    items:
    - 'null'
    - File
  outputBinding:
    glob: '*.txt'
    outputEval: |-
      ${
           function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("chr")[1];
              
              if(isNumeric(chrom_num.charAt(1)))
              {
                  chr_array.push(chrom_num.substr(0,2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(0,1))
              }
              return chr_array.toString()
          }
          
          function pair_chromosome_gds(file_array){
              var gdss = {};
              for(var i=0; i<file_array.length; i++){
                  gdss[find_chromosome(file_array[i].path)] = file_array[i]
              }
              return gdss
          }
          function pair_chromosome_gds_special(file_array, agg_file){
              var gdss = {};
              for(var i=0; i<file_array.length; i++){
                  gdss[find_chromosome(file_array[i].path)] = agg_file
              }
              return gdss
          }
          var input_gdss = pair_chromosome_gds(inputs.input_gds_files)
          var segments = self[0].contents.split('\n');
          segments = segments.slice(1)
          var chr;
          
          if(inputs.aggregate_files){
              if (inputs.aggregate_files[0] != null){
                  if (inputs.aggregate_files[0].basename.includes('chr'))
                      var input_aggregate_files = pair_chromosome_gds(inputs.aggregate_files);
                  else
                      var input_aggregate_files = pair_chromosome_gds_special(inputs.input_gds_files, inputs.aggregate_files[0].path);
                  var output_aggregate_files = []
                  for(var i=0;i<segments.length;i++){
                      chr = segments[i].split('\t')[0]
                      if(chr in input_aggregate_files){
                          output_aggregate_files.push(input_aggregate_files[chr])
                      }
                      else if(chr in input_gdss){
                          output_aggregate_files.push(null)
                      }
                  }
                  return output_aggregate_files
              }
          }
          else{
              var null_outputs = []
              for(var i=0; i<segments.length; i++){
                  chr = segments[i].split('\t')[0]
                  if(chr in input_gdss){
                      null_outputs.push(null)
                  }
              }
              return null_outputs
          }
      }
    loadContents: true
- id: variant_include_output
  label: Variant Include Output
  doc: Variant Include Output
  type:
  - 'null'
  - type: array
    items:
    - 'null'
    - File
  outputBinding:
    glob: '*.txt'
    outputEval: |-
      ${
           function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("chr")[1];
              
              if(isNumeric(chrom_num.charAt(1)))
              {
                  chr_array.push(chrom_num.substr(0,2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(0,1))
              }
              return chr_array.toString()
          }
          
          function pair_chromosome_gds(file_array){
              var gdss = {};
              for(var i=0; i<file_array.length; i++){
                  gdss[find_chromosome(file_array[i].path)] = file_array[i]
              }
              return gdss
          }
          var input_gdss = pair_chromosome_gds(inputs.input_gds_files)
          var segments = self[0].contents.split('\n');
          segments = segments.slice(1)
          var chr;
          
          if(inputs.variant_include_files){
              if (inputs.variant_include_files[0] != null){
                  var input_variant_files = pair_chromosome_gds(inputs.variant_include_files)
                  var output_variant_files = []
                  for(var i=0;i<segments.length;i++){
                      chr = segments[i].split('\t')[0]
                      if(chr in input_variant_files){
                          output_variant_files.push(input_variant_files[chr])
                      }
                      else if(chr in input_gdss){
                          output_variant_files.push(null)
                      }
                  }
                  return output_variant_files
              }
          }
          else{
              var null_outputs = [];
              for(var i=0; i<segments.length; i++){
                  chr = segments[i].split('\t')[0]
                  if(chr in input_gdss){
                      null_outputs.push(null)
                  }
              }
              return null_outputs
          }
      }
    loadContents: true

baseCommand: []
arguments:
- prefix: ''
  position: 0
  valueFrom: "${\n    return \"cp \" + inputs.segments_file.path + \" .\"\n}"
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
id: sevenbridges/sbgtools-cwl1-0-demo/sbg-prepare-segments/1
sbg:appVersion:
- v1.1
sbg:content_hash: af5431cfdc789d53445974b82b534a1ba1c6df2ac79d7b39af88dce65def8cb34
sbg:contributors:
- dajana_panovic
sbg:createdBy: dajana_panovic
sbg:createdOn: 1608907510
sbg:id: h-eeafaff0/h-028cc27d/h-9f188156/0
sbg:image_url:
sbg:latestRevision: 1
sbg:modifiedBy: dajana_panovic
sbg:modifiedOn: 1608907520
sbg:project: sevenbridges/sbgtools-cwl1-0-demo
sbg:projectName: SBGTools - CWL1.0 - Demo
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: CWLtool prep
sbg:revisionsInfo:
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608907510
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608907520
  sbg:revision: 1
  sbg:revisionNotes: CWLtool prep
sbg:sbgMaintained: false
sbg:validationErrors: []
