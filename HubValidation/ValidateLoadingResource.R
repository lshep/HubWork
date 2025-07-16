## Ensure main classes of Bioconductor have been installed before running
## There will be some that are not installed that are required
## Ideal pre-install any package associated with and required packages

library(AnnotationHub)
library(ExperimentHub)
library(BiocFileCache)
library(httr)
library(BiocManager)

##
## Start only with those we say should be currently available
##


eh <- ExperimentHub()
EHcheck = rep(TRUE, length(eh))
EHpackage = rep(TRUE, length(eh))

pkgsList = BiocManager::available()

for(i in 1:length(eh)){
    message("EH: ", i, " of ", length(eh))
    id = rownames(mcols(eh[i]))
    res_pkg = as.character(package(eh[i]))
    if (!(res_pkg %in% installed.packages()[,"Package"])){
        if(res_pkg %in% pkgsList){
            tryCatch({
                install(res_pkg)
            }, error=function(err){
                message("unable to install ", res_pkg) 
            })
        }else{
            message("package not found in Bioconductor: ", res_pkg)
        }
    }        
    EHcheck[i] = tryCatch({
        temp = eh[[id]]
        TRUE
    }, error=function(err){FALSE})
    removeResources(eh, ids=id)
    EHpackage[i] = package(eh[i])
}
EHids = rownames(mcols(eh))


save(EHids, EHcheck, EHpackage, file="EH_LoadingValidation.RData")


ah <- AnnotationHub()
AHcheck = rep(TRUE, length(ah))
AHpreparerclass = rep(TRUE, length(ah))

for(i in 1:length(ah)){
    message("AH: ",i, " of ", length(ah))
    id = rownames(mcols(ah[i]))
    AHcheck[i] = tryCatch({
        temp = ah[[id]]
        TRUE
    }, error=function(err){FALSE})
    removeResources(ah, ids=id)
    AHpreparerclass[i] = mcols(ah[i])$preparerclass
}
AHids = rownames(mcols(ah))

save(AHids, AHcheck, AHpreparerclass, file="AH_LoadingValidation.RData")
