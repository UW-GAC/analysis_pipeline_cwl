cwlVersion: v1.2
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
  dockerPull: uwgac/topmed-master:2.12.0
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
- cp
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
- prefix: ''
  position: 100
  valueFrom: "${\n    return ' >> job.out.log && chmod -R 777 .' \n}"
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
id: sevenbridges/sbgtools-cwl1-0-demo/sbg-gds-renamer/5
sbg:appVersion:
- v1.2
sbg:content_hash: a68b94f896356977fe45cb623215659008916591aa1860776445016e7fa1f0935
sbg:contributors:
- dajana_panovic
sbg:createdBy: dajana_panovic
sbg:createdOn: 1584358811
sbg:id: h-d47a8993/h-2cbb8e0d/h-d7b7882f/0
sbg:image_url:
sbg:latestRevision: 5
sbg:modifiedBy: dajana_panovic
sbg:modifiedOn: 1632131643
sbg:project: sevenbridges/sbgtools-cwl1-0-demo
sbg:projectName: SBGTools - CWL1.x - Demo
sbg:publisher: sbg
sbg:revision: 5
sbg:revisionNotes: uwgac/topmed-master:2.12.0
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
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608907259
  sbg:revision: 3
  sbg:revisionNotes: CWLtool prep
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1630916163
  sbg:revision: 4
  sbg:revisionNotes: chmod -R 777 added to command line
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1632131643
  sbg:revision: 5
  sbg:revisionNotes: uwgac/topmed-master:2.12.0
sbg:sbgMaintained: false
sbg:validationErrors: []
