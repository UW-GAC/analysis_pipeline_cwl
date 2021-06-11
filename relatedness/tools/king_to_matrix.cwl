cwlVersion: v1.2
class: CommandLineTool
label: king_to_matrix
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InitialWorkDirRequirement
  listing:
  - entryname: king_to_matrix.config
    writable: false
    entry: |-
      ${

      var cmd_line = "";

      if(inputs.king_file)
          cmd_line += "king_file \"" + inputs.king_file.path + "\"\n"
         
      if(inputs.sample_include_file)
          cmd_line += "sample_include_file \"" + inputs.sample_include_file.path + "\"\n"

      if(inputs.sparse_threshold)
      {
          cmd_line += "sparse_threshold \"" + inputs.sparse_threshold +"\"\n"
      } else {
          cmd_line += "sparse_threshold \"NA\"\n"
      }

      if(inputs.out_prefix)
      {
          cmd_line += "out_prefix \"" + inputs.out_prefix + "\"\n"
      }
      else
      {
          cmd_line += "out_prefix \"" + inputs.king_file.nameroot + "_king_ibdseg_Matrix\"\n"
      }
      if(inputs.kinship_method)
      {
          cmd_line += "kinship_method \"" + inputs.kinship_method + "\"\n"
      }

       return cmd_line
      }
- class: InlineJavascriptRequirement
  expressionLib:
  - |2-

    var setMetadata = function(file, metadata) {
        if (!('metadata' in file))
            file['metadata'] = metadata;
        else {
            for (var key in metadata) {
                file['metadata'][key] = metadata[key];
            }
        }
        return file
    };

    var inheritMetadata = function(o1, o2) {
        var commonMetadata = {};
        if (!Array.isArray(o2)) {
            o2 = [o2]
        }
        for (var i = 0; i < o2.length; i++) {
            var example = o2[i]['metadata'];
            for (var key in example) {
                if (i == 0)
                    commonMetadata[key] = example[key];
                else {
                    if (!(commonMetadata[key] == example[key])) {
                        delete commonMetadata[key]
                    }
                }
            }
        }
        if (!Array.isArray(o1)) {
            o1 = setMetadata(o1, commonMetadata)
        } else {
            for (var i = 0; i < o1.length; i++) {
                o1[i] = setMetadata(o1[i], commonMetadata)
            }
        }
        return o1;
    };

inputs:
- id: king_file
  label: KING File
  doc: Output of one of KING tools.
  type: File
  sbg:category: Input Files
  sbg:fileTypes: KIN, SEG
- id: sample_include_file
  label: Sample include file
  doc: |-
    RData file with vector of sample.id to include. If not provided, all samples in the KING file are included.
  type:
  - 'null'
  - File
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
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type:
  - 'null'
  - string
  sbg:category: Input Options
- id: kinship_method
  label: Kinship method
  doc: KING algorithm used.
  type:
    name: kinship_method
    type: enum
    symbols:
    - king_ibdseg
    - king_robust
  sbg:category: Input Options

outputs:
- id: king_matrix
  label: Kinship matrix
  doc: |-
    A block-diagonal matrix of pairwise kinship estimates. Samples are clustered into blocks of relatives based on `sparse_threshold`; all kinship estimates within a block are kept, and kinship estimates between blocks are set to 0.
  type:
  - 'null'
  - File
  outputBinding:
    glob: '*.RData'
    outputEval: $(inheritMetadata(self, inputs.king_file))
  sbg:fileTypes: RData
stdout: job.out.log

baseCommand:
- R -q --vanilla
arguments:
- prefix: <
  position: 2
  valueFrom: /usr/local/analysis_pipeline/R/king_to_matrix.R
  shellQuote: false
- prefix: --args
  position: 1
  valueFrom: king_to_matrix.config
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: king_to_matrix.config
