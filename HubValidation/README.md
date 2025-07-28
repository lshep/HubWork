# Hub Validations

This respository is for intitial investigation of Bioconductor Hub resources to
ensure validity.

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
   
