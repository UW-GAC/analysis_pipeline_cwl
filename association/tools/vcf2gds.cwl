cwlVersion: v1.1
class: CommandLineTool
label: vcf2gds
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: "${ if(inputs.cpu)\n        return inputs.cpu \n    else \n        return\
    \ 1\n}"
  ramMin: |-
    ${
        if(inputs.memory_gb)
            return parseFloat(inputs.memory_gb * 1024)
        else
            return 4*1024.0
    }
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InitialWorkDirRequirement
  listing:
  - entryname: vcf2gds.config
    writable: false
    entry: |-
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
          var config = "";
          config += "vcf_file \"" + inputs.vcf_file.path + "\"\n"
          if(inputs.format)
          {
              config += "format \"" + inputs.format.join(' ') + "\"\n"
          }
          else
          {
              config += "format \"GT\"\n"
          }
          if(inputs.gds_file_name)
              config += "gds_file \"" + inputs.gds_file_name + "\"\n"
          else
          {    
              
              if (inputs.vcf_file.basename.indexOf('.bcf') == -1){
              
               var chromosome = "chr" + find_chromosome(inputs.vcf_file.path);
               config += "gds_file \"" + inputs.vcf_file.path.split('/').pop().split(chromosome)[0] + chromosome + inputs.vcf_file.path.split('/').pop().split(chromosome)[1].split('.vcf')[0] +".gds\"";
              } else{
                  
                   var chromosome = "chr" + find_chromosome(inputs.vcf_file.path);
                   config += "gds_file \"" + inputs.vcf_file.path.split('/').pop().split(chromosome)[0] + chromosome + inputs.vcf_file.path.split('/').pop().split(chromosome)[1].split('.bcf')[0] +".gds\"";    
                  
                     }
              
              
          }
          return config
      }
         
- class: InlineJavascriptRequirement

inputs:
- id: vcf_file
  label: Variants Files
  doc: Input Variants Files.
  type: File
  sbg:category: Input Files
  sbg:fileTypes: VCF, VCF.GZ, BCF
- id: gds_file_name
  label: GDS File
  doc: Output GDS file.
  type: string?
- id: memory_gb
  label: Memory GB
  doc: Memory in GB for each job.
  type: float?
  sbg:category: Input options
  sbg:toolDefaultValue: '4'
- id: cpu
  label: Cpu
  doc: Number of CPUs for each tool job.
  type: int?
  sbg:category: Input Options
  sbg:toolDefaultValue: '1'
- id: format
  label: Format
  doc: VCF Format fields to keep in GDS file.
  type: string[]?
  sbg:category: General
  sbg:toolDefaultValue: GT

outputs:
- id: gds_output
  label: GDS Output File
  doc: GDS Output File.
  type: File?
  outputBinding:
    glob: '*.gds'
  sbg:fileTypes: GDS
- id: config_file
  type: File?
  outputBinding:
    glob: '*.config'
  sbg:fileTypes: CONFIG

baseCommand: []
arguments:
- prefix: ''
  position: 5
  valueFrom: |-
    ${
        return "Rscript /usr/local/analysis_pipeline/R/vcf2gds.R vcf2gds.config"
    }
  shellQuote: false
- prefix: ''
  position: 1
  valueFrom: |-
    ${
        if (inputs.cpu)
            return 'export NSLOTS=' + inputs.cpu + ' &&'
        else
            return ''
    }
  shellQuote: false
- prefix: ''
  position: 100
  valueFrom: "${\n    return \" >> job.out.log\"\n}"
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
id: boris_majic/genesis-toolkit-demo/vcf2gds/6
sbg:appVersion:
- v1.1
sbg:content_hash: aad1edf7ff5abb76730038fa3909aa8c03cc35c59b954113e5c79dd53333feee6
sbg:contributors:
- dajana_panovic
- boris_majic
sbg:createdBy: boris_majic
sbg:createdOn: 1577360497
sbg:id: h-3e407b72/h-03c00e87/h-9bfc0e04/0
sbg:image_url:
sbg:latestRevision: 6
sbg:modifiedBy: dajana_panovic
sbg:modifiedOn: 1616077524
sbg:project: boris_majic/genesis-toolkit-demo
sbg:projectName: GENESIS Toolkit - DEMO
sbg:publisher: sbg
sbg:revision: 6
sbg:revisionNotes: Docker updated to uwgac/topmed-master:2.10.0
sbg:revisionsInfo:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577360497
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577360526
  sbg:revision: 1
  sbg:revisionNotes: Import from F4C
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584373962
  sbg:revision: 2
  sbg:revisionNotes: GDS filename correction
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1594133464
  sbg:revision: 3
  sbg:revisionNotes: Docker image update to 2.8.0
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602155150
  sbg:revision: 4
  sbg:revisionNotes: BDC import 2.8.1 version
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608904059
  sbg:revision: 5
  sbg:revisionNotes: CWLtool prep
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1616077524
  sbg:revision: 6
  sbg:revisionNotes: Docker updated to uwgac/topmed-master:2.10.0
sbg:sbgMaintained: false
sbg:validationErrors: []
