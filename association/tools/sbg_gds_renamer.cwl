cwlVersion: v1.0
class: CommandLineTool
label: SBG GDS renamer
doc: |-
  This tool renames GDS file in GENESIS pipelines if they contain suffixes after chromosome (chr##) in the filename.
  For example: If GDS file has name data_chr1_subset.gds the tool will rename GDS file to data_chr1.gds.
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: ubuntu:16.04
- class: InlineJavascriptRequirement

inputs:
- id: in_variants
  label: GDS input
  doc: |-
    This tool removes suffix after 'chr##' in GDS filename. ## stands for chromosome name and can be (1-22,X,Y).
  type: File
  sbg:fileTypes: GDS

outputs:
- id: renamed_variants
  label: Renamed GDS
  doc: Renamed GDS file.
  type: File
  outputBinding:
    glob: "${\n    return '*'+inputs.in_variants.nameext\n}"
  sbg:fileTypes: GDS

baseCommand:
- mv
arguments:
- prefix: ''
  position: 0
  valueFrom: "${\n    if(inputs.in_variants){\n    return inputs.in_variants.path}\n\
    }"
  shellQuote: false
- prefix: ''
  position: 0
  valueFrom: |-
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
        
        var chr = find_chromosome(inputs.in_variants.nameroot)
        var base = inputs.in_variants.nameroot.split('chr'+chr)[0]
        
        return base+'chr' + chr + inputs.in_variants.nameext
      
    }
  shellQuote: false
id: sevenbridges/sbgtools-cwl1-0-demo/sbg-gds-renamer/2
sbg:appVersion:
- v1.0
sbg:content_hash: a34d3f6db559b26121d232f8bea272ddea3d4e150764868954d286b5b6e47c198
sbg:contributors:
- dajana_panovic
sbg:createdBy: dajana_panovic
sbg:createdOn: 1584358811
sbg:id: h-710eb1bb/h-7a66752c/h-bc6782bc/0
sbg:image_url:
sbg:latestRevision: 2
sbg:modifiedBy: dajana_panovic
sbg:modifiedOn: 1584359010
sbg:project: sevenbridges/sbgtools-cwl1-0-demo
sbg:projectName: SBGTools - CWL1.0 - Demo
sbg:publisher: sbg
sbg:revision: 2
sbg:revisionNotes: Description updated
sbg:revisionsInfo:
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584358811
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584358844
  sbg:revision: 1
  sbg:revisionNotes: Initial wrap
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584359010
  sbg:revision: 2
  sbg:revisionNotes: Description updated
sbg:sbgMaintained: false
sbg:validationErrors: []
