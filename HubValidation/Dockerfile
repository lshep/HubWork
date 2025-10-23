FROM bioconductor/bioconductor_docker:3.21-R-4.5.1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libcurl4-openssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install R packages (Bioconductor packages already available in base image)
RUN R -e "BiocManager::install(c( \
    'AnnotationHub', \
    'ExperimentHub', \
    'BiocFileCache', \
    'dplyr', \
    'dbplyr', \
    'RSQLite', \
    'httr2' \
))"

# Create app directory
WORKDIR /app

# Copy comboscript
COPY scriptsForSinglePassedId/comboscript.R ./comboscript.R

# Make script executable
RUN chmod +x ./comboscript.R

# Default command runs comboscript with arguments
ENTRYPOINT ["Rscript", "/app/comboscript.R"]