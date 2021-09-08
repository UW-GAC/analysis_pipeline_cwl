cwlVersion: v1.1
class: CommandLineTool
label: assoc_aggregate
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
  dockerPull: uwgac/topmed-master:2.10.0
- class: InitialWorkDirRequirement
  listing:
  - entryname: assoc_aggregate.config
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
              
          
          var chr = find_chromosome(inputs.gds_file.path);
          
          var config = "";
          
          if(inputs.out_prefix)
              config += "out_prefix \"" + inputs.out_prefix + "_chr"+chr + "\"\n"
          else
          {
              var data_prefix = inputs.gds_file.basename.split('chr');
              var data_prefix2 = inputs.gds_file.basename.split('.chr');
              
              if (data_prefix.length == data_prefix2.length)
                  config += 'out_prefix "' + data_prefix2[0] + '_aggregate_chr' + chr + inputs.gds_file.basename.split('chr'+chr)[1].split('.gds')[0] +'"'+ "\n";
              else
                  config += 'out_prefix "' + data_prefix[0] + 'aggregate_chr' + chr +inputs.gds_file.basename.split('chr'+chr)[1].split('.gds')[0]+'"' + "\n";
          } 
          if(inputs.gds_file)
              config += "gds_file \"" + inputs.gds_file.path + "\"\n"
          if(inputs.phenotype_file)
              config += "phenotype_file \"" + inputs.phenotype_file.path + "\"\n"
          if(inputs.aggregate_variant_file)
              config += "aggregate_variant_file \"" + inputs.aggregate_variant_file.path + "\"\n"
          if(inputs.null_model_file)
              config += "null_model_file \"" + inputs.null_model_file.path + "\"\n"
          if(inputs.null_model_params)
              config += "null_model_params \"" + inputs.null_model_params.path + "\"\n"
          if(inputs.rho)
          {
              config += "rho \"";;
              for(var i=0; i<inputs.rho.length; i++)
              {
                  config += inputs.rho[i].toString() + " ";
              }
              config += "\"\n";
          }
          if(inputs.segment_file)
              config += "segment_file \"" + inputs.segment_file.path + "\"\n"
          if(inputs.test)
             config += "test \"" + inputs.test + "\"\n"
          if(inputs.test_type)
              config += "test_type \"" + inputs.test_type + "\"\n"
          if(inputs.variant_include_file)
              config +="variant_include_file \"" + inputs.variant_include_file.path + "\"\n"
          if(inputs.weight_beta)
              config +="weight_beta \"" + inputs.weight_beta + "\"\n"
          if(inputs.aggregate_type)
              config +="aggregate_type \"" + inputs.aggregate_type + "\"\n"
          if(inputs.alt_freq_max)
              config +="alt_freq_max " + inputs.alt_freq_max + "\n"
          if(!inputs.pass_only)
              config += "pass_only FALSE"+ "\n"
          if(inputs.variant_weight_file)
              config +="variant_weight_file \"" + inputs.variant_weight_file + "\"\n"
          if(inputs.weight_user)
              config +="weight_user \"" + inputs.weight_user + "\"\n"
          if(inputs.genome_build)
              config +="genome_build \"" + inputs.genome_build + "\"\n"    
              
          return config
      }
- class: InlineJavascriptRequirement

inputs:
- id: gds_file
  label: GDS file
  doc: GDS File.
  type: File
  sbg:category: Input File
  sbg:fileTypes: GDS
- id: null_model_file
  label: Null model file
  doc: Null model file.
  type: File
  sbg:category: Input File
  sbg:fileTypes: RDATA
- id: phenotype_file
  label: Phenotype file
  doc: |-
    RData file with AnnotatedDataFrame of phenotypes. Used for plotting kinship estimates separately by study.
  type: File
  sbg:category: Input File
  sbg:fileTypes: RDATA
- id: aggregate_variant_file
  label: Aggregate variant file
  doc: File with regions that we want to test.
  type: File
  sbg:fileTypes: RDATA
- id: out_prefix
  label: Output prefix
  doc: Output prefix.
  type: string?
  sbg:category: Inputs
  sbg:toolDefaultValue: assoc_aggregate
- id: rho
  label: Rho
  doc: |-
    A numeric value or list of values in range [0,1] specifying the rho parameter when test is skat. 0 is a standard SKAT test, 1 is a score burden test, and multiple values is a SKAT-O test.
  type: float[]?
  sbg:toolDefaultValue: '0'
- id: segment_file
  label: Segment File
  doc: Segment File.
  type: File?
  sbg:category: Input files
  sbg:fileTypes: TXT
- id: test
  label: Test type
  doc: Test to perform. Options are burden, skat, smmat, fastskat, or skato.
  type:
  - 'null'
  - name: test
    type: enum
    symbols:
    - burden
    - skat
    - smmat
    - fastskat
    - skato
  sbg:toolDefaultValue: burden
- id: variant_include_file
  label: Variant Include File
  doc: Variants to be included when perform testing.
  type: File?
  sbg:fileTypes: RDATA
- id: weight_beta
  label: Weight Beta
  doc: |-
    Parameters of the Beta distribution used to determine variant weights, two space delimited values. "1 1" is flat weights, "0.5 0.5" is proportional to the Madsen-Browning weights, and "1 25" gives the Wu weights. This parameter is ignored if weight_user is provided.
  type: string?
  sbg:toolDefaultValue: 1 1
- id: segment
  label: Segment number
  doc: Segment Number
  type: int?
  inputBinding:
    prefix: --segment
    position: 10
    shellQuote: false
  sbg:category: Input Options
- id: aggregate_type
  label: Aggregate type
  doc: |-
    Type of aggregate grouping. Options are to select variants by allele (unique variants) or position (regions of interest).
  type:
  - 'null'
  - name: aggregate_type
    type: enum
    symbols:
    - allele
    - position
  sbg:toolDefaultValue: Allele
- id: alt_freq_max
  label: Alt Freq Max
  doc: Maximum alternate allele frequency to consider.
  type: float?
  sbg:toolDefaultValue: '1'
- id: pass_only
  label: Pass only
  doc: TRUE to select only variants with FILTER=PASS.
  type: boolean?
  sbg:toolDefaultValue: 'TRUE'
- id: variant_weight_file
  label: Variant Weight file
  doc: Variant Weight file.
  type: File?
- id: weight_user
  label: Weight user
  doc: |-
    Name of column in variant_weight_file or variant_group_file containing the weight for each variant.
  type: string?
- id: cpu
  label: CPU
  doc: 'Number of CPUs for each tool job. Default value: 1.'
  type: int?
  sbg:category: Input options
  sbg:toolDefaultValue: '1'
- id: memory_gb
  label: memory GB
  doc: 'Memory in GB per job. Default value: 8.'
  type: float?
  sbg:category: Input options
  sbg:toolDefaultValue: '8'
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

outputs:
- id: assoc_aggregate
  label: Assoc aggregate output
  type: File?
  outputBinding:
    glob: |-
      ${
          /*
        if (!inputs.out_prefix) {
          comm = "assoc_aggregate*.RData"
        } else {
          	comm = inputs.out_prefix + ".RData"
        }
        return comm */
        return "*.RData"
      }
  sbg:fileTypes: RDATA
- id: config
  label: Config file
  type: File?
  outputBinding:
    glob: '*.config'
  sbg:fileTypes: CONFIG

baseCommand: []
arguments:
- prefix: ''
  position: 1
  valueFrom: |-
    ${
        var cmd_line = "Rscript /usr/local/analysis_pipeline/R/assoc_aggregate.R assoc_aggregate.config ";

        function isNumeric(s) {

            return !isNaN(s - parseFloat(s));
        }

        function find_chromosome(file){

            var chr_array = [];
            var chrom_num = file.split("/").pop();
            chrom_num = chrom_num.split(".")[0]
            
            if(isNumeric(chrom_num.charAt(chrom_num.length-2)))
            {
                chr_array.push(chrom_num.substr(chrom_num.length - 2))
            }
            else
            {
                chr_array.push(chrom_num.substr(chrom_num.length - 1))
            }

            return chr_array.toString()
        }
        
    // 	chromosome = find_chromosome(inputs.gds_file.path)
    //     cmd_line += "--chromosome " + chromosome 
        return cmd_line
        
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
- class: sbg:SaveLogs
  value: job.out.log
id: boris_majic/genesis-toolkit-demo/assoc-aggregate/7
sbg:appVersion:
- v1.1
sbg:content_hash: a1fc9237f50620307a4def5c7ca276c1f610d84c729d5399e0e6d5b8a3da2ae5b
sbg:contributors:
- dajana_panovic
- boris_majic
sbg:createdBy: boris_majic
sbg:createdOn: 1577360633
sbg:id: h-2cd01937/h-3a1dba4d/h-b6926954/0
sbg:image_url:
sbg:latestRevision: 7
sbg:modifiedBy: dajana_panovic
sbg:modifiedOn: 1616077315
sbg:project: boris_majic/genesis-toolkit-demo
sbg:projectName: GENESIS Toolkit - DEMO
sbg:publisher: sbg
sbg:revision: 7
sbg:revisionNotes: Docker updated to uwgac/topmed-master:2.10.0
sbg:revisionsInfo:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577360633
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577360681
  sbg:revision: 1
  sbg:revisionNotes: Import from F4C
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584373824
  sbg:revision: 2
  sbg:revisionNotes: GDS filename corrected
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1594133421
  sbg:revision: 3
  sbg:revisionNotes: Docker image update 2.8.0
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602155215
  sbg:revision: 4
  sbg:revisionNotes: Import from BDC 2.8.1 version
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603797838
  sbg:revision: 5
  sbg:revisionNotes: BDC import
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608907090
  sbg:revision: 6
  sbg:revisionNotes: CWLtool prep
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1616077315
  sbg:revision: 7
  sbg:revisionNotes: Docker updated to uwgac/topmed-master:2.10.0
sbg:sbgMaintained: false
sbg:validationErrors: []
