cwlVersion: v1.1
class: CommandLineTool
label: pca_corr_plots
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: pca_corr_plots.config
    writable: false
    entry: |-
      ${ 
          function isNumeric(s) {
              return !isNaN(s - parseFloat(s))
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
          
          var a_file = inputs.corr_file[0]
          var chr = find_chromosome(a_file.basename);
          var path = a_file.path.split('chr'+chr);

          var chr_array = [];
          var chrom_num;
          for (var i = 0; i < inputs.corr_file.length; i++) 
          {
              chrom_num = find_chromosome(inputs.corr_file[i].nameroot)
                  
              chr_array.push(chrom_num)
          }
              
          chr_array = chr_array.sort((a, b) => a.localeCompare(b, 'en', {numeric: true, ignorePunctuation: true}))
              
          var chrs = chr_array.join(' ')
          
          var arguments = []
          arguments.push('corr_file ' + '"' + path[0].split('/').pop() + 'chr ' + path[1] + '"')
          arguments.push('chromosomes "' + chrs + '"')
          
          arguments.push('n_pcs ' + inputs.n_pcs_plot)
          arguments.push('n_perpage ' + inputs.n_perpage)
          
          if(inputs.out_prefix) {
              arguments.push('out_prefix "' + inputs.out_prefix + '"')
          }
          
          arguments.push('\n')
          return arguments.join('\n')
      }
- class: InlineJavascriptRequirement

inputs:
- id: n_pcs_plot
  label: Number of PCs to plot
  doc: Number of PCs to plot.
  type:
  - 'null'
  - int
  default: 20
  sbg:category: Input Options
  sbg:toolDefaultValue: '20'
- id: corr_file
  label: PC correlation file
  doc: PC correlation file
  type:
    type: array
    items: File
  sbg:category: Input File
  sbg:fileTypes: GDS
- id: n_perpage
  label: Number of plots per page
  doc: |-
    Number of PC-variant correlation plots to stack in a single page. The number of png files generated will be ceiling(n_pcs_plot/n_perpage).
  type:
  - 'null'
  - int
  default: 4
  sbg:category: Input Options
  sbg:toolDefaultValue: '4'
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type:
  - 'null'
  - string
  sbg:category: Input Options
  sbg:toolDefaultValue: pca_corr

outputs:
- id: pca_corr_plots
  label: PC-variant correlation plots
  doc: PC-variant correlation plots
  type:
  - 'null'
  - type: array
    items: File
  outputBinding:
    glob: '*.png'
  sbg:fileTypes: PNG
stdout: job.out.log

baseCommand: []
arguments:
- prefix: <
  position: 3
  valueFrom: /usr/local/analysis_pipeline/R/pca_corr_plots.R
  shellQuote: false
- prefix: ''
  position: 0
  valueFrom: |-
    ${
        var cmd_line = ""
        for (var i=0; i<inputs.corr_file.length; i++)
            cmd_line += "ln -s " + inputs.corr_file[i].path + " " + inputs.corr_file[i].basename + " && "
        
        return cmd_line
    }
  shellQuote: false
- prefix: --args
  position: 2
  valueFrom: pca_corr_plots.config
  shellQuote: false
- prefix: ''
  position: 1
  valueFrom: R -q --vanilla
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: pca_corr_plots.config
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/pca-corr-plots/9/raw/
sbg:appVersion:
- v1.1
sbg:content_hash: ad8c42ab0717ada2380237dd4b05b4c5976e35f0134387f0ed17c01d9462086ce
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1604988665
sbg:id: smgogarten/genesis-relatedness/pca-corr-plots/9
sbg:image_url:
sbg:latestRevision: 9
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615936369
sbg:project: smgogarten/genesis-relatedness
sbg:projectName: GENESIS relatedness
sbg:publisher: sbg
sbg:revision: 9
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: (uncommitted file)
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1604988665
  sbg:revision: 0
  sbg:revisionNotes: Copy of boris_majic/topmed-optimization/pca-corr-plots/0
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605730277
  sbg:revision: 1
  sbg:revisionNotes: initial update
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605765307
  sbg:revision: 2
  sbg:revisionNotes: copy config javascript from assoc_plots tool
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606334463
  sbg:revision: 3
  sbg:revisionNotes: update javascript for config file
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606340439
  sbg:revision: 4
  sbg:revisionNotes: fix filenames in config
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606355355
  sbg:revision: 5
  sbg:revisionNotes: update input and output labels
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606780666
  sbg:revision: 6
  sbg:revisionNotes: use basename instead of path.split
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609370845
  sbg:revision: 7
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609448682
  sbg:revision: 8
  sbg:revisionNotes: upate descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615936369
  sbg:revision: 9
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
sbg:sbgMaintained: false
sbg:validationErrors: []
