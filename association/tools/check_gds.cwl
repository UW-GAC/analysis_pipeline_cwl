cwlVersion: v1.1
class: CommandLineTool
label: check_gds
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  ramMin: 30000
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: check_gds.config
    writable: false
    entry: |-
      ${  
          var config = "";
          var vcf_array = [].concat(inputs.vcf_file);
          var vcf_first_part = vcf_array[0].path.split('chr')[0];
          var vcf_second_part = vcf_array[0].path.split('chr')[1].split('.');
          vcf_second_part.shift();
          config += "vcf_file \"" + vcf_first_part + 'chr .' + vcf_second_part.join('.') + "\"\n";
          var gds_first_part = inputs.gds_file.path.split('chr')[0];
          var gds_second_part = inputs.gds_file.path.split('chr')[1].split('.');
          gds_second_part.shift();
          config += "gds_file \"" + gds_first_part + 'chr .' + gds_second_part.join('.') + "\"\n";
          if(inputs.sample_file)
              config += "sample_file \"" + inputs.sample_file.path + "\"\n"
          return config
      }
         
- class: InlineJavascriptRequirement

inputs:
- id: vcf_file
  label: Variants file
  doc: VCF or BCF files can have two parts split by chromosome identifier.
  type: File[]
  sbg:category: Inputs
  sbg:fileTypes: VCF, VCF.GZ, BCF, BCF.GZ
- id: gds_file
  label: GDS File
  doc: GDS file produced by conversion.
  type: File
  sbg:category: Input
  sbg:fileTypes: gds
- id: sample_file
  label: Sample file
  doc: Sample file
  type: File?
  sbg:category: Inputs
- id: check_gds
  label: check GDS
  doc: |-
    Choose “Yes” to check for conversion errors by comparing all values in the output GDS file against the input files. The total cost of the job will be ~10x higher if check GDS is “Yes”.
  type:
  - 'null'
  - name: check_gds
    type: enum
    symbols:
    - Yes
    - No
  sbg:category: Inputs
  sbg:toolDefaultValue: No

outputs: []

baseCommand: []
arguments:
- prefix: ''
  position: 0
  valueFrom: |-
    ${
       
       function find_chromosome(file){
            var chr_array = []
            var chrom_num = file.split("/").pop()
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
       
       function isNumeric(s) {
            return !isNaN(s - parseFloat(s));
        }
       
       var chr = inputs.gds_file.path.split('chr')[1].split('.')[0];

       
       if(inputs.check_gds == 'Yes'){
        return "Rscript /usr/local/analysis_pipeline/R/check_gds.R check_gds.config " +"--chromosome " + chr}
        else{
             return 'echo Check GDS step skipped.'
        }
    }
  shellQuote: false
- prefix: ''
  position: 100
  valueFrom: ${return " >> job.out.log"}
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
id: boris_majic/genesis-toolkit-demo/check-gds/4
sbg:appVersion:
- v1.1
sbg:content_hash: a858c95ade17914a74f300bf521d8ce6fbb7a5978eb658abf2212dc1fd9e52b52
sbg:contributors:
- boris_majic
- dajana_panovic
sbg:createdBy: boris_majic
sbg:createdOn: 1577360376
sbg:id: h-be585466/h-af6252a8/h-ffcc9833/0
sbg:image_url:
sbg:latestRevision: 4
sbg:modifiedBy: dajana_panovic
sbg:modifiedOn: 1608904156
sbg:project: boris_majic/genesis-toolkit-demo
sbg:projectName: GENESIS Toolkit - DEMO
sbg:publisher: sbg
sbg:revision: 4
sbg:revisionNotes: CWLtool prep
sbg:revisionsInfo:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577360376
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577360446
  sbg:revision: 1
  sbg:revisionNotes: Import from F4C
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1594132857
  sbg:revision: 2
  sbg:revisionNotes: Docker image updated to 2.0.8
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602155815
  sbg:revision: 3
  sbg:revisionNotes: Import from BDC 2.8.1 version
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608904156
  sbg:revision: 4
  sbg:revisionNotes: CWLtool prep
sbg:sbgMaintained: false
sbg:validationErrors: []
