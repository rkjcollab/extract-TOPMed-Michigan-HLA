# Extract TOPMed and Michigan HLA

[![Docker Build Status](https://img.shields.io/docker/build/kgaultonlab/t1d-grs-analysis-r3-xgboost.svg)](https://hub.docker.com/repository/docker/kgaultonlab/t1d-grs-analysis)
## Overview

This project provides a Docker image that can be pulled from Docker Hub and run locally. The Docker image contains all necessary dependencies and code to get started quickly.

## Prerequisites

- Docker installed on your local machine. You can download Docker from [here](https://www.docker.com/products/docker-desktop).

## Getting Started

### Pulling the Docker Image

To pull the latest Docker image from Docker Hub, use the following command:

```
docker pull kgaultonlab/t1d-grs-analysis:latest
```

### Running the Docker Container

To run the Docker container with the necessary volume mappings, use the following command (this can be run as a bash script):

```
#!/bin/bash

# Run the Docker container
docker run --name my_temp_container \
  -v /path/to/your/TOPMED_r3:/data/TOPMED_r3 \
  -v /path/to/your/Michigan_HLA:/data/Michigan_HLA \
  -v /path/to/your/ALL5_199_TOPMED_SUSIE_HLA_T1D_signals_updateID_r3.snps:/data/ALL5_199_TOPMED_SUSIE_HLA_T1D_signals_updateID_r3.snps \
  your-dockerhub-username/your-repo:latest \
  /usr/local/bin/plink2 /data/TOPMED_r3 /data/Michigan_HLA /data/ALL5_199_TOPMED_SUSIE_HLA_T1D_signals_updateID_r3.snps /output.vcf

# Copy the output file from the container to the host directory
docker cp my_temp_container:/output.vcf /path/to/your/output/output.vcf
```
Replace the paths in the -v options with your actual paths where the files are located on your host machine.

### Stopping and Removing the Container

To stop the running container, use:

```
docker stop my_temp_container
```
To remove the container, use:
```
docker rm my_temp_container
```
### Checking Container Logs

If you need to check the logs of the running container, use:
```
docker logs my_temp_container
```
### Updating the Docker Image

To update the Docker image to the latest version, pull the latest image from Docker Hub:
```
docker pull kgaultonlab/t1d-grs-analysis:latest
```
Then, stop and remove the old container, and run the new image:
```
docker stop my_temp_container
docker rm my_temp_container
docker run -d --name my_temp_container your-dockerhub-username/your-repo:latest
```

## License
See the license document for information on licensing.  

## Contact
If you have any questions, feel free to open an issue.
