## package for application
packagesForApplication <- c(
    "dplyr",
    "dbplyr",
    "RSQLite",
    "AnnotationHub",
    "ExperimentHub",
    "BiocFileCache",
    "httr2",
    "jsonlite"
)

## package needed for loading resources based on maintainer specifications
## may or maynot need to adjust, segmenter was left off may need

packagesWithClasses <- c(
  "Rsamtools",
  "GenomicRanges",
  "VariantAnnotation",
  "base",
  "RSQLite",
  "AnnotationDbi",
  "rtracklayer",
  "DBI",
  "rBiopaxParser",
  "Biobase",
  "Biostrings",
  "MSnbase",
  "mzR",
  "S4Vectors",
  "GenomicFeatures",
  "ensembldb",
  "igraph",
  "data.table",
  "tibble",
  "CompoundDb",
  "SummarizedExperiment",
  "GenomicAlignments",
  "CellMapper",
  "gdsfmt",
  "RaggedExperiment",
  "bsseq",
  "flowCore",
  "wateRmelon",
  "sesame",
  "randomForest",
  "SingleCellExperiment",
  "minfi",
  "adductomicsR",
  "SummarizedBenchmark",
  "Bioc.gff",
  "Matrix",
  "Gviz",
  "Spectra",
  "HDF5Array",
  "hdf5",
  "QFeatures",
  "Seurat",
  "GSEABase",
  "IRanges",
  "SpatialExperiment",
  "h5mread",
  "caret",
  "magick",
  "InteractionSet",
  "EBImage",
  "SpatialFeatureExperiment",
  "DEXSeq",
  "cytomapper",
  "MultiAssayExperiment",
  "PSMatch",
  "keras",
  "hictoolsr",
  "mixOmics",
  "raster",
  "TFBSTools",
  "SparseArray",
  "ranger"
)


if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
library(BiocManager)

pkgs <- c(packagesForApplication, packagesWithClasses)
BiocManager::install(pkgs)
