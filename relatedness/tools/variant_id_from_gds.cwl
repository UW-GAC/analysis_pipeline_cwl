cwlVersion: v1.2
class: CommandLineTool
label: variant id from gds
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InitialWorkDirRequirement
  listing:
  - entryname: variant_id_from_gds.R
    writable: false
    entry: |
      library(argparser)
      library(SeqArray)

      argp <- arg_parser("variant_id_from_gds")
      argp <- add_argument(argp, "--gds_file", help="gds file")
      argp <- add_argument(argp, "--out_file", help="output file", default="variant_id.rds")
      argv <- parse_args(argp)

      gds <- seqOpen(argv$gds_file)
      var.id <- seqGetData(gds, "variant.id")
      saveRDS(var.id, file=argv$out_file)
      seqClose(gds)

inputs:
- id: gds_file
  label: GDS file
  type: File
  inputBinding:
    prefix: --gds_file
    position: 0
    shellQuote: false
  sbg:fileTypes: GDS
- id: out_file
  label: Name for output file
  type: string?
  inputBinding:
    prefix: --out_file
    position: 1
    shellQuote: false
  sbg:toolDefaultValue: variant_id.rds

outputs:
- id: output_file
  type: File
  outputBinding:
    glob: '*.rds'
stdout: job.out.log

baseCommand:
- Rscript
- variant_id_from_gds.R

hints:
- class: sbg:SaveLogs
  value: '*.log'
