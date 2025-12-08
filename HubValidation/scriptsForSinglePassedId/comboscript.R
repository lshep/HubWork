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
suppressPackageStartupMessages(library(jsonlite))

status_output = list(HubType = Hub,
                     HubID = hubid,
                     IdExists = TRUE,
                     IdStatus = "OK",
                     Endpoints = "OK",
                     FileSize = NA,
                     RClassIndicated = NA,
                     PackageOrRecipe = NA,
                     Loading = "OK",
                     RClassLoaded = "",
                     FileSizeLocally = NA,
                     StatusMessages = "")

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
status_messages = ""

tbl_values <- full2 %>% filter(ah_id == hubid)
if(nrow(tbl_values %>% collect()) == 0){
    msgTxt <- paste0(hubid, ": ERROR id does not exist in ", Hub)
    message(msgTxt)
    status_output[["IdExists"]] = FALSE
    status_messages = paste(status_messages, msgTxt, "\n")
}else{

    status_values <- tbl_values %>% select(status_id) %>% pull()
    removed_dates <- tbl_values %>% select(rdatadateremoved) %>% pull()
    if(any(status_values != 2)){
        msgTxt <- paste0(hubid, ": WARNING not public status in ", Hub)
        message(msgTxt)
        status_output[["IdStatus"]] = "WARNING"
        status_messages = paste(status_messages, msgTxt, "\n")
        if(any(status_values == 2)){
            msgTxt <- paste0(hubid, ": WARNING mixed status. Investigate")
            message(msgTxt)
            status_output[["IdStatus"]] = "WARNING"
            status_messages = paste(status_messages, msgTxt, "\n")
        } 
        if(any(is.na(removed_dates))){
            msgTxt <- paste0(hubid, ": WARNING rdatadateremove not specified. Investigate")  
            message(msgTxt)
            status_output[["IdStatus"]] = "WARNING"
            status_messages = paste(status_messages, msgTxt, "\n")
        }            
    }else{       
        if(!all(is.na(removed_dates))){
            msgTxt <- paste0(hubid, ": WARNING rdatadateremove but no remove status. Investigate")
            message(msgTxt)
            status_output[["IdStatus"]] = "WARNING"
            status_messages = paste(status_messages, msgTxt, "\n")
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
            msgTxt <- sprintf("%s: Request to %s failed: %s", hubid, url, e$message)
            warning(msgTxt)
            status_messages = paste(status_messages, msgTxt, "\n")
            400  # or e$message if you want the error text instead
        })
    })
    if(all(statuses == 200)){
        msgTxt <- paste0(hubid, ": OK endpoint valid")
        message(msgTxt)
        status_messages = paste(status_messages, msgTxt, "\n")
    }else{
        msgTxt <- paste0(hubid, ": ERROR contains an invalid endpoint")    
        message(msgTxt)
        status_output[["Endpoints"]] = "ERROR"
        status_messages = paste(status_messages, msgTxt, "\n")
    }
    status_output[["RClassIndicated"]] <- tbl_values %>% select(rdataclass) %>% pull()
    status_output[["PackageOrRecipe"]] <- tbl_values %>% select(preparerclass) %>% pull()
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

if(!is.na(fileSize)) status_output[["FileSize"]] = fileSize

msg <- ifelse(is.na(fileSize),
              paste0(hubid, ": WARNING cannot determine filesize"),
              paste0(hubid, ": OK filesize: ",fileSize, " bytes"))
message(msg)
status_messages = paste(status_messages, msg, "\n")
status_output[["StatusMessages"]] <- status_messages


##-------------------------------------------------------------------------------------------
##  Check Loading of File
##
##    This can get buggy:
##       May need additional packages to be installed/loaded
##
##       Some resources require large amounts of memory or CPU
##         Can we track this information so we can have a snapshot of resources
##         needed
##

loading_msg <- ""

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
get_pkg <- function(msg) {
  if (is.null(msg)) return(NA_character_)
  if (!grepl("required package", msg)) return(NA_character_)
  sub(".*required package '([^']+)'.*", "\\1", msg)
}

if(!(hubid %in% rownames(mcols(hub)))){    
    message("hubid: ", hubid, " not active in ", Hub)
    status_output[["Loading"]] = "ERROR"
}else{
    
    res <- safe_load({
        temp <- hub[[hubid]]
    })
     
    ## 
    ## Re-try loading associated package? 
    ##    ?? also search error message and try ?? sub(".*required package '([^']+)'.*", "\\1", res$message)
    if(!res$success){
        loading_message <- res$message
        pkgs_needed <- unique(na.omit(c(get_pkg(res$message), package(hub[hubid]))))
        if(length(pkgs_needed) == 0){
            loading_msg <- paste0(hubid, ": ERROR loading. No packages to install or load")
            status_output[["Loading"]] = "ERROR"
        }else{
            installed <- rownames(installed.packages())
            loading_msg <- paste0(loading_msg, "\n", hubid,
                                  ": Attempting to install packages: ", paste(pkgs_needed, collapse = ", "))
            for (p in pkgs_needed) {
                
                if (!(p %in% installed)) {
                    tryCatch(
                        BiocManager::install(p, ask = FALSE),
                        error = function(e) {
                            loading_msg <- paste0(loading_msg, "\n", hubid,": Unable to install required package ", p)
                        })
                }              
                tryCatch(suppressPackageStartupMessages(library(p)),
                         error = function(e) {
                             loading_msg <- paste0(loading_msg, "\n", hubid, ": Unable to load required package ",p)
                         })                   
            }
            ## second attempt after attempting to load required packages
            res2 <- safe_load({
                temp <- hub[[hubid]]
            })           
            if(!res$success){
                loading_msg <- paste0(hubid,": ERROR Loading.") 
                status_output[["Loading"]] = "ERROR"
            }else{
                loading_msg <- paste0(hubid,": OK loading after additional required packages installed or loaded.")
            }    
            
        }        
    }else{
        loading_msg <- paste0(hubid, ": OK loading")
    }
    message(loading_msg)
    status_output[["StatusMessages"]] <- paste0(status_output[["StatusMessages"]], "\n", loading_msg)
    
    ##
    ## Check loaded object class to have indication of needed package??
    ##     Could check against RClassIndicated??
    ##
    if(status_output[["Loading"]] == "OK"){
        status_output[["RClassLoaded"]] = paste(class(temp), collapse = ", ")
    }
    
    
    ##
    ## move filesize to before removal to check ones that dont have size in
    ## header information?
    ##
    fileSize2 <- tryCatch({
        bfc <- BiocFileCache(cache = hubCache(hub))
        bfcnames <- sub("^(EH[0-9]+).*", "\\1", bfcinfo(bfc)$rname)
        localpath <- bfcinfo(bfc)$rpath[which(bfcnames == hubid)]
        file.info(localpath)$size
    },error=function(err){
        NA
    })
    if(!is.na(fileSize2)) status_output[["FileSizeLocally"]] = fileSize2
    msg <- ifelse(is.na(fileSize2),
                  paste0(hubid, ": WARNING cannot determine local filesize"),
                  paste0(hubid, ": OK local filesize: ",fileSize2, " bytes"))
    message(msg)
    status_output[["StatusMessages"]] <- paste0(status_output[["StatusMessages"]],"\n", msg)

    
    ##
    ## remove resources
    ##
    removeResources(hub, ids=hubid)

}



## ------------------------------------------------------------------------------------------
##
## return(toJSON(status_output))
##
##

cat(toJSON(status_output))
