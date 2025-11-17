## These are potentially the list of packages needed to load any hub data
## resource. It might be overkill as it does not include resources removed or
## marked as non public. There would have to be a mapping of where the
## identified class comes from for rdataclass_data and they may not be accurate
## as these are provided by maintainers --
##
## It would be nice to figure out per resource what packages are actually needed
## to load resource (minimally) but more importantly/helpful to get an accurate
## class object after loading (could infer packages needed based on class)
## 
## the minimum package(s) needed to load the resource may not be the package
## that provided the resource. Example: package X provides resource A. Package X
## has several imports of packages containing class strucutres. The resource
## loaded is a GRanges object and therefore would not need the package it came
## from or an extra packages, it should soley need GenomicRanges...
##


#############################
##
## ExperimentHub
##
############################

## Ensure main classes of Bioconductor have been installed before running


c('SummarizedExperiment', 'GenomicRanges', 'RaggedExperiment', 'Biostrings', 'BiocSet', 'MultiAssayExperiment', 'SingleCellExperiment', 'SpatialExperiment', 'Spectra', 'BiocIO', 'ExperimentHub', 'dplyr', 'httr')

## Consider the following unique classes self identified and unique
## preparerclass

> unique(rdataclass_data)
 [1] "ExpressionSet"                      "SummarizedExperiment"              
 [3] "GAlignmentPairs"                    "CellMapperList"                    
 [5] "gds.class"                          "RangedSummarizedExperiment"        
 [7] "GRanges"                            "DataFrame"                         
 [9] "RaggedExperiment"                   "list"                              
[11] "List"                               "Character"                         
[13] "data.frame"                         "character"                         
[15] "bsseq"                              "flowSet"                           
[17] "RGChannelSet"                       "SigSet, CNSegment"                 
[19] "SigSet"                             "matrix"                            
[21] "SigSet, matrix"                     "matrix, data.frame"                
[23] "numeric and randomForest"           "randomForest"                      
[25] "numeric"                            "SingleCellExperiment"              
[27] "Data Frame"                         "Vector"                            
[29] "RGChannelSetExtended"               "BSseq"                             
[31] "mzXML"                              "adductQuantif"                     
[33] "DNAStringSet"                       "tibble"                            
[35] "SummarizedBenchmark"                "FaFile"                            
[37] "GFF3File"                           "BamFile"                           
[39] "FilePath"                           "AAStringSet"                       
[41] "dgCMatrix"                          "DFrame"                            
[43] "GeneRegionTrack"                    "Spectra"                           
[45] "environment"                        "Int"                               
[47] "list with 4 GRanges"                "data.table"                        
[49] "HDF5-SummarizedExperiment"          "HDF5Database"                      
[51] "vector"                             "QFeatures"                         
[53] "Matrix"                             "HDF5Matrix"                        
[55] "SeuratObject"                       "GSEABase::GeneSetCollection"       
[57] "CompressedCharacterList"            "GSEABase::SummarizedExperiment"    
[59] "SpatialExperiment"                  "boosting"                          
[61] "Lists"                              "H5File"                            
[63] "MIAME"                              "TENxMatrix"                        
[65] "GenomicRatioSet"                    "Dframe"                            
[67] "tbl"                                "caretStack"                        
[69] "preProcess"                         "SigDF"                             
[71] "magick-image"                       "GenomicRanges"                     
[73] "InteractionSet"                     "matrix array"                      
[75] "data.table data.frame"              "EBImage"                           
[77] "SpatialFeatureExperiment"           "DEXSeqDataSet"                     
[79] "CytoImageList"                      "Seurat"                            
[81] "MultiAssayExperiment"               "GRangesList"                       
[83] "PSM"                                "ZipFile"                           
[85] "keras.engine.functional.Functional" "HIC"                               
[87] "mixo_splsda"                        "Beta Matrix"                       
[89] "txt"                                "raster"                            
[91] "scalefactors"                       "PWMatrixList"                      
[93] "sparseMatrix"                       "SQLiteConnection"                  
[95] "Data.Frame"                         "ranger"

> unique(preparerclass_data)
  [1] "GSE62944"                          "curatedMetagenomicData"           
  [3] "alpineData"                        "CellMapperData"                   
  [5] "HumanAffyData"                     "SeqSQC"                           
  [7] "restfulSEData"                     "curatedTCGAData"                  
  [9] "HarmonizedTCGAData"                "HMP16SData"                       
 [11] "TENxBrainData"                     "MetaGxOvarian"                    
 [13] "CLLmethylation"                    "tissueTreg"                       
 [15] "MetaGxBreast"                      "HDCytoData"                       
 [17] "MetaGxPancreas"                    "FlowSorted.Blood.EPIC"            
 [19] "sesameData"                        "allenpvc"                         
 [21] "brainimageRdata"                   "CopyNeutralIMA"                   
 [23] "mcsurvdata"                        "DuoClustering2018"                
 [25] "celarefData"                       "TENxPBMCData"                     
 [27] "TabulaMurisData"                   "tcgaWGBSData.hg19"                
 [29] "DEqMS"                             "adductData"                       
 [31] "HCAData"                           "NestLink"                         
 [33] "chipseqDBData"                     "FlowSorted.CordBloodCombined.450k"
 [35] "bodymapRat"                        "curatedAdipoChIP"                 
 [37] "muscData"                          "depmap"                           
 [39] "benchmarkfdrData2019"              "RNAmodR.Data"                     
 [41] "PhyloProfileData"                  "scRNAseq"                         
 [43] "TENxBUSData"                       "MouseGastrulationData"            
 [45] "pwrEWAS.data"                      "SingleR"                          
 [47] "DMRcatedata"                       "biscuiteerData"                   
 [49] "tartare"                           "signatureSearchData"              
 [51] "curatedAdipoArray"                 "HighlyReplicatedRNASeq"           
 [53] "SingleCellMultiModal"              "clustifyrdatahub"                 
 [55] "GenomicDistributionsData"          "celldex"                          
 [57] "SCATEData"                         "FieldEffectCrc"                   
 [59] "scSpatial"                         "DropletTestFiles"                 
 [61] "recountmethylation"                "MethylSeqData"                    
 [63] "NanoporeRNASeq"                    "preciseTADhub"                    
 [65] "scpdata"                           "methylclockData"                  
 [67] "BeadSorted.Saliva.EPIC"            "LRcellTypeMarkers"                
 [69] "MACSdata"                          "MouseThymusAgeing"                
 [71] "microbiomeDataSets"                "ewceData"                         
 [73] "SimBenchData"                      "GSE103322"                        
 [75] "msigdb"                            "FlowSorted.BloodExtended.EPIC"    
 [77] "GSE13015"                          "SingleMoleculeFootprintingData"   
 [79] "emtdata"                           "ObMiTi"                           
 [81] "STexampleData"                     "quantiseqr"                       
 [83] "m6Aboost"                          "EpiXprSData"                      
 [85] "prolfqua"                          "crisprScoreData"                  
 [87] "spatialDmelxsim"                   "GSE159526"                        
 [89] "TabulaMurisSenisData"              "curatedTBData"                    
 [91] "easierData"                        "epimutacionsData"                 
 [93] "TENxVisiumData"                    "benchmark.data.scRNAseq"          
 [95] "NxtIRFdata"                        "RLHub"                            
 [97] "BioImageDbs"                       "tuberculosis"                     
 [99] "nullrangesData"                    "octad.db"                         
[101] "BrainCellularComposition"          "xcoredata"                        
[103] "VectraPolarisData"                 "standR"                           
[105] "HCATonsilData"                     "EpiMix.data"                      
[107] "MerfishData"                       "SFEData"                          
[109] "BioPlex"                           "HiContactsData"                   
[111] "CRCmodel"                          "imcdatasets"                      
[113] "WeberDivechaLCdata"                "CITEVizTestData"                  
[115] "hpar"                              "scMultiome"                       
[117] "MsDataHub"                         "homosapienDEE2CellScore"          
[119] "CTdata"                            "CoSIAdata"                        
[121] "orthosData"                        "curatedPCaData"                   
[123] "gDNAinRNAseqData"                  "marinerData"                      
[125] "eoPredData"                        "HiTIMED"                          
[127] "multiWGCNAdata"                    "SubcellularSpatialData"           
[129] "raerdata"                          "tigeR.data"                       
[131] "smokingMouse"                      "leukemiaAtlas"                    
[133] "CytoMethIC"                        "cfToolsData"                      
[135] "cellScaleFactors"                  "SpatialDatasets"                  
[137] "TumourMethData"                    "TransOmicsData"                   
[139] "TENxXeniumData"                    "muleaData"                        
[141] "chevreuldata"                      "scaeData"                         
[143] "JohnsonKinaseData"                 "GIMiCC"                           
[145] "MouseAgingData"                    "EpipwR.data"                      
[147] "sceptredata"                       "CENTREprecomputed"                
[149] "ProteinGymR"                       "TENET.ExperimentHub"              
[151] "humanHippocampus2024"              "muSpaData"                        
[153] "DeconvoBuddies"                    "msigdbeh"                         
[155] "AWAggregatorData"                  "ChIPDBData"                       
[157] "MutSeqRData"                       "iModMixData"                      
[159] "DoReMiTra"                         "nmrdata"                          
[161] "DaparToolshedData"                



#############################
##
## AnnotationHub
##
############################


## What packages or recipes need to be loaded to test resources??
## Requires in AnnotationHub/R

c("Rsamtools", "GenomicRanges", "VariantAnnotation", "rtracklayer", "Seqinfo", "rtracklayer", "rBiopaxParser", "Biobase", "gdsfmt", "rhdf5", "CompoundDb", "keras", "ensembldb", "SummarizedExperiment", "mzR", "Biostrings")

## Consider the following unique classes self identified and unique
## preparerclass

  unique(rdataclass_data)
 [1] "FaFile"                            "GRanges"                          
 [3] "CollapsedVCF"                      "data.frame"                       
 [5] "Inparanoid8Db"                     "OrgDb"                            
 [7] "TwoBitFile"                        "ChainFile"                        
 [9] "SQLiteConnection"                  "biopax"                           
[11] "VcfFile"                           "BigWigFile"                       
[13] "ExpressionSet"                     "AAStringSet"                      
[15] "MSnSet"                            "mzRpwiz"                          
[17] "mzRident"                          "list"                             
[19] "Rle"                               "TxDb"                             
[21] "EnsDb"                             "igraph"                           
[23] "data.frame, DNAStringSet, GRanges" "sqlite"                           
[25] "data.table"                        "character"                        
[27] "SQLite"                            "SQLiteFile"                       
[29] "Tibble"                            "Rda"                              
[31] "String"                            "CompDb"                           
[33] "JASPAR"

> unique(preparerclass_data)
 [1] "EnsemblFastaImportPreparer"          "EncodeImportPreparer"               
 [3] "UCSCFullTrackImportPreparer"         "dbSNPVCFImportPreparer"             
 [5] "EnsemblGtfImportPreparer"            "HaemCodeImportPreparer"             
 [7] "RefNetImportPreparer"                "Inparanoid8ImportPreparer"          
 [9] "NCBIImportPreparer"                  "UCSC2BitPreparer"                   
[11] "UCSCChainPreparer"                   "EpigenomeRoadMapPreparer"           
[13] "Grasp2ImportPreparer"                "ChEAImportPreparer"                 
[15] "PazarImportPreparer"                 "BioPaxImportPreparer"               
[17] "dbSNPVCFPreparer"                    "GSE62944ToExpressionSetPreparer"    
[19] "PXD000001FastaToAAStringSetPreparer" "PXD000001MzTabToMSnSetPreparer"     
[21] "PXD000001MzMLToMzRPwizPreparer"      "PXD000001MzidToMzRidentPreparer"    
[23] "GencodeGffImportPreparer"            "GencodeFastaImportPreparer"         
[25] "OrgDbFromPkgsImportPreparer"         "EnsemblTwoBitPreparer"              
[27] "None"                                "alternativeSplicingEvents.hg19"     
[29] "GenomicScores"                       "TxDbFromPkgsImportPreparer"         
[31] "AHCytoBands"                         "AHEnsDbs"                           
[33] "alternativeSplicingEvents.hg38"      "hpAnnot"                            
[35] "ipdDb"                               "EuPathDB"                           
[37] "GO.db"                               "ENCODExplorerData"                  
[39] "org.Mxanthus.db"                     "GenomicState"                       
[41] "PANTHER.db"                          "phastCons30way.UCSC.hg38"           
[43] "EpiTxDb.Hs.hg38"                     "EpiTxDb.Mm.mm10"                    
[45] "EpiTxDb.Sc.sacCer3"                  "customCMPdb"                        
[47] "metaboliteIDmapping"                 "geneplast.data"                     
[49] "AHPathbankDbs"                       "gwascatData"                        
[51] "AHMeSHDbs"                           "AHLRBaseDbs"                        
[53] "AHPubMedDbs"                         "AHWikipathwaysDbs"                  
[55] "CTCF"                                "alternativeSplicingEvents"          
[57] "rGenomeTracksData"                   "scAnnotatR.models"                  
[59] "synaptome.data"                      "excluderanges"                      
[61] "ontoProcData"                        "cotargeting.annotation"             
[63] "UCSCRepeatMasker"                    "phastCons35way.UCSC.mm39"           
[65] "phyloP35way.UCSC.mm39"               "AHMassBank"                         
[67] "MPO.db"                              "HPO.db"                             
[69] "Cara1.0"                             "AlphaMissense.v2023.hg19"           
[71] "AlphaMissense.v2023.hg38"            "cadd.v1.6.hg19"                     
[73] "cadd.v1.6.hg38"                      "EPICv2manifest"                     
[75] "TENET.AnnotationHub"                 "CENTREannotation"                   
[77] "org.Hbacteriophora.eg.db"            "JASPAR"                             
