# Hub Validations

This respository is for intitial investigation of Bioconductor Hub resources to
ensure validity.

## Sequential Steps of Validity and Initial Investigations 

1. **GetFileSizes.R** Using R functions, investigate the size of the resources
   available using HEAD request. May not work on servers that do not support HEAD
   requests. This information will help determine the size of an instance we need
   for following steps. 
       Produces: **EH_fileSize.RData** and  **AH_fileSize.RData**

2. **jetstreamsetup.sh**:
   command line installations and set up. Choose appropriate instance based on
   file size and processing.  **Note**: m3.medium was not adequate; there were
   some resources that maxed out the 8 CPU and 30 GB RAM and killed the
   process. 

3. **ValidateEndpoints.R** Using resource download url check if available. This
   may have false positives if server does not allow HEAD request.
       Produces: **ehresults.RData** and  **ahresults.RData**

4. **InvestigateBadEndpoints.R** Manual investigation of failures from
   ValidateEndpoints.R

5. **InvestigatePackagesNotAvailable.R** Based on available resources in
   ExperimentHub. What associated packages are not available.
       Produces: **eh_pkgsnotavail.RDData**

6. **ValidateLoadingResource.R** check if resources is able to load into
   R. Have not run AnnotationHub check yet.
   Produces: **EH_LoadingValidation.RData** (potentially
   "EH_PartialSave_LoadingValidation.RData" in case if fails early) and
   **AH_LoadingValidation.RData** (not available yet)

7. **(TODO)** virus check?
   

## Parallelization

See subdirectory scriptsForSinglePassedId. The most helpful parallelization
would be instead of each step sequentially performing on ids, send each id as a
separate job.  The scripts in this directory are modified from the original to
operate per id basis.  These scripts currently take two arguments:

	1. **Hub Type** (AnnotationHub or ExperimentHub)

	2. **Hub Id** (Id to perform task. eg. AH1, AH5012, EH2, EH1221)

Current Scripts:

1. **GetFileSizes.R**: Checks file sizes as determined by
`httr2::HEAD$content-length` (This script may get moved and altered to after a resources is
downloaded for better precision).

2. **ValidateEndpoints.R**: Checks status in Hub (if should be available via
status/rdatadateremoved) and validates endpoint via `httr2::HEAD$status`

3. comboscript.R: Attempt at combining previous steps in single script.

All functions currently can be executed using Rscript and passing the required
two arguments.

`Rscript comboscript.R ExperimentHub EH1`
`Rscript comboscript.R AnnotationHub AH5012`