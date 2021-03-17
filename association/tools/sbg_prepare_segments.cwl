cwlVersion: v1.0
class: CommandLineTool
label: SBG Prepare Segments
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: ubuntu:16.04
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
  type: File?
  outputBinding:
    glob: '*.txt'
    outputEval: |-
      ${
           function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          function find_chromosome(file){
              chr_array = []
              chrom_num = file.split("/").pop()
              split_by = chrom_num.substring(chrom_num.lastIndexOf('.'))
              chrom_num = chrom_num.split(split_by)[0]
              
              if(isNumeric(chrom_num.charAt(chrom_num.length-2)))
              {
                  chr_array.push(chrom_num.substr(chrom_num.length - 2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(chrom_num.length - 1))
              }
              return chr_array.toString()
          }
          
          function pair_chromosome_gds(file_array){
              var gdss = {}
              for(var i=0; i<file_array.length; i++){
                  gdss[find_chromosome(file_array[i].path)] = file_array[i]
              }
              return gdss
          }

          var input_gdss = pair_chromosome_gds(inputs.input_gds_files)
          var output_gdss = []
          segments = self[0].contents.split('\n')
          segments = segments.slice(1)
          for(i=0;i<segments.length;i++){
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
  type: File?
  outputBinding:
    glob: '*.txt'
    outputEval: |-
      ${
           function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          function find_chromosome(file){
              chr_array = []
              chrom_num = file.split("/").pop()
              split_by = chrom_num.substring(chrom_num.lastIndexOf('.'))
              chrom_num = chrom_num.split(split_by)[0]
              
              if(isNumeric(chrom_num.charAt(chrom_num.length-2)))
              {
                  chr_array.push(chrom_num.substr(chrom_num.length - 2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(chrom_num.length - 1))
              }
              return chr_array.toString()
          }
          
          function pair_chromosome_gds(file_array){
              var gdss = {}
              for(var i=0; i<file_array.length; i++){
                  gdss[find_chromosome(file_array[i].path)] = file_array[i]
              }
              return gdss
          }
          
          var input_gdss = pair_chromosome_gds(inputs.input_gds_files)
          var output_segments = []
          segments = self[0].contents.split('\n')
          segments = segments.slice(1)
          for(i=0;i<segments.length;i++){
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
  type: File?
  outputBinding:
    glob: '*.txt'
    outputEval: |-
      ${
           function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          function find_chromosome(file){
              chr_array = []
              chrom_num = file.split("/").pop()
              split_by = chrom_num.substring(chrom_num.lastIndexOf('.'))
              chrom_num = chrom_num.split(split_by)[0]
              
              if(isNumeric(chrom_num.charAt(chrom_num.length-2)))
              {
                  chr_array.push(chrom_num.substr(chrom_num.length - 2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(chrom_num.length - 1))
              }
              return chr_array.toString()
          }
          
          function pair_chromosome_gds(file_array){
              var gdss = {}
              for(var i=0; i<file_array.length; i++){
                  gdss[find_chromosome(file_array[i].path)] = file_array[i]
              }
              return gdss
          }
          function pair_chromosome_gds_special(file_array, agg_file){
              var gdss = {}
              for(var i=0; i<file_array.length; i++){
                  gdss[find_chromosome(file_array[i].path)] = agg_file
              }
              return gdss
          }
          var input_gdss = pair_chromosome_gds(inputs.input_gds_files)
          segments = self[0].contents.split('\n')
          segments = segments.slice(1)
          
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
              null_outputs = []
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
  sbg:fileTypes: RDATA
- id: variant_include_output
  label: Variant Include Output
  doc: Variant Include Output
  type: File?
  outputBinding:
    glob: '*.txt'
    outputEval: |-
      ${
           function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          function find_chromosome(file){
              chr_array = []
              chrom_num = file.split("/").pop()
              split_by = chrom_num.substring(chrom_num.lastIndexOf('.'))
              chrom_num = chrom_num.split(split_by)[0]
              
              if(isNumeric(chrom_num.charAt(chrom_num.length-2)))
              {
                  chr_array.push(chrom_num.substr(chrom_num.length - 2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(chrom_num.length - 1))
              }
              return chr_array.toString()
          }
          
          function pair_chromosome_gds(file_array){
              var gdss = {}
              for(var i=0; i<file_array.length; i++){
                  gdss[find_chromosome(file_array[i].path)] = file_array[i]
              }
              return gdss
          }
          var input_gdss = pair_chromosome_gds(inputs.input_gds_files)
          segments = self[0].contents.split('\n')
          segments = segments.slice(1)
          
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
              null_outputs = []
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
  sbg:fileTypes: RData

baseCommand: []
arguments:
- prefix: ''
  position: 0
  valueFrom: "${\n    return \"cp \" + inputs.segments_file.path + \" .\"\n}"
  shellQuote: false
id: bix-demo/sbgtools-demo/sbg-prepare-segments/4
sbg:appVersion:
- v1.0
sbg:content_hash: a3ab7ab3b9efbba8e7b1b98fe37b02e3fef2f31d3a5d6ff42f47d7a67a67263f0
sbg:contributors:
- boris_majic
sbg:createdBy: boris_majic
sbg:createdOn: 1570637160
sbg:id: h-edd7189a/h-809ad3bd/h-22dedc94/0
sbg:image_url:
sbg:latestRevision: 4
sbg:modifiedBy: boris_majic
sbg:modifiedOn: 1577369783
sbg:project: bix-demo/sbgtools-demo
sbg:projectName: SBGTools - Demo New
sbg:publisher: sbg
sbg:revision: 4
sbg:revisionNotes: Create special case for single multichromosomal aggregate file
sbg:revisionsInfo:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1570637160
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1570637272
  sbg:revision: 1
  sbg:revisionNotes: Import from F4C
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1570637516
  sbg:revision: 2
  sbg:revisionNotes:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1570637540
  sbg:revision: 3
  sbg:revisionNotes: Import from F4C
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577369783
  sbg:revision: 4
  sbg:revisionNotes: Create special case for single multichromosomal aggregate file
sbg:sbgMaintained: false
sbg:validationErrors: []
