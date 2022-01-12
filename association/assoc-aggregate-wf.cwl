cwlVersion: v1.2
class: Workflow
label: GENESIS Aggregate Association Testing
doc: |-
  **Aggregate Association Testing workflow** runs aggregate association tests, using Burden, SKAT [1], fastSKAT [2], SMMAT [3], or SKAT-O [4] to aggregate a user-defined set of variants. Association tests are parallelized by segments within chromosomes.

  Define segments splits the genome into segments and assigns each aggregate unit to a segment based on the position of its first variant. Note that number of segments refers to the whole genome, not a number of segments per chromosome. Association testing is then for each segment in parallel, before combining results on chromosome level. Finally, the last step creates QQ and Manhattan plots.

  Aggregate tests are typically used to jointly test rare variants. The **Alt freq max** parameter allows specification of the maximum alternate allele frequency allowable for inclusion in the test. Included variants are usually weighted using either a function of allele frequency (specified via the **Weight Beta** parameter) or some other annotation information (specified via the **Variant weight file** and **Weight user** parameters). 

  When running a burden test, the effect estimate is for each additional unit of burden; there are no effect size estimates for the other tests. Multiple alternate alleles for a single variant are treated separately.

  This workflow utilizes the *assocTestAggregate* function from the GENESIS software.


  ### Common Use Cases
   * This workflow is designed to perform multi-variant association testing on a user-defined groups of variants.


  ### Common Issues and important notes:
  * The null model input file should be created using GENESIS Null model. Please ensure that you use a Null model file and not one of Null model report only files also available in outputs. 
  * The phenotype input file should be created using GENESIS Null model workflow. It is listed in the Null model Phenotypes file output field.  

  * This pipeline expects that **GDS Files**, **Variant Include Files**, and **Variant group files** are separated per chromosome, and that files are properly named. It is expected that chromosome is included in the filename in following format: chr## , where ## is the name of the chromosome (1-24 or X, Y). Chromosome can be included at any part of the filename.  Examples: data_subset_chr1.vcf,  data_chr1_subset.vcf, chr1_data_subset.vcf.

  * If **Weight Beta** parameter is set, it needs to follow proper convention, two space-delimited floating point numbers.

  * **Number of segments** parameter, if provided, needs to be equal or higher than number of chromosomes.

  * Testing showed that default parameters for **CPU** and **memory GB** (8GB) are sufficient for testing studies (up to 50k samples), however different null models might increase the requirements.

  ### Performance Benchmarking

  In the following table you can find estimates of running time and cost. 

  | Samples &nbsp; &nbsp; &nbsp; &nbsp;|  | Rel. matrix in NM &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; | Test &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp;  | Parallel instances &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; | Instance type &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp;| Instance  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp;  | CPU &nbsp; &nbsp; | RAM (GB) &nbsp; &nbsp; &nbsp; &nbsp;| Time    &nbsp; &nbsp; &nbsp; &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp;    &nbsp;| Cost  &nbsp;  &nbsp; |
  | ------- | -------- | -------------------- | ------ | --------------------- | ---------------- | ------------- | --- | -------- | ----------- | ---- |
  | 10K     |        | w/o                  | Burden | 8                     | On Dm            | r5.12xlarge   | 1   | 8        | 1 h, 11 min | 16$  |
  | 10K     |         | Sparse               | Burden | 8                     | On Dm            | r5.12xlarge   | 1   | 8        | 1 h, 10min  | 17$  |
  | 10K     |         | Dense                | Burden | 8                     | On Dm            | r5.12xlarge   | 1   | 8        | 1 h, 12 min | 16$  |
  | 36K     |         | w/o                  | Burden | 8                     | On Dm            | r5.12xlarge   | 1   | 8        | 1 h, 46 min | 28$  |
  | 36K     |         | Sparse               | Burden | 8                     | On Dm            | r5.12xlarge   | 1   | 9        | 1 h, 50 min | 31$  |
  | 36K     |         | Dense                | Burden | 8                     | On Dm            | r5.12xlarge   | 4   | 36       | 2h, 59 min  | 66$  |
  | 50K     |         | w/o                  | Burden | 8                     | On Dm            | r5.12xlarge   | 1   | 8        | 2 h, 28 min | 40$  |
  | 50K     |         | Sparse               | Burden | 8                     | On Dm            | r5.12xlarge   | 1   | 9        | 2 h, 11 min | 43$  |
  | 50K     |         | Dense                | Burden | 8                     | On Dm            | r5.24xlarge   | 8   | 70       | 4 h, 47 min | 208$ |
  | 50K     |         | Dense                | Burden | 8                     | On Dm            | r5.24xlarge   | 8   | 70       | 4 h, 30 min | 218$ |
  | 50K     |         | Dense                | Burden | 8                     | On Dm            | r5.12xlarge   | 8   | 70       | 9 h         | 218$ |
  | 10K     |         | w/o                  | Burden | 8                     | On Dm            | n1-highmem-32 | 1   | 8        | 1 h, 55 min | 16$  |
  | 10K     |         | Sparse               | Burden | 8                     | On Dm            | n1-highmem-32 | 1   | 8        | 2 h         | 17$  |
  | 10K     |         | Dense                | Burden | 8                     | On Dm            | n1-highmem-32 | 1   | 8        | 2 h, 40 min | 16$  |
  | 36K     |         | w/o                  | Burden | 8                     | On Dm            | n1-highmem-32 | 1   | 8        | 2 h, 17 min | 30$  |
  | 36K     |         | Sparse               | Burden | 8                     | On Dm            | n1-highmem-32 | 1   | 9        | 2 h, 30 min | 30$  |
  | 36K     |         | Dense                | Burden | 8                     | On Dm            | n1-highmem-32 | 4   | 36       | 6 h         | 91$  |
  | 50K     |         | w/o                  | Burden | 8                     | On Dm            | n1-highmem-32 | 1   | 8        | 5 h, 50 min | 43$  |
  | 50K     |         | Sparse               | Burden | 8                     | On Dm            | n1-highmem-32 | 1   | 9        | 5 h, 50 min | 40$  |
  | 50K     |         | Dense                | Burden | 8                     | On Dm            | n1-highmem-96 | 8   | 70       | 6 h         | 270$ |     
  | 10K |  | w/o    | SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 15 min | 16$  |
  | 10K |  | Sparse | SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 15 min | 17$  |
  | 10K |  | Dense  | SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 17 min | 17$  |
  | 36K |  | w/o    | SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 47 min | 27$  |
  | 36K |  | Sparse | SKAT | 8 | On Dm | r5.12xlarge   | 1  | 9   | 1 h, 50 min | 31$  |
  | 36K |  | Dense  | SKAT | 8 | On Dm | r5.12xlarge   | 6  | 48  | 5 h, 5 min  | 110$ |
  | 50K |  | w/o    | SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 2 h, 27 min | 40$  |
  | 50K |  | Sparse | SKAT | 8 | On Dm | r5.12xlarge   | 1  | 9   | 2 h, 23 min | 44$  |
  | 50K |  | Dense  | SKAT | 8 | On Dm | r5.24xlarge   | 13 | 100 | 11 h, 2 min | 500$ |
  | 50K |  | Dense  | SKAT | 8 | On Dm | r5.24xlarge   | 12 | 90  | 9 h         | 435$ |
  | 50K |  | Dense  | SKAT | 8 | On Dm | r5.12xlarge   | 12 | 90  | 18 h        | 435$ |
  | 10K |  | w/o    | SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 1 h, 50 min | 17$  |
  | 10K |  | Sparse | SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 2 h         | 16$  |
  | 10K |  | Dense  | SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 2 h, 50 min | 17$  |
  | 36K |  | w/o    | SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 2 h, 45 min | 30$  |
  | 36K |  | Sparse | SKAT | 8 | On Dm | n1-highmem-32 | 1  | 9   | 2 h, 20 min | 30$  |
  | 36K |  | Dense  | SKAT | 8 | On Dm | n1-highmem-32 | 6  | 48  | 12 h        | 162$ |
  | 50K |  | w/o    | SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 5 h         | 45$  |
  | 50K |  | Sparse | SKAT | 8 | On Dm | n1-highmem-32 | 1  | 9   | 5 h         | 45$  |
  | 50K |  | Dense  | SKAT | 8 | On Dm | n1-highmem-96 | 13 | 100 | 14 h        | 620$ |
  | 50K |  | Dense  | SKAT | 8 | On Dm | n1-highmem-96 | 12 | 90  | 14 h        | 620$ |
  | 10K |  | w/o    | SMMAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 15 min  | 16$  |
  | 10K |  | Sparse | SMMAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 16 min  | 16$  |
  | 10K |  | Dense  | SMMAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 18 min  | 17$  |
  | 36K |  | w/o    | SMMAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 45 min  | 28$  |
  | 36K |  | Sparse | SMMAT | 8 | On Dm | r5.12xlarge   | 1  | 9   | 1 h, 48 min  | 32$  |
  | 36K |  | Dense  | SMMAT | 8 | On Dm | r5.12xlarge   | 6  | 48  | 5h           | 111$ |
  | 50K |  | w/o    | SMMAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 2 h, 30 min  | 40$  |
  | 50K |  | Sparse | SMMAT | 8 | On Dm | r5.12xlarge   | 1  | 9   | 2 h, 47 min  | 44$  |
  | 50K |  | Dense  | SMMAT | 8 | On Dm | r5.24xlarge   | 13 | 100 | 11 h, 30 min | 500$ |
  | 50K |  | Dense  | SMMAT | 8 | On Dm | r5.24xlarge   | 12 | 90  | 9 h          | 435$ |
  | 50K |  | Dense  | SMMAT | 8 | On Dm | r5.12xlarge   | 12 | 90  | 18 h         | 435$ |
  | 10K |  | w/o    | SMMAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 1 h 30 min   | 15$  |
  | 10K |  | Sparse | SMMAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 2 h          | 16$  |
  | 10K |  | Dense  | SMMAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 2 h, 50 min  | 17$  |
  | 36K |  | w/o    | SMMAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 2 h, 43 min  | 30$  |
  | 36K |  | Sparse | SMMAT | 8 | On Dm | n1-highmem-32 | 1  | 9   | 2 h, 25 min  | 30$  |
  | 36K |  | Dense  | SMMAT | 8 | On Dm | n1-highmem-32 | 6  | 48  | 12 h         | 160$ |
  | 50K |  | w/o    | SMMAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 5 h          | 42$  |
  | 50K |  | Sparse | SMMAT | 8 | On Dm | n1-highmem-32 | 1  | 9   | 5 h          | 50$  |
  | 50K |  | Dense  | SMMAT | 8 | On Dm | n1-highmem-96 | 13 | 100 | 14 h         | 620$ |
  | 50K |  | Dense  | SMMAT | 8 | On Dm | n1-highmem-96 | 12 | 90  | 14 h         | 620$ |
  | 10K |  | w/o    | Fast SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 14 min  | 16$  |
  | 10K |  | Sparse | Fast SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 15 min  | 16$  |
  | 10K |  | Dense  | Fast SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 17 min  | 17$  |
  | 36K |  | w/o    | Fast SKAT | 8 | On Dm | r5.12xlarge   | 1  | 8   | 1 h, 50 min  | 28$  |
  | 36K |  | Sparse | Fast SKAT | 8 | On Dm | r5.12xlarge   | 1  | 9   | 1 h, 40 min  | 34$  |
  | 36K |  | Dense  | Fast SKAT | 8 | On Dm | r5.12xlarge   | 6  | 50  | 5 h, 30 min  | 135$ |
  | 50K |  | w/o    | Fast SKAT | 8 | On Dm | r5.12xlarge   | 1  | 10  | 1 h, 30 min  | 40$  |
  | 50K |  | Sparse | Fast SKAT | 8 | On Dm | r5.12xlarge   | 1  | 10  | 1 h, 30 min  | 43$  |
  | 50K |  | Dense  | Fast SKAT | 8 | On Dm | r5.24xlarge   | 13 | 100 | 11 h, 41 min | 501$ |
  | 10K |  | w/o    | Fast SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 1 h, 30 min  | 16$  |
  | 10K |  | Sparse | Fast SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 1 h, 30 min  | 16$  |
  | 10K |  | Dense  | Fast SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 2 h, 50 min  | 17$  |
  | 36K |  | w/o    | Fast SKAT | 8 | On Dm | n1-highmem-32 | 1  | 8   | 3 h          | 30$  |
  | 36K |  | Sparse | Fast SKAT | 8 | On Dm | n1-highmem-32 | 1  | 9   | 4 h, 30min   | 32$  |
  | 36K |  | Dense  | Fast SKAT | 8 | On Dm | n1-highmem-32 | 6  | 50  | 11 h         | 160$ |
  | 50K |  | w/o    | Fast SKAT | 8 | On Dm | n1-highmem-32 | 1  | 10  | 3 h          | 45$  |
  | 50K |  | Sparse | Fast SKAT | 8 | On Dm | n1-highmem-32 | 1  | 10  | 3 h          | 45$  |
  | 50K |  | Dense  | Fast SKAT | 8 | On Dm | n1-highmem-96 | 13 | 100 | 14 h         | 650$ |

  In tests performed we used **1000G** (tasks with 2.5k participants) and **TOPMed freeze5** datasets (tasks with 10k or more participants). All these tests are done with applied **MAF < 1% filter.** There are **70 mio** variants with MAF <= 1% in **1000G** and **460 mio** in **TOPMed freeze5 dataset**. Typically, aggregate tests only use a subset of these variants; e.g. grouped by gene. Computational performance will vary depending on how many total variants are tested, and how many variants are included in each aggregation unit.

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
      "variant_group_files": api.files.query(project=project_id, names=["variant_group_chr1.RData", "variant_group_chr2.RData", ..]),
      "phenotype_file": api.files.query(project=project_id, names=["name_of_phenotype_file"])[0],
      "null_model_file": api.files.query(project=project_id, names=["name_of_null_model_file"])[0]
  }
  task = api.tasks.create(name='Aggregate Association Testing - API Run', project=project_id, app=app_id, inputs=inputs, run=False)
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
  sbg:x: -518
  sbg:y: -142
- id: n_segments
  label: Number of segments
  doc: |-
    Number of segments, used for parallelization (overrides Segment length). Note that this parameter defines the number of segments for the entire genome, so using this argument with selected chromosomes may result in fewer segments than you expect (and the minimum is one segment per chromosome).
  type: int?
  sbg:x: -691.4876708984375
  sbg:y: -61
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
  sbg:x: -517
  sbg:y: 5
- id: variant_group_files
  label: Variant group files
  doc: |-
    RData file with data.frame defining aggregate groups. If aggregate_type is allele, columns should be group_id, chr, pos, ref, alt. If aggregate_type is position, columns should be group_id, chr, start, end. Files may be separated by chromosome with ‘chr##’ string corresponding to each GDS file. If Variant Include file is specified, groups will be subset to included variants.
  type: File[]
  sbg:fileTypes: RDATA
  sbg:x: -282
  sbg:y: 94
- id: group_id
  label: Group ID
  doc: Alternate name for group_id column in Variant Group file.
  type: string?
  sbg:x: -397
  sbg:y: 190
- id: aggregate_type
  label: Aggregate type
  doc: |-
    Type of aggregate grouping. Options are to select variants by allele (unique variants) or position (regions of interest).
  type:
  - 'null'
  - name: aggregate_type
    type: enum
    symbols:
    - position
    - allele
  sbg:toolDefaultValue: allele
  sbg:x: -281
  sbg:y: 269
- id: weight_user
  label: Weight user
  doc: |-
    Name of column in variant_weight_file or variant_group_file containing the weight for each variant. Overrides Weight beta.
  type: string?
  sbg:x: 184.77578735351562
  sbg:y: 321.9588928222656
- id: weight_beta
  label: Weight Beta
  doc: |-
    Parameters of the Beta distribution used to determine variant weights based on minor allele frequency; two space delimited values. "1 1" is flat (uniform) weights, "0.5 0.5" is proportional to the Madsen-Browning weights, and "1 25" gives the Wu weights. This parameter is ignored if weight_user is provided.
  type: string?
  sbg:toolDefaultValue: 1 1
  sbg:x: 84
  sbg:y: 369.5714416503906
- id: variant_weight_file
  label: Variant Weight file
  doc: |-
    RData file(s) with data.frame specifying variant weights. Columns should contain either variant.id or all of (chr, pos, ref, alt). Files may be separated by chromosome with ‘chr##’ string corresponding to each GDS file. If not provided, all variants will be given equal weight in the test.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -11.714285850524902
  sbg:y: 415.8571472167969
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
  sbg:x: 189.85714721679688
  sbg:y: 460
- id: rho
  label: Rho
  doc: |-
    A numeric value or list of values in range [0,1] specifying the rho parameter when test is SKAT-O. 0 is a standard SKAT test, 1 is a burden test, and intermediate values are a weighted combination of both.
  type: float[]?
  sbg:toolDefaultValue: '0'
  sbg:x: 91.28571319580078
  sbg:y: 511.7142639160156
- id: phenotype_file
  label: Phenotype file
  doc: |-
    RData file with an AnnotatedDataFrame of phenotypes and covariates. Sample identifiers must be in column named “sample.id”. It is recommended to use the phenotype file output by the GENESIS Null Model app.
  type: File
  sbg:fileTypes: RDATA
  sbg:x: -10.142857551574707
  sbg:y: 556.7142944335938
- id: pass_only
  label: Pass only
  doc: |-
    TRUE to select only variants with FILTER=PASS. If FALSE, variants that failed the quality filter will be included in the test.
  type: boolean?
  sbg:toolDefaultValue: 'TRUE'
  sbg:x: 193.14285278320312
  sbg:y: 603.1428833007812
- id: null_model_file
  label: Null model file
  doc: |-
    RData file containing a null model object. Run the GENESIS Null Model app to create this file. Please make sure to use the null model output instead of the null model report only output.
  type: File
  sbg:fileTypes: RDATA
  sbg:x: 95.42857360839844
  sbg:y: 650.4285888671875
- id: memory_gb
  label: Memory GB
  doc: Memory in GB per job.
  type: float?
  sbg:toolDefaultValue: '8'
  sbg:x: -8.857142448425293
  sbg:y: 694
- id: cpu
  label: CPU
  doc: Number of CPUs for each job.
  type: int?
  sbg:toolDefaultValue: '1'
  sbg:x: 194.2857208251953
  sbg:y: 741.5714111328125
- id: alt_freq_max
  label: Alt Freq Max
  doc: |-
    Maximum alternate allele frequency of variants to include in the test. Default: 1 (no filtering of variants by frequency).
  type: float?
  sbg:toolDefaultValue: '1'
  sbg:x: 100.28571319580078
  sbg:y: 786.1428833007812
- id: thin_npoints
  label: Thin N points
  doc: Number of points in each bin after thinning.
  type: int?
  sbg:toolDefaultValue: '10000'
  sbg:x: 1115.013427734375
  sbg:y: 307.66204833984375
- id: thin_nbins
  label: Thin N bins
  doc: Number of bins to use for thinning.
  type: int?
  sbg:toolDefaultValue: '10'
  sbg:x: 954.8375854492188
  sbg:y: 338.2701110839844
- id: known_hits_file
  label: Known hits file
  doc: |-
    RData file with data.frame containing columns chr and pos. If provided, 1 Mb regions surrounding each variant listed will be omitted from the QQ and manhattan plots.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: 1191.838134765625
  sbg:y: 453.8511962890625
- id: disable_thin
  label: Disable Thin
  doc: |-
    Logical for whether to thin points in the QQ and Manhattan plots. By default, points are thinned in dense regions to reduce plotting time. If this parameter is set to TRUE, all variant p-values will be included in the plots, and the plotting will be very long and memory intensive.
  type: boolean?
  sbg:x: 1195.4864501953125
  sbg:y: 579.4459228515625
- id: input_gds_files
  label: GDS files
  doc: |-
    GDS files with genotype data for variants to be tested for association. If multiple files are selected, they will be run in parallel. Files separated by chromosome are expected to have ‘chr##’ strings indicating chromosome number, where ‘##’ can be (1-24, X, Y). Output files for each chromosome will include the corresponding chromosome number.
  type: File[]
  sbg:fileTypes: GDS
  sbg:x: -516.9198608398438
  sbg:y: -340.3941650390625
- id: out_prefix
  label: Output prefix
  doc: Prefix that will be included in all output files.
  type: string
  sbg:x: 236.25506591796875
  sbg:y: 888.9534301757812
- id: truncate_pval_threshold
  label: Truncate pval threshold
  doc: Maximum p-value to display in truncated QQ and manhattan plots.
  type: float?
  sbg:x: 974.3208618164062
  sbg:y: 581.1929931640625
- id: plot_mac_threshold
  label: Plot MAC threshold
  doc: |-
    Minimum minor allele count for variants or aggregate units to include in plots (if different from MAC threshold).
  type: int?
  sbg:x: 976.2490234375
  sbg:y: 719.1896362304688
- id: variant_include_files
  label: Variant Include Files
  doc: RData file containing ids of variants to be included.
  type: File[]?
  sbg:fileTypes: RData
  sbg:x: -105.97315979003906
  sbg:y: -521.52490234375

outputs:
- id: assoc_combined
  label: Association test results
  doc: |-
    RData file with data.frame of association test results (test statistic, p-value, etc.) See the documentation of the GENESIS R package for detailed description of output.
  type: File[]?
  outputSource:
  - assoc_combine_r/assoc_combined
  sbg:fileTypes: RDATA
  sbg:x: 1454.7757568359375
  sbg:y: 0.5113019943237305
- id: assoc_plots
  label: Association test plots
  doc: QQ and Manhattan Plots of p-values in association test results.
  type: File[]?
  outputSource:
  - assoc_plots_r/assoc_plots
  sbg:fileTypes: PNG
  sbg:x: 1609.0615234375
  sbg:y: 196.2255859375

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
  run: assoc-aggregate-wf.cwl.steps/define_segments_r.cwl
  out:
  - id: config
  - id: define_segments_output
  sbg:x: -246.3984375
  sbg:y: -60
- id: aggregate_list
  label: Aggregate List
  in:
  - id: variant_group_file
    source: variant_group_files
  - id: aggregate_type
    source: aggregate_type
  - id: group_id
    source: group_id
  scatter:
  - variant_group_file
  run: assoc-aggregate-wf.cwl.steps/aggregate_list.cwl
  out:
  - id: aggregate_list
  - id: config_file
  sbg:x: -96
  sbg:y: 191
- id: assoc_aggregate
  label: Association Testing Aggregate
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
  - id: aggregate_variant_file
    valueFrom: '$(self ? [].concat(self)[0] : self)'
    source:
    - sbg_prepare_segments_1/aggregate_output
    linkMerge: merge_flattened
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
  - id: aggregate_type
    source: aggregate_type
  - id: alt_freq_max
    source: alt_freq_max
  - id: pass_only
    source: pass_only
  - id: variant_weight_file
    source: variant_weight_file
  - id: weight_user
    source: weight_user
  - id: cpu
    source: cpu
  - id: memory_gb
    source: memory_gb
  - id: genome_build
    source: genome_build
  scatter:
  - gds_file
  - aggregate_variant_file
  - variant_include_file
  - segment
  scatterMethod: dotproduct
  run: assoc-aggregate-wf.cwl.steps/assoc_aggregate.cwl
  out:
  - id: assoc_aggregate
  - id: config
  sbg:x: 656
  sbg:y: 120
- id: assoc_combine_r
  label: Association Combine
  in:
  - id: chromosome
    valueFrom: '$(self ? [].concat(self) : self)'
    source:
    - sbg_group_segments_1/chromosome
  - id: assoc_type
    default: aggregate
  - id: assoc_files
    valueFrom: '$(self ? [].concat(self) : self)'
    source:
    - sbg_group_segments_1/grouped_assoc_files
  scatter:
  - chromosome
  - assoc_files
  scatterMethod: dotproduct
  run: assoc-aggregate-wf.cwl.steps/assoc_combine_r.cwl
  out:
  - id: assoc_combined
  - id: configs
  sbg:x: 1267
  sbg:y: 180.71429443359375
- id: assoc_plots_r
  label: Association test plots
  in:
  - id: assoc_files
    valueFrom: '$(self ? [].concat(self) : self)'
    source:
    - assoc_combine_r/assoc_combined
    linkMerge: merge_flattened
  - id: assoc_type
    default: aggregate
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
  run: assoc-aggregate-wf.cwl.steps/assoc_plots_r.cwl
  out:
  - id: assoc_plots
  - id: configs
  - id: Lambdas
  sbg:x: 1462.4285888671875
  sbg:y: 357.4285583496094
- id: sbg_gds_renamer
  label: SBG GDS renamer
  in:
  - id: in_variants
    source: input_gds_files
  scatter:
  - in_variants
  run: assoc-aggregate-wf.cwl.steps/sbg_gds_renamer.cwl
  out:
  - id: renamed_variants
  sbg:x: -372.694091796875
  sbg:y: -244.2437744140625
- id: sbg_flatten_lists
  label: SBG FlattenLists
  in:
  - id: input_list
    valueFrom: |-
      ${     var out = [];     for (var i = 0; i<self.length; i++){         if (self[i])    out.push(self[i])     }     return out }
    source:
    - assoc_aggregate/assoc_aggregate
  run: assoc-aggregate-wf.cwl.steps/sbg_flatten_lists.cwl
  out:
  - id: output_list
  sbg:x: 915.6107788085938
  sbg:y: 182.4495849609375
- id: sbg_group_segments_1
  label: SBG Group Segments
  in:
  - id: assoc_files
    source:
    - sbg_flatten_lists/output_list
  run: assoc-aggregate-wf.cwl.steps/sbg_group_segments_1.cwl
  out:
  - id: grouped_assoc_files
  - id: chromosome
  sbg:x: 1075.814208984375
  sbg:y: 178.85438537597656
- id: sbg_prepare_segments_1
  label: SBG Prepare Segments
  in:
  - id: input_gds_files
    source:
    - sbg_gds_renamer/renamed_variants
  - id: segments_file
    source: define_segments_r/define_segments_output
  - id: aggregate_files
    source:
    - aggregate_list/aggregate_list
  - id: variant_include_files
    source:
    - variant_include_files
  run: assoc-aggregate-wf.cwl.steps/sbg_prepare_segments_1.cwl
  out:
  - id: gds_output
  - id: segments
  - id: aggregate_output
  - id: variant_include_output
  sbg:x: 95.99354553222656
  sbg:y: -143.77420043945312

hints:
- class: sbg:AWSInstanceType
  value: c5.2xlarge;ebs-gp2;1024
- class: sbg:maxNumberOfParallelInstances
  value: '8'
- class: sbg:AzureInstanceType
  value: Standard_D8s_v4;PremiumSSD;1024
sbg:appVersion:
- v1.2
sbg:categories:
- GWAS
- CWL1.0
sbg:content_hash: a3fd61e6b6475b7259f65100df8cb701b5ace99bd556be0792e407fd807d710fb
sbg:contributors:
- admin
sbg:createdBy: admin
sbg:createdOn: 1577727846
sbg:expand_workflow: false
sbg:id: admin/sbg-public-data/aggregate-association-testing/35
sbg:image_url:
sbg:latestRevision: 35
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
sbg:modifiedOn: 1635438711
sbg:original_source: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/admin/sbg-public-data/aggregate-association-testing/35/raw/
sbg:project: admin/sbg-public-data
sbg:projectName: SBG Public Data
sbg:publisher: sbg
sbg:revision: 35
sbg:revisionNotes: thin_nbins updated in assoc plot
sbg:revisionsInfo:
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727846
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727846
  sbg:revision: 1
  sbg:revisionNotes: Revision for publishing
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727847
  sbg:revision: 2
  sbg:revisionNotes: Modify description in accordance to reviews
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727847
  sbg:revision: 3
  sbg:revisionNotes: Modify description
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577727847
  sbg:revision: 4
  sbg:revisionNotes: CWL1.0
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1577807264
  sbg:revision: 5
  sbg:revisionNotes: Latest
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1585350127
  sbg:revision: 6
  sbg:revisionNotes: SBG GDS Renamer added
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1585350128
  sbg:revision: 7
  sbg:revisionNotes: Output prefix required
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1585350128
  sbg:revision: 8
  sbg:revisionNotes: Description updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602161635
  sbg:revision: 9
  sbg:revisionNotes: SBG FlattenList updated to CWL1.0
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602161635
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
  sbg:revisionNotes: Input and output update
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755637
  sbg:revision: 14
  sbg:revisionNotes: Plot prefix = output prefix
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755637
  sbg:revision: 15
  sbg:revisionNotes: Apps ordering in app settings
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1602755637
  sbg:revision: 16
  sbg:revisionNotes: Description updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1604053018
  sbg:revision: 17
  sbg:revisionNotes: Congig cleaning
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1604053019
  sbg:revision: 18
  sbg:revisionNotes: Config cleaning
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1604053019
  sbg:revision: 19
  sbg:revisionNotes: Config cleaning
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1616425668
  sbg:revision: 20
  sbg:revisionNotes: CWLtool compatible
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1616425668
  sbg:revision: 21
  sbg:revisionNotes: Docker updated to uwgac/topmed-master:2.10.0
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1616425668
  sbg:revision: 22
  sbg:revisionNotes: Plot update
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1616425668
  sbg:revision: 23
  sbg:revisionNotes: Benchmarking table updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1617276239
  sbg:revision: 24
  sbg:revisionNotes: Plot update
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1617276239
  sbg:revision: 25
  sbg:revisionNotes: Plot update
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1621514962
  sbg:revision: 26
  sbg:revisionNotes: Assoc plot labels updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1621514962
  sbg:revision: 27
  sbg:revisionNotes: Azure instance hint added
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1624463206
  sbg:revision: 28
  sbg:revisionNotes: Azure hint change
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1624463206
  sbg:revision: 29
  sbg:revisionNotes: Azure hint change
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1630939196
  sbg:revision: 30
  sbg:revisionNotes: chmod -R 777 added to command line
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1632333811
  sbg:revision: 31
  sbg:revisionNotes: uwgac/topmed-master:2.12.0
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1632333811
  sbg:revision: 32
  sbg:revisionNotes: Assoc plot computational requirements adjusted
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1632333811
  sbg:revision: 33
  sbg:revisionNotes: Description updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1632333811
  sbg:revision: 34
  sbg:revisionNotes: Description updated
- sbg:modifiedBy: admin
  sbg:modifiedOn: 1635438711
  sbg:revision: 35
  sbg:revisionNotes: thin_nbins updated in assoc plot
sbg:sbgMaintained: false
sbg:toolAuthor: TOPMed DCC
sbg:validationErrors: []
sbg:workflowLanguage: CWL
