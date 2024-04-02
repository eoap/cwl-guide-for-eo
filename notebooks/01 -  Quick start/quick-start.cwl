cwlVersion: v1.2

# What type of CWL process we have in this document.
class: CommandLineTool
# This CommandLineTool executes the rasterio "rio" command-line tool.
baseCommand: rio
# The arguments for this process
arguments: 
- bounds
# The inputs for this process.
inputs:
  geotiff:
    type: string
    # A default value that can be overridden, e.g. --message "Hola mundo"
    default: "https://sentinel-cogs.s3.us-west-2.amazonaws.com/sentinel-s2-l2a-cogs/10/T/FK/2021/7/S2B_10TFK_20210713_0_L2A/TCI.tif"
    # Bind this message value as an argument to "echo".
    inputBinding:
      position: 1
outputs: []

requirements:
    DockerRequirement:
        dockerPull: localhost/rio:latest
    NetworkAccess:
        networkAccess: true