library(dplyr)
library(dbplyr)
library(RSQLite)
library(AnnotationHub)
library(ExperimentHub)
library(BiocFileCache)
library(httr)
library(rvest)



## Load ExperimentHub
## Start with what is currently suppose to be available
eh <- ExperimentHub()

## Identify unique packages
pkgsInHubs <- unique(mcols(eh)$preparerclass)

## get list of CRAN/Bioconductor packages
pkgsAvail <- BiocManager::available() 

## list packages not available
notAvail <- pkgsInHubs[!(pkgsInHubs %in% pkgsAvail)]

##  [1] "alpineData"                    "restfulSEData"                
##  [3] "MetaGxOvarian"                 "allenpvc"                     
##  [5] "brainimageRdata"               "MetaGxPancreas"               
##  [7] "tcgaWGBSData.hg19"             "benchmarkfdrData2019"         
##  [9] "pwrEWAS.data"                  "SCATEData"                    
## [11] "scSpatial"                     "FlowSorted.BloodExtended.EPIC"
## [13] "EpiXprSData"                   "prolfqua"                     
## [15] "benchmark.data.scRNAseq"       "RLHub"                        
## [17] "BrainCellularComposition"      "CRCmodel"                     
## [19] "CITEVizTestData"               "HiTIMED"                      
## [21] "tigeR.data"                    "leukemiaAtlas"                
## [23] "cellScaleFactors"              "chevreuldata"                 
## [25] "GIMiCC"                        "sceptredata"                  
## [27] "CENTREprecomputed"             "msigdbeh"                     
## [29] "AWAggregatorData"              "ChIPDBData"                   
## [31] "MutSeqRData"                  


## which of these have been removed 
url <- "https://bioconductor.org/about/removed-packages/"  # replace with your actual page
page <- read_html(url)
removed_packages <- page %>%
  html_elements("ul.inline_list li a") %>%
  html_text()

reason <- rep("", length(notAvail))
reason[notAvail %in% removed_packages] <- "Package Deprecated and Removed"

## Most Emails were sent out May 8

## > data.frame(notAvail, reason)

##                         notAvail  reason
## 1                     alpineData Package Deprecated and Removed
## 2                  restfulSEData Package Deprecated and Removed
## 3                  MetaGxOvarian   Currently failing since release     
## 4                       allenpvc Package Deprecated and Removed
## 5                brainimageRdata   Removed case mismatch brainImageRdata        
## 6                 MetaGxPancreas   Currently failing since release     
## 7              tcgaWGBSData.hg19 Package Deprecated and Removed
## 8           benchmarkfdrData2019 Package Deprecated and Removed
## 9                   pwrEWAS.data Package Deprecated and Removed
## 10                     SCATEData Package Deprecated and Removed
## 11                     scSpatial   Emailed - email bounced     
## 12 FlowSorted.BloodExtended.EPIC   Remove Requested - Emailed - using alternative       
## 13                   EpiXprSData   Never finished submission https://github.com/Bioconductor/Contributions/issues/1995    
## 14                      prolfqua   Remove Requested - Emailed - will not submit package     
## 15       benchmark.data.scRNAseq   Never finished submission https://github.com/Bioconductor/Contributions/issues/2279 
## 16                         RLHub Package Deprecated and Removed
## 17      BrainCellularComposition   Emailed - no response     
## 18                      CRCmodel   Emailed - no response    
## 19               CITEVizTestData   Never finished submission https://github.com/Bioconductor/Contributions/issues/2738
## 20                       HiTIMED   Never finished submission https://github.com/Bioconductor/Contributions/issues/3030     
## 21                    tigeR.data   Emailed - email bounced    
## 22                 leukemiaAtlas   Data seemed wrong see validating endpoints - never responded to email follow up     
## 23              cellScaleFactors   Emailed - no response      
## 24                  chevreuldata   Did not accept data package and no response https://github.com/Bioconductor/Contributions/issues/3332   
## 25                        GIMiCC   Emailed - no response     
## 26                   sceptredata   Remove Requested- Emailed - using alternative smaller datasets     
## 27             CENTREprecomputed   Currently In Review     
## 28                      msigdbeh   Currently In Review     
## 29              AWAggregatorData   Currently In Review
## 30                    ChIPDBData   Currently In Review   
## 31                   MutSeqRData   Currently In Review     





save.image(file="eh_pkgsnotavail.RData")
