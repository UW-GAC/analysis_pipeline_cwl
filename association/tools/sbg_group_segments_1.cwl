cwlVersion: v1.1
class: CommandLineTool
label: SBG Group Segments
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InlineJavascriptRequirement

inputs:
- id: assoc_files
  label: Assoc files
  doc: Assoc files.
  type: File[]
  sbg:category: Inputs
  sbg:fileTypes: RDATA

outputs:
- id: grouped_assoc_files
  type:
  - 'null'
  - type: array
    items:
    - type: array
      items:
      - File
      - 'null'
    - 'null'
  outputBinding:
    outputEval: |-
      ${
          function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("/").pop();
              chrom_num = chrom_num.substr(0,chrom_num.lastIndexOf(".")).split('_').slice(0,-1).join('_')
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
          
          var assoc_files_dict = {};
          var grouped_assoc_files = [];
          var chr;
          for(var i=0; i<inputs.assoc_files.length; i++){
              chr = find_chromosome(inputs.assoc_files[i].path)
              if(chr in assoc_files_dict){
                  assoc_files_dict[chr].push(inputs.assoc_files[i])
              }
              else{
                  assoc_files_dict[chr] = [inputs.assoc_files[i]]
              }
          }
          for(var key in assoc_files_dict){
              grouped_assoc_files.push(assoc_files_dict[key])
          }
          return grouped_assoc_files
          
      }
- id: chromosome
  label: Chromosomes
  doc: Chromosomes.
  type: string[]?
  outputBinding:
    outputEval: |-
      ${
          function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("/").pop();
              chrom_num = chrom_num.substr(0,chrom_num.lastIndexOf(".")).split('_').slice(0,-1).join('_')
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
          
          var assoc_files_dict = {};
          var output_chromosomes = [];
          var chr;
          for(var i=0; i<inputs.assoc_files.length; i++){
              chr = find_chromosome(inputs.assoc_files[i].path)
              if(chr in assoc_files_dict){
                  assoc_files_dict[chr].push(inputs.assoc_files[i])
              }
              else{
                  assoc_files_dict[chr] = [inputs.assoc_files[i]]
              }
          }
          for(var key in assoc_files_dict){
              output_chromosomes.push(key)
          }
          return output_chromosomes
          
      }

baseCommand:
- echo
- '"Grouping"'

hints:
- class: sbg:SaveLogs
  value: job.out.log
id: sevenbridges/sbgtools-cwl1-0-demo/sbg-group-segments/1
sbg:appVersion:
- v1.1
sbg:content_hash: a515be0f5124c62e65c743e3ca9940a2d4d90f71217b08949ce69537195ad562c
sbg:contributors:
- dajana_panovic
sbg:createdBy: dajana_panovic
sbg:createdOn: 1608907549
sbg:id: h-5bd2b83b/h-435f591a/h-e047dd70/0
sbg:image_url:
sbg:latestRevision: 1
sbg:modifiedBy: dajana_panovic
sbg:modifiedOn: 1608907559
sbg:project: sevenbridges/sbgtools-cwl1-0-demo
sbg:projectName: SBGTools - CWL1.0 - Demo
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: CWLtool prep
sbg:revisionsInfo:
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608907549
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608907559
  sbg:revision: 1
  sbg:revisionNotes: CWLtool prep
sbg:sbgMaintained: false
sbg:validationErrors: []
