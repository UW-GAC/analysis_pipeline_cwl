cwlVersion: v1.1
class: CommandLineTool
label: assoc_combine.R
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: "${ if(inputs.cpu)\n        return inputs.cpu \n    else \n        return\
    \ 1\n}"
  ramMin: |-
    ${
        if(inputs.memory_gb)
            return parseInt(inputs.memory_gb * 1024)
        else
            return 4*1024
    }
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InitialWorkDirRequirement
  listing:
  - entryname: assoc_combine.config
    writable: false
    entry: |-
      ${
          var argument = [];
          argument.push('assoc_type "'+ inputs.assoc_type + '"');
          var data_prefix = inputs.assoc_files[0].basename.split('_chr')[0];
          if (inputs.out_prefix)
          {
              argument.push('out_prefix "' + inputs.out_prefix+ '"');
          }
          else
          {
              argument.push('out_prefix "' + data_prefix+ '"');
          }
          
          if(inputs.conditional_variant_file){
              argument.push('conditional_variant_file "' + inputs.conditional_variant_file.path + '"');
          }
          //if(inputs.assoc_files)
          //{
          //    arguments.push('assoc_files "' + inputs.assoc_files[0].path + '"')
          //}
          return argument.join('\n') + '\n'
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
- id: chromosome
  label: Chromosome
  doc: Chromosome (1-24 or X,Y).
  type: string[]?
  inputBinding:
    prefix: --chromosome
    position: 10
    shellQuote: false
  sbg:altPrefix: -c
  sbg:category: Optional inputs
- id: assoc_type
  label: Association Type
  doc: 'Type of association test: single, window or aggregate.'
  type:
    name: assoc_type
    type: enum
    symbols:
    - single
    - aggregate
    - window
- id: assoc_files
  label: Association files
  doc: Association files to be combined.
  type: File[]
  sbg:fileTypes: RDATA
- id: out_prefix
  label: Out Prefix
  doc: Output prefix.
  type: string?
- id: memory_gb
  label: memory GB
  doc: 'Memory in GB per one job. Default value: 4GB.'
  type: float?
  sbg:category: Input options
  sbg:toolDefaultValue: '4'
- id: cpu
  label: CPU
  doc: 'Number of CPUs for each tool job. Default value: 1.'
  type: int?
  sbg:category: Input Options
  sbg:toolDefaultValue: '1'
- id: conditional_variant_file
  label: Conditional variant file
  doc: |-
    RData file with data frame of of conditional variants. Columns should include chromosome (or chr) and variant.id. The alternate allele dosage of these variants will be included as covariates in the analysis.
  type: File?
  sbg:category: General
  sbg:fileTypes: RData, RDATA

outputs:
- id: assoc_combined
  label: Assoc combined
  doc: Assoc combined.
  type: File?
  outputBinding:
    glob: |-
      ${
          
          //var input_files = [].concat(inputs.assoc_files);
          //var first_filename = input_files[0].basename;
          
          //var chr = first_filename.split('_chr')[1].split('_')[0].split('.RData')[0];
          
          //return first_filename.split('chr')[0]+'chr'+chr+'.RData';
          
          return '*.RData'
      }
    outputEval: $(inheritMetadata(self, inputs.assoc_files))
  sbg:fileTypes: RDATA
- id: configs
  label: Config files
  doc: Config files.
  type: File[]?
  outputBinding:
    glob: '*config*'
  sbg:fileTypes: CONFIG

baseCommand: []
arguments:
- prefix: ''
  position: 100
  valueFrom: assoc_combine.config
  shellQuote: false
- prefix: ''
  position: 5
  valueFrom: Rscript /usr/local/analysis_pipeline/R/assoc_combine.R
  shellQuote: false
- prefix: ''
  position: 1
  valueFrom: |-
    ${
        var command = '';
        var i;
        for(i=0; i<inputs.assoc_files.length; i++)
            command += "ln -s " + inputs.assoc_files[i].path + " " + inputs.assoc_files[i].path.split("/").pop() + " && "
        
        return command
    }
  shellQuote: false
- prefix: ''
  position: 100
  valueFrom: "${\n    return ' >> job.out.log'\n}"
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
id: boris_majic/genesis-toolkit-demo/assoc-combine-r/7
sbg:appVersion:
- v1.1
sbg:content_hash: a9441836c8bc986fc185a4d0cacafb79eee2380bb33c56e1b49de6a4cabdbf4b8
sbg:contributors:
- dajana_panovic
- boris_majic
sbg:createdBy: boris_majic
sbg:createdOn: 1577360839
sbg:id: h-8e9a5577/h-3060bf70/h-a25e1de5/0
sbg:image_url:
sbg:latestRevision: 7
sbg:modifiedBy: dajana_panovic
sbg:modifiedOn: 1616077298
sbg:project: boris_majic/genesis-toolkit-demo
sbg:projectName: GENESIS Toolkit - DEMO
sbg:publisher: sbg
sbg:revision: 7
sbg:revisionNotes: Docker updated to uwgac/topmed-master:2.10.0
sbg:revisionsInfo:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577360839
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577360864
  sbg:revision: 1
  sbg:revisionNotes: Import from F4C
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584373599
  sbg:revision: 2
  sbg:revisionNotes: GDS filename correction
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1594133318
  sbg:revision: 3
  sbg:revisionNotes: Docker image update 2.8.0
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602155372
  sbg:revision: 4
  sbg:revisionNotes: Import from BDC 2.8.1 version
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603797891
  sbg:revision: 5
  sbg:revisionNotes: BDC import
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608907124
  sbg:revision: 6
  sbg:revisionNotes: CWLtool prep
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1616077298
  sbg:revision: 7
  sbg:revisionNotes: Docker updated to uwgac/topmed-master:2.10.0
sbg:sbgMaintained: false
sbg:validationErrors: []
