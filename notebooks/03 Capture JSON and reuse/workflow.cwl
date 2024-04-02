#!/usr/bin/env cwl-runner

$graph:
- class: Workflow

  inputs:
    stac_item: 
      type: string
    asset_id:
      type: string

  outputs:
    quicklook:
      outputSource: step_convert/quicklook
      type: File

  steps:
    
    step_stac:

      in: 
        stac_item: stac_item
      out: 
      - asset

      run:
        "#stac"

    step_convert:

        in:
          asset: 
            source: step_stac/asset
          asset_id: asset_id

        out: 
        - quicklook

        run: 
          "#rio"

  id: main

- class: CommandLineTool

  id: stac

  requirements:
    InlineJavascriptRequirement: {}
    NetworkAccess:
      networkAccess: true

  hints:
    DockerRequirement: 
      dockerPull: docker.io/curlimages/curl:latest

  baseCommand: curl

  stdout: message

  arguments: 
  - $( inputs.stac_item )

  inputs:

    stac_item:
      type: string

  outputs:

    asset: 
      type: Any
      outputBinding:
        glob: message
        loadContents: true
        outputEval: ${ return JSON.parse(self[0].contents).assets; }

- class: CommandLineTool

  requirements:
    EnvVarRequirement:
      envDef: {}
    InlineJavascriptRequirement: {}
    NetworkAccess:
      networkAccess: true

  inputs:
    asset:
      type: Any
    asset_id:
      type: string 

  outputs:
    quicklook: 
      type: File
      outputBinding:
        glob: "quicklook.png"
  
  baseCommand: rio
  arguments:
  - convert
  - -f
  - PNG
  - valueFrom: |
      $( inputs.asset[inputs.asset_id].href )
  - quicklook.png

  hints:
    DockerRequirement:
      dockerPull: localhost/rio:latest
  id: rio
  
cwlVersion: v1.2
