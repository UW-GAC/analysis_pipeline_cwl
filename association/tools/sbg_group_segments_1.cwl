cwlVersion: v1.2
class: CommandLineTool
label: SBG Group Segments
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.12.0
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
id: sevenbridges/sbgtools-cwl1-0-demo/sbg-group-segments/2
sbg:appVersion:
- v1.2
sbg:content_hash: aef083f19dfb9ccbcbf5494e7a516ba929cdf6965651e29063c9552620fd00c72
sbg:contributors:
- dajana_panovic
sbg:createdBy: dajana_panovic
sbg:createdOn: 1608907549
sbg:id: h-6301fb7d/h-9b94d48c/h-01c3af10/0
sbg:image_url:
sbg:latestRevision: 2
sbg:modifiedBy: dajana_panovic
sbg:modifiedOn: 1632131619
sbg:project: sevenbridges/sbgtools-cwl1-0-demo
sbg:projectName: SBGTools - CWL1.x - Demo
sbg:publisher: sbg
sbg:revision: 2
sbg:revisionNotes: uwgac/topmed-master:2.12.0
sbg:revisionsInfo:
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608907549
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608907559
  sbg:revision: 1
  sbg:revisionNotes: CWLtool prep
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1632131619
  sbg:revision: 2
  sbg:revisionNotes: uwgac/topmed-master:2.12.0
sbg:sbgMaintained: false
sbg:validationErrors: []
