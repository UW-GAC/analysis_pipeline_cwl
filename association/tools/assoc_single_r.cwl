cwlVersion: v1.2
class: CommandLineTool
label: assoc_single.R
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
            return parseFloat(inputs.memory_gb * 1024)
        else
            return 8*1024
    }
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.12.0
- class: InitialWorkDirRequirement
  listing:
  - entryname: assoc_single.config
    writable: false
    entry: |-
      ${
          function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("chr")[1];
              
              if(isNumeric(chrom_num.charAt(1)))
              {
                  chr_array.push(chrom_num.substr(0,2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(0,1))
              }
              return chr_array.toString()
          }
              
          var chr = find_chromosome(inputs.gds_file.path)
          
          var argument = [];
          if(!inputs.is_unrel)
          {   
              if(inputs.out_prefix){
                  argument.push("out_prefix \"" + inputs.out_prefix + "_chr"+chr + "\"");
              }
              if(!inputs.out_prefix){
              var data_prefix = inputs.gds_file.basename.split('chr');
              var data_prefix2 = inputs.gds_file.basename.split('.chr');
              if(data_prefix.length == data_prefix2.length)
                  argument.push('out_prefix "' + data_prefix2[0] + '_single_chr' + chr + inputs.gds_file.basename.split('chr'+chr)[1].split('.gds')[0] +'"');
              else
                  argument.push('out_prefix "' + data_prefix[0] + 'single_chr' + chr +inputs.gds_file.basename.split('chr'+chr)[1].split('.gds')[0]+'"');}
              argument.push('gds_file "' + inputs.gds_file.path +'"');
              argument.push('null_model_file "' + inputs.null_model_file.path + '"');
              argument.push('phenotype_file "' + inputs.phenotype_file.path + '"');
              if(inputs.mac_threshold){
                  argument.push('mac_threshold ' + inputs.mac_threshold);
              }
              if(inputs.maf_threshold){
                  argument.push('maf_threshold ' + inputs.maf_threshold);
              }
              if(inputs.pass_only){
                  argument.push('pass_only ' + inputs.pass_only);
              }
              if(inputs.segment_file){
                  argument.push('segment_file "' + inputs.segment_file.path + '"');
              }
              if(inputs.test_type){
                  argument.push('test_type "' + inputs.test_type + '"') ;
              }
              if(inputs.variant_include_file){
                  argument.push('variant_include_file "' + inputs.variant_include_file.path + '"');
              }
              if(inputs.variant_block_size){
                  argument.push('variant_block_size ' + inputs.variant_block_size);
              }
              if(inputs.genome_build){
                  argument.push('genome_build ' + inputs.genome_build);
              }
              if(inputs.genotype_coding){
                  argument.push('genotype_coding ' + inputs.genotype_coding);
              }
              argument.push('');
              return argument.join('\n');
          }
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
- id: gds_file
  label: GDS file
  doc: GDS file.
  type: File
  sbg:category: Configs
  sbg:fileTypes: GDS
- id: null_model_file
  label: Null model file
  doc: Null model file.
  type: File
  sbg:category: Configs
  sbg:fileTypes: RDATA
- id: phenotype_file
  label: Phenotype file
  doc: RData file with AnnotatedDataFrame of phenotypes.
  type: File
  sbg:category: Configs
  sbg:fileTypes: RDATA
- id: mac_threshold
  label: MAC threshold
  doc: |-
    Minimum minor allele count for variants to include in test. Use a higher threshold when outcome is binary. To disable it set it to NA. Tool default: 5.
  type: float?
  sbg:category: Configs
  sbg:toolDefaultValue: '5'
- id: maf_threshold
  label: MAF threshold
  doc: |-
    Minimum minor allele frequency for variants to include in test. Only used if MAC threshold is NA. Tool default: 0.001.
  type: float?
  sbg:category: Configs
  sbg:toolDefaultValue: '0.001'
- id: pass_only
  label: Pass only
  doc: TRUE to select only variants with FILTER=PASS.
  type:
  - 'null'
  - name: pass_only
    type: enum
    symbols:
    - 'TRUE'
    - 'FALSE'
  sbg:category: Configs
  sbg:toolDefaultValue: 'TRUE'
- id: segment_file
  label: Segment file
  doc: Segment file.
  type: File?
  sbg:category: Configs
  sbg:fileTypes: TXT
- id: test_type
  label: Test type
  doc: |-
    Type of test to perform. If samples are related (mixed model), options are score if binary is FALSE, score and score.spa if binary is TRUE. Default value: score.
  type:
  - 'null'
  - name: test_type
    type: enum
    symbols:
    - score
    - score.spa
    - BinomiRare
  sbg:category: Configs
  sbg:toolDefaultValue: score
- id: variant_include_file
  label: Variant include file
  doc: RData file with vector of variant.id to include.
  type: File?
  sbg:category: Configs
  sbg:fileTypes: RDATA
- id: chromosome
  label: Chromosome
  doc: Chromosome (1-24 or X,Y).
  type: string?
  inputBinding:
    prefix: --chromosome
    position: 1
    shellQuote: false
  sbg:altPrefix: -c
  sbg:category: Optional inputs
- id: segment
  label: Segment number
  doc: Segment number.
  type: int?
  inputBinding:
    prefix: --segment
    position: 2
    shellQuote: false
  sbg:category: Optional parameters
- id: memory_gb
  label: memory GB
  doc: 'Memory in GB per job. Default value: 8.'
  type: float?
  sbg:category: Input options
  sbg:toolDefaultValue: '8'
- id: cpu
  label: CPU
  doc: 'Number of CPUs for each tool job. Default value: 1.'
  type: int?
  sbg:category: Input options
  sbg:toolDefaultValue: '1'
- id: variant_block_size
  label: Variant block size
  doc: 'Number of variants to read in a single block. Default: 1024'
  type: int?
  sbg:category: General
  sbg:toolDefaultValue: '1024'
- id: out_prefix
  label: Output prefix
  doc: Output prefix
  type: string?
  sbg:toolDefaultValue: assoc_single
- id: genome_build
  label: Genome build
  doc: |-
    Genome build for the genotypes in the GDS file (hg19 or hg38). Used to divide the genome into segments for parallel processing.
  type:
  - 'null'
  - name: genome_build
    type: enum
    symbols:
    - hg19
    - hg38
  default: hg38
- id: genotype_coding
  label: Genetic model
  doc: 'Genetic model can be one of: additive, recessive, dominant.'
  type:
  - 'null'
  - name: genotype_coding
    type: enum
    symbols:
    - additive
    - recessive
    - dominant
  default: additive
  sbg:toolDefaultValue: additive

outputs:
- id: configs
  label: Config files
  doc: Config files.
  type: File[]?
  outputBinding:
    glob: '*config*'
  sbg:fileTypes: CONFIG
- id: assoc_single
  label: Assoc single output
  doc: Assoc single output.
  type: File?
  outputBinding:
    glob: '*.RData'
    outputEval: $(inheritMetadata(self, inputs.gds_file))
  sbg:fileTypes: RDATA

baseCommand: []
arguments:
- prefix: ''
  position: 100
  valueFrom: |-
    ${
        if(inputs.is_unrel)
        {
            return "assoc_single_unrel.config"
        }
        else
        {
            return "assoc_single.config"
        }
        
    }
  separate: false
  shellQuote: false
- prefix: ''
  position: 1
  valueFrom: |-
    ${
        if(inputs.is_unrel)
        {
            return "Rscript /usr/local/analysis_pipeline/R/assoc_single_unrel.R"
        }
        else
        {
            return "Rscript /usr/local/analysis_pipeline/R/assoc_single.R"
        }
        
    }
  shellQuote: false
- prefix: ''
  position: 0
  valueFrom: |-
    ${
        if (inputs.cpu)
            return 'export NSLOTS=' + inputs.cpu + ' &&'
        else
            return ''
    }
  shellQuote: false
- prefix: ''
  position: 100
  valueFrom: "${\n    return ' >> job.out.log'\n}"
  shellQuote: false

hints:
- class: sbg:AWSInstanceType
  value: r4.8xlarge;ebs-gp2;500
- class: sbg:SaveLogs
  value: job.out.log
id: boris_majic/genesis-toolkit-demo/assoc-single-r/10
sbg:appVersion:
- v1.2
sbg:content_hash: a2f4118b92dbecd7610d0f6e07d9cf3bd6afa91c3f1ed54bbb86ba31043ed130b
sbg:contributors:
- boris_majic
- dajana_panovic
sbg:createdBy: boris_majic
sbg:createdOn: 1577360947
sbg:id: h-bdc9627e/h-05376477/h-e980d70a/0
sbg:image_url:
sbg:latestRevision: 10
sbg:modifiedBy: dajana_panovic
sbg:modifiedOn: 1632131339
sbg:project: boris_majic/genesis-toolkit-demo
sbg:projectName: GENESIS Toolkit - DEMO
sbg:publisher: sbg
sbg:revision: 10
sbg:revisionNotes: uwgac/topmed-master:2.12.0 and genotype model change
sbg:revisionsInfo:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577360947
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577360972
  sbg:revision: 1
  sbg:revisionNotes: Import from F4C
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584373463
  sbg:revision: 2
  sbg:revisionNotes: GDS filename corrected
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1594133227
  sbg:revision: 3
  sbg:revisionNotes: Docker image update to 2.8.0
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602155510
  sbg:revision: 4
  sbg:revisionNotes: Import from BDC 2.8.1 version
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603361997
  sbg:revision: 5
  sbg:revisionNotes: parseFloat instead parseInt
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603362503
  sbg:revision: 6
  sbg:revisionNotes: ParseFloat instead parseInt
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603797707
  sbg:revision: 7
  sbg:revisionNotes: BDC import
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608907021
  sbg:revision: 8
  sbg:revisionNotes: CWLtool prep
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1616077397
  sbg:revision: 9
  sbg:revisionNotes: Docker updated to v2.10.0 and BinomiRare test added
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1632131339
  sbg:revision: 10
  sbg:revisionNotes: uwgac/topmed-master:2.12.0 and genotype model change
sbg:sbgMaintained: false
sbg:validationErrors: []
