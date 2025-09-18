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

if( ((Hub == "ExperimentHub") & startsWith(hubid, "AH")) |
    ((Hub == "AnnotationHub") & startsWith(hubid, "EH")) ){
    
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
suppressPackageStartupMessages(library(httr2))

## Possible Argument to script in addition to hubid (see below), which Hub is it
## Added as script argument
# Hub <- "AnnotationHub"


##-------------------------------------------------------------------------------------------
##  This section will load Hub and load database of metadata into R
##-------------------------------------------------------------------------------------------

if(Hub == "AnnotationHub"){

    ## Load AnnotationHub and get the path to the sqlite file
    hub <- AnnotationHub()
    bfc <- AnnotationHub:::.get_cache(hub)
    hub_sqlite <- bfcpath(bfc, bfcrid(bfcquery(bfc, "annotationhub.sqlite3", fields="rname", exact=TRUE)))
    
}else{
    
    ## Load AnnotationHub and get the path to the sqlite file
    hub <- ExperimentHub()
    bfc <- AnnotationHub:::.get_cache(hub)
    hub_sqlite <- bfcpath(bfc, bfcrid(bfcquery(bfc, "experimenthub.sqlite3", fields="rname", exact=TRUE)))
}


##-------------------------------------------------------------------------------------------
##  Temporarily assign manually an ahid
##  Consider altering script to take argument that is id
##-------------------------------------------------------------------------------------------

## Added as script argument
# hubid <- rownames(mcols(hub[1]))


##-------------------------------------------------------------------------------------------
##  Check File Sizes
##  uses Hub function that internally uses httr2 HEAD content-length
##
##  NOTE: consider moving to after download and get official content size and to
##  avoid situations where content-lenght is not available 
## -------------------------------------------------------------------------------------------

fileSize <-
    tryCatch({
        as.numeric(getInfoOnIds(hub, hubid)$file_size)
    }, error=function(err){
        NA
    })

msg <- ifelse(is.na(fileSize),
              paste0(hubid, ": WARNING cannot determine filesize"),
              paste0(hubid, ": OK filesize: ",fileSize, " bytes"))

message(msg)
