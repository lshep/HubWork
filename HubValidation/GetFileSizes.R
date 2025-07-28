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
eh_mat = data.frame(EHids, EHpackage, EHFileSize)
eh_mat_sorted <- eh_mat[order(eh_mat[, "EHFileSize"], decreasing=TRUE, na.last = TRUE), ]
save(EHids, EHFileSize, EHpackage, eh_mat, eh_mat_sorted, file="EH_fileSize.RData")

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
ah_mat = data.frame(AHids, AHpreparerclass, AHFileSize)
ah_mat_sorted <- ah_mat[order(ah_mat[, "AHFileSize"], decreasing=TRUE, na.last = TRUE), ]
save(AHids, AHFileSize, AHpreparerclass, ah_mat, ah_mat_sorted, file="AH_fileSize.RData")
