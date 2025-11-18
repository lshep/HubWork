suppressPackageStartupMessages(library(dplyr))
suppressPackageStartupMessages(library(dbplyr))
suppressPackageStartupMessages(library(RSQLite))
suppressPackageStartupMessages(library(AnnotationHub))
suppressPackageStartupMessages(library(ExperimentHub))
suppressPackageStartupMessages(library(BiocFileCache))

maintainerDefinedClasses = c()
for(Hub in c("AnnotationHub", "ExperimentHub")){
    
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


    hubcon <- DBI::dbConnect(RSQLite::SQLite(), hub_sqlite)
    resources <- tbl(hubcon, "resources") %>% select(id, ah_id, status_id, location_prefix_id, rdatadateremoved, preparerclass)
    rdatapaths <- tbl(hubcon, "rdatapaths")
    full <-  left_join(rdatapaths, resources, by=c("resource_id"="id"))
    full2 <- full %>% filter(status_id == 2)
    
    rdataclassesDefined <- full2 %>% select(rdataclass) %>% pull()

    clean_classes <- function(x) {
        parts <- strsplit(x, "\\s*(,|\\band\\b)\\s*")
        cleaned <- trimws(unlist(parts))
        cleaned <- cleaned[cleaned != ""]
        cleaned <- sub(".*::", "", cleaned)
        unique(cleaned)
    }
    DBI::dbDisconnect(hubcon)

    maintainerDefinedClasses <- c(maintainerDefinedClasses,
                                  clean_classes(rdataclassesDefined))
                                    
}

definedClasses <- unique(maintainerDefinedClasses)





find_setClass_definitions <- function(root_dir = ".") {

  rfiles <- list.files(
    path = root_dir,
    pattern = "\\.[Rr]$",
    full.names = TRUE,
    recursive = TRUE
  )

  results <- lapply(rfiles, function(f) {
    lines <- tryCatch(readLines(f, warn = FALSE), error = function(e) return(NULL))
    if (is.null(lines)) return(NULL)

    idx <- grep("setClass\\s*\\(", lines)
    if (length(idx) == 0) return(NULL)

    cls <- regmatches(
      lines[idx],
      regexpr('setClass\\s*\\(["\']([^"\']+)["\']', lines[idx], perl = TRUE)
    )

    cls <- sub('setClass\\s*\\(["\']', "", cls)
    cls <- sub('["\'].*', "", cls)

    if (length(cls) == 0) return(NULL)

    # go up TWO directories: <pkg>/R/file.R
    pkg <- basename(dirname(dirname(f)))

    data.frame(
      package = pkg,
      class = cls,
      stringsAsFactors = FALSE
    )
  })

  do.call(rbind, results)
}

setclass_map <- find_setClass_definitions("~/BioconductorPackages/SoftwarePkg")

class_to_pkg <- setNames(setclass_map$package, setclass_map$class)

mapped <- data.frame(
  class = definedClasses,
  package = unname(class_to_pkg[definedClasses]),
  stringsAsFactors = FALSE
)

mapped$package[is.na(mapped$package)] <- "NOT FOUND"

save(definedClasses, setclass_map, mapped, file = "BiocClassInvestigation.RData")

write.csv(mapped, "mapped_classes.csv", row.names = FALSE)


## tbl <- read.csv("mapped_classes.csv")

## ]> tbl[!(tbl[,"class"] %in% definedClasses),"class"]
## [1] "CollapsedVCF" "CNSegment"   
