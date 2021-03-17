cwlVersion: v1.0
class: CommandLineTool
label: SBG Group Segments
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: DockerRequirement
  dockerPull: alpine
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
  type: File[]?
  outputBinding:
    outputEval: |-
      ${
          function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          function find_chromosome(file){
              chr_array = []
              chrom_num = file.split("/").pop()
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
          
          assoc_files_dict = {}
          grouped_assoc_files = []
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
              chr_array = []
              chrom_num = file.split("/").pop()
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
          
          assoc_files_dict = {}
          output_chromosomes = []
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
- echo "Grouping"
id: bix-demo/sbgtools-demo/sbg-group-segments/1
sbg:appVersion:
- v1.0
sbg:content_hash: a28c335913434b3df3475ad90d7fb1321d7267642a4ae01f74f3bc82c73919970
sbg:contributors:
- boris_majic
sbg:createdBy: boris_majic
sbg:createdOn: 1570637340
sbg:id: h-fa68e168/h-a6d55e5b/h-81349546/0
sbg:image_url:
sbg:latestRevision: 1
sbg:modifiedBy: boris_majic
sbg:modifiedOn: 1570637358
sbg:project: bix-demo/sbgtools-demo
sbg:projectName: SBGTools - Demo New
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: Import from F4C
sbg:revisionsInfo:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1570637340
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1570637358
  sbg:revision: 1
  sbg:revisionNotes: Import from F4C
sbg:sbgMaintained: false
sbg:validationErrors: []
