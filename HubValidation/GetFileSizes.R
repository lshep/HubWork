library(AnnotationHub)
library(ExperimentHub)




eh <- ExperimentHub()
EHFileSize = rep(0, length(eh))
EHpackage = rep(TRUE, length(eh))

for(i in 1:length(eh)){
    message("EH: ", i, " of ", length(eh))
    id = rownames(mcols(eh[i]))
    EHFileSize[i] = tryCatch({
        as.numeric(getInfoOnIds(eh, id)$file_size)
    }, error=function(err){
        NA
    })
    EHpackage[i] = as.character(package(eh[i]))
}
EHids = rownames(mcols(eh))
save(EHids, EHFileSize, EHpackage, file="EH_fileSize.RData")

ah <- AnnotationHub()
AHFileSize = rep(0, length(ah))
AHpreparerclass = rep(TRUE, length(ah))

for(i in 1:length(ah)){
    message("AH: ", i, " of ", length(ah))
    id = rownames(mcols(ah[i]))
    AHFileSize[i] = tryCatch({
        as.numeric(getInfoOnIds(ah, id)$file_size)
    }, error=function(err){
        NA
    })
    AHpreparerclass[i] = mcols(ah[i])$preparerclass
}
AHids = rownames(mcols(ah))
save(AHids, AHFileSize, AHpreparerclass, file="AH_fileSize.RData")
