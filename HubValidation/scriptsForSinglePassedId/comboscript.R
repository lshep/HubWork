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

suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(dbplyr))
suppressPackageStartupMessages(library(RSQLite))
suppressPackageStartupMessages(library(AnnotationHub))
suppressPackageStartupMessages(library(ExperimentHub))
suppressPackageStartupMessages(library(BiocFileCache))
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

    
## Load Sqlite file for direct query of all database tables and rows 
## including removed, deprecated, rdatadateremoved

hubcon <- DBI::dbConnect(RSQLite::SQLite(), hub_sqlite)
resources <- tbl(hubcon, "resources") %>% select(id, ah_id, status_id, location_prefix_id, rdatadateremoved, preparerclass)
rdatapaths <- tbl(hubcon, "rdatapaths")
locationPF <- tbl(hubcon, "location_prefixes")
status <- tbl(hubcon, "statuses")

full <- 
left_join(rdatapaths, left_join(resources, locationPF,
                                by=c("location_prefix_id"="id")),
          by=c("resource_id"="id"))
full2 <- left_join(full, status, by=c("status_id"="id"))

##-------------------------------------------------------------------------------------------
## full list of ids regardless if already designated as removed
##  we could filter this down or use id list straight from Hub constructor call
##  Likely this will be removed if we are not looping over ids
##-------------------------------------------------------------------------------------------

# full_unique_id_list <- full2 %>% select(ah_id) %>% collect() %>% unique() %>% pull()

##-------------------------------------------------------------------------------------------
##  Temporarily assign manually an ahid
##  Consider altering script to take argument that is id
##-------------------------------------------------------------------------------------------

## if we looped over ids
#for(ahid in full_unique_id_list){

## Added as script argument
# hubid = full_unique_id_list[1]







##-------------------------------------------------------------------------------------------
##  Check Valid Endpoints
##    Uses HEAD requests which may result in false postiive if endpoint does not allow HEAD requests
##    Note: ids may have multiple endpoints, ex. fa/fai, bam/bai
##          make sure to account for multiple endpoints
##-------------------------------------------------------------------------------------------

## Check status and rdatadateremoved
## Public status means available,  Public:  status == 2
## Rdatadateremoved is date the resource was removed and should no longer be available
##    ?? does a non public status mean that it would not be visible in previous
##       versions ??
##

tbl_values <- full2 %>% filter(ah_id == hubid)
if(nrow(tbl_values %>% collect()) == 0){
    
    message(hubid, ": ERROR id does not exist in ", Hub)

}else{

    status_values <- tbl_values %>% select(status_id) %>% pull()
    removed_dates <- tbl_values %>% select(rdatadateremoved) %>% pull()
    if(any(status_values != 2)){
        message(hubid, ": WARNING not public status in ", Hub)
        if(any(status_values == 2)){
            message(hubid, ": WARNING mixed status. Investigate")
        } 
        if(any(is.na(removed_dates))){
            message(hubid, ": WARNING rdatadateremove not specified. Investigate")
        }            
    }else{       
        if(!all(is.na(removed_dates))){
            message(hubid, ": WARNING rdatadateremove but no remove status. Investigate")
        }
    }

    ## Do we care with checking endpoint based on if status or rdatadateremoved are indicated? 

    endpoints <- tbl_values %>% mutate(endpoint = paste0(location_prefix, rdatapath)) %>% pull(endpoint)

    statuses <- sapply(endpoints, function(url) {
        tryCatch({
            req <- request(url) |> 
            req_method("HEAD")
            resp <- req_perform(req)
            resp_status(resp)
        }, error = function(e) {
            warning(sprintf("%s: Request to %s failed: %s", hubid, url, e$message))
            400  # or e$message if you want the error text instead
        })
    })
    if(all(statuses == 200)){
        message(hubid, ": OK endpoint valid")
    }else{
        message(hubid, ": ERROR contains an invalid endpoint")
    }
}



DBI::dbDisconnect(hubcon)

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
