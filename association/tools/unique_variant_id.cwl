cwlVersion: v1.1
class: CommandLineTool
label: unique_variant_id
$namespaces:
  sbg: https://sevenbridges.com

requirements:
- class: ShellCommandRequirement
- class: DockerRequirement
  dockerPull: uwgac/topmed-master:2.10.0
- class: InitialWorkDirRequirement
  listing:
  - entryname: unique_variant_ids.config
    writable: false
    entry: |
      ${
          function isNumeric(s) {
              return !isNaN(s - parseFloat(s));
          }
          
          function compareNatural(a,b){
              return a.localeCompare(b, 'en', {numeric: true, ignorePunctuation: true})
          }
          
          function find_chromosome(file){
              var chr_array = [];
              var chrom_num = file.split("/").pop();
              chrom_num = chrom_num.split("chr")[1];
              
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
          var chr = find_chromosome(inputs.gds_file[0].path);
          var gds = inputs.gds_file[0].path.split('/').pop();
          
          
          
          var chr_array = [];
          for (var i = 0; i < inputs.gds_file.length; i++) 
          {
              var chrom_num = inputs.gds_file[i].path.split("/").pop();
              chrom_num = chrom_num.split("chr")[1];
              
              if(isNumeric(chrom_num.charAt(1)))
              {
                  chr_array.push(chrom_num.substr(0,2))
              }
              else
              {
                  chr_array.push(chrom_num.substr(0,1))
              }
          }
          
          
          
          chr_array = chr_array.sort(compareNatural);
          var chrs = "";
          for (var i = 0; i < chr_array.length; i++) 
          {
              chrs += chr_array[i] + " "
          }
          
          
          var ind_X = chrs.includes("X")
          var ind_Y = chrs.includes("Y")
          var ind_M = chrs.includes("M")
          
          var chr_array = chrs.split(" ")
          var chr_order = [];
          var chr_result = ""
          
          for(i=0; i<chr_array.length; i++){
              
          if(!isNaN(chr_array[i]) && chr_array[i]!= "") {chr_order.push(parseInt(chr_array[i]))}    
              
              
          }
          
          
          chr_order = chr_order.sort(function(a, b){return a-b})
          for(i=0; i<chr_order.length; i++){
              
              chr_result += chr_order[i].toString() + " "
          }
          
          if(ind_X) chr_result += "X "
          if(ind_Y) chr_result += "Y "
          if(ind_M) chr_result += "M "
          
          chrs = chr_result

          
          
          var return_arguments = [];
          return_arguments.push('gds_file "' + gds.split("chr")[0] + "chr "+gds.split("chr"+chr)[1] +'"');
          return_arguments.push('chromosomes "' + chrs + '"')
          
          return return_arguments.join('\n') + "\n"
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
  doc: List of GDS files produced by VCF2GDS tool.
  type: File[]
  sbg:fileTypes: GDS

outputs:
- id: unique_variant_id_gds_per_chr
  label: Unique variant ID corrected GDS files per chromosome
  doc: Corrected GDS files per chromosome.
  type: File[]?
  outputBinding:
    glob: '*chr*'
    outputEval: $(inheritMetadata(self, inputs.gds_file))
  sbg:fileTypes: GDS
- id: config
  label: Config file
  doc: Config file for running the R script.
  type: File?
  outputBinding:
    glob: '*.config'
  sbg:fileTypes: CONFIG

baseCommand: []
arguments:
- prefix: ''
  position: 5
  valueFrom: |-
    ${
        var cmd_line = "cp ";
        for (var i=0; i<inputs.gds_file.length; i++)
            cmd_line += inputs.gds_file[i].path + " "
        cmd_line += ". && "
        if(inputs.merged_gds_file)
        {
            cmd_line += "cp " + inputs.merged_gds_file.path + " . && "
        }
        return cmd_line
    }
  shellQuote: false
- prefix: ''
  position: 10
  valueFrom: |-
    ${
        return " Rscript /usr/local/analysis_pipeline/R/unique_variant_ids.R unique_variant_ids.config"
    }
  shellQuote: false
- prefix: ''
  position: 100
  valueFrom: "${\n    return ' >> job.out.log'\n}"
  shellQuote: false

hints:
- class: sbg:SaveLogs
  value: job.out.log
id: boris_majic/genesis-toolkit-demo/unique-variant-id/8
sbg:appVersion:
- v1.1
sbg:content_hash: a9d7399aa9b7ad61f15221a7e3008cc628f0fa2ac6a0bf9b53a4f5829da5e27c3
sbg:contributors:
- dajana_panovic
- boris_majic
sbg:createdBy: boris_majic
sbg:createdOn: 1577360588
sbg:id: h-4d9218f9/h-08255f6e/h-5cc28abf/0
sbg:image_url:
sbg:latestRevision: 8
sbg:modifiedBy: dajana_panovic
sbg:modifiedOn: 1616077508
sbg:project: boris_majic/genesis-toolkit-demo
sbg:projectName: GENESIS Toolkit - DEMO
sbg:publisher: sbg
sbg:revision: 8
sbg:revisionNotes: Docker updated to uwgac/topmed-master:2.10.0
sbg:revisionsInfo:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577360588
  sbg:revision: 0
  sbg:revisionNotes:
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1577360610
  sbg:revision: 1
  sbg:revisionNotes: Import from F4C
- sbg:modifiedBy: boris_majic
  sbg:modifiedOn: 1580990298
  sbg:revision: 2
  sbg:revisionNotes: Removed arrow notation
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1584373255
  sbg:revision: 3
  sbg:revisionNotes: ''
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1594133042
  sbg:revision: 4
  sbg:revisionNotes: Docker image updated to 2.8.0
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1602155656
  sbg:revision: 5
  sbg:revisionNotes: Import from BDC 2.8.1 version
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1603718027
  sbg:revision: 6
  sbg:revisionNotes: Config cleaning
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1608904099
  sbg:revision: 7
  sbg:revisionNotes: CWLtool prep
- sbg:modifiedBy: dajana_panovic
  sbg:modifiedOn: 1616077508
  sbg:revision: 8
  sbg:revisionNotes: Docker updated to uwgac/topmed-master:2.10.0
sbg:sbgMaintained: false
sbg:validationErrors: []
