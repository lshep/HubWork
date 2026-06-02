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

## Most Emails were sent out May 8 2025

## > data.frame(notAvail, reason)

##                         notAvail  reason
## 1                     alpineData Package Deprecated and Removed
## 2                  restfulSEData Package Deprecated and Removed
## 3                  MetaGxOvarian   Currently failing since release -- This has been resolved     
## 4                       allenpvc Package Deprecated and Removed
## 5                brainimageRdata Package Deprecated and Removed case mismatch brainImageRdata        
## 6                 MetaGxPancreas   Currently failing since release -- This has been resolved      
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
## 23              cellScaleFactors   Emailed - no response -   https://github.com/metamaden/cellScaleFactors/issues   
## 24                  chevreuldata   Did not accept data package and no response https://github.com/Bioconductor/Contributions/issues/3332   
## 25                        GIMiCC   Emailed - no response     
## 26                   sceptredata   Remove Requested- Emailed - using alternative smaller datasets     
## 27                      msigdbeh   Never finished submission https://github.com/Bioconductor/Contributions/issues/3771   



## New when reran 05/19/26
## homosapienDEE2CellScore - ERROR no packge CellScore (removed in 3.23); different maintainer contact
## DaparToolshedData -- didnt finish review https://github.com/Bioconductor/Contributions/issues/3950
## CLAMPData  - currently in review
## OmniAgeRData - currently in review


save.image(file="eh_pkgsnotavail.RData")



## Deprecate in sqlite
UPDATE resources SET rdatadateremoved = '2026-04-28'
WHERE preparerclass IN ('alpineData', 'restfulSEData', 'allenpvc',
                        'brainimageRdata', 'tcgaWGBSData.hg19',
                        'benchmarkfdrData2019', 'pwrEWAS.data', 'SCATEData',
                        'scSpatial', 'FlowSorted.BloodExtended.EPIC',
                        'EpiXprSData', 'prolfqua', 'benchmark.data.scRNAseq',
                        'RLHub', 'BrainCellularComposition', 'CRCmodel',
                        'CITEVizTestData', 'HiTIMED', 'tigeR.data',
                        'leukemiaAtlas', 'cellScaleFactors', 'chevreuldata',
                        'GIMiCC', 'sceptredata', 'msigdbeh');



## Went back and manually updated status_id 06/02/2026

# cellScaleFactors interested in submitting. giving more time
update resources set rdatadateremoved=NULL where preparerclass = "cellScaleFactors";


update resources set status_id = 10 where preparerclass IN ('alpineData',
                                                            'restfulSEData',
                                                            'allenpvc',
                                                            'brainimageRdata','tcgaWGBSData.hg19',
                                                            'benchmarkfdrData2019',
                                                            'pwrEWAS.data',
                                                            'SCATEData',
                                                            'RLHub');
update resources set status_id = 9 where id = 554;


update resources set status_id = 7 where preparerclass IN ('scSpatial',
                                                           'EpiXprSData',
                                                           'prolfqua',
                                                           'benchmark.data.scRNAseq',
                                                           'BrainCellularComposition',
                                                           'CRCmodel',
                                                           'CITEVizTestData',
                                                           'HiTIMED',
                                                           'tigeR.data',
                                                           'chevreuldata',
                                                           'GIMiCC', 'msigdbeh',
                                                           'DaparToolshedData');

update resources set status_id = 6 where preparerclass IN ('FlowSorted.BloodExtended.EPIC', 'sceptredata');
update resources set status_id = 7 where preparerclass = "leukemiaAtlas";
