library(dplyr)
library(dbplyr)
library(RSQLite)
library(AnnotationHub)
library(ExperimentHub)
library(BiocFileCache)
library(httr)


##
## Start only with those we say should be currently available
##


eh <- ExperimentHub()
EHcheck = rep(TRUE, length(eh))
EHpackage = rep(TRUE, length(eh))

for(i in 1:length(eh)){
    message("EH: ", i, " of ", length(eh))
    id = rownames(mcols(eh[i]))
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
    message("AH: ",i, " of ", length(eh))
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
