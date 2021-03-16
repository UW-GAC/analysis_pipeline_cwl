cwlVersion: v1.1
class: CommandLineTool
label: subset_gds
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.8.1
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
  type:
  - 'null'
  - File
  sbg:category: Inputs
  sbg:fileTypes: RDATA
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type:
  - 'null'
  - string
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
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/genesis-relatedness/subset_gds/9/raw/
sbg:appVersion:
- v1.1
sbg:content_hash: a6ec7a58ea70f2b69d7e82f13f113bf5a67a3a86afbeecc3d8365d53a4de60a90
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1601921410
sbg:id: smgogarten/genesis-relatedness/subset_gds/9
sbg:image_url:
sbg:latestRevision: 9
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615933368
sbg:project: smgogarten/genesis-relatedness
sbg:projectName: GENESIS relatedness
sbg:publisher: sbg
sbg:revision: 9
sbg:revisionNotes: |-
  Uploaded using sbpack v2020.10.05. 
  Source: 
  repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
  file: subset_gds.cwl
  commit: 730ce42
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1601921410
  sbg:revision: 0
  sbg:revisionNotes: Copy of boris_majic/topmed-optimization/subset_gds/4
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606254989
  sbg:revision: 1
  sbg:revisionNotes: update subset_gds
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606267367
  sbg:revision: 2
  sbg:revisionNotes: only one variant include file as input
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606285396
  sbg:revision: 3
  sbg:revisionNotes: set output type to gds
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606334858
  sbg:revision: 4
  sbg:revisionNotes: set .gds as output extension
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606335219
  sbg:revision: 5
  sbg:revisionNotes: update test values
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606335263
  sbg:revision: 6
  sbg:revisionNotes: remove extraneous code
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1606336200
  sbg:revision: 7
  sbg:revisionNotes: simplify file names
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1609449495
  sbg:revision: 8
  sbg:revisionNotes: update descriptions
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615933368
  sbg:revision: 9
  sbg:revisionNotes: |-
    Uploaded using sbpack v2020.10.05. 
    Source: 
    repo: git@github.com:UW-GAC/analysis_pipeline_cwl.git
    file: subset_gds.cwl
    commit: 730ce42
sbg:sbgMaintained: false
sbg:validationErrors: []
