cwlVersion: v1.1
class: CommandLineTool
label: null_model.R
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: ResourceRequirement
  coresMin: |-
    ${
        if(inputs.cpu){
            return inputs.cpu
        }
        else{
            return 1
        }
    }
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InitialWorkDirRequirement
  listing:
  - entryname: null_model.config
    writable: false
    entry: |-
      ${  

          var arg = [];
          if(inputs.output_prefix){
              var filename = inputs.output_prefix + "_null_model";
              arg.push('out_prefix \"' + filename + '\"');
              var phenotype_filename = inputs.output_prefix + "_phenotypes.RData";
              arg.push('out_phenotype_file \"' + phenotype_filename + '\"');
          }
          else{
              arg.push('out_prefix "null_model"');
              arg.push('out_phenotype_file "phenotypes.RData"');
          }
          arg.push('outcome ' + inputs.outcome);
          arg.push('phenotype_file "' + inputs.phenotype_file.basename + '"');
          if(inputs.gds_files){
              
             function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
             }    
              
             var gds = inputs.gds_files[0].path.split('/').pop();    
             var right = gds.split('chr')[1];
             var chr = [];
             
             if(isNumeric(parseInt(right.charAt(1)))) chr.push(right.substr(0,2))
             else chr.push(right.substr(0,1))
             
              arg.push('gds_file "' + inputs.gds_files[0].basename.split("chr")[0] + "chr "+gds.split("chr"+chr)[1] +'"')
              
              
          }
          if(inputs.pca_file){
              arg.push('pca_file "' + inputs.pca_file.basename + '"')
          }
          if(inputs.relatedness_matrix_file){
              arg.push('relatedness_matrix_file "' + inputs.relatedness_matrix_file.basename + '"')
          }
          if(inputs.family){
              arg.push('family ' + inputs.family)
          }
          if(inputs.conditional_variant_file){
              arg.push('conditional_variant_file "' + inputs.conditional_variant_file.basename + '"')
          }
          if(inputs.covars){
              var temp = [];
              for(var i=0; i<inputs.covars.length; i++){
                  temp.push(inputs.covars[i])
              }
              arg.push('covars "' + temp.join(' ') + '"')
          }
          if(inputs.group_var){
              arg.push('group_var "' + inputs.group_var + '"')
          }
          if(inputs.inverse_normal){
              arg.push('inverse_normal ' + inputs.inverse_normal)
          }
          if(inputs.n_pcs){
              if(inputs.n_pcs > 0)
                  arg.push('n_pcs ' + inputs.n_pcs)
          }
          if(inputs.rescale_variance){
              arg.push('rescale_variance "' + inputs.rescale_variance + '"')
          }
          if(inputs.resid_covars){
              arg.push('resid_covars ' + inputs.resid_covars)
          }
          if(inputs.sample_include_file){
              arg.push('sample_include_file "' + inputs.sample_include_file.basename + '"')
          }
          if(inputs.norm_bygroup){
              arg.push('norm_bygroup ' + inputs.norm_bygroup)
          }
          return arg.join('\n')
      }
  - writable: true
    entry: "${\n    return inputs.phenotype_file\n}"
  - writable: true
    entry: "${\n    return inputs.gds_files\n}"
  - writable: true
    entry: "${\n    return inputs.pca_file\n}"
  - writable: true
    entry: "${\n    return inputs.relatedness_matrix_file\n}"
  - writable: true
    entry: "${\n    return inputs.conditional_variant_file\n}"
  - writable: true
    entry: "${\n    return inputs.sample_include_file\n}"
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
- id: outcome
  label: Outcome
  doc: Name of column in Phenotype File containing outcome variable.
  type: string
  sbg:category: Configs
- id: phenotype_file
  label: Phenotype file
  doc: RData file with AnnotatedDataFrame of phenotypes.
  type: File
  sbg:category: Categories
  sbg:fileTypes: RDATA
- id: gds_files
  label: GDS Files
  doc: List of gds files. Required if conditional_variant_file is specified.
  type: File[]?
  sbg:altPrefix: GDS file.
  sbg:category: Configs
  sbg:fileTypes: GDS
- id: pca_file
  label: PCA File
  doc: RData file with PCA results created by PC-AiR.
  type: File?
  sbg:category: Configs
  sbg:fileTypes: RDATA
- id: relatedness_matrix_file
  label: Relatedness matrix file
  doc: RData or GDS file with a kinship matrix or GRM.
  type: File?
  sbg:category: Categories
  sbg:fileTypes: GDS, RDATA, RData
- id: family
  label: Family
  doc: |-
    Depending on the output type (quantitative or qualitative) one of possible values should be chosen: Gaussian, Binomial, Poisson.
  type:
    name: family
    type: enum
    symbols:
    - gaussian
    - poisson
    - binomial
  sbg:category: Configs
  sbg:toolDefaultValue: gaussian
- id: conditional_variant_file
  label: Conditional Variant File
  doc: |-
    RData file with data frame of of conditional variants. Columns should include chromosome and variant.id. The alternate allele dosage of these variants will be included as covariates in the analysis.
  type: File?
  sbg:category: Configs
  sbg:fileTypes: RDATA
- id: covars
  label: Covariates
  doc: Names of columns phenotype_file containing covariates.
  type: string[]?
- id: group_var
  label: Group variate
  doc: |-
    Name of covariate to provide groupings for heterogeneous residual error variances in the mixed model.
  type: string?
  sbg:category: Configs
- id: inverse_normal
  label: Inverse normal
  doc: |-
    TRUE if an inverse-normal transform should be applied to the outcome variable. If Group variate is provided, the transform is done on each group separately.
  type:
  - 'null'
  - name: inverse_normal
    type: enum
    symbols:
    - 'TRUE'
    - 'FALSE'
  sbg:category: Configs
  sbg:toolDefaultValue: 'TRUE'
- id: n_pcs
  label: Number of PCs to include as covariates
  doc: Number of PCs to include as covariates.
  type: int?
  sbg:category: Configs
  sbg:toolDefaultValue: '3'
- id: rescale_variance
  label: Rescale variance
  doc: |-
    Applies only if Inverse normal is TRUE and Group variate is provided. Controls whether to rescale the variance for each group after inverse-normal transform, restoring it to the original variance before the transform. Options are marginal, varcomp, or none.
  type:
  - 'null'
  - name: rescale_variance
    type: enum
    symbols:
    - marginal
    - varcomp
    - none
  sbg:category: Configs
  sbg:toolDefaultValue: marginal
- id: resid_covars
  label: Residual covariates
  doc: |-
    Applies only if Inverse normal is TRUE. Logical for whether covariates should be included in the second null model using the residuals as the outcome variable.
  type:
  - 'null'
  - name: resid_covars
    type: enum
    symbols:
    - 'TRUE'
    - 'FALSE'
  sbg:category: Configs
  sbg:toolDefaultValue: 'TRUE'
- id: sample_include_file
  label: Sample include file
  doc: RData file with vector of sample.id to include.
  type: File?
  sbg:category: Configs
  sbg:fileTypes: RDATA
- id: cpu
  label: CPU
  doc: 'Number of CPUs for each tool job. Default value: 1.'
  type: int?
  sbg:category: Input Options
  sbg:toolDefaultValue: '1'
- id: output_prefix
  label: Output prefix
  doc: Base for all output file names. By default it is null_model.
  type: string?
  sbg:category: Configs
  sbg:toolDefaultValue: null_model
- id: norm_bygroup
  label: Norm by group
  doc: |-
    If TRUE and group_var is provided, the inverse normal transform is done on each group separately.
  type:
  - 'null'
  - name: norm_bygroup
    type: enum
    symbols:
    - 'TRUE'
    - 'FALSE'
  sbg:category: General
  sbg:toolDefaultValue: 'FALSE'

outputs:
- id: configs
  label: Config files
  doc: Config files.
  type: File[]?
  outputBinding:
    glob: '*.config*'
- id: null_model_phenotypes
  label: Null model Phenotypes file
  doc: Phenotypes file
  type: File?
  outputBinding:
    glob: |-
      ${
          if(inputs.null_model_file)
          {
              return inputs.phenotype_file.basename
          }
          else
          {
              return "*phenotypes.RData"
          }
      }
    outputEval: $(inheritMetadata(self, inputs.phenotype_file))
  sbg:fileTypes: RData
- id: null_model_files
  label: Null model file
  doc: Null model file.
  type: File[]?
  outputBinding:
    glob: |-
      ${
          if(inputs.null_model_file)
          {
              return inputs.null_model_file.basename
          }
          else
          {
              if(inputs.output_prefix)
              {
                  return inputs.output_prefix + '_null_model*RData'
              }
              return "*null_model*RData"
          }
      }
  sbg:fileTypes: RData
- id: null_model_params
  label: Parameter file
  doc: Parameter file
  type: File?
  outputBinding:
    glob: '*.params'
  sbg:fileTypes: params
- id: null_model_output
  type: File[]?
  outputBinding:
    glob: |-
      ${
          if(inputs.null_model_file)
          {
              return inputs.null_model_file.basename
          }
          else
          {
              if(inputs.output_prefix)
              {
                  return inputs.output_prefix + '_null_model*RData'
              }
              return "*null_model*RData"
          }
      }
    outputEval: |-
      ${
          var result = []
          var len = self.length
          var i;

          for(i=0; i<len; i++){
              if(!self[i].path.split('/')[self[0].path.split('/').length-1].includes('reportonly')){
                  result.push(self[i])
              }
          }
          return result
      }

baseCommand: []
arguments:
- prefix: ''
  position: 1
  valueFrom: |-
    ${
            return "Rscript /usr/local/analysis_pipeline/R/null_model.R null_model.config"
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
id: boris_majic/genesis-toolkit-demo/null-model-r/9
sbg:appVersion:
- v1.1
sbg:content_hash: a29ebdb2dd77dd3a1b21a60950dc736723d2cd50f33c9702ef7ea9b21de79e471
sbg:contributors:
- dajana_panovic
- boris_majic
sbg:createdBy: boris_majic
sbg:createdOn: 1577361146
sbg:id: h-2e1ffaa6/h-23c7dac1/h-31aca52f/0
sbg:image_url:
sbg:latestRevision: 9
sbg:modifiedBy: dajana_panovic
sbg:modifiedOn: 1616077473
sbg:project: boris_majic/genesis-toolkit-demo
sbg:projectName: GENESIS Toolkit - DEMO
sbg:publisher: sbg
sbg:revision: 9
sbg:revisionNotes: Docker updated to uwgac/topmed-master:2.10.0
sbg:revisionsInfo:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577361146
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577361172
  sbg:revision: 1
  sbg:revisionNotes: Import from F4C
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1579790667
  sbg:revision: 2
  sbg:revisionNotes: Binary is now required
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584373307
  sbg:revision: 3
  sbg:revisionNotes: GDS filename corrected
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1594133109
  sbg:revision: 4
  sbg:revisionNotes: Docker image updated to 2.8.0
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602155608
  sbg:revision: 5
  sbg:revisionNotes: Import from BDC 2.8.1 version
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602573604
  sbg:revision: 6
  sbg:revisionNotes: Reportonly excluded
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603284245
  sbg:revision: 7
  sbg:revisionNotes: Family correct
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608904208
  sbg:revision: 8
  sbg:revisionNotes: CWLtool prep
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1616077473
  sbg:revision: 9
  sbg:revisionNotes: Docker updated to uwgac/topmed-master:2.10.0
sbg:sbgMaintained: false
sbg:validationErrors: []
