cwlVersion: v1.1
class: CommandLineTool
label: merge_gds
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
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
  type:
    type: array
    items: File
  sbg:fileTypes: GDS
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files
  type:
  - 'null'
  - string

outputs:
- id: merged_gds_output
  label: Merged GDS output file
  doc: GDS output file
  type:
  - 'null'
  - File
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
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/merge-gds/8/raw/
sbg:appVersion:
- v1.1
sbg:content_hash: a08d83747a5fe576d67da9f7e1b21b757d492e81e487ef7926205b660e68f3452
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1601921548
sbg:id: smgogarten/genesis-relatedness/merge-gds/8
sbg:image_url:
sbg:latestRevision: 8
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615931960
sbg:project: smgogarten/genesis-relatedness
sbg:projectName: GENESIS relatedness
sbg:publisher: sbg
sbg:revision: 8
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: (uncommitted file)
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1601921548
  sbg:revision: 0
  sbg:revisionNotes: Copy of boris_majic/topmed-optimization/merge-gds/6
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606255644
  sbg:revision: 1
  sbg:revisionNotes: update merge_gds
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606268200
  sbg:revision: 2
  sbg:revisionNotes: set test values
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606332248
  sbg:revision: 3
  sbg:revisionNotes: update file type
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606335066
  sbg:revision: 4
  sbg:revisionNotes: update test values
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606337758
  sbg:revision: 5
  sbg:revisionNotes: fix filename parsing in config
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606780719
  sbg:revision: 6
  sbg:revisionNotes: use basename instead of path.split
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615931575
  sbg:revision: 7
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615931960
  sbg:revision: 8
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
sbg:sbgMaintained: false
sbg:validationErrors: []
