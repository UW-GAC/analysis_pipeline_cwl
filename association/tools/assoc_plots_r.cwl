cwlVersion: v1.1
class: CommandLineTool
label: assoc_plots.R
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: 1
  ramMin: 64000
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: assoc_file.config
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
          
          var arguments = [];
          arguments.push('out_prefix "assoc_single"');
          var a_file = [].concat(inputs.assoc_files)[0];
          var chr = find_chromosome(a_file.basename);
          var path = a_file.path.split('chr'+chr);
          var extension = path[1].split('.')[1];
          
           
          if(inputs.plots_prefix){
              arguments.push('plots_prefix ' + inputs.plots_prefix);
              arguments.push('out_file_manh ' + inputs.plots_prefix + '_manh.png');
              arguments.push('out_file_qq ' + inputs.plots_prefix + '_qq.png');
          }
          else{
              var data_prefix = path[0].split('/').pop();
              arguments.push('out_file_manh ' + data_prefix + 'manh.png');
              arguments.push('out_file_qq ' + data_prefix + 'qq.png');
              arguments.push('plots_prefix "plots"')
          }
          if(inputs.assoc_type){
              arguments.push('assoc_type ' + inputs.assoc_type)
          }
          
          arguments.push('assoc_file ' + '"' + path[0].split('/').pop() + 'chr ' +path[1] + '"')

          if(inputs.chromosomes){
              arguments.push('chromosomes "' + inputs.chromosomes + '"')
          }
          else {
              var chr_array = [];
              var chrom_num;
              for (var i = 0; i < inputs.assoc_files.length; i++) 
              {
                  chrom_num = inputs.assoc_files[i].path.split("/").pop()
                  chrom_num = find_chromosome(chrom_num)
                  
                  chr_array.push(chrom_num)
              }
              
              chr_array = chr_array.sort((a, b) => a.localeCompare(b, 'en', {numeric: true, ignorePunctuation: true}))
              
              chrs = ""
              for (var i = 0; i < chr_array.length; i++) 
              {
                  chrs += chr_array[i] + " "
              }
              arguments.push('chromosomes "' + chrs + '"')
          }
          if(inputs.disable_thin){
              arguments.push('thin FALSE')
          }
          if(inputs.thin_npoints)
              arguments.push('thin_npoints ' + inputs.thin_npoints)
          if(inputs.thin_npoints)
              arguments.push('thin_nbins ' + inputs.thin_nbins)
          if(inputs.known_hits_file)
              arguments.push('known_hits_file "' + inputs.known_hits_file.path + '"')
          if(inputs.plot_mac_threshold)
              arguments.push('plot_mac_threshold ' + inputs.plot_mac_threshold)  
          if(inputs.truncate_pval_threshold)
              arguments.push('truncate_pval_threshold ' + inputs.truncate_pval_threshold)    
              
          arguments.push('\n')
          return arguments.join('\n')
      }
- class: InlineJavascriptRequirement

inputs:
- id: assoc_files
  label: Association File
  doc: Association File.
  type: File[]
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: assoc_type
  label: Association Type
  doc: 'Type of association test: single, window or aggregate'
  type:
  - 'null'
  - name: assoc_type
    type: enum
    symbols:
    - single
    - window
    - aggregate
  sbg:category: Input options
- id: chromosomes
  label: Chromosomes
  doc: |-
    List of chromosomes. If not provided, in case of multiple files, it will be automatically generated with assumtion that files are in format *chr*.RData
    Example: 1 2 3
  type: string?
  sbg:category: Input options
  sbg:toolDefaultValue: 1-23
- id: plots_prefix
  label: Plots prefix
  doc: Prefix for plot files.
  type: string?
  sbg:category: Input Options
  sbg:toolDefaultValue: plots
- id: disable_thin
  label: Disable Thin
  doc: |-
    Logical for whether to thin points in the PC-variant correlation plots. By default, thin is set to TRUE. This parameter disables it.
  type: boolean?
  sbg:category: Input Options
- id: known_hits_file
  label: Known hits file
  doc: |-
    RData file with data.frame containing columns chr and pos. If provided, 1 Mb regions surrounding each variant listed will be omitted from the QQ and manhattan plots.
  type: File?
  sbg:category: Inputs
  sbg:fileTypes: RData, RDATA
- id: thin_npoints
  label: Thin N points
  doc: 'Number of points in each bin after thinning. Default: 10000'
  type: int?
  sbg:category: General
  sbg:toolDefaultValue: '10000'
- id: thin_nbins
  label: Thin N bins
  doc: 'Number of bins to use for thinning. Default: 10.'
  type: int?
  sbg:category: General
  sbg:toolDefaultValue: '10'
- id: plot_mac_threshold
  label: Plot MAC threshold
  doc: Plot MAC threshold.
  type: int?
- id: truncate_pval_threshold
  label: Truncate pval threshold
  doc: Truncate pval threshold.
  type: float?

outputs:
- id: assoc_plots
  label: Assoc plots
  doc: QQ and Manhattan Plots generated by assoc_plots.R script.
  type: File[]?
  outputBinding:
    glob: '*.png'
  sbg:fileTypes: PNG
- id: configs
  label: Config files
  doc: Config files.
  type: File[]?
  outputBinding:
    glob: '*config*'
  sbg:fileTypes: CONFIG

baseCommand: []
arguments:
- prefix: ''
  position: 5
  valueFrom: assoc_file.config
  shellQuote: false
- prefix: ''
  position: 3
  valueFrom: Rscript /usr/local/analysis_pipeline/R/assoc_plots.R
  shellQuote: false
- prefix: ''
  position: 1
  valueFrom: |-
    ${
        command = ''
        for(i=0; i<inputs.assoc_files.length; i++)
            command += "ln -s " + inputs.assoc_files[i].path + " " + inputs.assoc_files[i].path.split("/").pop() + " && "
        
        return command
    }
  shellQuote: false
- prefix: ''
  position: 100
  valueFrom: "${\n    return ' >> job.out.log'\n}"
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
id: boris_majic/genesis-toolkit-demo/assoc-plots-r/5
sbg:appVersion:
- v1.1
sbg:content_hash: a88a973d29b9bf06e179018bd00c127ebb7d1eaf1d86bccef388393bbe02fe20f
sbg:contributors:
- dajana_panovic
- boris_majic
sbg:createdBy: boris_majic
sbg:createdOn: 1577360892
sbg:id: h-4aeade4f/h-7032cf44/h-a97c42ec/0
sbg:image_url:
sbg:latestRevision: 5
sbg:modifiedBy: dajana_panovic
sbg:modifiedOn: 1603797944
sbg:project: boris_majic/genesis-toolkit-demo
sbg:projectName: GENESIS Toolkit - DEMO
sbg:publisher: sbg
sbg:revision: 5
sbg:revisionNotes: BDC import
sbg:revisionsInfo:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577360892
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577360921
  sbg:revision: 1
  sbg:revisionNotes: Import from F4C
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584373539
  sbg:revision: 2
  sbg:revisionNotes: GDS filename correction
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1594133277
  sbg:revision: 3
  sbg:revisionNotes: Docker image update to 2.8.0
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602155455
  sbg:revision: 4
  sbg:revisionNotes: Import from BDC 2.8.1 version
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603797944
  sbg:revision: 5
  sbg:revisionNotes: BDC import
sbg:sbgMaintained: false
sbg:validationErrors: []
