cwlVersion: v1.2
class: Workflow
label: VCF to GDS converter
doc: |-
  **VCF to GDS** workflow converts VCF or BCF files into Genomic Data Structure (GDS) format. GDS files are required by all workflows utilizing the GENESIS or SNPRelate R packages.

  Step 1 (*VCF to GDS*) converts  VCF or BCF files (one per chromosome) into GDS files, with option to keep a subset of **Format** fields (by default only *GT* field). (BCF files may be used instead of  VCF.) 

  Step 2 (Unique Variant IDs) ensures that each variant has a unique integer ID across the genome. 

  Step 3 (Check GDS) ensures that no important information is lost during conversion. If Check GDS fails, it is likely that there was an issue during the conversion.
  **Important note:** This step can be time consuming and therefore expensive. Also, failure of this tool is rare. For that reason we allows this step to be optional and it's turned off by default. To turn it on check yes at *check GDS* port. For information on differences in execution time and cost of the same task with and without check GDS  please refer to Benchmarking section.  

  ### Common use cases
  This workflow is used for converting VCF files to GDS files.

  ### Common issues and important notes
  * This pipeline expects that input **Variant files** are separated to be per chromosome and that files are properly named.  It is expected that chromosome is included in the file name in following format:  chr## , where ## is the name of the chromosome (1-24 or X, Y). Chromosome can be included at any part of the filename. Inputs can be in vcf, vcf.gz and bcf format.  Examples: Data_subset_chr1.vcf, Data_subset_chr1.vcf.gz, Data_chr1_subset.vcf, Data_subset_chr1.bcf. 



  * **Number of CPUs** parameter should only be used when working with VCF files. The workflow is unable to utilize more than one thread when working with BCF files, and will fail if number of threads is set for BCF conversion.

  * **Note:** Variant IDs in output workflow might be different than expected. Unique variants are assigned for one chromosome at a time, in ascending, natural order (1,2,..,24 or X,Y). Variant IDs are integer IDs unique to your data and do not map to *rsIDs* or any other standard identifier. Be sure to use *variant_id* file for down the line workflows generated based on GDS files created by this workflow.

  * **Note** This workflow has not been tested on datasets containing more than 62k samples. Since *check_gds* step is very both ram and storage memory demanding, increasing sample count might lead to task failure. In case of any task failure, feel free to contact our support.

  * **Note** **Memory GB** should be set when working with larger number of samples (more than 10k). During benchmarking, 4GB of memory were enough when working with 50k samples. This parameter is related to *VCF to GDS* step, different amount of memory is used in other steps.


  ### Changes introduced by Seven Bridges
  Final step of the workflow is writing checking status to stderr, and therefore it is stored in *job_err.log*, available in the platform *task stats and logs page*. If workflow completes successfully, it means that validation has passed, if workflow fails on *check_gds* step, it means that validation failed.

  ### Performance Benchmarking

  In the following table you can find estimates of running time and cost. 
        

  | Sample Count | Total sample size (GB) | Duration  | Cost - spot ($) |  Instance (AWS)  |
  |-------------------|-------------------|------------------|----------|-------------|------------|------------|
  | 1k samples | 0.2                    | 6m                 | 0.34 |  1x c5.18xlarge |
  | 50k simulated samples (VCF.GZ) | 200        | 1d4h                 | 134     |   4x c5.18xlarge |
  | 62k real samples (BCF) | 400                    | 2d11h                 | 139     | 1x c5.18xlarge |



  *Cost shown here were obtained with **spot instances** enabled. Visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances) for more details.*      

  **Note** Both at 50k samples, and 62k samples, termination of spot instance occurred, leading to higher duration and final cost. These results are not removed from benchmark as this behavior is usual and expected, and should be taken into account when using spot instances.


  ### API Python Implementation

  The app's draft task can also be submitted via the **API**. In order to learn how to get your **Authentication token** and **API endpoint** for the corresponding Platform visit our [documentation](https://github.com/sbg/sevenbridges-python#authentication-and-configuration).

  ```python
  from sevenbridges import Api

  authentication_token, api_endpoint = "enter_your_token", "enter_api_endpoint"
  api = Api(token=authentication_token, url=api_endpoint)
  # Get project_id/app_id from your address bar. Example: https://f4c.sbgenomics.com/u/your_username/project/app
  project_id, app_id = "your_username/project", "your_username/project/app"
  # Get file names from files in your project. Example: Names are taken from Data/Public Reference Files.
  inputs = {
      "input_gds_files": api.files.query(project=project_id, names=["basename_chr1.gds", "basename_chr2.gds", ..]),
      "phenotype_file": api.files.query(project=project_id, names=["name_of_phenotype_file"])[0],
      "null_model_file": api.files.query(project=project_id, names=["name_of_null_model_file"])[0]
  }
  task = api.tasks.create(name='Single Variant Association Testing - API Run', project=project_id, app=app_id, inputs=inputs, run=False)
  ```
  Instructions for installing and configuring the API Python client, are provided on [github](https://github.com/sbg/sevenbridges-python#installation). For more information about using the API Python client, consult [sevenbridges-python documentation](http://sevenbridges-python.readthedocs.io/en/latest/). **More examples** are available [here](https://github.com/sbg/okAPI).

  Additionally, [API R](https://github.com/sbg/sevenbridges-r) and [API Java](https://github.com/sbg/sevenbridges-java) clients are available. To learn more about using these API clients please refer to the [API R client documentation](https://sbg.github.io/sevenbridges-r/), and [API Java client documentation](https://docs.sevenbridges.com/docs/java-library-quickstart).
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ScatterFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: vcf_file
  label: Variants Files
  doc: Input Variants Files.
  type: File[]
  sbg:fileTypes: VCF, VCF.GZ, BCF, BCF.GZ
  sbg:x: -301.39886474609375
  sbg:y: -11
- id: memory_gb
  label: memory GB
  doc: |-
    Memory to allocate per job. For low number of samples (up to 10k), 1GB is usually enough. For larger number of samples, value should be set higher (50k samples ~ 4GB). Default: 4.
  type: float?
  sbg:x: -363
  sbg:y: 124
- id: format
  label: Format
  doc: VCF Format fields to keep in GDS file.
  type: string[]?
  sbg:toolDefaultValue: GT
  sbg:x: -351
  sbg:y: 305
- id: cpu
  label: Number of CPUs
  doc: 'Number of CPUs to use per job. Default value: 1.'
  type: int?
  sbg:x: -295
  sbg:y: 437
- id: check_gds_1
  label: check GDS
  doc: |-
    Choose “Yes” to check for conversion errors by comparing all values in the output GDS file against the input files. The total cost of the job will be ~10x higher if check GDS is “Yes.”
  type:
  - 'null'
  - name: check_gds
    type: enum
    symbols:
    - Yes
    - No
  sbg:toolDefaultValue: No
  sbg:x: -71.421875
  sbg:y: 406.5

outputs:
- id: unique_variant_id_gds_per_chr
  label: Unique variant ID corrected GDS files per chromosome
  doc: |-
    GDS files in which each variant has a unique identifier across the entire genome. For example, if chromosome 1 has 100 variants and chromosome 2 has 100 variants, the variant.id field will contain 1:100 in the chromosome 1 file and 101:200 in the chromosome 2 file.
  type: File[]?
  outputSource:
  - unique_variant_id/unique_variant_id_gds_per_chr
  sbg:fileTypes: GDS
  sbg:x: 385.79351806640625
  sbg:y: 44.093116760253906

steps:
- id: vcf2gds
  label: vcf2gds
  in:
  - id: vcf_file
    source: vcf_file
  - id: memory_gb
    source: memory_gb
  - id: cpu
    source: cpu
  - id: format
    source:
    - format
  scatter:
  - vcf_file
  run: vcf-to-gds-wf.cwl.steps/vcf2gds.cwl
  out:
  - id: gds_output
  - id: config_file
  sbg:x: -71
  sbg:y: 184
- id: unique_variant_id
  label: Unique Variant ID
  in:
  - id: gds_file
    source:
    - vcf2gds/gds_output
  run: vcf-to-gds-wf.cwl.steps/unique_variant_id.cwl
  out:
  - id: unique_variant_id_gds_per_chr
  - id: config
  sbg:x: 138
  sbg:y: 97
- id: check_gds
  label: Check GDS
  in:
  - id: vcf_file
    source:
    - vcf_file
  - id: gds_file
    source: unique_variant_id/unique_variant_id_gds_per_chr
  - id: check_gds
    source: check_gds_1
  scatter:
  - gds_file
  run: vcf-to-gds-wf.cwl.steps/check_gds.cwl
  out: []
  sbg:x: 374.6356201171875
  sbg:y: 303.9109191894531

hints:
- class: sbg:AWSInstanceType
  value: c5.18xlarge;ebs-gp2;700
- class: sbg:maxNumberOfParallelInstances
  value: '5'
- class: sbg:AzureInstanceType
  value: Standard_F64s_v2;PremiumSSD;1024
sbg:appVersion:
- v1.2
sbg:categories:
- GWAS
- VCF Processing
- CWL1.0
sbg:content_hash: a54d80656c76a4e8eb4f163eb486c4ddc1eb77a51708313c7710f8966bc231a25
sbg:contributors:
- admin
sbg:createdBy: admin
sbg:createdOn: 1577727847
sbg:expand_workflow: false
sbg:id: admin/sbg-public-data/vcf-to-gds/19
sbg:image_url:
sbg:latestRevision: 19
sbg:license: MIT
sbg:links:
- id: https://github.com/UW-GAC/analysis_pipeline
  label: Source Code, Download
- id: |-
    https://academic.oup.com/bioinformatics/advance-article-abstract/doi/10.1093/bioinformatics/btz567/5536872?redirectedFrom=fulltext
  label: Publication
- id: |-
    https://www.bioconductor.org/packages/release/bioc/vignettes/GENESIS/inst/doc/assoc_test.html
  label: Home Page
- id: https://bioconductor.org/packages/devel/bioc/manuals/GENESIS/man/GENESIS.pdf
  label: Documentation
sbg:modifiedBy: admin
sbg:modifiedOn: 1632333810
sbg:original_source: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/admin/sbg-public-data/vcf-to-gds/19/raw/
sbg:project: admin/sbg-public-data
sbg:projectName: SBG Public Data
sbg:publisher: sbg
sbg:revision: 19
sbg:revisionNotes: uwgac/topmed-master:2.12.0
sbg:revisionsInfo:
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727847
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727848
  sbg:revision: 1
  sbg:revisionNotes: Revision for publishing
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727848
  sbg:revision: 2
  sbg:revisionNotes: Modify description according to review
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727848
  sbg:revision: 3
  sbg:revisionNotes: Modify description in accordance to reviews
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727848
  sbg:revision: 4
  sbg:revisionNotes: Modify description
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577807265
  sbg:revision: 5
  sbg:revisionNotes: Latest
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1585350123
  sbg:revision: 6
  sbg:revisionNotes: Updated unique variant ID
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1585350124
  sbg:revision: 7
  sbg:revisionNotes: Import from BDC
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602161636
  sbg:revision: 8
  sbg:revisionNotes: Input descriptions update
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755636
  sbg:revision: 9
  sbg:revisionNotes: Import from BDC 2.8.1 version
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755636
  sbg:revision: 10
  sbg:revisionNotes: Input and output descriptions updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1604053019
  sbg:revision: 11
  sbg:revisionNotes: Config cleaning
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1612797361
  sbg:revision: 12
  sbg:revisionNotes: Description updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1612797368
  sbg:revision: 13
  sbg:revisionNotes: CWLtool compatible
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1612797368
  sbg:revision: 14
  sbg:revisionNotes: GENESIS VCF to GDS renamed to VCF to GDS converter
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1617276237
  sbg:revision: 15
  sbg:revisionNotes: Docker updated to uwgac/topmed-master:2.10.0
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1621514961
  sbg:revision: 16
  sbg:revisionNotes: Check GDS job memory updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1621514961
  sbg:revision: 17
  sbg:revisionNotes: Azure instance hint added
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1624463206
  sbg:revision: 18
  sbg:revisionNotes: Azure hint change
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1632333810
  sbg:revision: 19
  sbg:revisionNotes: uwgac/topmed-master:2.12.0
sbg:sbgMaintained: false
sbg:toolAuthor: TOPMed DCC
sbg:validationErrors: []
sbg:workflowLanguage: CWL
