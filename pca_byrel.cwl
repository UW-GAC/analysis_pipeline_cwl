cwlVersion: v1.1
class: CommandLineTool
label: pca_byrel
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: EnvVarRequirement
  envDef:
  - envName: NSLOTS
    envValue: ${ return inputs.cpu }
- class: ResourceRequirement
  coresMin: "${ if(inputs.cpu)\n        return inputs.cpu \n    else \n        return\
    \ 4\n}"
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: pca_byrel.config
    writable: false
    entry: |-
      ${

          var cmd_line = ''
          var arguments = []
          
          if(inputs.gds_file)
           arguments.push("gds_file \"" + inputs.gds_file.path + "\"")
          if(inputs.related_file)
              arguments.push("related_file \"" + inputs.related_file.path + "\"")
          
          if(inputs.unrelated_file)
              arguments.push("unrelated_file \"" + inputs.unrelated_file.path + "\"")
              
          if(inputs.variant_include_file)
              arguments.push("variant_include_file \"" + inputs.variant_include_file.path + "\"")
              
          if(inputs.n_pcs)
              arguments.push('n_pcs ' + inputs.n_pcs)
          
          if(inputs.out_prefix) {
              arguments.push(cmd_line +='out_file "' + inputs.out_prefix + '_pca.RData"')
          
              arguments.push('out_file_unrel "' + inputs.out_prefix + '_pca_unrel.RData"')
          }
          
          if(inputs.sample_include_file)
              arguments.push('sample_include_file "' + inputs.sample_include_file.path + '"')
          
          return arguments.join("\n")
      }
- class: InlineJavascriptRequirement

inputs:
- id: gds_file
  label: GDS File
  doc: |-
    Input GDS file used for PCA. It is recommended to use an LD pruned file with all chromosomes.
  type: File
  sbg:category: Input Files
  sbg:fileTypes: GDS
- id: related_file
  label: Related file
  doc: RData file with related subjects.
  type: File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: unrelated_file
  label: Unrelated file
  doc: RData file with unrelated subjects.
  type: File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
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
  label: Variant include file
  doc: |-
    RData file with vector of variant.id to include. If not provided, all variants in the GDS file are included.
  type:
  - 'null'
  - File
  sbg:category: Input Options
  sbg:fileTypes: RDATA
- id: n_pcs
  label: Number of PCs
  doc: Number of PCs (Principal Components) to return.
  type:
  - 'null'
  - int
  default: 32
  sbg:category: Input Options
  sbg:toolDefaultValue: '32'
- id: out_prefix
  label: Output prefix
  doc: Output prefix.
  type:
  - 'null'
  - string
  sbg:category: Input Options
- id: cpu
  label: cpu
  doc: Number of CPUs used for each job.
  type:
  - 'null'
  - int
  default: 4
  sbg:category: Input Options
  sbg:toolDefaultValue: '4'

outputs:
- id: pcair_output
  label: RData file with PC-AiR PCs for all samples
  type:
  - 'null'
  - File
  outputBinding:
    glob: |-
      ${
        if (!inputs.out_prefix) {
          var comm = "pca.RData"
        } else {
          var comm = inputs.out_prefix + "_pca.RData"
        }
        return comm
      }
  sbg:fileTypes: RDATA
- id: pcair_output_unrelated
  label: PCA byrel unrelated
  doc: RData file with PC-AiR PCs for unrelated samples
  type:
  - 'null'
  - File
  outputBinding:
    glob: |-
      ${
        if (!inputs.out_prefix) {
          var comm = "pca_unrel.RData"
        } else {
          var comm = inputs.out_prefix + "_pca_unrel.RData"
        }
        return comm
      }
  sbg:fileTypes: RDATA
stdout: job.out.log

baseCommand:
- R -q --vanilla
arguments:
- prefix: <
  position: 3
  valueFrom: /usr/local/analysis_pipeline/R/pca_byrel.R
  shellQuote: false
- prefix: --args
  position: 2
  valueFrom: pca_byrel.config
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: pca_byrel.config
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/pca-byrel/20/raw/
sbg:appVersion:
- v1.1
sbg:content_hash: a3d8a9da2fd468018c616ebdfd5c1b7075d5621a288152586c6ccd2225a367a2e
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1604988650
sbg:id: smgogarten/genesis-relatedness/pca-byrel/20
sbg:image_url:
sbg:latestRevision: 20
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615936346
sbg:project: smgogarten/genesis-relatedness
sbg:projectName: GENESIS relatedness
sbg:publisher: sbg
sbg:revision: 20
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: (uncommitted file)
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1604988650
  sbg:revision: 0
  sbg:revisionNotes: Copy of boris_majic/topmed-optimization/pca-byrel/0
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1604990205
  sbg:revision: 1
  sbg:revisionNotes: base command ->  arguments
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1604991094
  sbg:revision: 2
  sbg:revisionNotes: fix output ports
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1604991605
  sbg:revision: 3
  sbg:revisionNotes: use out_prefix
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605570979
  sbg:revision: 4
  sbg:revisionNotes: try redirecting stdout and stderr to same file
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605571421
  sbg:revision: 5
  sbg:revisionNotes: variant_include should not be required
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605571692
  sbg:revision: 6
  sbg:revisionNotes: redirecting stdout and stderr to same file just loses stderr
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605572819
  sbg:revision: 7
  sbg:revisionNotes: use R as base command instead of Rscript
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605577005
  sbg:revision: 8
  sbg:revisionNotes: add cpu as an argument
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605639326
  sbg:revision: 9
  sbg:revisionNotes: set NSLOTS for parallelization
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605640696
  sbg:revision: 10
  sbg:revisionNotes: set default n_pcs to 32
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605647083
  sbg:revision: 11
  sbg:revisionNotes: try using EnvVarRequirement
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605648960
  sbg:revision: 12
  sbg:revisionNotes: try EnvironmentDef
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605721746
  sbg:revision: 13
  sbg:revisionNotes: fix EnvVarRequirement
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605726503
  sbg:revision: 14
  sbg:revisionNotes: set NSLOTS automatically instead of as input
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605737241
  sbg:revision: 15
  sbg:revisionNotes: add resource requirement
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606356018
  sbg:revision: 16
  sbg:revisionNotes: update input and output labels
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609448527
  sbg:revision: 17
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609461048
  sbg:revision: 18
  sbg:revisionNotes: fix missing quotation mark
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609461797
  sbg:revision: 19
  sbg:revisionNotes: update output names and descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615936346
  sbg:revision: 20
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
sbg:sbgMaintained: false
sbg:validationErrors: []
