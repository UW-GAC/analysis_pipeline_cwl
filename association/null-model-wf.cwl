cwlVersion: v1.1
class: Workflow
label: GENESIS Null Model
doc: |-
  **Null Model** workflow fits the regression or mixed effects model under the null hypothesis of no genotype effects. i.e., The outcome variable is regressed on the specified fixed effect covariates and random effects. The output of this null model is then used in the association tests.

  Quantitative and binary outcomes are both supported. Set parameter **family** to gaussian, binomial or poisson depending on the outcome type. Fixed effect covariates from the **Phenotype file** are specified using the **Covariates** parameter, and ancestry principal components can be included as fixed effects using the **PCA Files** and **Number of PCs to include as covariates** parameters. A kinship matrix (KM) or genetic relationship matrix (GRM) can be provided using the **Relatedness matrix file** parameter to account for genetic similarity among samples as a random effect. 

  When no **Relatedness matrix file** is provided, standard linear regression is used if the parameter **family** is set to gaussian, logistic regression is used if the parameter **family** is set to binomial and poisson regression is used in case when **family** is set to poisson. When **Relatedness matrix file** is provided, a linear mixed model (LMM) is fit if **family** is set to gaussian, or a generalized linear mixed model (GLMM) is fit using the [GMMAT method](https://doi.org/10.1016/j.ajhg.2016.02.012) if **family** is set to binomial or poisson. For either the LMM or GLMM, the [AI-REML algorithm](https://doi.org/10.1111/jbg.12398) is used to estimate the variance components and fixed effects parameters.
   
  When samples come from multiple groups (e.g., study or ancestry group), it is common to observe different variances by group for quantitative traits. It is recommended to allow the null model to fit heterogeneous residual variances by group using the parameter group_var. This often provides better control of false positives in subsequent association testing. Note that this only applies when **family** is set to gaussian.

  Rank-based inverse Normal transformation is supported for quantitative outcomes via the inverse_normal parameter. This parameter is TRUE by default. When **inverse normal** parameter is set to TRUE, (1) the null model is fit using the original outcome values, (2) the marginal residuals are rank-based inverse Normal transformed, and (3) the null model is fit again using the transformed residuals as the outcome; fixed effects and random effects are included both times the null model is fit. It has been shown that this fully adjusted two-stage procedure provides better false positive control and power in association tests than simply inverse Normalizing the outcome variable prior to analysis [(**reference**)](https://doi.org/10.1002/gepi.22188).

  This workflow utilizes the *fitNullModel* function from the [GENESIS](doi.org/10.1093/bioinformatics/btz567) software.

  Workflow consists of two steps. First step fits the null model, and the second one generates reports based on data. Reports are available both in RMD and HTML format. If **inverse normal** is TRUE, reports are generated for the model both before and after the transformation.
  Reports contain the following information: Config info, phenotype distributions, covariate effect size estimates, marginal residuals, adjusted phenotype values and session information.

  ### Common use cases:
  This workflow is the first step in association testing. This workflow fits the null model and produces several files which are used in the association testing workflows:
  * Null model file which contains adjusted outcome values, the model matrix, the estimated covariance structure, and other parameters required for downstream association testing. This file will be input in association testing workflows.
  * Phenotype file which is a subset of the provided phenotype file, containing only the outcome and covariates used in fitting null model.
  * *Reportonly* null model file which is used to generate the report for the association test


  This workflow can be used for trait heritability estimation.

  Individual genetic variants or groups of genetic variants can be directly tested for association with this workflow by including them as fixed effect covariates in the model (via the **Conditional Variant File** parameter). This would be extremely inefficient genome-wide, but is useful for follow-up analyses testing variants of interest.


  ### Common issues and important notes:
  * If **PCA File** is not provided, the **Number of PCs to include as covariates** parameter **must** be set to 0.

  * **PCA File** must be an RData object output from the *pcair* function in the GENESIS package.

  * The null model job can be very computationally demanding in large samples (e.g. > 20K). GENESIS supports using sparse representations of matrices in the **Relatedness matrix file** via the R Matrix package, and this can substantially reduce memory usage and CPU time.

  ### Performance Benchmarking

  In the following table you can find estimates of running time and cost on spot instances. 
        

  | Sample Count | Relatedness matrix   | Duration   | Cost - spot ($)  |  Instance (AWS)  |
  |--------------------|----------------------------|-------------|---------------------|------------------------|
  | 2.5k samples  |                 | 4 min                 | $0.01   |   1x c4.xlarge |
  | 2.5k samples  | sparse     | 5 min                 | $0.01   |   1x c4.xlarge |
  | 2.5k samples  | dense      | 5 min                 | $0.01   |   1x c4.xlarge |
  | 10k samples   |                 | 6 min                 | $0.06   |   1x r4.8xlarge |
  | 10k samples   | sparse     | 7 min                 | $0.07   |   1x r4.8xlarge |
  | 10k samples   | dense      | 16 min               | $0.13    |   1x r4.8xlarge |
  | 36k samples  |                 | 7 min                 | $0.06    |   1x r4.8xlarge |
  | 36k samples  | sparse     | 24 min               | $0.27    |   1x r4.8xlarge |
  | 36k samples  | dense      | 52 min               | $0.56    |   1x r4.8xlarge |
  | 54k samples  |                 | 7 min                 | $0.07     |   1x r4.8xlarge |
  | 54k samples  | sparse     | 32 min               | $0.36    |   1x r4.8xlarge |
  | 54k samples  | dense      | 2 h                     | $1.5       | 1x r4.8xlarge |


  *Cost shown here were obtained with **spot instances** enabled. Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: sample_include_file
  label: Sample include file
  doc: |-
    RData file with a vector of sample.id to include. If not provided, all samples in the Phenotype file will be included in the analysis.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -608.4528198242188
  sbg:y: -792.2285766601562
- id: relatedness_matrix_file
  label: Relatedness matrix file
  doc: |-
    RData or GDS file with a kinship matrix or genetic relatedness matrix (GRM). For RData files, R object type may be “matrix” or “Matrix”. For very large sample sizes, a block diagonal sparse Matrix object from the “Matrix” package is recommended.
  type: File?
  sbg:fileTypes: GDS, RDATA
  sbg:x: -611
  sbg:y: -661
- id: phenotype_file
  label: Phenotype file
  doc: |-
    RData file with an AnnotatedDataFrame of phenotypes and covariates. Sample identifiers must be in column named “sample.id”.
  type: File
  sbg:fileTypes: RDATA
  sbg:x: -779.132080078125
  sbg:y: -731.9622802734375
- id: pca_file
  label: PCA File
  doc: |-
    RData file containing principal components for ancestry adjustment. R object type may be “pcair”, data.frame, or matrix. Row names must contain sample identifiers.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -877.1132202148438
  sbg:y: -620.0188598632812
- id: output_prefix
  label: Output prefix
  doc: Base for all output file names. By default it is null_model.
  type: string?
  sbg:x: -693.75
  sbg:y: -475.75
- id: gds_files
  label: GDS Files
  doc: |-
    List of gds files with genotype data for variants to be included as covariates for conditional analysis. Only required if Conditional Variant file is specified.
  type: File[]?
  sbg:fileTypes: GDS
  sbg:x: -726.8867797851562
  sbg:y: -351.88677978515625
- id: inverse_normal
  label: Two stage model
  doc: |-
    TRUE if a two-stage model should be implemented. Stage 1: a null model is fit using the original outcome variable. Stage 2: a second null model is fit using the inverse-normal transformed residuals from Stage 1 as the outcome variable. When FALSE, only the Stage 1 model is fit.  Only applies when Family is “gaussian”.
  type:
  - 'null'
  - name: inverse_normal
    type: enum
    symbols:
    - 'TRUE'
    - 'FALSE'
  sbg:toolDefaultValue: 'TRUE'
  sbg:x: -565.0943603515625
  sbg:y: -251.3773651123047
- id: conditional_variant_file
  label: Conditional variant file
  doc: |-
    RData file with a data.frame of identifiers for variants to be included as covariates for conditional analysis. Columns should include “chromosome” and “variant.id” that match the variant.id in the GDS files. The alternate allele dosage of these variants will be included as covariates in the analysis.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -365.25
  sbg:y: -231.75
- id: rescale_variance
  label: Rescale residuals
  doc: |-
    Applies only if Two stage model is TRUE. Controls whether to rescale the inverse-normal transformed residuals before fitting the Stage 2 null model, restoring the values to their original scale before the transform. “Marginal” rescales by the standard deviation of the marginal residuals from the Stage 1 model. “Varcomp” rescales by an estimate of the standard deviation based on the Stage 1 model variance component estimates; this can only be used if Norm by group is TRUE. “None” does not rescale.
  type:
  - 'null'
  - name: rescale_variance
    type: enum
    symbols:
    - marginal
    - varcomp
    - none
  sbg:toolDefaultValue: Marginal
  sbg:x: -576
  sbg:y: -43.5
- id: outcome
  label: Outcome
  doc: Name of column in Phenotype file containing outcome variable.
  type: string
  sbg:x: -671.5
  sbg:y: 1
- id: norm_bygroup
  label: Norm by group
  doc: |-
    Applies only if Two stage model is TRUE and Group variate is provided. If TRUE,the inverse-normal transformation (and rescaling) is done on each group separately. If FALSE, this is done on all samples jointly.
  type:
  - 'null'
  - name: norm_bygroup
    type: enum
    symbols:
    - 'TRUE'
    - 'FALSE'
  sbg:toolDefaultValue: 'FALSE'
  sbg:x: -562.75
  sbg:y: 133
- id: n_pcs
  label: Number of PCs to include as covariates
  doc: Number of PCs from PCA file to include as covariates.
  type: int?
  sbg:toolDefaultValue: '0'
  sbg:x: -651.81103515625
  sbg:y: 180.75
- id: group_var
  label: Group variate
  doc: |-
    Name of column in Phenotype file providing groupings for heterogeneous residual error variances in the model. Only applies when Family is “gaussian”.
  type: string?
  sbg:x: -449.409423828125
  sbg:y: 285.0613098144531
- id: cpu
  label: CPU
  doc: Number of CPUs to use per job.
  type: int?
  sbg:toolDefaultValue: '1'
  sbg:x: -538
  sbg:y: 329.25
- id: covars
  label: Covariates
  doc: Names of columns in Phenotype file containing covariates.
  type: string[]?
  sbg:x: -619.25
  sbg:y: 377.5
- id: family
  label: Family
  doc: |-
    The distribution used to fit the model. Select “gaussian” for continuous outcomes, “binomial” for binary or case/control outcomes, or “poisson” for count outcomes.
  type:
    name: family
    type: enum
    symbols:
    - gaussian
    - poisson
    - binomial
  sbg:x: -463.0585021972656
  sbg:y: 69.44185638427734
- id: n_categories_boxplot
  label: Number of categories in boxplot
  doc: |-
    If a covariate has fewer than the specified value, boxplots will be used instead of scatter plots for that covariate in the null model report.
  type: int?
  sbg:x: 293.9433898925781
  sbg:y: 314.99371337890625

outputs:
- id: null_model_phenotypes
  label: Null model Phenotypes file
  doc: |-
    Phenotype file containing all covariates used in the model. This file should be used as the “Phenotype file” input for the GENESIS association testing workflows.
  type: File?
  outputSource:
  - null_model_r/null_model_phenotypes
  sbg:fileTypes: RDATA
  sbg:x: 529.75
  sbg:y: 81
- id: rmd_files
  label: Rmd files
  doc: R markdown files used to generate the HTML reports.
  type: File[]?
  outputSource:
  - null_model_report/rmd_files
  sbg:fileTypes: Rmd
  sbg:x: 834.340576171875
  sbg:y: -492.55523681640625
- id: html_reports
  label: HTML Reports
  doc: HTML Reports generated by the tool.
  type: File[]?
  outputSource:
  - null_model_report/html_reports
  sbg:fileTypes: html
  sbg:x: 822.75
  sbg:y: 24.75
- id: null_model_file
  label: Null model file
  type: File[]?
  outputSource:
  - null_model_r/null_model_output
  sbg:x: 501.5128173828125
  sbg:y: 291.2054138183594

steps:
- id: null_model_r
  label: Fit Null Model
  in:
  - id: outcome
    source: outcome
  - id: phenotype_file
    source: phenotype_file
  - id: gds_files
    source:
    - gds_files
  - id: pca_file
    source: pca_file
  - id: relatedness_matrix_file
    source: relatedness_matrix_file
  - id: family
    source: family
  - id: conditional_variant_file
    source: conditional_variant_file
  - id: covars
    source:
    - covars
  - id: group_var
    source: group_var
  - id: inverse_normal
    source: inverse_normal
  - id: n_pcs
    source: n_pcs
  - id: rescale_variance
    source: rescale_variance
  - id: sample_include_file
    source: sample_include_file
  - id: cpu
    source: cpu
  - id: output_prefix
    source: output_prefix
  - id: norm_bygroup
    source: norm_bygroup
  run: null-model-wf.cwl.steps/null_model_r.cwl
  out:
  - id: configs
  - id: null_model_phenotypes
  - id: null_model_files
  - id: null_model_params
  - id: null_model_output
  sbg:x: 112.75
  sbg:y: 112.25
- id: null_model_report
  label: Null Model Report
  in:
  - id: family
    source: family
  - id: inverse_normal
    source: inverse_normal
  - id: null_model_params
    source: null_model_r/null_model_params
  - id: phenotype_file
    source: phenotype_file
  - id: sample_include_file
    source: sample_include_file
  - id: pca_file
    source: pca_file
  - id: relatedness_matrix_file
    source: relatedness_matrix_file
  - id: null_model_files
    source:
    - null_model_r/null_model_files
  - id: output_prefix
    source: output_prefix
  - id: conditional_variant_file
    source: conditional_variant_file
  - id: gds_files
    source:
    - gds_files
  - id: n_categories_boxplot
    source: n_categories_boxplot
  run: null-model-wf.cwl.steps/null_model_report.cwl
  out:
  - id: html_reports
  - id: rmd_files
  sbg:x: 537
  sbg:y: -212.5
sbg:appVersion:
- v1.1
sbg:categories:
- GWAS
- CWL1.0
- Genomics
sbg:content_hash: a0ee3e47fb2127f277f84287abd53e315129ff99c8a8e2d411dcd2965feff6eb3
sbg:contributors:
- admin
sbg:createdBy: admin
sbg:createdOn: 1577727845
sbg:expand_workflow: false
sbg:id: admin/sbg-public-data/null-model/17
sbg:image_url: |-
  https://platform.sb.biodatacatalyst.nhlbi.nih.gov/ns/brood/images/admin/sbg-public-data/null-model/17.png
sbg:latestRevision: 17
sbg:license: MIT
sbg:links:
- id: https://github.com/UW-GAC/analysis_pipeline
  label: Source Code, Download
- id: doi.org/10.1093/bioinformatics/btz567
  label: Publication
- id: |-
    https://www.bioconductor.org/packages/release/bioc/vignettes/GENESIS/inst/doc/assoc_test.html
  label: Home Page
- id: https://bioconductor.org/packages/devel/bioc/manuals/GENESIS/man/GENESIS.pdf
  label: Documentation
sbg:modifiedBy: admin
sbg:modifiedOn: 1604053018
sbg:original_source: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/admin/sbg-public-data/null-model/17/raw/
sbg:project: admin/sbg-public-data
sbg:projectName: SBG Public Data
sbg:publisher: sbg
sbg:revision: 17
sbg:revisionNotes: Config cleaning
sbg:revisionsInfo:
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727845
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727845
  sbg:revision: 1
  sbg:revisionNotes: Revision for publishing
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727846
  sbg:revision: 2
  sbg:revisionNotes: Modify description in accordance to rewievs
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727846
  sbg:revision: 3
  sbg:revisionNotes: Modify description
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577807265
  sbg:revision: 4
  sbg:revisionNotes: Latest
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1585350124
  sbg:revision: 5
  sbg:revisionNotes: Binary is set to required
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1585350125
  sbg:revision: 6
  sbg:revisionNotes: GDS filename correction
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602161636
  sbg:revision: 7
  sbg:revisionNotes: Input descriptions update
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602161636
  sbg:revision: 8
  sbg:revisionNotes: Input descriptions update
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755635
  sbg:revision: 9
  sbg:revisionNotes: Import from BDC 2.8.1 version
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755636
  sbg:revision: 10
  sbg:revisionNotes: Input and output description updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755636
  sbg:revision: 11
  sbg:revisionNotes: Input and output descriptions updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755636
  sbg:revision: 12
  sbg:revisionNotes: Report only excluded from the outputs
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1603365046
  sbg:revision: 13
  sbg:revisionNotes: Family correct
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1603365047
  sbg:revision: 14
  sbg:revisionNotes: Null model file
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1604053017
  sbg:revision: 15
  sbg:revisionNotes: Config cleaning
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1604053018
  sbg:revision: 16
  sbg:revisionNotes: Config cleaning
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1604053018
  sbg:revision: 17
  sbg:revisionNotes: Config cleaning
sbg:sbgMaintained: false
sbg:toolAuthor: TOPMed DCC
sbg:validationErrors: []
