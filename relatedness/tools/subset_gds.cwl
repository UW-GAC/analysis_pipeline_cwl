cwlVersion: v1.2
class: CommandLineTool
label: subset_gds
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InitialWorkDirRequirement
  listing:
  - entryname: subset_gds.config
    writable: false
    entry: |
      ${
          var config = "";
        	if (inputs.gds_file) 
        	{
        	    config += 'gds_file "' + inputs.gds_file.path  + "\"\n";
        	}
        	if (inputs.variant_include_file)
        	{
        	    config += 'variant_include_file "' + inputs.variant_include_file.path + "\"\n"
        	}
          
          if (inputs.sample_include_file) 
            config += "sample_include_file \"" + inputs.sample_include_file.path + "\"\n";
            
          if (inputs.out_prefix)
          {
              var chromosome = inputs.gds_file.nameroot.split('chr')[1].split('.')[0];
              config += 'subset_gds_file "' + inputs.out_prefix + '_chr' + chromosome + '.gds"\n';
          }
          else
          {
              var chromosome = inputs.gds_file.nameroot.split('chr')[1].split('.')[0]
              var basename = inputs.gds_file.nameroot.split('chr')[0]
              config += 'subset_gds_file "' + basename + 'subset_chr' + chromosome + '.gds"\n'
          }

          return config
      }
- class: InlineJavascriptRequirement

inputs:
- id: gds_file
  label: GDS file
  doc: Input GDS file.
  type: File
  sbg:category: Inputs
  sbg:fileTypes: GDS
- id: sample_include_file
  label: Sample include file
  doc: |-
    RData file with vector of sample.id to include. All samples in the GDS file are included when not provided.
  type: File?
  sbg:category: Inputs
  sbg:fileTypes: RDATA
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
- id: variant_include_file
  label: Variant include file
  doc: |-
    RData file with vector of variant.id to include. All variants in the GDS files are used when not provided.
  type: File
  sbg:category: Inputs
  sbg:fileTypes: RDATA

outputs:
- id: output
  label: Subset file
  doc: GDS file with subset of variants from original file
  type: File?
  outputBinding:
    glob: '*.gds'
  sbg:fileTypes: GDS
stdout: job.out.log

baseCommand:
- R -q --vanilla
arguments:
- prefix: <
  position: 2
  valueFrom: /usr/local/analysis_pipeline/R/subset_gds.R
  shellQuote: false
- prefix: --args
  position: 1
  valueFrom: subset_gds.config
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: subset_gds.config
