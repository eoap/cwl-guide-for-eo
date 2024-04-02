#!/usr/bin/env cwl-runner

$graph:
- class: Workflow

  inputs:
    tif:
      type: string

  outputs:
    info:
      type: string
      outputSource: rio-info/info

  steps:
    
    stac:
      in: 
        stac_item: stac_item
      out: 
      - asset

      run:
        "#stac"

    rio-info:
      in:
        geotiff: tif
      run: '#rio'
      out:
      - info

  id: main

- class: CommandLineTool

  requirements:
    EnvVarRequirement:
      envDef: {}
    InlineJavascriptRequirement: {}
    NetworkAccess:
      networkAccess: true

  inputs:
    geotiff:
      type: string
      inputBinding:
        position: 1  

  outputs:
    info:
      type: Any
      outputBinding:
        glob: message
        outputEval: $( self[0].contents )
        loadContents: true
  
  stdout: message

  baseCommand: rio
  arguments:
  - info



  hints:
    DockerRequirement:
      dockerPull: localhost/rio:latest
  id: rio
cwlVersion: v1.2
