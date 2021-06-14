cwlVersion: v1.2
class: CommandLineTool
label: pca_corr
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: 4
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InitialWorkDirRequirement
  listing:
  - entryname: pca_corr.config
    writable: false
    entry: |-
      ${
          var config = ""
          if (inputs.gds_file.nameroot.includes('chr'))
          {
              var parts = inputs.gds_file.nameroot.split('chr')
              var outfile_temp = 'pca_corr_chr' + parts[1] + '.gds'
          } else {
              var outfile_temp = 'pca_corr.gds'
          }
          if(inputs.out_prefix){
              outfile_temp = inputs.out_prefix + '_' + outfile_temp
          }
          config += 'out_file "' + outfile_temp + '"\n'

          
        	if (inputs.n_pcs_corr) {
              config += "n_pcs " + inputs.n_pcs_corr + "\n"
        	}
          
          if (inputs.variant_include_file)
            config += "variant_include_file \"" + inputs.variant_include_file.path + "\"\n"
            
          if(inputs.gds_file)
              config += "gds_file \"" + inputs.gds_file.path + "\"\n"

          if(inputs.pca_file)
              config += "pca_file \"" + inputs.pca_file.path + "\"\n"
              
          return config
      }
- class: EnvVarRequirement
  envDef:
  - envName: NSLOTS
    envValue: ${ return runtime.cores }
- class: InlineJavascriptRequirement

inputs:
- id: gds_file
  label: GDS File
  doc: Input GDS file
  type: File
  sbg:category: Input Files
  sbg:fileTypes: GDS
- id: variant_include_file
  label: Variant include file
  doc: |-
    RData file with vector of variant.id to include. If not provided, all variants in the GDS file are included.
  type: File?
  sbg:category: Input Options
  sbg:fileTypes: RDATA
- id: pca_file
  label: PCA file
  doc: RData file with PCA results for unrelated samples
  type: File
  sbg:fileTypes: RDATA
- id: n_pcs_corr
  label: Number of PCs
  doc: Number of PCs (Principal Components) to use for PC-variant correlation
  type: int?
  default: 32
  sbg:category: Input Options
  sbg:toolDefaultValue: '32'
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
  sbg:category: Input Options
- id: chromosome
  label: Chromosome
  doc: Run on this chromosome only. 23=X, 24=Y
  type: int?
  inputBinding:
    prefix: --chromosome
    position: 3
    shellQuote: false
  sbg:category: Input Options

outputs:
- id: pca_corr_gds
  label: PC-SNP correlation
  doc: GDS file with PC-SNP correlation results
  type: File?
  outputBinding:
    glob: '*.gds'
  sbg:fileTypes: GDS
stdout: job.out.log

baseCommand:
- R -q --vanilla
arguments:
- prefix: --args
  position: 2
  valueFrom: pca_corr.config
  shellQuote: false
- prefix: <
  position: 4
  valueFrom: /usr/local/analysis_pipeline/R/pca_corr.R
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: pca_corr.config
- class: sbg:SaveLogs
  value: job.out.log
