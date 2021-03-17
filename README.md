# analysis_pipeline_cwl
This repository contains CWL for running [analysis pipeline](https://github.com/UW-GAC/analysis_pipeline) scripts as workflows. Each workflow mirrors a python script in the original repository.

These CWL scripts were developed on the [BioData Catalyst Powered by Seven Bridges](https://platform.sb.biodatacatalyst.nhlbi.nih.gov/) platform, as a collaboration between the UW GAC and Seven Bridges developers. Workflows are composed of tools that wrap R scripts.

Tools require the [uwgac/topmed-master docker image](https://hub.docker.com/r/uwgac/topmed-master).

Workflows were fetched from the [BioData Catalyst Powered by Seven Bridges](https://platform.sb.biodatacatalyst.nhlbi.nih.gov/) platform using [sbpack](https://github.com/rabix/sbpack).
