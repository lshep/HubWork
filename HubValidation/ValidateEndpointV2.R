library(dplyr)
library(dbplyr)
library(RSQLite)
library(AnnotationHub)
library(ExperimentHub)
library(BiocFileCache)
#library(httr)
library(httr2)


## Load AnnotationHub and get the path to the sqlite file
ah <- AnnotationHub()
bfc <- AnnotationHub:::.get_cache(ah)
ah_sqlite <- bfcpath(bfc, bfcrid(bfcquery(bfc, "annotationhub.sqlite3", fields="rname", exact=TRUE)))

## Load Sqlite file for direct query of all database tables and rows 
## including removed, deprecated, rdatadateremoved

ahub <- DBI::dbConnect(RSQLite::SQLite(), ah_sqlite)
resources <- tbl(ahub, "resources") %>% select(id, ah_id, status_id, location_prefix_id, rdatadateremoved, preparerclass)
rdatapaths <- tbl(ahub, "rdatapaths")
locationPF <- tbl(ahub, "location_prefixes")
status <- tbl(ahub, "statuses")


full <- 
left_join(rdatapaths, left_join(resources, locationPF,
                                by=c("location_prefix_id"="id")),
          by=c("resource_id"="id"))
full2 <- left_join(full, status, by=c("status_id"="id"))


## full list of ids regardless if already designated as removed 
full_unique_ah_id_list <- full2 %>% select(ah_id) %>% collect() %>% unique() %>% pull()

#for(ahid in full_unique_ah_id_list){
ahid = full_unique_ah_id_list[1]

## ids may have multiple endpoints, ex. fa/fai, bam/bai
## make sure to account for multiple endpoints

    tbl_values <- full2 %>% filter(ah_id == ahid)
    status_values <- tbl_values %>% select(status_id) %>% pull()
    if(any(status_values != 2)){
        message(ahid, " is not longer active id in AnnotationHub")
        if(any(status_values == 2)){
            message("  ", ahid, " has mixed status. Investigate")
        }
        rdatadateremoved <- tbl_values %>% select(rdatadateremoved) %>% pull()
        if(any(is.na(rdatadateremoved))){
            message("  ", ahid, " rdatadateremove may not be specified. Investigate")
        }            
    }
    if(!is.na(tbl_values %>% select(rdatadateremoved) %>% pull())){
        message(ahid, " has rdatadateremove but not a remove status. Investigate")
    }
    ## Do we care with checking endpoint then?
    endpoints <- tbl_values %>% mutate(endpoint = paste0(location_prefix, rdatapath)) %>% pull(endpoint)
    
    statuses <- sapply(endpoints, function(url) {
        tryCatch({
            req <- request(url) |> 
            req_method("HEAD")
            
            resp <- req_perform(req)
            resp_status(resp)
        }, error = function(e) {
            warning(sprintf("Request to %s failed: %s", url, e$message))
            400  # or e$message if you want the error text instead
        })
    })
    if(all(statuses == 200)){
        message(ahid, " endpoint still valid")
    }else{
        message(ahid, " contains an invalid endpoint")
    }
    
#} ends for loop over all ah_ids
