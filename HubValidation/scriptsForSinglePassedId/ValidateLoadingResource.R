args <- commandArgs(trailingOnly = TRUE)

if (length(args) != 2) {
  stop("Expecting two arguments: Hub Type (AnnotationHub/ExperimentHub) and Hub resource id (e.g AH2/EH2)",
  call. = FALSE)
}

Hub <- args[1]
hubid <- args[2]

##-------------------------------------------------------------------------------------------
##  Argument Sanity Check
##-------------------------------------------------------------------------------------------

if( !(Hub %in% c("ExperimentHub", "AnnotationHub")) ){
    stop("Hub must be either ExperimentHub or AnnotationHub.\n",
         "  Received: ", Hub)
}

if( ((Hub == "ExperimentHub") & !startsWith(hubid, "EH")) |
    ((Hub == "AnnotationHub") & !startsWith(hubid, "AH")) ){
    
    stop("Mismatch of Hub with hubid.\n",
         "  ExperimentHub should have EH ids\n",
         "  AnnotationHub should have AH ids\n",
         "  Received: ", Hub, " ", hubid)
}



##-------------------------------------------------------------------------------------------
##  Load R Libraries
##-------------------------------------------------------------------------------------------


suppressPackageStartupMessages(library(AnnotationHub))
suppressPackageStartupMessages(library(ExperimentHub))
suppressPackageStartupMessages(library(BiocFileCache))
suppressPackageStartupMessages(library(httr))
suppressPackageStartupMessages(library(BiocManager))
suppressPackageStartupMessages(library(dplyr))




## Possible Argument to script in addition to hubid (see below), which Hub is it
## Added as script argument
# Hub <- "AnnotationHub"


##
##
##
##
##   Do we care about testing the loading of an ah/eh id that is not suppose to
##   be availablle?
##
##
##
##
##





##-------------------------------------------------------------------------------------------
##  This section will load Hub and load database of metadata into R
##-------------------------------------------------------------------------------------------

if(Hub == "AnnotationHub"){

    ## Load AnnotationHub and get the path to the sqlite file
    hub <- AnnotationHub()
    
}else{
    
    ## Load AnnotationHub and get the path to the sqlite file
    hub <- ExperimentHub()
}

safe_load <- function(expr) {
  tryCatch(
    {
      expr
      list(success = TRUE, message = NULL)
    },
    error = function(e) {
      list(success = FALSE, message = conditionMessage(e))
    }
  )
}

if(!(hubid %in% rownames(mcols(hub)))){    
    message("hubid: ", hubid, " not active in ", Hub)
}else{
    
    res <- safe_load({
        temp <- hub[[hubid]]
    })

    
    
    
    ##
    ## move filesize to before removal to check ones that dont have size in
    ## header information?
    ##
    
    removeResources(hub, ids=hubid)

}
