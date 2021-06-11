cwlVersion: v1.2
class: CommandLineTool
label: merge_gds
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InitialWorkDirRequirement
  listing:
  - entryname: merge_gds.config
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
          
          var a_file = inputs.gds_file[0]
          var chr = find_chromosome(a_file.basename);
          var path = a_file.path.split('chr'+chr);

          var chr_array = [];
              var chrom_num;
              for (var i = 0; i < inputs.gds_file.length; i++) 
              {
                  chrom_num = find_chromosome(inputs.gds_file[i].nameroot)
                  
                  chr_array.push(chrom_num)
              }
              
              chr_array = chr_array.sort((a, b) => a.localeCompare(b, 'en', {numeric: true, ignorePunctuation: true}))
              
              var chrs = chr_array.join(' ')
          
          if(inputs.out_prefix)
          {
              var merged_gds_file_name = inputs.out_prefix + ".gds"
          }
          else
          {
              var merged_gds_file_name = "merged.gds"
          }
          var arguments = []
          arguments.push('gds_file ' + '"' + path[0].split('/').pop() + 'chr ' + path[1] + '"')
          arguments.push('merged_gds_file "' + merged_gds_file_name + '"')
          arguments.push('chromosomes "' + chrs + '"')
          
          return arguments.join('\n')
      }
- class: InlineJavascriptRequirement

inputs:
- id: gds_file
  label: GDS files
  doc: Input GDS files.
  type: File[]
  sbg:fileTypes: GDS
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files
  type: string?

outputs:
- id: merged_gds_output
  label: Merged GDS output file
  doc: GDS output file
  type: File?
  outputBinding:
    glob: '*.gds'
  sbg:fileTypes: GDS
stdout: job.out.log

baseCommand: []
arguments:
- prefix: <
  position: 10
  valueFrom: /usr/local/analysis_pipeline/R/merge_gds.R
  shellQuote: false
- prefix: ''
  position: 0
  valueFrom: |-
    ${
        var cmd_line = ""
        for (var i=0; i<inputs.gds_file.length; i++)
            cmd_line += "ln -s " + inputs.gds_file[i].path + " " + inputs.gds_file[i].basename + " && "
        
        return cmd_line
    }
  shellQuote: false
- prefix: --args
  position: 1
  valueFrom: merge_gds.config
  shellQuote: false
- prefix: ''
  position: 0
  valueFrom: R -q --vanilla
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: merge_gds.config
- class: sbg:SaveLogs
  value: job.out.log
