# Use a lightweight base image
FROM ubuntu:20.04

# Install dependencies
RUN apt-get update && \
    apt-get install -y wget unzip bzip2 && \
    apt-get clean

# Install PLINK v2
# https://s3.amazonaws.com/plink2-assets/alpha5/plink2_linux_x86_64_20240105.zip
RUN wget https://s3.amazonaws.com/plink2-assets/alpha5/plink2_linux_x86_64_20240105.zip && \
    unzip plink2_linux_x86_64_20240105.zip && \
    mv plink2 /usr/local/bin/ && \
    rm plink2_linux_x86_64_20240105.zip

# Copy the script into the container
COPY extract_TOPMed_R3_Michigan_HLA.sh /usr/local/bin/

# Give execute permission to the script
RUN chmod +x /usr/local/bin/extract_TOPMed_R3_Michigan_HLA.sh

# Set the entry point to the script
ENTRYPOINT ["/usr/local/bin/extract_TOPMed_R3_Michigan_HLA.sh"]
