library(dplyr)
library(dbplyr)
library(RSQLite)
library(AnnotationHub)
library(ExperimentHub)
library(BiocFileCache)
library(httr)


##
##
##
##  ExperimentHub
##    manually looked up database: 6953 entries
##
##

## Load ExperimentHub and get the path to the sqlite file
eh <- ExperimentHub()
bfc <- AnnotationHub:::.get_cache(eh)
eh_sqlite <- bfcpath(bfc, bfcrid(bfcquery(bfc, "experimenthub.sqlite3", fields="rname", exact=TRUE)))

## Load Sqlite file for direct query of all database tables and rows 
## including removed, deprecated, rdatadateremoved

ehub <- DBI::dbConnect(RSQLite::SQLite(), eh_sqlite)
resources <- tbl(ehub, "resources") %>% select(id, ah_id, status_id, location_prefix_id, rdatadateremoved)
rdatapaths <- tbl(ehub, "rdatapaths")
locationPF <- tbl(ehub, "location_prefixes")
status <- tbl(ehub, "statuses")


full <- 
left_join(rdatapaths, left_join(resources, locationPF,
                                by=c("location_prefix_id"="id")),
          by=c("resource_id"="id"))

full2 <- left_join(full, status, by=c("status_id"="id"))


sub_path <- full2 %>% select("location_prefix", "rdatapath", "status", "rdatadateremoved") %>% collect()
eh_results <- rep(FALSE, nrow(sub_path))
for(i in 1:nrow(sub_path)){
    message(i)
    url = paste0(sub_path[i,1], sub_path[i,2])
    eh_results[i] = (httr::HEAD(url)$status == 200)
}


eh_sub_path = sub_path 

## now list the ones that failed that should according to status still be
## publically available

eh_temp = eh_sub_path[which(!eh_results),]
eh_bad = eh_temp[which(eh_temp[,3]=="Public"),]
## dim(eh_bad)
## [1] 18 3
## investigate these?
## make sure rdatadateremoved is also NA


save(eh_sub_path, eh_results, eh_temp, eh_bad, file="ehresults.RData")


##
##
##
##  AnnotationHub
##    manually looked up database: 110065 entries
##
##
##

## Load AnnotationHub and get the path to the sqlite file
ah <- AnnotationHub()
bfc <- AnnotationHub:::.get_cache(ah)
ah_sqlite <- bfcpath(bfc, bfcrid(bfcquery(bfc, "annotationhub.sqlite3", fields="rname", exact=TRUE)))

## Load Sqlite file for direct query of all database tables and rows 
## including removed, deprecated, rdatadateremoved

ahub <- DBI::dbConnect(RSQLite::SQLite(), ah_sqlite)
resources <- tbl(ahub, "resources") %>% select(id, ah_id, status_id, location_prefix_id, rdatadateremoved)
rdatapaths <- tbl(ahub, "rdatapaths")
locationPF <- tbl(ahub, "location_prefixes")
status <- tbl(ahub, "statuses")


full <- 
left_join(rdatapaths, left_join(resources, locationPF,
                                by=c("location_prefix_id"="id")),
          by=c("resource_id"="id"))
full2 <- left_join(full, status, by=c("status_id"="id"))


sub_path <- full2 %>% select("location_prefix", "rdatapath", "status", "rdatadateremoved") %>% collect()
ah_results <- rep(FALSE, nrow(sub_path))
for(i in 1:nrow(sub_path)){
    message(i)
    url = paste0(sub_path[i,1], sub_path[i,2])
    ah_results[i] = (httr::HEAD(url)$status == 200)
}


ah_sub_path = sub_path 

## now list the ones that failed that should according to status still be
## publically available

ah_temp = ah_sub_path[which(!ah_results),]
ah_bad = ah_temp[which(ah_temp[,3]=="Public"),]
## dim(ah_bad)
## investigate these?
## make sure rdatadateremoved is also NA

save(ah_sub_path, ah_results, ah_temp, ah_bad, file="ahresults.rdata")
