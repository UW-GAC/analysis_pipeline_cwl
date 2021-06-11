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
id: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness-pre-build/subset-gds/3/raw/
sbg:appVersion:
- v1.2
sbg:content_hash: a48aaf001b751c2090e07255b525a17c6ff382a64ec284b44cdb5655f84e9c6f9
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1609452021
sbg:id: smgogarten/genesis-relatedness-pre-build/subset-gds/3
sbg:image_url:
sbg:latestRevision: 3
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1623437540
sbg:project: smgogarten/genesis-relatedness-pre-build
sbg:projectName: GENESIS relatedness - Pre-build
sbg:publisher: sbg
sbg:revision: 3
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: 
  commit: c68ac3f
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609452021
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609452067
  sbg:revision: 1
  sbg:revisionNotes: import to pre-build project
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615931143
  sbg:revision: 2
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: (uncommitted file)
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1623437540
  sbg:revision: 3
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: 
    commit: c68ac3f
sbg:sbgMaintained: false
sbg:validationErrors: []
