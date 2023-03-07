
################################################################################
##
## Table of total resources in hubs
##
################################################################################

Hubtotals = data.frame("year"=c("2017", "2018", "2019", "2020", "2021", "2022", "current"),
                       "AH" = c(42034, 44925, 46259, 50277, 60134, 67944, 67944),
                       "EH" = c(0, 1239, 2329, 2850, 6075, 6543, 6624))
library(ggplot2)
p1 = ggplot() + 
  geom_line(data = Hubtotals, aes(x = year, y = AH, group=1), color = "blue") +
  xlab('AnnotationHub') +
  ylab('Total Resources Available')
p2 = ggplot() +
    geom_line(data = Hubtotals, aes(x = year, y = EH, group=1), color = "red") +
    xlab('ExperimentHub') +
    ylab('Total Resources Available')
library(gridExtra)
pdf("HubTotals.pdf")
grid.arrange(p1, p2)
dev.off()

## Print Hubtotals ??




################################################################################
##
## Total Number of Downloads for packages
##
################################################################################

PkgList = c("AnnotationHub", "ExperimentHub")
Years = 2017:2023
library(dplyr)
## Modified from vjcitn/BiocReporting
summarize_pkg_downloads = function(pkg, years = Years) {
    
    ## http://bioconductor.org/packages/stats/bioc/ExperimentHub/ExperimentHub_2017_stats.tab
    urls <- sprintf(
        "http://bioconductor.org/packages/stats/bioc/%s/%s_%d_stats.tab", 
        pkg,pkg,years
    )
    
    tbl <- Map(read.table, urls, MoreArgs=list(header=TRUE))
    tbl0 <- as_tibble(do.call(rbind, unname(tbl)))
    tbl0 = tbl0 |> filter(Month == "all")
    tbl0 = tbl0 %>% select(Year, Nb_of_distinct_IPs, Nb_of_downloads)
    return(tbl0)
}
PkgDownloads <- Map(summarize_pkg_downloads, PkgList, MoreArgs=list(years=Years))

AHPkgDownloads = as.data.frame(PkgDownloads$AnnotationHub)[-7,] 
EHPkgDownloads = as.data.frame(PkgDownloads$ExperimentHub)[-7,]

library(ggplot2)
p1 = ggplot() + 
  geom_line(data = AHPkgDownloads, aes(x = Year, y = Nb_of_distinct_IPs), color
            = "blue") +
  geom_line(data = AHPkgDownloads, aes(x = Year, y = Nb_of_downloads), color
            = "lightblue") +  
  xlab('AnnotationHub') +
  ylab('Total Downloads')
p2 = ggplot() + 
  geom_line(data = EHPkgDownloads, aes(x = Year, y = Nb_of_distinct_IPs), color
            = "blue") +
  geom_line(data = EHPkgDownloads, aes(x = Year, y = Nb_of_downloads), color
            = "lightblue") +  
  xlab('ExperimentHub') +
  ylab('Total Downloads')
pdf("HubPkgDownloads.pdf")
grid.arrange(p1, p2)
dev.off()

## Print EHPkgDownloads and AHPkgDownloads ??



################################################################################
##
## Number of packages with designated biocViews terms
## Manual looked at https://bioconductor.org/packages/release/BiocViews.html
##
################################################################################

AnnotationHub, 31
ExperimentHub, 81
AnnotationHubSoftware, 3
ExperimentHubSoftware, 4


################################################################################
##
## Reverse Dependency Count
##
################################################################################

##"https://bioconductor.org/packages/devel/bioc/html/ExperimentHub.html"
## ?from landing page or from pkgtools



################################################################################
##
## Individual Resource Stats and Stats on activity of using EH/AH interface
##
################################################################################

