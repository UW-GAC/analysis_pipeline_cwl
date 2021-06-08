cwlVersion: v1.1
class: Workflow
label: GENESIS Sliding Window Association Testing
doc: |-
  **Sliding Window Association Testing workflow** runs sliding-window association tests. It can use Burden, SKAT [1], fastSKAT [2], SMMAT [3], or SKAT-O [4] to aggregate all variants in a window.

  Sliding window Workflow consists of several steps. Define Segments divides genome into segments, either by a number of segments, or by a segment length. Note that number of segments refers to whole genome, not a number of segments per chromosome Association test is then performed for each segment in parallel, before combining results on chromosome level. Final step produces QQ and Manhattan plots.

  Aggregate tests are typically used to jointly test rare variants. The **Alt freq max** parameter allows specification of the maximum alternate allele frequency allowable for inclusion in the test. Included variants are usually weighted using either a function of allele frequency (specified via the **Weight Beta** parameter) or some other annotation information (specified via the **Variant weight file** and **Weight user** parameters). 

  When running a burden test, the effect estimate is for each additional unit of burden; there are no effect size estimates for the other tests. Multiple alternate alleles for a single variant are treated separately.

  This workflow utilizes the *assocTestAggregate* function from the GENESIS software [5].


  ### Common Use Cases

  Sliding Window Association Testing workflow is designed to run multi-variant, sliding window, association tests using GENESIS software. Set of variants on which to run association testing can be reduced by providing **Variant Include Files** - One file per chromosome containing variant IDs for variants on which association testing will be performed.

  ### Changes Introduced by Seven Bridges:

  There are no changes introduced by Seven Bridges.

  ### Common Issues and Important Notes:

  * This workflow expects **GDS** files split by chromosome, and will not work otherwise. If provided, **variant include** files must also be split in the same way. Also GDS and Variant include files should be properly named. It is expected that chromosome is included in the filename in following format: chr## , where ## is the name of the chromosome (1-24 or X, Y). Chromosome can be included at any part of the filename. Examples for GDS: data_subset_chr1.gds, data_chr1_subset.gds. Examples for Variant include files: variant_include_chr1.RData, chr1_variant_include.RData.

  * **Note:** Memory requirements varies drastically based on input size, and on complexity of null model (for example inclusion of **Relatedness Matrix file** when fitting a null model, in *Null Model* workflow). For example, total input size of **GDS Files** of 100GB, requires 80GB of RAM if GRM is used, and 5 GB of RAM if GRM is not used. For this reason, **memory GB** parameter is exposed for users to adjust. If you need help with adjustments, fell free to contact our support. Running out of memory often, but not always, manifests as *error code 137*.

  ### Performance Benchmarking

  In the following table you can find estimates of running time and cost. All samples are aligned against **hg38 human reference** with default options. 

  | Samples &nbsp; &nbsp; |  | Rel. matrix &nbsp; &nbsp;| Test   &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;| Parallel instances &nbsp; &nbsp;| Instance type &nbsp; &nbsp; &nbsp;  | Instance   &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;   | CPU &nbsp; &nbsp; | RAM (GB) &nbsp; &nbsp; | Time  &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;  &nbsp; &nbsp;&nbsp; &nbsp;   | Cost |
  | ------- | -------- | -------------------- | ------ | --------------------- | ---------------- | ------------- | --- | -------- | ----------- | ---- |
  | 10K     |          | w/o                  | Burden | 8                     | On Dm            | r5.12xlarge   | 1   | 8        | 1 h, 11 min | $16  |
  | 10K     |          | Sparse               | Burden | 8                     | On Dm            | r5.12xlarge   | 1   | 8        | 1 h, 10min  | $17  |
  | 10K     |          | Dense                | Burden | 8                     | On Dm            | r5.12xlarge   | 1   | 8        | 1 h, 12 min | $16  |
  | 36K     |          | w/o                  | Burden | 8                     | On Dm            | r5.12xlarge   | 1   | 8        | 1 h, 46 min | $28  |
  | 36K     |          | Sparse               | Burden | 8                     | On Dm            | r5.12xlarge   | 1   | 9        | 1 h, 50 min | $31  |
  | 36K     |          | Dense                | Burden | 8                     | On Dm            | r5.12xlarge   | 4   | 36       | 2h, 59 min  | $66  |
  | 50K     |          | w/o                  | Burden | 8                     | On Dm            | r5.12xlarge   | 1   | 8        | 2 h, 28 min | $40  |
  | 50K     |          | Sparse               | Burden | 8                     | On Dm            | r5.12xlarge   | 1   | 9        | 2 h, 11 min | $43  |
  | 50K     |          | Dense                | Burden | 8                     | On Dm            | r5.24xlarge   | 8   | 70       | 4 h, 47 min | $208 |
  | 50K     |          | Dense                | Burden | 8                     | On Dm            | r5.24xlarge   | 8   | 70       | 4 h, 30 min | $218 |
  | 50K     |          | Dense                | Burden | 8                     | On Dm            | r5.24xlarge   | 8   | 70       | 9 h         | $218 |
  | 10K     |          | w/o                  | Burden | 8                     | On Dm            | n1-highmem-32 | 1   | 8        | 1 h, 55 min | $16  |
  | 10K     |          | Sparse               | Burden | 8                     | On Dm            | n1-highmem-32 | 1   | 8        | 2 h         | $17  |
  | 10K     |          | Dense                | Burden | 8                     | On Dm            | n1-highmem-32 | 1   | 8        | 2 h, 40 min | $16  |
  | 36K     |         | w/o                  | Burden | 8                     | On Dm            | n1-highmem-32 | 1   | 8        | 2 h, 17 min | $30  |
  | 36K     |         | Sparse               | Burden | 8                     | On Dm            | n1-highmem-32 | 1   | 9        | 2 h, 30 min | $30  |
  | 36K     |         | Dense                | Burden | 8                     | On Dm            | n1-highmem-32 | 4   | 36       | 6 h         | $91  |
  | 50K     |         | w/o                  | Burden | 8                     | On Dm            | n1-highmem-32 | 1   | 8        | 5 h, 50 min | $43  |
  | 50K     |         | Sparse               | Burden | 8                     | On Dm            | n1-highmem-32 | 1   | 9        | 5 h, 50 min | $40  |
  | 50K     |         | Dense                | Burden | 8                     | On Dm            | n1-highmem-96 | 8   | 70       | 6 h         | $270 |
  | 10K     |          | w/o    | SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 15 min | $16  |
  | 10K     |          | Sparse | SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 15 min | $17  |
  | 10K     |          | Dense  | SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 17 min | $17  |
  | 36K     |          | w/o    | SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 47 min | $27  |
  | 36K     |            | Sparse | SKAT | 8 | On Dm | r5.12xlarge   | 1  | 9   | 1 h, 50 min | $31  |
  | 36K     |          | Dense  | SKAT | 8 | On Dm | r5.12xlarge   | 6  | 48  | 5 h, 5 min  | $110 |
  | 50K     |        | w/o    | SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 2 h, 27 min | $40  |
  | 50K |            | Sparse | SKAT | 8 | On Dm | r5.12xlarge   | 1  | 9   | 2 h, 23 min | $44  |
  | 50K |           | Dense  | SKAT | 8 | On Dm | r5.24xlarge   | 13 | 100 | 11 h, 2 min | $500 |
  | 50K |        | Dense  | SKAT | 8 | On Dm | r5.24xlarge   | 12 | 90  | 9 h         | $435 |
  | 50K |        | Dense  | SKAT | 8 | On Dm | r5.24xlarge   | 12 | 90  | 18 h        | $435 |
  | 10K |        | w/o    | SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 1 h, 50 min | $17  |
  | 10K |        | Sparse | SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 2 h         | $16  |
  | 10K |       | Dense  | SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 2 h, 50 min | $17  |
  | 36K |           | w/o    | SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 2 h, 45 min | $30  |
  | 36K |         | Sparse | SKAT | 8 | On Dm | n1-highmem-32 | 1  | 9   | 2 h, 20 min | $30  |
  | 36K |           | Dense  | SKAT | 8 | On Dm | n1-highmem-32 | 6  | 48  | 12 h        | $162 |
  | 50K |          | w/o    | SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 5 h         | $45  |
  | 50K |           | Sparse | SKAT | 8 | On Dm | n1-highmem-32 | 1  | 9   | 5 h         | $45  |
  | 50K |           | Dense  | SKAT | 8 | On Dm | n1-highmem-96 | 13 | 100 | 14 h        | $620 |
  | 50K |      | Dense  | SKAT | 8 | On Dm | n1-highmem-96 | 12 | 90  | 14 h        | $620 |
  | 10K |  | w/o    | SMMAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 15 min  | $16  |
  | 10K |  | Sparse | SMMAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 16 min  | $16  |
  | 10K |  | Dense  | SMMAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 18 min  | $17  |
  | 36K | | w/o    | SMMAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 45 min  | $28  |
  | 36K |  | Sparse | SMMAT | 8 | On Dm | r5.12xlarge   | 1  | 9   | 1 h, 48 min  | $32  |
  | 36K |  | Dense  | SMMAT | 8 | On Dm | r5.12xlarge   | 6  | 48  | 5h           | $111 |
  | 50K |  | w/o    | SMMAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 2 h, 30 min  | $40  |
  | 50K |  | Sparse | SMMAT | 8 | On Dm | r5.12xlarge   | 1  | 9   | 2 h, 47 min  | $44  |
  | 50K |  | Dense  | SMMAT | 8 | On Dm | r5.24xlarge   | 13 | 100 | 11 h, 30 min | $500 |
  | 50K |  | Dense  | SMMAT | 8 | On Dm | r5.24xlarge   | 12 | 90  | 9 h          | $435 |
  | 50K |  | Dense  | SMMAT | 8 | On Dm | r5.24xlarge   | 12 | 90  | 18 h         | $435 |
  | 10K |  | w/o    | SMMAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 1 h 30 min   | $15  |
  | 10K |  | Sparse | SMMAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 2 h          | $16  |
  | 10K |  | Dense  | SMMAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 2 h, 50 min  | $17  |
  | 36K |  | w/o    | SMMAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 2 h, 43 min  | $30  |
  | 36K |  | Sparse | SMMAT | 8 | On Dm | n1-highmem-32 | 1  | 9   | 2 h, 25 min  | $30  |
  | 36K |  | Dense  | SMMAT | 8 | On Dm | n1-highmem-32 | 6  | 48  | 12 h         | $160 |
  | 50K |  | w/o    | SMMAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 5 h          | $42  |
  | 50K |  | Sparse | SMMAT | 8 | On Dm | n1-highmem-32 | 1  | 9   | 5 h          | $50  |
  | 50K |  | Dense  | SMMAT | 8 | On Dm | n1-highmem-96 | 13 | 100 | 14 h         | $620 |
  | 50K |  | Dense  | SMMAT | 8 | On Dm | n1-highmem-96 | 12 | 90  | 14 h         | $620 |
  | 50K |  | Dense  | SMMAT | 8 | On Dm | r5.24xlarge   | 12 | 90  | 18 h         | $435 |
  | 10K |  | w/o    | Fast SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 14 min  | $16  |
  | 10K |  | Sparse | Fast SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 15 min  | $16  |
  | 10K |  | Dense  | Fast SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 17 min  | $17  |
  | 36K |  | w/o    | Fast SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 50 min  | $28  |
  | 36K |  | Sparse | Fast SKAT | 8 | On Dm | r5.12xlarge   | 1  | 9   | 1 h, 40 min  | $34  |
  | 36K |  | Dense  | Fast SKAT | 8 | On Dm | r5.12xlarge   | 6  | 50  | 5 h, 30 min  | $135 |
  | 50K |  | w/o    | Fast SKAT | 8 | On Dm | r5.12xlarge   | 1  | 10  | 1 h, 30 min  | $40  |
  | 50K | | Sparse | Fast SKAT | 8 | On Dm | r5.12xlarge   | 1  | 10  | 1 h, 30 min  | $43  |
  | 50K |  | Dense  | Fast SKAT | 8 | On Dm | r5.24xlarge   | 13 | 100 | 11 h, 41 min | $501 |
  | 10K |  | w/o    | Fast SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 1 h, 30 min  | $16  |
  | 10K |  | Sparse | Fast SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 1 h, 30 min  | $16  |
  | 10K |  | Dense  | Fast SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 2 h, 50 min  | $17  |
  | 36K |  | w/o    | Fast SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 3 h          | $30  |
  | 36K |  | Sparse | Fast SKAT | 8 | On Dm | n1-highmem-32 | 1  | 9   | 4 h, 30min   | $32  |
  | 36K |  | Dense  | Fast SKAT | 8 | On Dm | n1-highmem-32 | 6  | 50  | 11 h         | $160 |
  | 50K |  | w/o    | Fast SKAT | 8 | On Dm | n1-highmem-32 | 1  | 10  | 3 h          | $45  |
  | 50K |  | Sparse | Fast SKAT | 8 | On Dm | n1-highmem-32 | 1  | 10  | 3 h          | $45  |
  | 50K |  | Dense  | Fast SKAT | 8 | On Dm | n1-highmem-96 | 13 | 100 | 14 h         | $650 |

  In tests performed we used **1000G** (tasks with 2.5k participants) and **TOPMed freeze5** datasets (tasks with 10k or more participants). All these tests are done with applied **MAF < 1% filter, window size 50kb** and **window step 20kb**. The number of variants that have been tested in **1000G** dataset is **175 mio (140k windows, 1k variants/window)**. The number of variants tested in **TOPMed freeze 5** is **1bio variants (140k windows, 7k variants/window)**.

  Please note that we run all tests with default values for window size and window step (meaning 50kb and 20kb respectively). In this set up windows are overlapping and this is why we have so high number of variants tested. 

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
  task = api.tasks.create(name='Sliding Window Association Testing - API Run', project=project_id, app=app_id, inputs=inputs, run=False)
  ```
  Instructions for installing and configuring the API Python client, are provided on [github](https://github.com/sbg/sevenbridges-python#installation). For more information about using the API Python client, consult [sevenbridges-python documentation](http://sevenbridges-python.readthedocs.io/en/latest/). **More examples** are available [here](https://github.com/sbg/okAPI).

  Additionally, [API R](https://github.com/sbg/sevenbridges-r) and [API Java](https://github.com/sbg/sevenbridges-java) clients are available. To learn more about using these API clients please refer to the [API R client documentation](https://sbg.github.io/sevenbridges-r/), and [API Java client documentation](https://docs.sevenbridges.com/docs/java-library-quickstart).


  ### References
  [1] [SKAT](https://dx.doi.org/10.1016%2Fj.ajhg.2011.05.029)  
  [2] [fastSKAT](https://doi.org/10.1002/gepi.22136)  
  [3] [SMMAT](https://doi.org/10.1016/j.ajhg.2018.12.012)  
  [4] [SKAT-O](https://doi.org/10.1093/biostatistics/kxs014)  
  [5] [GENESIS](https://f4c.sbgenomics.com/u/boris_majic/genesis-pipelines-dev/apps/doi.org/10.1093/bioinformatics/btz567)
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
  sbg:x: -330.39886474609375
  sbg:y: -166
- id: n_segments
  label: Number of segments
  doc: |-
    Number of segments, used for parallelization (overrides Segment length). Note that this parameter defines the number of segments for the entire genome, so using this argument with selected chromosomes may result in fewer segments than you expect (and the minimum is one segment per chromosome).
  type: int?
  sbg:x: -381.39886474609375
  sbg:y: -52
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
  sbg:x: -329
  sbg:y: 74
- id: window_step
  label: Window step
  doc: Step size of sliding window in kb.
  type: int?
  sbg:toolDefaultValue: 20kb
  sbg:x: 82
  sbg:y: 129
- id: window_size
  label: Window size
  doc: Size of sliding window in kb.
  type: int?
  sbg:toolDefaultValue: 50kb
  sbg:x: -17
  sbg:y: 176
- id: weight_user
  label: Weight user
  doc: |-
    Name of column in variant_weight_file or variant_group_file containing the weight for each variant. Overrides Weight beta.
  type: string?
  sbg:x: -104
  sbg:y: 225
- id: weight_beta
  label: Weight Beta
  doc: |-
    Parameters of the Beta distribution used to determine variant weights based on minor allele frequency; two space delimited values. "1 1" is flat (uniform) weights, "0.5 0.5" is proportional to the Madsen-Browning weights, and "1 25" gives the Wu weights. This parameter is ignored if weight_user is provided.
  type: string?
  sbg:toolDefaultValue: 1 1
  sbg:x: 86
  sbg:y: 265
- id: variant_weight_file
  label: Variant weight file
  doc: |-
    RData file(s) with data.frame specifying variant weights. Columns should contain either variant.id or all of (chr, pos, ref, alt). Files may be separated by chromosome with ‘chr##’ string corresponding to each GDS file. If not provided, all variants will be given equal weight in the test.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -9
  sbg:y: 312
- id: test
  label: Test
  doc: Test to perform. Options are burden, SKAT, SMMAT, fast-SKAT, or SKAT-O.
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
  sbg:toolDefaultValue: Burden
  sbg:x: -101
  sbg:y: 356
- id: rho
  label: Rho
  doc: |-
    A numeric value or list of values in range [0,1] specifying the rho parameter when test is SKAT-O. 0 is a standard SKAT test, 1 is a burden test, and intermediate values are a weighted combination of both.
  type: float[]?
  sbg:toolDefaultValue: '0'
  sbg:x: 89
  sbg:y: 397
- id: phenotype_file
  label: Phenotype file
  doc: |-
    RData file with an AnnotatedDataFrame of phenotypes and covariates. Sample identifiers must be in column named “sample.id”. It is recommended to use the phenotype file output by the GENESIS Null Model app.
  type: File
  sbg:fileTypes: RDATA
  sbg:x: -3
  sbg:y: 446
- id: pass_only
  label: Pass only
  doc: |-
    TRUE to select only variants with FILTER=PASS. If FALSE, variants that failed the quality filter will be included in the test.
  type: boolean?
  sbg:toolDefaultValue: 'TRUE'
  sbg:x: -95
  sbg:y: 492
- id: null_model_file
  label: Null model file
  doc: |-
    RData file containing a null model object. Run the GENESIS Null Model app to create this file.
  type: File
  sbg:fileTypes: RDATA
  sbg:x: 91
  sbg:y: 544
- id: memory_gb
  label: Memory GB
  doc: Memory in GB per each tool job.
  type: float?
  sbg:toolDefaultValue: '8'
  sbg:x: 3
  sbg:y: 589
- id: cpu
  label: CPU
  doc: Number of CPUs for each job.
  type: int?
  sbg:toolDefaultValue: '1'
  sbg:x: -95
  sbg:y: 637
- id: alt_freq_max
  label: Alt freq max
  doc: |-
    Maximum alternate allele frequency of variants to include in the test. Default: 1 (no filtering of variants by frequency).
  type: float?
  sbg:toolDefaultValue: '1'
  sbg:x: 104.18907928466797
  sbg:y: 675.7794189453125
- id: thin_npoints
  label: Thin N points
  doc: Number of points in each bin after thinning.
  type: int?
  sbg:toolDefaultValue: '10000'
  sbg:x: 1051.27734375
  sbg:y: 406.12115478515625
- id: thin_nbins
  label: Thin N bins
  doc: Number of bins to use for thinning.
  type: int?
  sbg:toolDefaultValue: '10'
  sbg:x: 1124.09716796875
  sbg:y: 516.5892944335938
- id: known_hits_file
  label: Known hits file
  doc: |-
    RData file with data.frame containing columns chr and pos. If provided, 1 Mb regions surrounding each variant listed will be omitted from the QQ and manhattan plots.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: 1029.5416259765625
  sbg:y: 602.0654907226562
- id: disable_thin
  label: Disable Thin
  doc: |-
    Logical for whether to thin points in the QQ and Manhattan plots. By default, points are thinned in dense regions to reduce plotting time. If this parameter is set to TRUE, all variant p-values will be included in the plots, and the plotting will be very long and memory intensive.
  type: boolean?
  sbg:x: 1127.9185791015625
  sbg:y: 696.5892944335938
- id: out_prefix
  label: Output prefix
  doc: Prefix that will be included in all output files.
  type: string
  sbg:x: 0.9453675150871277
  sbg:y: 778.094482421875
- id: input_gds_files
  label: GDS files
  doc: |-
    GDS files with genotype data for variants to be tested for association. If multiple files are selected, they will be run in parallel. Files separated by chromosome are expected to have ‘chr##’ strings indicating chromosome number, where ‘##’ can be (1-24, X, Y). Output files for each chromosome will include the corresponding chromosome number.
  type: File[]
  sbg:fileTypes: GDS
  sbg:x: -294.1038513183594
  sbg:y: -322.0341491699219
- id: truncate_pval_threshold
  label: Truncate pval threshold
  doc: Maximum p-value to display in truncated QQ and manhattan plots.
  type: float?
  sbg:x: 873.642822265625
  sbg:y: 558.6107177734375
- id: plot_mac_threshold
  label: Plot MAC threshold
  doc: |-
    Minimum minor allele count for variants or aggregate units to include in plots (if different from MAC threshold).
  type: int?
  sbg:x: 865.5167846679688
  sbg:y: 719.1002197265625
- id: variant_include_files
  label: Variant Include Files
  doc: RData file containing ids of variants to be included.
  type: File[]?
  sbg:fileTypes: RData
  sbg:x: -67.34032440185547
  sbg:y: -340.61676025390625

outputs:
- id: assoc_combined
  label: Association test results
  doc: |-
    RData file with data.frame of association test results (test statistic, p-value, etc.) See the documentation of the GENESIS R package for detailed description of output.
  type: File[]?
  outputSource:
  - assoc_combine_r/assoc_combined
  sbg:fileTypes: RDATA
  sbg:x: 1405.60107421875
  sbg:y: 86.9375228881836
- id: assoc_plots
  label: Association test plots
  doc: QQ and Manhattan Plots of p-values in association test results.
  type: File[]?
  outputSource:
  - assoc_plots_r/assoc_plots
  sbg:fileTypes: PNG
  sbg:x: 1714.2301025390625
  sbg:y: 456.1864013671875

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
  run: assoc-window-wf.cwl.steps/define_segments_r.cwl
  out:
  - id: config
  - id: define_segments_output
  sbg:x: -174
  sbg:y: -53
- id: assoc_window
  label: Association Testing Window
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
  - id: out_prefix
    source: out_prefix
  - id: rho
    source:
    - rho
  - id: segment_file
    valueFrom: '$(self ? [].concat(self)[0] : self)'
    source:
    - define_segments_r/define_segments_output
    linkMerge: merge_flattened
  - id: test
    source: test
  - id: variant_include_file
    valueFrom: '$(self ? [].concat(self)[0] : self)'
    source:
    - sbg_prepare_segments_1/variant_include_output
    linkMerge: merge_flattened
  - id: weight_beta
    source: weight_beta
  - id: segment
    valueFrom: '$(self ? [].concat(self)[0] : self)'
    source:
    - sbg_prepare_segments_1/segments
    linkMerge: merge_flattened
  - id: pass_only
    source: pass_only
  - id: window_size
    source: window_size
  - id: window_step
    source: window_step
  - id: variant_weight_file
    source: variant_weight_file
  - id: alt_freq_max
    source: alt_freq_max
  - id: weight_user
    source: weight_user
  - id: memory_gb
    source: memory_gb
  - id: cpu
    source: cpu
  - id: genome_build
    source: genome_build
  scatter:
  - gds_file
  - variant_include_file
  - segment
  scatterMethod: dotproduct
  run: assoc-window-wf.cwl.steps/assoc_window.cwl
  out:
  - id: assoc_window
  - id: config_file
  sbg:x: 655.7789306640625
  sbg:y: -43.699947357177734
- id: assoc_plots_r
  label: Association Plots
  in:
  - id: assoc_files
    valueFrom: '$(self ? [].concat(self) : self)'
    source:
    - assoc_combine_r/assoc_combined
    linkMerge: merge_flattened
  - id: assoc_type
    default: window
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
  run: assoc-window-wf.cwl.steps/assoc_plots_r.cwl
  out:
  - id: assoc_plots
  - id: configs
  - id: Lambdas
  sbg:x: 1434.0654296875
  sbg:y: 427.8849182128906
- id: assoc_combine_r
  label: Association Combine
  in:
  - id: chromosome
    valueFrom: '$(self ? [].concat(self) : self)'
    source:
    - sbg_group_segments_1/chromosome
  - id: assoc_type
    default: window
  - id: assoc_files
    valueFrom: '$(self ? [].concat(self) : self)'
    source:
    - sbg_group_segments_1/grouped_assoc_files
  scatter:
  - chromosome
  - assoc_files
  scatterMethod: dotproduct
  run: assoc-window-wf.cwl.steps/assoc_combine_r.cwl
  out:
  - id: assoc_combined
  - id: configs
  sbg:x: 1208
  sbg:y: 254
- id: sbg_gds_renamer
  label: SBG GDS renamer
  in:
  - id: in_variants
    source: input_gds_files
  scatter:
  - in_variants
  run: assoc-window-wf.cwl.steps/sbg_gds_renamer.cwl
  out:
  - id: renamed_variants
  sbg:x: -167.189208984375
  sbg:y: -201.54766845703125
- id: sbg_flatten_lists
  label: SBG FlattenLists
  in:
  - id: input_list
    valueFrom: |-
      ${     var out = [];     for (var i = 0; i<self.length; i++){         if (self[i])    out.push(self[i])     }     return out }
    source:
    - assoc_window/assoc_window
  run: assoc-window-wf.cwl.steps/sbg_flatten_lists.cwl
  out:
  - id: output_list
  sbg:x: 832.23046875
  sbg:y: 252.8946990966797
- id: sbg_group_segments_1
  label: SBG Group Segments
  in:
  - id: assoc_files
    source:
    - sbg_flatten_lists/output_list
  run: assoc-window-wf.cwl.steps/sbg_group_segments_1.cwl
  out:
  - id: grouped_assoc_files
  - id: chromosome
  sbg:x: 1011.0945434570312
  sbg:y: 234.52940368652344
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
  run: assoc-window-wf.cwl.steps/sbg_prepare_segments_1.cwl
  out:
  - id: gds_output
  - id: segments
  - id: aggregate_output
  - id: variant_include_output
  sbg:x: 167.8256378173828
  sbg:y: -154.29832458496094

hints:
- class: sbg:AWSInstanceType
  value: r5.12xlarge;ebs-gp2;1024
- class: sbg:maxNumberOfParallelInstances
  value: '8'
sbg:appVersion:
- v1.1
sbg:categories:
- GWAS
- CWL1.0
- Genomics
sbg:content_hash: a8fb6450529f52ff73c36cfaaa48898630eda71205316f38824a78375dcb2d5bc
sbg:contributors:
- admin
sbg:createdBy: admin
sbg:createdOn: 1577727849
sbg:expand_workflow: false
sbg:id: admin/sbg-public-data/sliding-window-association-testing/22
sbg:image_url:
sbg:latestRevision: 22
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
sbg:modifiedOn: 1617276239
sbg:original_source: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/admin/sbg-public-data/sliding-window-association-testing/22/raw/
sbg:project: admin/sbg-public-data
sbg:projectName: SBG Public Data
sbg:publisher: sbg
sbg:revision: 22
sbg:revisionNotes: Plot update
sbg:revisionsInfo:
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727849
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727849
  sbg:revision: 1
  sbg:revisionNotes: Revision for publishing
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727849
  sbg:revision: 2
  sbg:revisionNotes: Modify description in accordance to review
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727850
  sbg:revision: 3
  sbg:revisionNotes: Modify description
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727850
  sbg:revision: 4
  sbg:revisionNotes: CWL1.0
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577807264
  sbg:revision: 5
  sbg:revisionNotes: Latest
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1585350126
  sbg:revision: 6
  sbg:revisionNotes: SBG GDS Renamer added and output prefix exposed
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1585350126
  sbg:revision: 7
  sbg:revisionNotes: Description updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1585350127
  sbg:revision: 8
  sbg:revisionNotes: Description updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602161636
  sbg:revision: 9
  sbg:revisionNotes: SBG FlattenList updated to CWL1.0
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602161636
  sbg:revision: 10
  sbg:revisionNotes: Input descriptions update
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755637
  sbg:revision: 11
  sbg:revisionNotes: Import from BDC 2.8.1 version
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755637
  sbg:revision: 12
  sbg:revisionNotes: Input and output descriptions updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755637
  sbg:revision: 13
  sbg:revisionNotes: Plot prefix = output prefix
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755638
  sbg:revision: 14
  sbg:revisionNotes: Description update
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1604053019
  sbg:revision: 15
  sbg:revisionNotes: Config cleaning
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1604053019
  sbg:revision: 16
  sbg:revisionNotes: Config cleaning
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1604053019
  sbg:revision: 17
  sbg:revisionNotes: Config cleaning
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1617276239
  sbg:revision: 18
  sbg:revisionNotes: CWLtool compatible
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1617276239
  sbg:revision: 19
  sbg:revisionNotes: Docker updated to uwgac/topmed-master:2.10.0
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1617276239
  sbg:revision: 20
  sbg:revisionNotes: Plot updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1617276239
  sbg:revision: 21
  sbg:revisionNotes: Plot update
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1617276239
  sbg:revision: 22
  sbg:revisionNotes: Plot update
sbg:sbgMaintained: false
sbg:toolAuthor: TOPMed DCC
sbg:validationErrors: []
