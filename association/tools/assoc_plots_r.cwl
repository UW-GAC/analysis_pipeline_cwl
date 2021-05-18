cwlVersion: v1.1
class: CommandLineTool
label: GENESIS Association Results Plotting
doc: |-
  ### Description

  The UW-GAC Assoc_plots standalone app creates Manhattan and QQ plots from GENESIS association test results with additional filtering and stratification options available. This app is run automatically with default options set by the GENESIS Association Testing Workflows. Users can fine-tune the Manhattan and QQ plots by running this app separately, after one of the association testing workflows. The available options are:
   - Create QQ plots by chromosome.
   - Include a user-specified subset of the results in the plots.
   - Filter results to only those with MAC or MAF greater than a specified threshold.
   - Calculate genomic inflation lambda at various quantiles.
   - Specify the significance type and level.
   - Create QQ plots stratified by MAC or MAF.
   - Specify a maximum p-value to display on the plots.
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: 1
  ramMin: 64000
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
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
          
          var argument = [];
          argument.push('out_prefix "assoc_single"');
          var a_file = [].concat(inputs.assoc_files)[0];
          var chr = find_chromosome(a_file.basename);
          var path = a_file.path.split('chr'+chr);
          var extension = path[1].split('.')[1];
          
           
          if(inputs.plots_prefix){
              argument.push('plots_prefix ' + inputs.plots_prefix);
              argument.push('out_file_manh ' + inputs.plots_prefix + '_manh.png');
              argument.push('out_file_qq ' + inputs.plots_prefix + '_qq.png');
          }
          else{
              var data_prefix = path[0].split('/').pop();
              argument.push('out_file_manh ' + data_prefix + 'manh.png');
              argument.push('out_file_qq ' + data_prefix + 'qq.png');
              argument.push('plots_prefix "plots"')
          }
          if(inputs.assoc_type){
              argument.push('assoc_type ' + inputs.assoc_type)
          }
          
          argument.push('assoc_file ' + '"' + path[0].split('/').pop() + 'chr ' +path[1] + '"')

          if(inputs.chromosomes){
              argument.push('chromosomes "' + inputs.chromosomes + '"')
          }
          else {
              var chr_array = [];
              var chrom_num;
              var i;
              for (var i = 0; i < inputs.assoc_files.length; i++) 
              {
                  chrom_num = inputs.assoc_files[i].path.split("/").pop()
                  chrom_num = find_chromosome(chrom_num)
                  
                  chr_array.push(chrom_num)
              }
              
              chr_array = chr_array.sort(function(a, b) { a.localeCompare(b, 'en', {numeric: true, ignorePunctuation: true})})
              
              var chrs = "";
              for (var i = 0; i < chr_array.length; i++) 
              {
                  chrs += chr_array[i] + " "
              }
              argument.push('chromosomes "' + chrs + '"')
          }
          if(inputs.disable_thin){
              argument.push('thin FALSE')
          }
          if(inputs.thin_npoints)
              argument.push('thin_npoints ' + inputs.thin_npoints)
          if(inputs.thin_npoints)
              argument.push('thin_nbins ' + inputs.thin_nbins)
          if(inputs.known_hits_file)
              argument.push('known_hits_file "' + inputs.known_hits_file.path + '"')
          if(inputs.plot_mac_threshold)
              argument.push('plot_mac_threshold ' + inputs.plot_mac_threshold)  
          if(inputs.truncate_pval_threshold)
              argument.push('truncate_pval_threshold ' + inputs.truncate_pval_threshold)    
          if(inputs.plot_qq_by_chrom){
              argument.push('plot_qq_by_chrom ' + inputs.plot_qq_by_chrom)
          }
          if(inputs.plot_include_file){
              argument.push('plot_include_file ' + '"'+ inputs.plot_include_file.path + '"')
          }
          if(inputs.signif_type){
              argument.push('signif_type ' + inputs.signif_type)
          }    
          if(inputs.signif_line_fixed){
              argument.push('signif_line_fixed ' + inputs.signif_line_fixed)
          } 
          if(inputs.qq_mac_bins){
              argument.push('qq_mac_bins ' + inputs.qq_mac_bins)
          }
          if(inputs.qq_maf_bins){
              argument.push('qq_maf_bins ' + inputs.qq_maf_bins)
          }    
          if(inputs.lambda_quantiles){
              argument.push('lambda_quantiles ' + inputs.lambda_quantiles)
          }    
          if(inputs.out_file_lambdas){
              argument.push('out_file_lambdas ' + inputs.out_file_lambdas)
          } 
          if(inputs.plot_max_p){
              argument.push('plot_max_p ' + inputs.plot_max_p)
          } 
          if(inputs.plot_maf_threshold){
              argument.push('plot_maf_threshold ' + inputs.plot_maf_threshold)
          }
              
              
          argument.push('\n')
          return argument.join('\n')
      }
- class: InlineJavascriptRequirement

inputs:
- id: assoc_files
  label: Results from association testing
  doc: Rdata files. Results from association testing workflow.
  type: File[]
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: assoc_type
  label: Association Type
  doc: 'Type of association test: single, window or aggregate'
  type:
    name: assoc_type
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
  doc: Prefix for output files.
  type: string?
  sbg:category: Input Options
  sbg:toolDefaultValue: plots
- id: disable_thin
  label: Disable Thin
  doc: |-
    Logical for whether to thin points in the QQ and Manhattan plots. By default, points are thinned in dense regions to reduce plotting time. If this parameter is set to TRUE, all variant p-values will be included in the plots, and the plotting will be very long and memory intensive.
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
  label: Number of points in each bin after thinning
  doc: Number of points in each bin after thinning.
  type: int?
  sbg:category: General
  sbg:toolDefaultValue: '10000'
- id: thin_nbins
  label: Thin N binsNumber of bins to use for thinning
  doc: Number of bins to use for thinning.
  type: int?
  sbg:category: General
  sbg:toolDefaultValue: '10'
- id: plot_mac_threshold
  label: Plot MAC threshold
  doc: |-
    Minimum minor allele count for variants or Minimum cumulative minor allele count for aggregate units to include in plots (if different from threshold used to run tests; see `mac_threshold`).
  type: int?
- id: truncate_pval_threshold
  label: Truncate pval threshold
  doc: Truncate pval threshold.
  type: float?
- id: plot_qq_by_chrom
  label: Logical indicator for whether to generate QQ plots faceted by chromosome
  doc: Logical indicator for whether to generate QQ plots faceted by chromosome.
  type: boolean?
  sbg:toolDefaultValue: 'FALSE'
- id: plot_include_file
  label: RData file with vector of ids to include
  doc: |-
    RData file with vector of ids to include. See `TopmedPipeline::assocFilterByFile` for format requirements.
  type: File?
  sbg:fileTypes: RDATA
- id: signif_type
  label: |-
    Character string for how to calculate the significance threshold. Default is `fixed` for single variant analysis and `bonferroni` for other analysis types.
  doc: |-
    `fixed`, `bonferroni`, or `none`; character string for how to calculate the significance threshold. Default is `fixed` for single variant analysis and `bonferroni` for other analysis types.
  type:
  - 'null'
  - name: signif_type
    type: enum
    symbols:
    - fixed
    - bonferroni
    - none
- id: signif_line_fixed
  label: P-value for the significance line. Only used if `signif_type = fixed`
  doc: P-value for the significance line. Only used if `signif_type = fixed`.
  type: float?
  sbg:toolDefaultValue: '5e-9'
- id: qq_mac_bins
  label: |-
    Space separated string of integers (e.g., `"5 20 50"`). If set, generate a QQ plot binned by the specified MAC thresholds. 0 and Infinity will automatically be added.
  doc: |-
    Space separated string of integers (e.g., `"5 20 50"`). If set, generate a QQ plot binned by the specified MAC thresholds. 0 and Infinity will automatically be added.
  type: string?
- id: qq_maf_bins
  label: |-
    Space separated string of minor allele frequencies (e.g., "0.01 0.05 0.1"). If set, generate a QQ plot binned by the specified minor allele frequencies. 0 and Infinity will automatically be added. Single variant tests only.
  doc: |-
    Space separated string of minor allele frequencies (e.g., "0.01 0.05 0.1"). If set, generate a QQ plot binned by the specified minor allele frequencies. 0 and Infinity will automatically be added. Single variant tests only.
  type: string?
- id: lambda_quantiles
  label: |-
    Space separated string of quantiles at which to calculate lambda (e.g., “0.25 0.5 0.75”). If set, create a text file with lambda calculated at the specified quantiles stored in `out_file_lambdas`.
  doc: |-
    Space separated string of quantiles at which to calculate genomic inflation lambda (e.g., “0.25 0.5 0.75”). If set, create a text file with lambda calculated at the specified quantiles stored in `out_file_lambdas`.
  type: string?
- id: out_file_lambdas
  label: File name of file to store lambda calculated at different quantiles
  doc: |-
    File name of file to store lambda calculated at different quantiles. The default is `lambda.txt`.
  type: string?
  sbg:toolDefaultValue: lambda.txt
- id: plot_max_p
  label: |-
    Maximum p-value to plot in QQ and Manhattan plots. Expected QQ values are still calculated using the full set of p-values.
  doc: |-
    Maximum p-value to plot in QQ and Manhattan plots. Expected QQ values are still calculated using the full set of p-values.
  type: float?
  sbg:toolDefaultValue: '1'
- id: plot_maf_threshold
  label: |-
    Minimum minor allele frequency for variants to include in plots. Ignored if `plot_mac_threshold` is specified. Single variant association tests only.
  doc: |-
    Minimum minor allele frequency for variants to include in plots. Ignored if `plot_mac_threshold` is specified. Single variant association tests only.
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
- id: Lambdas
  label: File to store lambda calculated at different quantiles
  doc: File to store lambda calculated at different quantiles.
  type: File?
  outputBinding:
    glob: '*.txt'
  sbg:fileTypes: TXT

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
        var command = '';
        var i;
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
id: boris_majic/genesis-toolkit-demo/assoc-plots-r/10
sbg:appVersion:
- v1.1
sbg:content_hash: a5d8dc74db1119dc51408377c30dcdd5c785f05ca28302d3bd25ba23f291d750c
sbg:contributors:
- dajana_panovic
- boris_majic
sbg:createdBy: boris_majic
sbg:createdOn: 1577360892
sbg:id: h-aa8e9be2/h-7b6ceace/h-b4797dc6/0
sbg:image_url:
sbg:latestRevision: 10
sbg:modifiedBy: dajana_panovic
sbg:modifiedOn: 1617267791
sbg:project: boris_majic/genesis-toolkit-demo
sbg:projectName: GENESIS Toolkit - DEMO
sbg:publisher: sbg
sbg:revision: 10
sbg:revisionNotes: Name update
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
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608907158
  sbg:revision: 6
  sbg:revisionNotes: CWLtool prep
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1616077280
  sbg:revision: 7
  sbg:revisionNotes: Docker updated to uwgac/topmed-master:2.10.0
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1616144891
  sbg:revision: 8
  sbg:revisionNotes: Input descriptions updated
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1617264622
  sbg:revision: 9
  sbg:revisionNotes: Description updated
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1617267791
  sbg:revision: 10
  sbg:revisionNotes: Name update
sbg:sbgMaintained: false
sbg:validationErrors: []
