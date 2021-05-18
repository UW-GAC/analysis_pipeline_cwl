cwlVersion: v1.1
class: CommandLineTool
label: find_unrelated
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
- class: InitialWorkDirRequirement
  listing:
  - entryname: find_unrelated.config
    writable: false
    entry: |
      ${
          var config = ""
          
          if(inputs.kinship_file)
              config += "kinship_file \"" + inputs.kinship_file.path + "\"\n"

          if(inputs.divergence_file)
              config += "divergence_file \"" + inputs.divergence_file.path + "\"\n"

        	if (inputs.kinship_threshold) 
            config += "kinship_threshold " + inputs.kinship_threshold  + "\n"
          
        	if (inputs.divergence_threshold) 
            config += "divergence_threshold " + inputs.kinship_threshold  + "\n"
          
        	if (inputs.out_prefix) {
            config += "out_related_file \"" + inputs.out_prefix  + "_related.RData\"\n"
          
            config += "out_unrelated_file \"" + inputs.out_prefix  + "_unrelated.RData\"\n"
        	}
        
          if (inputs.sample_include_file) 
            config += "sample_include_file \"" + inputs.sample_include_file.path + "\"\n"

          return config
      }
- class: InlineJavascriptRequirement

inputs:
- id: kinship_file
  label: Kinship File
  doc: |-
    Pairwise kinship matrix used to identify unrelated and related sets of samples. It is recommended to use KING-IBDseg or PC-Relate estimates.
  type: File
  sbg:category: Input Files
  sbg:fileTypes: RDATA, GDS
- id: divergence_file
  label: Divergence File
  doc: |-
    Pairwise matrix used to identify ancestrally divergent pairs of samples. It is recommended to use KING-robust estimates.
  type: File?
  sbg:category: Input Files
  sbg:fileTypes: RDATA, GDS
- id: kinship_threshold
  label: Kinship threshold
  doc: Minimum kinship estimate to use for identifying relatives.
  type: float?
  sbg:category: Input Options
  sbg:toolDefaultValue: 2^(-9/2) (third-degree relatives and closer)
- id: divergence_threshold
  label: Divergence threshold
  doc: |-
    Maximum divergence estimate to use for identifying ancestrally divergent pairs of samples.
  type: float?
  sbg:category: Input Options
  sbg:toolDefaultValue: -2^(-9/2)
- id: sample_include_file
  label: Sample Include file
  doc: |-
    RData file with vector of sample.id to include. If not provided, all samples in the kinship file are included.
  type: File?
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
  sbg:category: Input Options

outputs:
- id: out_related_file
  label: Related file
  doc: |-
    RData file with vector of sample.id of samples related to the set of unrelated samples
  type: File?
  outputBinding:
    glob: |-
      ${   
          if (!inputs.out_prefix) {     
              var comm = "related.RData"   
          } else {     	
              var comm = inputs.out_prefix + "_related.RData"   
          }   
          return comm 
      }
  sbg:fileTypes: RDATA
- id: out_unrelated_file
  label: Unrelated file
  doc: RData file with vector of sample.id of unrelated samples
  type: File?
  outputBinding:
    glob: |-
      ${       
          if (!inputs.out_prefix) {              
              var comm = "unrelated.RData"        
          } else {     	         
              var comm = inputs.out_prefix + "_unrelated.RData"       
          }        
          return comm  
      }
  sbg:fileTypes: RDATA
stdout: job.out.log

baseCommand:
- R -q --vanilla
arguments:
- prefix: --args
  position: 1
  valueFrom: find_unrelated.config
  shellQuote: false
- prefix: <
  position: 2
  valueFrom: /usr/local/analysis_pipeline/R/find_unrelated.R
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
- class: sbg:SaveLogs
  value: find_unrelated.config
id: smgogarten/genesis-relatedness-pre-build/find-unrelated/1
sbg:appVersion:
- v1.1
sbg:content_hash: a0b33dc1edc7c27a35817510603320a960c53de02a97665cac7fabbe8e22454be
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1609450964
sbg:id: smgogarten/genesis-relatedness-pre-build/find-unrelated/1
sbg:image_url:
sbg:latestRevision: 1
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1609450991
sbg:project: smgogarten/genesis-relatedness-pre-build
sbg:projectName: GENESIS relatedness - Pre-build
sbg:publisher: sbg
sbg:revision: 1
sbg:revisionNotes: import to pre-build project
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609450964
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609450991
  sbg:revision: 1
  sbg:revisionNotes: import to pre-build project
sbg:sbgMaintained: false
sbg:validationErrors: []
