cwlVersion: v1.1
class: CommandLineTool
label: pca_corr_vars
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: pca_corr_vars.config
    writable: false
    entry: |-
      ${
          var config = ""
          //if (inputs.gds_file.nameroot.includes('chr'))
          //{
          //    var parts = inputs.gds_file.nameroot.split('chr')
          //    var outfile_temp = 'pca_corr_vars_chr' + parts[1] + '.RData'
          //} else {
          //    var outfile_temp = 'pca_corr_vars.RData'
          //}
          var outfile_temp = 'pca_corr_vars_chr .RData'
          if(inputs.out_prefix){
              outfile_temp = inputs.out_prefix + '_' + outfile_temp
          }
          config += 'out_file "' + outfile_temp + '"\n'

          
          if (inputs.variant_include_file)
            config += "variant_include_file \"" + inputs.variant_include_file.path + "\"\n"
            
          if(inputs.gds_file)
              config += "gds_file \"" + inputs.gds_file.path + "\"\n"

          config += "segment_file \"/usr/local/analysis_pipeline/segments_hg38.txt\"\n"

          return config
      }
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
    RData file with vector of variant.id to include. These variants will be added to the set of randomly selected variants. It is recommended to provide the set of pruned variants used for PCA.
  type:
  - 'null'
  - File
  sbg:category: Input Options
  sbg:fileTypes: RDATA
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type:
  - 'null'
  - string
  sbg:category: Input Options
- id: n_corr_vars
  label: Number of variants to select
  doc: |-
    Randomly select this number of variants distributed across the entire genome to use for PC-variant correlation. If running on a single chromosome, the variants returned will be scaled by the proportion of that chromosome in the genome.
  type:
  - 'null'
  - int
  sbg:category: Input Options
  sbg:toolDefaultValue: '10e6'
- id: chromosome
  label: Chromosome
  doc: Run on this chromosome only. 23=X, 24=Y
  type: int
  inputBinding:
    prefix: --chromosome
    position: 3
    shellQuote: false
  sbg:category: Input Options

outputs:
- id: pca_corr_vars
  label: Variants to use for PC correlation
  doc: |-
    RData file with a randomly selected set of variant.ids distributed across the genome, plus any variants from variant_include_file.
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*.RData'
  sbg:fileTypes: RDATA
stdout: job.out.log

baseCommand:
- R -q --vanilla
arguments:
- prefix: --args
  position: 2
  valueFrom: pca_corr_vars.config
  shellQuote: false
- prefix: <
  position: 4
  valueFrom: /usr/local/analysis_pipeline/R/pca_corr_vars.R
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: pca_corr_vars.config
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/pca-corr-vars/6/raw/
sbg:appVersion:
- v1.1
sbg:content_hash: a05d0a2f6cceb0e7893373293d17cfadfabfacc36410a0faa142ac0897564f297
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1608671560
sbg:id: smgogarten/genesis-relatedness/pca-corr-vars/6
sbg:image_url:
sbg:latestRevision: 6
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615936348
sbg:project: smgogarten/genesis-relatedness
sbg:projectName: GENESIS relatedness
sbg:publisher: sbg
sbg:revision: 6
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: (uncommitted file)
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608671560
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608672869
  sbg:revision: 1
  sbg:revisionNotes: tool for selecting variant for pc correlation
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608674522
  sbg:revision: 2
  sbg:revisionNotes: add newline in config, chromosome arg is required
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608681003
  sbg:revision: 3
  sbg:revisionNotes: need blank space for chromosome number
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609370853
  sbg:revision: 4
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609448724
  sbg:revision: 5
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615936348
  sbg:revision: 6
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
sbg:sbgMaintained: false
sbg:validationErrors: []
