## Ensure main classes of Bioconductor have been installed before running
## c('SummarizedExperiment', 'GenomicRanges', 'RaggedExperiment', 'Biostrings', 'BiocSet', 'MultiAssayExperiment', 'SingleCellExperiment', 'SpatialExperiment', 'Spectra', 'BiocIO', 'ExperimentHub', 'dplyr', 'httr')
## There will be some that are not installed that are required
## Ideal pre-install any package associated with and required packages
##  to speed up change to install unique(package(eh)) before running
## I think a few also reference Seurat 
## there may be more require but not specified -- debug as necessary


library(AnnotationHub)
library(ExperimentHub)
library(BiocFileCache)
library(httr)
library(BiocManager)
library(dplyr)

##
## Start only with those we say should be currently available
##


eh <- ExperimentHub()
EHcheck = rep(TRUE, length(eh))
EHpackage = rep(TRUE, length(eh))
#load("EH_PartialSave_LoadingValidation.RData")

pkgsList = BiocManager::available()
eh_skipped = c()

## 6970 maxed CPU and RAM - try again bigger

for(i in 1:length(eh)){
    message("EH: ", i, " of ", length(eh))

if (!(i %in% eh_skipped)){
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
    save.image("EH_PartialSave_LoadingValidation.RData")
}else{
	save.image("EH_PartialSave_LoadingValidation.RData")
}
}
EHids = rownames(mcols(eh))

eh_loading_mat = data.frame(EHids, EHpackage, EHcheck)
save(EHids, EHcheck, EHpackage, eh_loading_mat, file="EH_LoadingValidation.RData")

## length(which(!EHcheck))
##    245
## temp = eh_loading_mat[which(!EHcheck),]
## unique(eh_loading_mat[which(!EHcheck),"EHpackage"])
## load("eh_pkgsnotavail.RData")
## temp2 = temp[ !temp$EHpackage %in% notAvail, ]
## dim(temp2)[1]
##    65

## > temp2
##       EHids               EHpackage EHcheck
## 296   EH460  curatedMetagenomicData   FALSE
## 297   EH461  curatedMetagenomicData   FALSE
## 298   EH462  curatedMetagenomicData   FALSE
## 299   EH463  curatedMetagenomicData   FALSE
## 300   EH464  curatedMetagenomicData   FALSE
## 301   EH465  curatedMetagenomicData   FALSE
## 302   EH466  curatedMetagenomicData   FALSE
## 1124 EH1408              sesameData   FALSE
## 1125 EH1409              sesameData   FALSE
## 1126 EH1410              sesameData   FALSE
## 1128 EH1412              sesameData   FALSE
## 1354 EH1664              sesameData   FALSE
## 1355 EH1665              sesameData   FALSE
## 1356 EH1666              sesameData   FALSE
## 1358 EH1668              sesameData   FALSE
## 1649 EH1959              adductData   FALSE
## 3156 EH3659              sesameData   FALSE
## 3157 EH3660              sesameData   FALSE
## 3158 EH3661              sesameData   FALSE
## 3160 EH3663              sesameData   FALSE
## 3268 EH3773      recountmethylation   FALSE
## 3269 EH3774      recountmethylation   FALSE
## 3270 EH3775      recountmethylation   FALSE
## 3271 EH3776      recountmethylation   FALSE
## 3405 EH3913         methylclockData   FALSE
## 4822 EH5965              sesameData   FALSE
## 4825 EH5968              sesameData   FALSE
## 6319 EH7560                 SFEData   FALSE
## 6320 EH7561                 SFEData   FALSE
## 6321 EH7562                 SFEData   FALSE
## 6322 EH7563                 BioPlex   FALSE
## 6499 EH7741                 SFEData   FALSE
## 6500 EH7742                 SFEData   FALSE
## 6501 EH7743                 SFEData   FALSE
## 6502 EH7744                 SFEData   FALSE
## 6503 EH7745                 SFEData   FALSE
## 6504 EH7746                 SFEData   FALSE
## 6552 EH7800                 SFEData   FALSE
## 6553 EH7801                 SFEData   FALSE
## 6554 EH7802                 SFEData   FALSE
## 6568 EH7816 homosapienDEE2CellScore   FALSE
## 6569 EH7817 homosapienDEE2CellScore   FALSE
## 6570 EH7818 homosapienDEE2CellScore   FALSE
## 6571 EH7819 homosapienDEE2CellScore   FALSE
## 6572 EH7820 homosapienDEE2CellScore   FALSE
## 6573 EH7821 homosapienDEE2CellScore   FALSE
## 6574 EH7822 homosapienDEE2CellScore   FALSE
## 6575 EH7823 homosapienDEE2CellScore   FALSE
## 6605 EH7864              orthosData   FALSE
## 6606 EH7865              orthosData   FALSE
## 6607 EH7866              orthosData   FALSE
## 6608 EH7867              orthosData   FALSE
## 6609 EH7868              orthosData   FALSE
## 6610 EH7869              orthosData   FALSE
## 6611 EH7870              orthosData   FALSE
## 6612 EH7871              orthosData   FALSE
## 6613 EH7872              orthosData   FALSE
## 6614 EH7873              orthosData   FALSE
## 6962 EH8222          multiWGCNAdata   FALSE
## 6966 EH8226          multiWGCNAdata   FALSE
## 7263 EH8533          TumourMethData   FALSE
## 7278 EH8548          TENxXeniumData   FALSE
## 7280 EH8550          TENxXeniumData   FALSE
## 8344 EH9623               MsDataHub   FALSE
## 8345 EH9624               MsDataHub   FALSE


#############################################################
#############################################################
#############################################################

##
## Before running this consult resource size evaluation
## Also investigate recipes/package requirements  
##

## What packages or recipes need to be loaded to test resources??
## Requires in AnnotationHub/R
## c("Rsamtools", "GenomicRanges", "VariantAnnotation", "rtracklayer", "Seqinfo", "rtracklayer", "rBiopaxParser", "Biobase", "gdsfmt", "rhdf5", "CompoundDb", "keras", "ensembldb", "SummarizedExperiment", "mzR", "Biostrings")
## temp = unique(mcols(ah)$preparerclass)
## temp[temp %in% BiocManager::available()]
    
ah <- AnnotationHub()
AHcheck = rep(TRUE, length(ah))
AHpreparerclass = rep(TRUE, length(ah))
ah_skipped = c()

for(i in 1:length(ah)){
    message("AH: ",i, " of ", length(ah))

if(!(i %in% ah_skipped)){
    id = rownames(mcols(ah[i]))
    AHcheck[i] = tryCatch({
        temp = ah[[id]]
        TRUE
    }, error=function(err){FALSE})
    removeResources(ah, ids=id)
    AHpreparerclass[i] = mcols(ah[i])$preparerclass
    save.image("AH_PartialSave_LoadingValidation.RData")
}else{
    save.image("AH_PartialSave_LoadingValidation.RData")
}
} 
AHids = rownames(mcols(ah))

ah_loading_mat = data.frame(AHids, AHpreparerclass, AHcheck)
save(AHids, AHcheck, AHpreparerclass, ah_loading_mat, file="AH_LoadingValidation.RData")

