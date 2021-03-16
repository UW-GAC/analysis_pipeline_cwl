cwlVersion: v1.1
class: CommandLineTool
label: ld_pruning
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: ld_pruning.config
    writable: false
    entry: |-
      ${

          var cmd_line = ""
          
          if(inputs.gds_file)
              cmd_line += "gds_file \"" + inputs.gds_file.path + "\"\n"
          if(inputs.exclude_pca_corr)
              cmd_line += "exclude_pca_corr " + inputs.exclude_pca_corr + "\n"
          if(inputs.genome_build)
              cmd_line += "genome_build \"" + inputs.genome_build + "\"\n"
          if(inputs.ld_r_threshold)
              cmd_line += "ld_r_threshold " + inputs.ld_r_threshold + "\n"
          if(inputs.ld_win_size)
              cmd_line += "ld_win_size " + inputs.ld_win_size + "\n"
          if(inputs.maf_threshold)
              cmd_line += "maf_threshold " + inputs.maf_threshold + "\n"
          if(inputs.missing_threshold)
              cmd_line += "missing_threshold " + inputs.missing_threshold + "\n"
          
          if(inputs.sample_include_file)
              cmd_line += "sample_include_file \"" + inputs.sample_include_file.path + "\"\n"
              
              
              
          if(inputs.variant_include_file){
              cmd_line += "variant_include_file \"" + inputs.variant_include_file.path + "\"\n"
              //var chr = inputs.variant_include_file.path.split('/').pop()
              //cmd_line += 'out_file "' + outfile_temp + '_' + chr + '"\n'
          }
          if (inputs.gds_file.nameroot.includes('chr'))
          {
              var parts = inputs.gds_file.nameroot.split('chr')
              var outfile_temp = 'pruned_variants_chr' + parts[1] + '.RData'
          } else {
              var outfile_temp = 'pruned_variants.RData'
          }
          if(inputs.out_prefix){
              outfile_temp = inputs.out_prefix + '_' + outfile_temp
          }
          
          cmd_line += 'out_file "' + outfile_temp + '"\n'
              
          return cmd_line
      }
- class: InlineJavascriptRequirement

inputs:
- id: gds_file
  label: GDS file
  doc: Input GDS file.
  type: File
  sbg:category: Input files
  sbg:fileTypes: GDS
- id: ld_r_threshold
  label: LD |r| threshold
  doc: '|r| threshold for LD pruning.'
  type:
  - 'null'
  - float
  sbg:category: Input Options
  sbg:toolDefaultValue: 0.32 (r^2 = 0.1)
- id: ld_win_size
  label: LD window size
  doc: Sliding window size in Mb for LD pruning.
  type:
  - 'null'
  - float
  sbg:category: Input options
  sbg:toolDefaultValue: '10'
- id: maf_threshold
  label: MAF threshold
  doc: |-
    Minimum MAF for variants used in LD pruning. Variants below this threshold are removed.
  type:
  - 'null'
  - float
  sbg:category: Input options
  sbg:toolDefaultValue: '0.01'
- id: missing_threshold
  label: Missing call rate threshold
  doc: |-
    Maximum missing call rate for variants used in LD pruning. Variants above this threshold are removed.
  type:
  - 'null'
  - float
  sbg:category: Input options
  sbg:toolDefaultValue: '0.01'
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type:
  - 'null'
  - string
  sbg:category: Input Options
- id: sample_include_file
  label: Sample Include file
  doc: |-
    RData file with vector of sample.id to include. If not provided, all samples in the GDS file are included.
  type:
  - 'null'
  - File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: variant_include_file
  label: Variant Include file
  doc: |-
    RData file with vector of variant.id to consider for LD pruning. If not provided, all variants in the GDS file are included.
  type:
  - 'null'
  - File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: exclude_pca_corr
  label: Exclude PCA corr
  doc: |-
    Exclude variants in genomic regions known to result in high PC-variant correlations when included (HLA, LCT, inversions).
  type:
  - 'null'
  - boolean
  sbg:category: Input options
  sbg:toolDefaultValue: 'true'
- id: genome_build
  label: Genome build
  doc: |-
    Genome build, used to define genomic regions to filter for PC-variant correlation.
  type:
  - 'null'
  - name: genome_build
    type: enum
    symbols:
    - hg18
    - hg19
    - hg38
  default: hg38
  sbg:category: Input Options
  sbg:toolDefaultValue: hg38
- id: chromosome
  label: Chromosome
  doc: Chromosome range of gds file (1-24 or X,Y).
  type:
  - 'null'
  - string
  inputBinding:
    prefix: --chromosome
    position: 20
    shellQuote: false
  sbg:category: Input Options

outputs:
- id: ld_pruning_output
  label: Pruned output file
  doc: RData file with variant.id of pruned variants.
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
  valueFrom: ld_pruning.config
  shellQuote: false
- prefix: <
  position: 1
  valueFrom: /usr/local/analysis_pipeline/R/ld_pruning.R
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: ld_pruning.config
- class: sbg:SaveLogs
  value: job.out.log
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/ld-pruning/9/raw/
sbg:appVersion:
- v1.1
sbg:content_hash: ac8a7a3f89600a672b6bfccee670eb30dd01ab56001c4ce5d51bcf025e75caf5c
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1601921404
sbg:id: smgogarten/genesis-relatedness/ld-pruning/9
sbg:image_url:
sbg:latestRevision: 9
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615931959
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
  sbg:modifiedOn: 1601921404
  sbg:revision: 0
  sbg:revisionNotes: Copy of boris_majic/topmed-optimization/ld-pruning/8
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606254528
  sbg:revision: 1
  sbg:revisionNotes: revise ld pruning
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606257249
  sbg:revision: 2
  sbg:revisionNotes: revise output file names
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1607925789
  sbg:revision: 3
  sbg:revisionNotes: add missing call rate threshold
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608144336
  sbg:revision: 4
  sbg:revisionNotes: update documentation
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609294635
  sbg:revision: 5
  sbg:revisionNotes: ''
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609307564
  sbg:revision: 6
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609448349
  sbg:revision: 7
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615931568
  sbg:revision: 8
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615931959
  sbg:revision: 9
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
sbg:sbgMaintained: false
sbg:validationErrors: []