cwlVersion: v1.1
class: CommandLineTool
label: pca_corr
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: EnvVarRequirement
  envDef:
  - envName: NSLOTS
    envValue: ${ return runtime.cores }
- class: ResourceRequirement
  coresMin: 4
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
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
  type:
  - 'null'
  - File
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
  type:
  - 'null'
  - int
  default: 32
  sbg:category: Input Options
  sbg:toolDefaultValue: '32'
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type:
  - 'null'
  - string
  sbg:category: Input Options
- id: chromosome
  label: Chromosome
  doc: Run on this chromosome only. 23=X, 24=Y
  type:
  - 'null'
  - int
  inputBinding:
    prefix: --chromosome
    position: 3
    shellQuote: false
  sbg:category: Input Options

outputs:
- id: pca_corr_gds
  label: PC-SNP correlation
  doc: GDS file with PC-SNP correlation results
  type:
  - 'null'
  - File
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
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/pca-corr/14/raw/
sbg:appVersion:
- v1.1
sbg:content_hash: afe7fada8fd3c36928664ebb513ccf58f229b6b88af1724dd418209b359c6e30b
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1604988662
sbg:id: smgogarten/genesis-relatedness/pca-corr/14
sbg:image_url:
sbg:latestRevision: 14
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615936349
sbg:project: smgogarten/genesis-relatedness
sbg:projectName: GENESIS relatedness
sbg:publisher: sbg
sbg:revision: 14
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: (uncommitted file)
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1604988662
  sbg:revision: 0
  sbg:revisionNotes: Copy of boris_majic/topmed-optimization/pca-corr/0
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605577131
  sbg:revision: 1
  sbg:revisionNotes: save complete R output
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605639828
  sbg:revision: 2
  sbg:revisionNotes: add NSLOTS for parallelization
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605640837
  sbg:revision: 3
  sbg:revisionNotes: set default n_pcs to 32
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605726814
  sbg:revision: 4
  sbg:revisionNotes: use runtime.cores to set NSLOTS
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605729508
  sbg:revision: 5
  sbg:revisionNotes: try checking the multi-thread box
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605730462
  sbg:revision: 6
  sbg:revisionNotes: try setting min CPUs
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606335780
  sbg:revision: 7
  sbg:revisionNotes: put chromosome number in output file name
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606341005
  sbg:revision: 8
  sbg:revisionNotes: fix output file name
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606355536
  sbg:revision: 9
  sbg:revisionNotes: update input and output labels
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606356416
  sbg:revision: 10
  sbg:revisionNotes: update labels
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608672691
  sbg:revision: 11
  sbg:revisionNotes: fix position of chromosome argument
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609370838
  sbg:revision: 12
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609448619
  sbg:revision: 13
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615936349
  sbg:revision: 14
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
sbg:sbgMaintained: false
sbg:validationErrors: []
