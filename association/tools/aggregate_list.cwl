cwlVersion: v1.1
class: CommandLineTool
label: aggregate_list
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: aggregate_list.config
    writable: false
    entry: |-
      ${
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("/").pop();
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
          
          function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          
          var arguments = [];
          
          
          if (inputs.variant_group_file.basename.includes('chr'))
          {   
              var chr = find_chromosome(inputs.variant_group_file.path);
              var chromosomes_basename = inputs.variant_group_file.path.slice(0,-6).replace(/\/.+\//g,"");
              
              for(i = chromosomes_basename.length - 1; i > 0; i--)
                  if(chromosomes_basename[i] != 'X' && chromosomes_basename[i] != "Y" && isNaN(chromosomes_basename[i]))
                      break
              chromosomes_basename = inputs.variant_group_file.basename.split('chr'+chr)[0]+"chr "+ inputs.variant_group_file.basename.split('chr'+chr)[1]
              
              arguments.push('variant_group_file "' + chromosomes_basename + '"')
          }
          else
          {
              arguments.push('variant_group_file "' + inputs.variant_group_file.basename + '"')
          }
          
          if(inputs.out_file)
              if (inputs.variant_group_file.basename.includes('chr')){
                  
                  arguments.push('out_file "' + inputs.out_file + ' .RData"')}
              else
                  arguments.push('out_file "' + inputs.out_file + '.RData"')
          else
          {
              if (inputs.variant_group_file.basename.includes('chr'))
                  arguments.push('out_file "aggregate_list_chr .RData"')
              else
                  arguments.push('out_file aggregate_list.RData')
          }
              

          if(inputs.aggregate_type)
              arguments.push('aggregate_type "' + inputs.aggregate_type + '"')
          
          if(inputs.group_id)
              arguments.push('group_id "' + inputs.group_id + '"')
          
          return arguments.join('\n') + '\n'

      }
- class: InlineJavascriptRequirement

inputs:
- id: variant_group_file
  label: Variant group file
  doc: |-
    RData file with data frame defining aggregate groups. If aggregate_type is allele, columns should be group_id, chromosome, position, ref, alt. If aggregate_type is position, columns should be group_id, chromosome, start, end.
  type: File
  sbg:category: Input File
  sbg:fileTypes: RDATA
- id: aggregate_type
  label: Aggregate type
  doc: |-
    Type of aggregate grouping. Options are to select variants by allele (unique variants) or position (regions of interest). Default is allele.
  type:
  - 'null'
  - name: aggregate_type
    type: enum
    symbols:
    - position
    - allele
  sbg:category: Input Options
  sbg:toolDefaultValue: allele
- id: out_file
  label: Out file
  doc: Out file.
  type: string?
  sbg:toolDefaultValue: aggregate_list.RData
- id: group_id
  label: Group ID
  doc: Alternate name for group_id column.
  type: string?
  sbg:category: General
  sbg:toolDefaultValue: group_id

outputs:
- id: aggregate_list
  label: Aggregate list
  type: File?
  outputBinding:
    glob: |-
      ${
          if (!inputs.variant_group_file.basename.includes('chr'))
          {
              return '*RData'
          }
        if (!inputs.out_file) {
          comm = "aggregate_list*.RData"
        } else {
          	comm = inputs.out_file + ".RData"
        }
        return comm
      }
  sbg:fileTypes: RDATA
- id: config_file
  label: Config file
  type: File?
  outputBinding:
    glob: '*.config'
  sbg:fileTypes: CONFIG

baseCommand: []
arguments:
- prefix: ''
  position: 0
  valueFrom: |-
    ${
        if (inputs.variant_group_file)
        {
            cmd_line = "cp " + inputs.variant_group_file.path + " " + inputs.variant_group_file.basename
        
            return cmd_line
        }
        else
        {
            return "echo variant group file not provided"
        }
    }
  shellQuote: false
- prefix: ''
  position: 0
  valueFrom: |-
    ${
        cmd_line = "";
        if (inputs.variant_group_file)
        {
            cmd_line = "&& Rscript /usr/local/analysis_pipeline/R/aggregate_list.R aggregate_list.config "
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
        
        function isNumeric(s) {
            return !isNaN(s - parseFloat(s));
        }
        
        if (inputs.variant_group_file.basename.includes('chr'))
        {
    	    chromosome = find_chromosome(inputs.variant_group_file.path)
            cmd_line += "--chromosome " + chromosome 
            return cmd_line
        }
        return ''
        
        
    }
  shellQuote: false
- prefix: ''
  position: 100
  valueFrom: "${\n    return ' >> job.out.log'\n}"
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
id: boris_majic/genesis-toolkit-demo/aggregate-list/4
sbg:appVersion:
- v1.1
sbg:content_hash: a69fe7f64e607824bcce08036f9f626ea9f64d3c1b12dd0f46accc5e450e28b28
sbg:contributors:
- dajana_panovic
- boris_majic
sbg:createdBy: boris_majic
sbg:createdOn: 1577360995
sbg:id: h-2ea8af7b/h-bae3dbed/h-3e2358c1/0
sbg:image_url:
sbg:latestRevision: 4
sbg:modifiedBy: dajana_panovic
sbg:modifiedOn: 1602155556
sbg:project: boris_majic/genesis-toolkit-demo
sbg:projectName: GENESIS Toolkit - DEMO
sbg:publisher: sbg
sbg:revision: 4
sbg:revisionNotes: Import from BDC 2.8.1 version
sbg:revisionsInfo:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577360995
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577361017
  sbg:revision: 1
  sbg:revisionNotes: Import from F4C
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584373405
  sbg:revision: 2
  sbg:revisionNotes: GDS filename corrected
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1594133165
  sbg:revision: 3
  sbg:revisionNotes: Docker image update to 2.8.0
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602155556
  sbg:revision: 4
  sbg:revisionNotes: Import from BDC 2.8.1 version
sbg:sbgMaintained: false
sbg:validationErrors: []
