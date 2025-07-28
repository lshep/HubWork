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


## As of July 28, 2025 Largest AnnotationHub File that could be checked was 48G
## and the largest ExperimentHub File that could be checked was 120 G

## > head(ah_mat_sorted)
##          AHids      AHpreparerclass  AHFileSize
## 70617 AH121697          AHPubMedDbs 48403341312
## 70618 AH121698          AHPubMedDbs 16684392448
## 70620 AH121700          AHPubMedDbs 14321082368
## 70631 AH121711          AHPubMedDbs 13074512788
## 70624 AH121704          AHPubMedDbs 13074512772
## 4093   AH21414 Grasp2ImportPreparer  5684839424


## > head(eh_mat_sorted)
##       EHids              EHpackage   EHFileSize
## 3272 EH3777     recountmethylation 120167684020
## 6617 EH7876             orthosData  34730902377
## 6615 EH7874             orthosData  26858159065
## 7157 EH8427          HCATonsilData  11157337032
## 6599 EH7858              CoSIAdata   8754619199
## 4310 EH5453 curatedMetagenomicData   7772897328
