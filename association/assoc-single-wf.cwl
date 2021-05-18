cwlVersion: v1.1
class: Workflow
label: GENESIS Single Variant Association Testing
doc: |-
  **Single Variant workflow** runs single-variant association tests. It consists of several steps. Define Segments divides genome into segments, either by a number of segments, or by a segment length. Note that number of segments refers to whole genome, not a number of segments per chromosome. Association test is then performed for each segment in parallel, before combining results on chromosome level. Final step produces QQ and Manhattan plots.

  This workflow uses the output from a model fit using the null model workflow to perform score tests for all variants individually. The reported effect estimate is for the alternate allele, and multiple alternate alleles for a single variant are tested separately.

  When testing a binary outcome, the saddlepoint approximation (SPA) for p-values [1][2] can be used by specifying **Test type** = ‘score.spa’; this is generally recommended. SPA will provide better calibrated p-values, particularly for rarer variants in samples with case-control imbalance. 

  When testing a binary outcome, the BinomiRare test is also available[3]. This is a “carriers only” exact test that compares the observed number of variant carriers who are cases to the expected number based on the probability of being a case under the null hypothesis of no association between outcome and variant. This test may be useful when testing association of very rare variants with rare outcomes.

  If your genotype data has sporadic missing values, they are mean imputed using the allele frequency observed in the sample.

  On the X chromosome, males have genotype values coded as 0/2 (females as 0/1/2).

  This workflow utilizes the *assocTestSingle* function from the GENESIS software [4].

  ### Common Use Cases

  Single Variant Association Testing workflow is designed to run single-variant association tests using GENESIS software. Set of variants on which to run association testing can be reduced by providing **Variant Include Files** - One file per chromosome containing variant IDs for variants on which association testing will be performed.


  ### Common issues and important notes
  * Association Testing - Single job can be very memory demanding, depending on number of samples and null model used. We suggest running with at least 5GB of memory allocated for small studies, and to use approximation of 0.5GB per thousand samples for larger studies (with more than 10k samples), but this again depends on complexity of null model. If a run fails with *error 137*, and with message killed, most likely cause is lack of memory. Memory can be allocated using the **memory GB** parameter.

  * This workflow expects **GDS** files split by chromosome, and will not work otherwise. If provided, **variant include** files must also be split in the same way. Also GDS and Variant include files should be properly named. It is expected that chromosome is included in the filename in following format: chr## , where ## is the name of the chromosome (1-24 or X, Y). Chromosome can be included at any part of the filename. Examples for GDS: data_subset_chr1.gds, data_chr1_subset.gds. Examples for Variant include files: variant_include_chr1.RData, chr1_variant_include.RData.

  * Some input arguments are mutually exclusive, for more information, please visit workflow [github page](https://github.com/UW-GAC/analysis_pipeline/tree/v2.5.0)

  ### Changes introduced by Seven Bridges
  There are no changes introduced by Seven Bridges.

  ### Performance Benchmarking

  In the following table you can find estimates of running time and cost. 
          

  | Samples &nbsp; &nbsp; |    | Rel. Matrix &nbsp; &nbsp;|Parallel instances &nbsp; &nbsp; | Instance type  &nbsp; &nbsp; &nbsp; &nbsp;| Spot/On Dem. &nbsp; &nbsp; |CPU &nbsp; &nbsp; | RAM &nbsp; &nbsp; | Time  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| Cost |
  |--------------------|---------------|----------------|------------------------|--------------------|--------------------|--------|--------|---------|-------|
  | 2.5k   |                 |   w/o          | 8                           |  r4.8xlarge | Spot     |1  | 2   | 1 h, 8 min   | $5  |
  | 2.5k   |               |   Dense     | 8                           |  r4.8xlarge | Spot     |1  | 2   | 1 h, 8 min   | $5  |
  | 10k   |                 |   w/o           | 8                           |  c5.18xlarge | On Demand     |1  | 2   | 50 min   | $10  |
  | 10k   |                |   Sparse     | 8                           |  c5.18xlarge | On Demand     |1  | 2   | 58 min   | $11  |
  | 10k   |                |   Sparse     | 8                           |  r4.8xlarge | On Demand     |1  | 2   | 1 h, 30 min   | $11  |
  | 10k   |                 |   Dense      | 8                           |  r5.4xlarge | On Demand     |1  | 8   | 3 h   | $24  |
  | 36k  |                  |   w/o           | 8                           |  r5.4xlarge | On Demand     |1  | 5   | 3 h, 20 min   | $27  |
  | 36k  |                  |   Sparse     | 8                           |  r5.4xlarge | On Demand     |1  | 5   | 4 h   | $32  |
  | 36k   |                  |   Sparse     | 8                           |  r5.12xlarge | On Demand     |1  | 5   | 1 h, 20 min   | $32  |
  | 36k   |                  |   Dense      | 8                           |  r5.12xlarge | On Demand     |1  | 50   | 1 d, 15 h   | $930  |
  | 36k   |                 |   Dense      | 8                           |  r5.24xlarge | On Demand     |1  | 50   | 17 h   | $800  |
  | 50k   |                  |   w/o           | 8                           |  r5.12xlarge | On Demand     |1  | 8   | 2 h   | $44  |
  | 50k   |                  |   Sparse     | 8                           |  r5.12xlarge | On Demand     |1  | 8   | 2 h   | $48 |
  | 50k   |                  |   Dense      | 8                           |  r5.24xlarge | On Demand     |48  | 100   | 11 d   | $13500  |
  | 2.5k   |                  |   w/o          | 8                           |  n1-standard-64 | Preemptible    |1  | 2   | 1 h   | $7  |
  | 2.5k   |                  |   Dense     | 8                           |  n1-standard-64 | Preemptible    |1  | 2   | 1 h   | $7  |
  | 10k   |                  |   w/o           | 8                           |  n1-standard-4 | On Demand     |1  | 2   | 1 h, 12 min  | $13  |
  | 10k   |                  |   Sparse     | 8                           |  n1-standard-4 | On Demand     |1  | 2   | 1 h, 13  min   | $14 |
  | 10k  |                  |   Dense      | 8                           |  n1-highmem-32 | On Demand     |1  | 8   | 2 h, 20  min   | $30  |
  | 36k   |                  |   w/o           | 8                           |  n1-standard-64 | On Demand     |1  | 5   | 1 h, 30  min   | $35  |
  | 36k   |                 |   Sparse     | 8                           |  n1-highmem-16 | On Demand     |1  | 5   | 4 h, 30  min   | $35  |
  | 36k   |                  |   Sparse     | 8                           |  n1-standard-64 | On Demand     |1  | 5   | 1 h, 30  min   | $35  |
  | 36k   |                  |   Dense      | 8                           |  n1-highmem-96 | On Demand     |1  | 50   | 1 d, 6  h   | $1300  |
  | 50k   |                  |   w/o           | 8                           |  n1-standard-96 | On Demand     |1  | 8    | 2  h   | $73  |
  | 50k   |                  |   Sparse     | 8                           |  n1-standard-96 | On Demand     |1  | 8    | 2  h   | $73  |
  | 50k   |                  |   Dense      | 8                           |  n1-highmem-96 | On Demand     |16  | 100    | 6  d   | $6600  |

  In tests performed we used 1000G (tasks with 2.5k participants) and TOPMed freeze5 datasets (tasks with 10k or more participants). 
  All these tests are done with applied **MAF >= 1%** filter. The number of variants that have been tested is **14 mio in 1000G** and **12 mio in TOPMed freeze 5** dataset. 

  Also, a common filter in these analysis is **MAC>=5**. In that case the number of variants would be **32 mio for 1000G** and **92 mio for TOPMed freeze5** data. Since for single variant testing, the compute time grows linearly with the number of variants tested the execution time and price can be easily estimated from the results above.

  *For more details on **spot/preemptible instances** please visit the [Knowledge Center](https://docs.sevenbridges.com/docs/about-spot-instances).*   


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


  ### References
  [1] [SaddlePoint Approximation (SPA)](https://doi.org/10.1016/j.ajhg.2017.05.014)  
  [2] [SPA - additional reference](https://doi.org/10.1038/s41588-018-0184-y)  
  [3] [BinomiRare](https://pubmed.ncbi.nlm.nih.gov/28393384/)  
  [4] [GENESIS toolkit](doi.org/10.1093/bioinformatics/btz567)
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ScatterFeatureRequirement
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: segment_length
  label: Segment length
  doc: Segment length in kb, used for parallelization.
  type: int?
  sbg:toolDefaultValue: 10000kb
  sbg:x: -361
  sbg:y: -204
- id: n_segments
  label: Number of segments
  doc: |-
    Number of segments, used for parallelization (overrides Segment length). Note that this parameter defines the number of segments for the entire genome, so using this argument with selected chromosomes may result in fewer segments than you expect (and the minimum is one segment per chromosome).
  type: int?
  sbg:x: -484
  sbg:y: -88
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
  sbg:toolDefaultValue: hg38
  sbg:x: -363
  sbg:y: 6
- id: variant_block_size
  label: Variant block size
  doc: |-
    Number of variants to read from the GDS file in a single block. For smaller sample sizes, increasing this value will reduce the number of iterations in the code. For larger sample sizes, values that are too large will result in excessive memory use.
  type: int?
  sbg:toolDefaultValue: '1024'
  sbg:x: 58.5833740234375
  sbg:y: 42.84904098510742
- id: test_type
  label: Test type
  doc: |-
    Type of association test to perform. “Score” performs a score test and can be used with any null model. “Score.spa” uses the saddle point approximation (SPA) to provide more accurate p-values, especially for rare variants, in samples with unbalanced case:control ratios; “score.spa” can only be used if the null model family is “binomial”. “BinomiRare” is a carriers only exact test that may perform better when testing very rare variants with rare outcomes; “BinomiRare” can only be used if the null model family is “binomial”.
  type:
  - 'null'
  - name: test_type
    type: enum
    symbols:
    - score
    - score.spa
    - BinomiRare
  sbg:toolDefaultValue: score
  sbg:x: -50
  sbg:y: 93
- id: phenotype_file
  label: Phenotype file
  doc: |-
    RData file with an AnnotatedDataFrame of phenotypes and covariates. Sample identifiers must be in column named “sample.id”. It is recommended to use the phenotype file output by the GENESIS Null Model app.
  type: File
  sbg:fileTypes: RDATA
  sbg:x: 57
  sbg:y: 150
- id: pass_only
  label: Pass only
  doc: |-
    TRUE to select only variants with FILTER=PASS. If FALSE, variants that failed the quality filter will be included in the test.
  type:
  - 'null'
  - name: pass_only
    type: enum
    symbols:
    - 'TRUE'
    - 'FALSE'
  sbg:toolDefaultValue: 'TRUE'
  sbg:x: -49
  sbg:y: 202
- id: null_model_file
  label: Null model file
  doc: |-
    RData file containing a null model object. Run the GENESIS Null Model app to create this file.
  type: File
  sbg:fileTypes: RDATA
  sbg:x: 60
  sbg:y: 268
- id: memory_gb
  label: memory GB
  doc: Memory in GB per job.
  type: float?
  sbg:toolDefaultValue: '8'
  sbg:x: -44
  sbg:y: 319
- id: maf_threshold
  label: MAF threshold
  doc: |-
    Minimum minor allele frequency for variants to include in test. Only used if MAC threshold is NA.
  type: float?
  sbg:toolDefaultValue: '0.001'
  sbg:x: 59
  sbg:y: 383
- id: mac_threshold
  label: MAC threshold
  doc: |-
    Minimum minor allele count for variants to include in test. Recommend to use a higher threshold when outcome is binary or count data. To disable it set it to NA.
  type: float?
  sbg:toolDefaultValue: '5'
  sbg:x: -42
  sbg:y: 432
- id: cpu
  label: CPU
  doc: Number of CPUs for each job.
  type: int?
  sbg:toolDefaultValue: '1'
  sbg:x: -46.285701751708984
  sbg:y: 548.0167846679688
- id: disable_thin
  label: Disable Thin
  doc: |-
    Logical for whether to thin points in the QQ and Manhattan plots. By default, points are thinned in dense regions to reduce plotting time. If this parameter is set to TRUE, all variant p-values will be included in the plots, and the plotting will be very long and memory intensive.
  type: boolean?
  sbg:toolDefaultValue: 'TRUE'
  sbg:x: 952.9915771484375
  sbg:y: 432.899169921875
- id: known_hits_file
  label: Known hits file
  doc: |-
    RData file with data.frame containing columns chr and pos. If provided, 1 Mb regions surrounding each variant listed will be omitted from the QQ and manhattan plots.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: 1070
  sbg:y: 407
- id: thin_nbins
  label: Thin N bins
  doc: Number of bins to use for thinning.
  type: int?
  sbg:toolDefaultValue: '10'
  sbg:x: 1052.4117431640625
  sbg:y: 253.57142639160156
- id: thin_npoints
  label: Thin N points
  doc: Number of points in each bin after thinning.
  type: int?
  sbg:toolDefaultValue: '10000'
  sbg:x: 934.3193359375
  sbg:y: 234
- id: out_prefix
  label: Output prefix
  doc: Prefix that will be included in all output files.
  type: string
  sbg:x: 74.62183380126953
  sbg:y: 502.3025207519531
- id: input_gds_files
  label: GDS files
  doc: |-
    GDS files with genotype data for variants to be tested for association. If multiple files are selected, they will be run in parallel. Files separated by chromosome are expected to have ‘chr##’ strings indicating chromosome number, where ‘##’ can be (1-24, X, Y). Output files for each chromosome will include the corresponding chromosome number.
  type: File[]
  sbg:fileTypes: GDS
  sbg:x: -358.317626953125
  sbg:y: -345.1597595214844
- id: truncate_pval_threshold
  label: Truncate pval threshold
  doc: Maximum p-value to display in truncated QQ and manhattan plots.
  type: float?
  sbg:x: 1158.9296875
  sbg:y: 598.3650512695312
- id: plot_mac_threshold
  label: Plot MAC threshold
  doc: |-
    Minimum minor allele count for variants or aggregate units to include in plots (if different from MAC threshold).
  type: int?
  sbg:x: 1044.307861328125
  sbg:y: 560.8524169921875
- id: variant_include_files
  label: Variant Include Files
  doc: RData file containing ids of variants to be included.
  type: File[]?
  sbg:fileTypes: RData
  sbg:x: 13.8739652633667
  sbg:y: -437.260498046875

outputs:
- id: assoc_combined
  label: Association test results
  doc: |-
    RData file with data.frame of association test results (test statistic, p-value, etc.) See the documentation of the GENESIS R package for detailed description of output.
  type: File[]?
  outputSource:
  - assoc_combine_r/assoc_combined
  sbg:fileTypes: RDATA
  sbg:x: 1370.5833740234375
  sbg:y: -3.150960683822632
- id: assoc_plots
  label: Association test plots
  doc: QQ and Manhattan Plots of p-values in association test results.
  type: File[]?
  outputSource:
  - assoc_plots_r/assoc_plots
  sbg:fileTypes: PNG
  sbg:x: 1577.5833740234375
  sbg:y: 331.8490295410156

steps:
- id: define_segments_r
  label: define_segments.R
  in:
  - id: segment_length
    source: segment_length
  - id: n_segments
    source: n_segments
  - id: genome_build
    source: genome_build
  run: assoc-single-wf.cwl.steps/define_segments_r.cwl
  out:
  - id: config
  - id: define_segments_output
  sbg:x: -199.3984375
  sbg:y: -88
- id: assoc_single_r
  label: Association Testing Single
  in:
  - id: gds_file
    valueFrom: '$(self ? [].concat(self)[0] : self)'
    source:
    - sbg_prepare_segments_1/gds_output
    linkMerge: merge_flattened
  - id: null_model_file
    source: null_model_file
  - id: phenotype_file
    source: phenotype_file
  - id: mac_threshold
    source: mac_threshold
  - id: maf_threshold
    source: maf_threshold
  - id: pass_only
    source: pass_only
  - id: segment_file
    valueFrom: '$(self ? [].concat(self)[0] : self)'
    source:
    - define_segments_r/define_segments_output
    linkMerge: merge_flattened
  - id: test_type
    source: test_type
  - id: variant_include_file
    valueFrom: '$(self ? [].concat(self)[0] : self)'
    source:
    - sbg_prepare_segments_1/variant_include_output
    linkMerge: merge_flattened
  - id: segment
    valueFrom: '$(self ? [].concat(self)[0] : self)'
    source:
    - sbg_prepare_segments_1/segments
    linkMerge: merge_flattened
  - id: memory_gb
    default: 80
    source: memory_gb
  - id: cpu
    source: cpu
  - id: variant_block_size
    source: variant_block_size
  - id: out_prefix
    source: out_prefix
  - id: genome_build
    source: genome_build
  scatter:
  - gds_file
  - variant_include_file
  - segment
  scatterMethod: dotproduct
  run: assoc-single-wf.cwl.steps/assoc_single_r.cwl
  out:
  - id: configs
  - id: assoc_single
  sbg:x: 410
  sbg:y: 110
- id: assoc_combine_r
  label: Association Combine
  in:
  - id: chromosome
    valueFrom: '$(self ? [].concat(self) : self)'
    source:
    - sbg_group_segments_1/chromosome
  - id: assoc_type
    default: single
  - id: assoc_files
    valueFrom: '$(self ? [].concat(self) : self)'
    source:
    - sbg_group_segments_1/grouped_assoc_files
  - id: memory_gb
    default: 8
  - id: cpu
    default: 2
  scatter:
  - chromosome
  - assoc_files
  scatterMethod: dotproduct
  run: assoc-single-wf.cwl.steps/assoc_combine_r.cwl
  out:
  - id: assoc_combined
  - id: configs
  sbg:x: 1087
  sbg:y: 113
- id: assoc_plots_r
  label: Association Plots
  in:
  - id: assoc_files
    valueFrom: '$(self ? [].concat(self) : self)'
    source:
    - assoc_combine_r/assoc_combined
    linkMerge: merge_flattened
  - id: assoc_type
    default: single
  - id: plots_prefix
    source: out_prefix
  - id: disable_thin
    source: disable_thin
  - id: known_hits_file
    source: known_hits_file
  - id: thin_npoints
    source: thin_npoints
  - id: thin_nbins
    source: thin_nbins
  - id: plot_mac_threshold
    source: plot_mac_threshold
  - id: truncate_pval_threshold
    source: truncate_pval_threshold
  run: assoc-single-wf.cwl.steps/assoc_plots_r.cwl
  out:
  - id: assoc_plots
  - id: configs
  - id: Lambdas
  sbg:x: 1367
  sbg:y: 306
- id: sbg_gds_renamer
  label: SBG GDS renamer
  in:
  - id: in_variants
    source: input_gds_files
  scatter:
  - in_variants
  run: assoc-single-wf.cwl.steps/sbg_gds_renamer.cwl
  out:
  - id: renamed_variants
  sbg:x: -138.8903045654297
  sbg:y: -234.21176147460938
- id: sbg_flatten_lists
  label: SBG FlattenLists
  in:
  - id: input_list
    valueFrom: |-
      ${     var out = [];     for (var i = 0; i<self.length; i++){         if (self[i])    out.push(self[i])     }     return out }
    source:
    - assoc_single_r/assoc_single
  run: assoc-single-wf.cwl.steps/sbg_flatten_lists.cwl
  out:
  - id: output_list
  sbg:x: 684.666015625
  sbg:y: 128.0019073486328
- id: sbg_prepare_segments_1
  label: SBG Prepare Segments
  in:
  - id: input_gds_files
    source:
    - sbg_gds_renamer/renamed_variants
  - id: segments_file
    source: define_segments_r/define_segments_output
  - id: variant_include_files
    source:
    - variant_include_files
  run: assoc-single-wf.cwl.steps/sbg_prepare_segments_1.cwl
  out:
  - id: gds_output
  - id: segments
  - id: aggregate_output
  - id: variant_include_output
  sbg:x: 76.38661193847656
  sbg:y: -183.02523803710938
- id: sbg_group_segments_1
  label: SBG Group Segments
  in:
  - id: assoc_files
    source:
    - sbg_flatten_lists/output_list
  run: assoc-single-wf.cwl.steps/sbg_group_segments_1.cwl
  out:
  - id: grouped_assoc_files
  - id: chromosome
  sbg:x: 855.9915771484375
  sbg:y: 119.47896575927734

hints:
- class: sbg:maxNumberOfParallelInstances
  value: '8'
sbg:appVersion:
- v1.1
sbg:categories:
- GWAS
- CWL1.0
- Genomics
sbg:content_hash: a779487b2aeb97311196b11a6c99fa6f26bfb80e981ac1113e328ba9b4706c6f9
sbg:contributors:
- admin
sbg:createdBy: admin
sbg:createdOn: 1577727843
sbg:expand_workflow: false
sbg:id: admin/sbg-public-data/single-variant-association-testing/25
sbg:image_url:
sbg:latestRevision: 25
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
sbg:modifiedOn: 1617276240
sbg:original_source: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/admin/sbg-public-data/single-variant-association-testing/25/raw/
sbg:project: admin/sbg-public-data
sbg:projectName: SBG Public Data
sbg:publisher: sbg
sbg:revision: 25
sbg:revisionNotes: Plot update
sbg:revisionsInfo:
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727843
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727843
  sbg:revision: 1
  sbg:revisionNotes: Revision for publishing
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727844
  sbg:revision: 2
  sbg:revisionNotes: Modify description according to reviews
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727844
  sbg:revision: 3
  sbg:revisionNotes: Modify description
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727844
  sbg:revision: 4
  sbg:revisionNotes: CWL1.0
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577728861
  sbg:revision: 5
  sbg:revisionNotes: Label
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577807264
  sbg:revision: 6
  sbg:revisionNotes: Latest
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1585350122
  sbg:revision: 7
  sbg:revisionNotes: SBG GDS Renamer added and output prefix exposed
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1585350123
  sbg:revision: 8
  sbg:revisionNotes: Description updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602161634
  sbg:revision: 9
  sbg:revisionNotes: SBG FlattenList updated to CWL1.0
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602161635
  sbg:revision: 10
  sbg:revisionNotes: Input descriptions updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755636
  sbg:revision: 11
  sbg:revisionNotes: Import from BDC 2.8.1 version
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755636
  sbg:revision: 12
  sbg:revisionNotes: Input and output descriptions update
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755636
  sbg:revision: 13
  sbg:revisionNotes: Input and output description update
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755637
  sbg:revision: 14
  sbg:revisionNotes: Plot prefix = Output prefix
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755637
  sbg:revision: 15
  sbg:revisionNotes: Description updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755637
  sbg:revision: 16
  sbg:revisionNotes: Description update
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1603365237
  sbg:revision: 17
  sbg:revisionNotes: ParseFloat instead parseInt
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1603365237
  sbg:revision: 18
  sbg:revisionNotes: ParseFloat
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1604053019
  sbg:revision: 19
  sbg:revisionNotes: Config cleaning
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1604053019
  sbg:revision: 20
  sbg:revisionNotes: Config cleaning
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1604053019
  sbg:revision: 21
  sbg:revisionNotes: Config cleaning
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1617276239
  sbg:revision: 22
  sbg:revisionNotes: CWLtool compatible
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1617276240
  sbg:revision: 23
  sbg:revisionNotes: BinomiRare option added to test_type
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1617276240
  sbg:revision: 24
  sbg:revisionNotes: Plot update
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1617276240
  sbg:revision: 25
  sbg:revisionNotes: Plot update
sbg:sbgMaintained: false
sbg:toolAuthor: TOPMed DCC
sbg:validationErrors: []
