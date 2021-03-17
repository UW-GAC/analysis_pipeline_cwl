cwlVersion: v1.1
class: Workflow
label: Pedigree Check
doc: |-
  This UW-GAC workflow checks expected relationships specified in a pedigree file against empirical kinship values from KING or PC-Relate. 

  The pedigree file should be in tab-delimited text, CSV, or PLINK FAM format. Columns are expected to be "FAMILY_ID", "SUBJECT_ID", "FATHER", "MOTHER", "SEX", with some flexibility for variation in column names (e.g., "FAMID", "SUBJID") and case ignored. A header row is expected unless the suffix is ".fam". Text or CSV files may have columns in a different order, as long as column names can be interpreted.

  Pedigree files are checked for internal consistency and formatting errors, with the output of this check provided in the Pedigree error file. See the documentation for the R function GWASTools::pedigreeCheck for more information on interpreting this file. Attempts are made to correct errors automatically and proceed with the check (e.g. defining subfamilies, filling in rows for missing parents), but if errors cannot be resolved, the workflow will fail and users should use the "view tasks and logs" feature to examine the pedigree error file.

  The phenotype file is necessary for linking the subject identifiers in the pedigree file to sample identifiers in the kinship file. Sample identifiers in the phenotype file should be in a column named "sample.id". The default value for the subject identifier field is "submitted_subject_id", but this may be specified in "subjectID". The subject identifier in the phenotype file is expected to be unique. Some pedigrees label individuals uniquely only within families; if this is the case, set "concat_family_individ" to "True", and the subject identifier in the phenotype file to <family>_<individual>.

  If the check succeeds, two additional output files will be generated: a plot of kinship estimates showing expected and unexpected relationships, and an RData file with a data.frame of sample pairs labeled by expected and observed relationships.

  Observed relationships are classified by degree as outlined in Manichaikul et al 2010, Bioinformatics 26(22):2867-2873. Duplicates/monozygotic twins have kinship > 2(-3/2), 1st degree relatives (parent/offspring, full siblings) have kinship > 2^(-5/2), 2nd degree relatives (half siblings, avuncular, grandparent/grandchild) have kinship > 2^(-7/2), and 3rd degree relatives (first cousins) have kinship > 2^(-9/2). Pairs with kinship < 2^(-9/2) are classified as unrelated.
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: InlineJavascriptRequirement
- class: StepInputExpressionRequirement

inputs:
- id: phenotype_file
  label: Phenotype File
  doc: RData file with data.frame or AnnotatedDataFrame of phenotypes.
  type: File
  sbg:fileTypes: RDATA
  sbg:x: -561.6885986328125
  sbg:y: -273.5149841308594
- id: kinship_file
  label: Kinship File
  doc: Kinship file
  type: File
  sbg:fileTypes: RDATA, SEG, KIN, GDS
  sbg:x: -467.7105407714844
  sbg:y: -145.34210205078125
- id: sample_include_file
  label: Sample Include File
  doc: RData file with vector of sample.id to include.
  type: File?
  sbg:fileTypes: RDATA
  sbg:x: -407.4191589355469
  sbg:y: -391.5269470214844
- id: out_prefix
  label: Output prefix
  doc: Prefix for output files.
  type: string?
  sbg:x: -590.0526123046875
  sbg:y: 175.1052703857422
- id: kinship_method
  label: Kinship method
  doc: |-
    Method used to generate kinship estimates (KING IBDseg, KING robust, or PC-Relate).
  type:
    name: kinship_method
    type: enum
    symbols:
    - king_ibdseg
    - pcrelate
    - king_robust
  sbg:exposed: true
- id: subjectID
  label: Subject ID column name
  doc: Name of column in phenotype_file containing subject identifier variable.
  type: string?
  sbg:exposed: true
- id: pedigree_file
  label: Pedigree file
  doc: |-
    Text file with pedigree data. Columns should be "FAMILY_ID", "SUBJECT_ID", "FATHER", "MOTHER", "SEX". A header line is expected unless the file extension is ".fam".
  type: File
  sbg:fileTypes: TXT, CSV, FAM
  sbg:x: -628.5648803710938
  sbg:y: 5.703203201293945

outputs:
- id: observed_relatives
  label: Observed relatives
  doc: |-
    RData file with data.frame of pairwise relationships annotated with expected and observed relationship categories. Kinship estimates are included for observed relationships. Pairs expected to be related based on the pedigree but absent from the kinship file will be included with missing values for kinship estimates.
  type: File?
  outputSource:
  - pedigree_check/observed_relatives
  sbg:fileTypes: RDATA
  sbg:x: 174.45025634765625
  sbg:y: -178.64395141601562
- id: kinship_plots
  label: Kinship plots
  doc: |-
    Plots of estimated kinship coefficients vs. IBS0. Expected and unexpected relatives will be plotted in separate panels.
  type: File?
  outputSource:
  - pedigree_check/kinship_plots
  sbg:fileTypes: PDF
  sbg:x: 160.7985076904297
  sbg:y: 19.306297302246094
- id: err_file
  label: Pedigree error file
  doc: RData file with the output of the GWASTools::pedigreeCheck function.
  type: File?
  outputSource:
  - pedigree_format/err_file
  sbg:fileTypes: RDATA
  sbg:x: -174.67015075683594
  sbg:y: 132.07162475585938

steps:
- id: pedigree_format
  label: pedigree_format
  in:
  - id: pedigree_file
    source: pedigree_file
  - id: out_prefix
    source: out_prefix
  run: pedigree-check-wf.cwl.steps/pedigree_format.cwl
  out:
  - id: exp_rels_file
  - id: err_file
  sbg:x: -419.5789489746094
  sbg:y: 6.210526466369629
- id: pedigree_check
  label: pedigree_check
  in:
  - id: kinship_file
    source: kinship_file
  - id: kinship_method
    source: kinship_method
  - id: exp_rel_file
    source: pedigree_format/exp_rels_file
  - id: phenotype_file
    source: phenotype_file
  - id: subjectID
    source: subjectID
  - id: sample_include_file
    source: sample_include_file
  - id: out_prefix
    source: out_prefix
  run: pedigree-check-wf.cwl.steps/pedigree_check.cwl
  out:
  - id: kinship_plots
  - id: observed_relatives
  sbg:x: -107.16937255859375
  sbg:y: -102.1703109741211
sbg:appVersion:
- v1.1
sbg:categories:
- Ancestry and Relatedness
- Quality Control
sbg:content_hash: a8480b8e46f82758cc969046ed5180797557119d9385b0191d3d6c278a007a007
sbg:contributors:
- smgogarten
sbg:createdBy: smgogarten
sbg:createdOn: 1615236741
sbg:id: smgogarten/uw-gac-commit/pedigree-check/2
sbg:image_url: |-
  https://platform.sb.biodatacatalyst.nhlbi.nih.gov/ns/brood/images/smgogarten/uw-gac-commit/pedigree-check/2.png
sbg:latestRevision: 2
sbg:modifiedBy: smgogarten
sbg:modifiedOn: 1615308797
sbg:original_source: |-
  https://api.sb.biodatacatalyst.nhlbi.nih.gov/v2/apps/smgogarten/uw-gac-commit/pedigree-check/2/raw/
sbg:project: smgogarten/uw-gac-commit
sbg:projectName: UW GAC - Commit
sbg:publisher: UWGAC
sbg:revision: 2
sbg:revisionNotes: update step id
sbg:revisionsInfo:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615236741
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615236786
  sbg:revision: 1
  sbg:revisionNotes: import from pre-build
- sbg:modifiedBy: smgogarten
  sbg:modifiedOn: 1615308797
  sbg:revision: 2
  sbg:revisionNotes: update step id
sbg:sbgMaintained: false
sbg:validationErrors: []
