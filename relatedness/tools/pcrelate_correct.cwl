cwlVersion: v1.1
class: CommandLineTool
label: pcrelate_correct
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: pcrelate_correct.config
    writable: false
    entry: |-
      ${
          var config = ""

          if (inputs.pcrelate_block_files) {
              var prefix = inputs.pcrelate_block_files[0].nameroot.split("_block_")[0]
              config += "pcrelate_prefix \"" + prefix + "\"\n"
          }
            
        	if (inputs.n_sample_blocks) 
              config += "n_sample_blocks " + inputs.n_sample_blocks + "\n"
            
          if (inputs.sparse_threshold) 
              config += "sparse_threshold " + inputs.sparse_threshold + "\n"  
          
          return config
      }
- class: InlineJavascriptRequirement

inputs:
- id: n_sample_blocks
  label: Number of sample blocks
  doc: |-
    Number of blocks to divide samples into for parallel computation. Adjust depending on computer memory and number of samples in the analysis.
  type: int
  default: 1
  sbg:category: Input Options
  sbg:toolDefaultValue: '1'
- id: pcrelate_block_files
  label: PCRelate files for all sample blocks
  doc: PCRelate files for all sample blocks
  type:
    type: array
    items: File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: sparse_threshold
  label: Sparse threshold
  doc: |-
    Threshold for making the output kinship matrix sparse. A block diagonal matrix will be created such that any pair of samples with a kinship estimate greater than the threshold is in the same block; all pairwise estimates within a block are kept, and pairwise estimates between blocks are set to 0.
  type:
  - 'null'
  - float
  default: 0.02209709
  sbg:category: Input Options
  sbg:toolDefaultValue: 2^(-11/2) (~0.022, 4th degree)

outputs:
- id: pcrelate_output
  label: PC-Relate output file
  doc: PC-Relate output file with all samples
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*_pcrelate.RData'
  sbg:fileTypes: RDATA
- id: pcrelate_matrix
  label: Kinship matrix
  doc: |-
    A block diagonal matrix of pairwise kinship estimates with sparsity set by sparse_threshold. Samples are clustered into blocks of relatives based on `sparse_threshold`; all kinship estimates within a block are kept, and kinship estimates between blocks are set to 0. When `sparse_threshold` is 0, this is a dense matrix with all pairwise kinship estimates.
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*_pcrelate_Matrix.RData'
  sbg:fileTypes: RDATA
stdout: job.out.log

baseCommand: []
arguments:
- prefix: <
  position: 3
  valueFrom: /usr/local/analysis_pipeline/R/pcrelate_correct.R
  shellQuote: false
- prefix: --args
  position: 2
  valueFrom: pcrelate_correct.config
  shellQuote: false
- prefix: ''
  position: 0
  valueFrom: |-
    ${
        var cmd_line = ""
        
        for (var i=0; i<inputs.pcrelate_block_files.length; i++)
            cmd_line += "ln -s " + inputs.pcrelate_block_files[i].path + " " + inputs.pcrelate_block_files[i].basename + " && "
        
        return cmd_line
    }
  shellQuote: false
- prefix: ''
  position: 1
  valueFrom: R -q --vanilla
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: pcrelate_correct.config
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/pcrelate-correct/7/raw/
sbg:appVersion:
- v1.1
sbg:content_hash: a08841b337573a2de979b257729c2932e95c5fd44a0574ec9e22b5a4b1670368a
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1606778864
sbg:id: smgogarten/genesis-relatedness/pcrelate-correct/7
sbg:image_url:
sbg:latestRevision: 7
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615937214
sbg:project: smgogarten/genesis-relatedness
sbg:projectName: GENESIS relatedness
sbg:publisher: sbg
sbg:revision: 7
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: (uncommitted file)
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606778864
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606780923
  sbg:revision: 1
  sbg:revisionNotes: wrap pcrelate_correct script
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606781401
  sbg:revision: 2
  sbg:revisionNotes: add outputs and sparse threshold
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606798474
  sbg:revision: 3
  sbg:revisionNotes: fix name of R script
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606839731
  sbg:revision: 4
  sbg:revisionNotes: don't repeat '_pcrelate' in output file names
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606939015
  sbg:revision: 5
  sbg:revisionNotes: pcrelate_prefix must match input file names, so can't change
    output string
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609374238
  sbg:revision: 6
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615937214
  sbg:revision: 7
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
sbg:sbgMaintained: false
sbg:validationErrors: []
