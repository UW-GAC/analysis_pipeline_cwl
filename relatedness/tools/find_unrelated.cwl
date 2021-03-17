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
  type:
  - 'null'
  - File
  sbg:category: Input Files
  sbg:fileTypes: RDATA, GDS
- id: kinship_threshold
  label: Kinship threshold
  doc: Minimum kinship estimate to use for identifying relatives.
  type:
  - 'null'
  - float
  sbg:category: Input Options
  sbg:toolDefaultValue: 2^(-9/2) (third-degree relatives and closer)
- id: divergence_threshold
  label: Divergence threshold
  doc: |-
    Maximum divergence estimate to use for identifying ancestrally divergent pairs of samples.
  type:
  - 'null'
  - float
  sbg:category: Input Options
  sbg:toolDefaultValue: -2^(-9/2)
- id: sample_include_file
  label: Sample Include file
  doc: |-
    RData file with vector of sample.id to include. If not provided, all samples in the kinship file are included.
  type:
  - 'null'
  - File
  sbg:category: Input Files
  sbg:fileTypes: RDATA
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type:
  - 'null'
  - string
  sbg:category: Input Options

outputs:
- id: out_related_file
  label: Related file
  doc: |-
    RData file with vector of sample.id of samples related to the set of unrelated samples
  type:
  - 'null'
  - File
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
  type:
  - 'null'
  - File
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
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/find-unrelated/20/raw/
sbg:appVersion:
- v1.1
sbg:content_hash: a9d2eae01787b4a3f0d58278c94981a6b1fa5efa6b213fe3846a2d4440506bd9c
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1581464601
sbg:id: smgogarten/genesis-relatedness/find-unrelated/20
sbg:image_url:
sbg:latestRevision: 20
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615936345
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
  sbg:modifiedOn: 1581464601
  sbg:revision: 0
  sbg:revisionNotes: Copy of boris_majic/topmed-optimization/find-unrelated/2
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1583954906
  sbg:revision: 1
  sbg:revisionNotes: import changes from RC
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1604987303
  sbg:revision: 2
  sbg:revisionNotes: use out_prefix instead of separate file names
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1604987972
  sbg:revision: 3
  sbg:revisionNotes: fix config file
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1604988821
  sbg:revision: 4
  sbg:revisionNotes: use master docker image
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1604990537
  sbg:revision: 5
  sbg:revisionNotes: must keep separate output ports for use in workflow
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1604990841
  sbg:revision: 6
  sbg:revisionNotes: allow for missing output prefix
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1604990983
  sbg:revision: 7
  sbg:revisionNotes: using prefix in output ports
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1604991264
  sbg:revision: 8
  sbg:revisionNotes: update category
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1604991568
  sbg:revision: 9
  sbg:revisionNotes: update description names
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605548620
  sbg:revision: 10
  sbg:revisionNotes: try stdout redirect
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605570523
  sbg:revision: 11
  sbg:revisionNotes: separate arguments, move config to logs
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605571246
  sbg:revision: 12
  sbg:revisionNotes: try redirecting stdout and stderr to same file
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605571681
  sbg:revision: 13
  sbg:revisionNotes: redirecting stdout and stderr to same file just loses stderr
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605572061
  sbg:revision: 14
  sbg:revisionNotes: see what happens when we pipe to R instead of using Rscript
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1605572744
  sbg:revision: 15
  sbg:revisionNotes: rearrange base command and args
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606355852
  sbg:revision: 16
  sbg:revisionNotes: update input and output labels
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1608621762
  sbg:revision: 17
  sbg:revisionNotes: default label
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609370869
  sbg:revision: 18
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609447255
  sbg:revision: 19
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615936345
  sbg:revision: 20
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
sbg:sbgMaintained: false
sbg:validationErrors: []
