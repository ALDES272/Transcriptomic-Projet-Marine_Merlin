R version 4.4.2 (2024-10-31 ucrt) -- "Pile of Leaves"
Copyright (C) 2024 The R Foundation for Statistical Computing
Platform: x86_64-w64-mingw32/x64

R est un logiciel libre livré sans AUCUNE GARANTIE.
Vous pouvez le redistribuer sous certaines conditions.
Tapez 'license()' ou 'licence()' pour plus de détails.

R est un projet collaboratif avec de nombreux contributeurs.
Tapez 'contributors()' pour plus d'information et
'citation()' pour la façon de le citer dans les publications.

Tapez 'demo()' pour des démonstrations, 'help()' pour l'aide
en ligne ou 'help.start()' pour obtenir l'aide au format HTML.
Tapez 'q()' pour quitter R.

> library(dplyr)

Attachement du package : ‘dplyr’

Les objets suivants sont masqués depuis ‘package:stats’:

    filter, lag

Les objets suivants sont masqués depuis ‘package:base’:

    intersect, setdiff, setequal, union

> library(readr)
> library(here)
here() starts at C:/Users/Marine/OneDrive - Université Laval/PhD Médecine Moléculaire/Projet PRRT/Expérience #1/THE FINAL ONE/Transcriptomic/Essais sur R
> library(DESeq2)
Le chargement a nécessité le package : S4Vectors
Le chargement a nécessité le package : stats4
Le chargement a nécessité le package : BiocGenerics

Attachement du package : ‘BiocGenerics’

Les objets suivants sont masqués depuis ‘package:dplyr’:

    combine, intersect, setdiff, union

Les objets suivants sont masqués depuis ‘package:stats’:

    IQR, mad, sd, var, xtabs

Les objets suivants sont masqués depuis ‘package:base’:

    anyDuplicated, aperm, append, as.data.frame, basename, cbind, colnames, dirname,
    do.call, duplicated, eval, evalq, Filter, Find, get, grep, grepl, intersect,
    is.unsorted, lapply, Map, mapply, match, mget, order, paste, pmax, pmax.int,
    pmin, pmin.int, Position, rank, rbind, Reduce, rownames, sapply, saveRDS,
    setdiff, table, tapply, union, unique, unsplit, which.max, which.min


Attachement du package : ‘S4Vectors’

Les objets suivants sont masqués depuis ‘package:dplyr’:

    first, rename

L'objet suivant est masqué depuis ‘package:utils’:
  
  findMatches

Les objets suivants sont masqués depuis ‘package:base’:
  
  expand.grid, I, unname

Le chargement a nécessité le package : IRanges

Attachement du package : ‘IRanges’

Les objets suivants sont masqués depuis ‘package:dplyr’:
  
  collapse, desc, slice

L'objet suivant est masqué depuis ‘package:grDevices’:

    windows

Le chargement a nécessité le package : GenomicRanges
Le chargement a nécessité le package : GenomeInfoDb
Le chargement a nécessité le package : SummarizedExperiment
Le chargement a nécessité le package : MatrixGenerics
Le chargement a nécessité le package : matrixStats

Attachement du package : ‘matrixStats’

L'objet suivant est masqué depuis ‘package:dplyr’:
  
  count


Attachement du package : ‘MatrixGenerics’

Les objets suivants sont masqués depuis ‘package:matrixStats’:
  
  colAlls, colAnyNAs, colAnys, colAvgsPerRowSet, colCollapse, colCounts,
colCummaxs, colCummins, colCumprods, colCumsums, colDiffs, colIQRDiffs, colIQRs,
colLogSumExps, colMadDiffs, colMads, colMaxs, colMeans2, colMedians, colMins,
colOrderStats, colProds, colQuantiles, colRanges, colRanks, colSdDiffs, colSds,
colSums2, colTabulates, colVarDiffs, colVars, colWeightedMads, colWeightedMeans,
colWeightedMedians, colWeightedSds, colWeightedVars, rowAlls, rowAnyNAs,
rowAnys, rowAvgsPerColSet, rowCollapse, rowCounts, rowCummaxs, rowCummins,
rowCumprods, rowCumsums, rowDiffs, rowIQRDiffs, rowIQRs, rowLogSumExps,
rowMadDiffs, rowMads, rowMaxs, rowMeans2, rowMedians, rowMins, rowOrderStats,
rowProds, rowQuantiles, rowRanges, rowRanks, rowSdDiffs, rowSds, rowSums2,
rowTabulates, rowVarDiffs, rowVars, rowWeightedMads, rowWeightedMeans,
rowWeightedMedians, rowWeightedSds, rowWeightedVars

Le chargement a nécessité le package : Biobase
Welcome to Bioconductor

Vignettes contain introductory material; view with 'browseVignettes()'. To cite
Bioconductor, see 'citation("Biobase")', and for packages 'citation("pkgname")'.


Attachement du package : ‘Biobase’

L'objet suivant est masqué depuis ‘package:MatrixGenerics’:

    rowMedians

Les objets suivants sont masqués depuis ‘package:matrixStats’:

    anyMissing, rowMedians

> library(readxl)
> raw_counts <- read_excel("~/Data/raw_counts.xlsx")
> View(raw_counts)
> raw_counts_mat<- raw_counts[, -1] %>% as.matrix
> head(raw_counts_mat)
     ACt8 BCt8 ATTT8 BTTT8
[1,]   49   46    61    20
[2,] 3067 2805  2872  3000
[3,] 1022 1056  1787  1302
[4,]   17   21    21     8
[5,]    6    4     5     0
[6,]   40   21    72    78
> rownames(raw_counts_mat)<- raw_counts$symbol
> head(raw_counts_mat)
        ACt8 BCt8 ATTT8 BTTT8
A1BG      49   46    61    20
A1CF    3067 2805  2872  3000
A2M     1022 1056  1787  1302
A2ML1     17   21    21     8
A3GALT2    6    4     5     0
A4GALT    40   21    72    78
> coldata<- data.frame(condition = c("Control", "Control", "TMZ", "TMZ"))
> rownames(coldata)<- colnames(raw_counts_mat)
> coldata
      condition
ACt8    Control
BCt8    Control
ATTT8       TMZ
BTTT8       TMZ
> dds <- DESeqDataSetFromMatrix(countData = raw_counts_mat,
+                               colData = coldata,
+                               design = ~ condition)
converting counts to integer mode
Messages d'avis :
  1: Dans DESeqDataSet(se, design = design, ignoreRank) :
  2874 duplicate rownames were renamed by adding numbers
2: Dans DESeqDataSet(se, design = design, ignoreRank) :
  some variables in design formula are characters, converting to factors
> dds <- DESeq(dds)
estimating size factors
estimating dispersions
gene-wise dispersion estimates
mean-dispersion relationship
final dispersion estimates
fitting model and testing
> res <- results(dds, contrast = c("condition", "TMZ", "Control"))
> res %>%
  +     as.data.frame() %>%
  +     arrange((padj), desc(log2FoldChange)) %>%
  +     head(n=50)
baseMean log2FoldChange     lfcSE       stat       pvalue         padj
TPPP3    2640.5752      2.3423167 0.1521467  15.395119 1.765002e-53 2.709984e-49
MMP13    1322.5852      2.3665820 0.1672355  14.151191 1.836219e-45 1.409665e-41
C6        442.3146      3.2658787 0.2549369  12.810537 1.431410e-37 7.325954e-34
CAPS     1456.8180      2.5647872 0.2011305  12.751855 3.044132e-37 1.168490e-33
CALB2    2776.4100      1.8627673 0.1489845  12.503092 7.180340e-36 1.837449e-32
CALB2.1  2776.4100      1.8627673 0.1489845  12.503092 7.180340e-36 1.837449e-32
TTR       451.7269      2.3409264 0.2183166  10.722623 7.971036e-27 1.748390e-23
HMGCS1  28273.0972     -1.3448170 0.1293362 -10.397843 2.536080e-25 4.867371e-22
PBXIP1   3759.0884      1.3613020 0.1342676  10.138726 3.719188e-24 6.344935e-21
CTSD     9687.2701      1.3182264 0.1305610  10.096629 5.717407e-24 8.778507e-21
GADD45B  2156.6384     -1.6562578 0.1644178 -10.073469 7.237908e-24 1.010280e-20
CD68     4000.5524      1.4123293 0.1464600   9.643106 5.257270e-22 6.726677e-19
MFGE8    2730.6691      1.3115644 0.1367431   9.591447 8.685796e-22 1.025859e-18
DUOX2    1346.3276      2.0900091 0.2259489   9.249919 2.246635e-20 2.463916e-17
ENKUR     700.9860      1.7422816 0.1900212   9.168881 4.779535e-20 4.892332e-17
PIFO     1189.4047      1.4945563 0.1645845   9.080782 1.077977e-19 1.034454e-16
APOD     1476.5085      1.4623891 0.1653266   8.845457 9.115425e-19 8.232838e-16
CCN2     8265.1246      1.4990586 0.1734344   8.643377 5.457528e-18 4.655272e-15
ACAT2    2242.3349     -1.3678306 0.1586599  -8.621147 6.628674e-18 5.356666e-15
GDF15   78900.0900      1.1531973 0.1343673   8.582428 9.289166e-18 7.131293e-15
TMEM190   352.1708      2.6045332 0.3058501   8.515717 1.655621e-17 1.210495e-14
MT-CO3  84268.5354     -0.9817397 0.1154521  -8.503435 1.840624e-17 1.284588e-14
MKNK2   25960.5863     -0.9992923 0.1176976  -8.490338 2.060366e-17 1.375429e-14
DRC1     1041.2805      1.4434932 0.1705791   8.462311 2.621313e-17 1.676985e-14
ENPP2    2351.1918      1.5829258 0.1913714   8.271484 1.323019e-16 8.125453e-14
CFAP90    443.3957      1.8143361 0.2207515   8.218906 2.053682e-16 1.212778e-13
IGFBP1    194.0329      2.7358930 0.3420862   7.997672 1.267937e-15 7.210334e-13
AGT       875.7892      1.6424439 0.2069294   7.937219 2.067656e-15 1.133814e-12
IFI27     628.7503      1.8718875 0.2385885   7.845675 4.306313e-15 2.279970e-12
TNN       114.9153      6.0126852 0.7683378   7.825575 5.053417e-15 2.586339e-12
ROPN1L    182.4378      2.5704085 0.3343794   7.687103 1.505039e-14 7.454314e-12
LCN15   29394.2891     -1.2155033 0.1582311  -7.681822 1.568412e-14 7.525436e-12
APOA2    3817.4474      1.3986408 0.1835351   7.620563 2.525726e-14 1.175151e-11
ACSS2    4509.9500     -1.0686993 0.1407531  -7.592723 3.132509e-14 1.414604e-11
ANPEP     312.4977      2.4189021 0.3187625   7.588415 3.238431e-14 1.420653e-11
DUOXA2    259.0020      2.3180176 0.3060656   7.573597 3.630294e-14 1.548320e-11
HLA-B.5 58639.2580      1.0213760 0.1350959   7.560378 4.018987e-14 1.667771e-11
ANKRD66   112.9878      3.1069529 0.4112963   7.554050 4.219281e-14 1.704812e-11
CP        786.9817      1.5492051 0.2058272   7.526726 5.202828e-14 2.048313e-11
CLU      3298.0446      1.1073727 0.1479850   7.483007 7.264104e-14 2.788326e-11
LAMA3    4933.0658      1.1831383 0.1585266   7.463342 8.435474e-14 3.158982e-11
INSIG1   3188.3691     -1.1129130 0.1495194  -7.443269 9.822412e-14 3.590793e-11
PLCG2     454.4191      1.5712317 0.2118545   7.416561 1.202010e-13 4.232734e-11
HMGA2    2257.4530     -1.0733862 0.1447518  -7.415357 1.212976e-13 4.232734e-11
HABP2     127.5878      2.8819012 0.3890062   7.408368 1.278627e-13 4.362676e-11
MKI67    8009.2193     -1.0647261 0.1448967  -7.348176 2.009302e-13 6.706701e-11
CFAP73    237.2705      2.3303015 0.3198113   7.286489 3.181378e-13 1.039295e-10
H2AC18    139.3927     -4.0552783 0.5570722  -7.279627 3.347436e-13 1.070761e-10
CD59     2897.0000      1.2260201 0.1687333   7.266025 3.702200e-13 1.160073e-10
VCAN      798.9673      1.3856330 0.1913722   7.240514 4.469872e-13 1.372608e-10
> significant_genes<- res %>%
  +     as.data.frame() %>%
  +     filter(padj <=0.05, abs(log2FoldChange) >= 1) %>% 
  +     rownames()
> significant_genes
[1] "ABCA1"      "ABCA6"      "ABCA8"      "ACAT2"      "ACOX2"      "ACP5"      
[7] "ACSS1"      "ACSS2"      "ADGRF4"     "ADPRHL1"    "AGT"        "AKR1B10"   
[13] "ALOX5"      "ALPL"       "ANKDD1B"    "ANKRD33"    "ANKRD66"    "ANPEP"     
[19] "ANXA1"      "APCDD1"     "APOA2"      "APOBEC3C"   "APOD"       "APOE"      
[25] "AQP10"      "AQP3"       "ARC"        "ARG1"       "ARMC3"      "ASPM"      
[31] "ATP4B"      "ATP6V1C2"   "BEST4"      "BMERB1"     "BOC"        "BRINP2"    
[37] "BTN3A3"     "C11orf16"   "C15orf48"   "C19orf38"   "C1QTNF12"   "C22orf42"  
[43] "C6"         "C8G"        "C9orf152"   "C9orf24"    "CA12"       "CABCOCO1"  
[49] "CACNA1A"    "CALB2"      "CALB2.1"    "CALY"       "CAPS"       "CATIP"     
[55] "CCDC153"    "CCDC170"    "CCDC190"    "CCDC198"    "CCDC33"     "CCDC33.1"  
[61] "CCDC78"     "CCDC96"     "CCN2"       "CCN3"       "CD164L2"    "CD36"      
[67] "CD59"       "CD68"       "CDA"        "CDCA3"      "CDH16"      "CDH5"      
[73] "CDHR2"      "CDHR4"      "CERCAM"     "CERKL"      "CFAP126"    "CFAP206"   
[79] "CFAP276"    "CFAP300"    "CFAP43"     "CFAP45"     "CFAP47"     "CFAP61"    
[85] "CFAP73"     "CFAP77"     "CFAP90"     "CFAP95"     "CHD9NB"     "CHST15"    
[91] "CIBAR2"     "CIDEB"      "CISD3.1"    "CLCN1"      "CLDN18"     "CLIC2"     
[97] "CLU"        "CLXN"       "CNIH2"      "CNR1"       "CNTN1"      "COL10A1"   
[103] "COL17A1"    "COL6A2"     "COLEC12"    "CP"         "CPM"        "CRACDL"    
[109] "CREBL2"     "CRLF1"      "CRTAC1"     "CSF1R"      "CTSD"       "CTSS"      
[115] "CTSV"       "CXCL12"     "CYTH4"      "DDAH2"      "DDAH2.1"    "DDAH2.3"   
[121] "DMBT1"      "DNAAF8"     "DNAH3"      "DNAI2"      "DNAI3"      "DNAI7"     
[127] "DRC1"       "DRC7"       "DTHD1"      "DTX1"       "DUOX2"      "DUOXA2"    
[133] "DYDC2"      "DYSF"       "E2F7"       "EFHB"       "EFHC2"      "EGFL8"     
[139] "EGFL8.1"    "EGFL8.3"    "EID3"       "EIF3CL"     "ELOVL2"     "EML1"      
[145] "ENKUR"      "ENPP2"      "ERP27"      "EZH2"       "F10"        "F7"        
[151] "FAM156B"    "FAM166B"    "FAM171B"    "FAM229B"    "FAM72C"     "FAM81B"    
[157] "FAP"        "FGFR2"      "FKBPL"      "FKBPL.3"    "FNDC11"     "FRMPD2"    
[163] "FXYD2"      "FXYD6"      "GABBR1"     "GADD45B"    "GBP1"       "GBP3"      
[169] "GDF15"      "GGT1"       "GINS2"      "GJA1"       "GNL1.2"     "GNL1.4"    
[175] "GNL1.5"     "GNL1.6"     "GPBAR1"     "GPR179.1"   "GPRC5B"     "GPSM3.1"   
[181] "GRIN2A"     "GRIN3B"     "H2AC18"     "H2AC6"      "H2BC4"      "H2BC5"     
[187] "H2BC9"      "HABP2"      "HAS2"       "HCN3.1"     "HEG1"       "HLA-B.5"   
[193] "HLA-F.4"    "HMGA2"      "HMGCS1"     "HSPA6"      "HTR1D"      "HTRA1"     
[199] "ID2"        "IFI27"      "IFI44"      "IFITM10"    "IGFBP1"     "IGFBP5"    
[205] "IL31RA"     "IL6R"       "INSIG1"     "IQUB"       "IRF8"       "ITGB8"     
[211] "JAK2"       "KCNE1"      "KCNIP4"     "KCNN3"      "KIF14"      "KIF17"     
[217] "KIF18B"     "KIF19"      "KIF20A"     "KIF26B.1"   "KIF5C.1"    "KLHL41"    
[223] "KRT20.1"    "KRT23.1"    "LAMA3"      "LAMP3"      "LAPTM5"     "LCN15"     
[229] "LCP1"       "LDLRAD1"    "LGALS3"     "LGR6"       "LMNB1"      "LRP4"      
[235] "LRRN1"      "LSS.1"      "LXN"        "LY6E"       "LY96"       "LYPD8"     
[241] "MAF"        "MAP1A"      "MAP3K19"    "MAP6"       "MAPK15"     "MARCHF4"   
[247] "MATN2"      "MBOAT4"     "MEF2C"      "MELTF"      "MEP1A"      "MFGE8"     
[253] "MGAT3"      "MICA.2"     "MICA.3"     "MINDY4"     "MKI67"      "MLXIP.1"   
[259] "MMP10"      "MMP12"      "MMP13"      "MORN5"      "MR1"        "MRM1"      
[265] "MRM1.1"     "MROH5"      "MS4A8"      "MUC13"      "MUC5B"      "MYB"       
[271] "NAPRT"      "NDRG2"      "NEK6"       "NGB"        "NIBAN1"     "NID2"      
[277] "NME1-NME2"  "NOMO1"      "NOS3"       "NRCAM"      "NRM"        "NXPE2"     
[283] "ODF3B"      "ODF3L1"     "OLFM4"      "OLFML2B"    "OLFML3"     "OXTR"      
[289] "PBXIP1"     "PCSK1N"     "PDE3A"      "PHF21B"     "PIERCE1"    "PIF1"      
[295] "PIFO"       "PLA1A"      "PLAU"       "PLCG2"      "PLK1"       "POU2AF2"   
[301] "PPP1R18.5"  "PRKD1"      "PRR29"      "PRSS23"     "RBM24"      "RBM44"     
[307] "RBP4"       "RCAN2"      "RFLNA"      "RFTN1"      "RHCE"       "RING1.3"   
[313] "RING1.4"    "ROPN1L"     "RSPH1"      "RSPH4A"     "S100A1"     "S100A3"    
[319] "SAXO2"      "SEC16B"     "SEMA6A"     "SERPINF2.1" "SERTAD4"    "SERTAD4.1" 
[325] "SEZ6"       "SFRP4"      "SFTPA1"     "SHANK2"     "SHANK3"     "SHROOM4"   
[331] "SKA1.1"     "SLC18A1"    "SLC1A2"     "SLC22A31"   "SLC35F3"    "SLC6A12"   
[337] "SLC9C1.1"   "SMKR1"      "SMN2.2"     "SNTN"       "SP7"        "SP7.1"     
[343] "SPATA18"    "SPDL1"      "SPOCD1"     "SPOCK1"     "SRPX"       "SSTR3"     
[349] "ST6GAL1"    "STMND1"     "STOML3"     "STOX1"      "SULT1C2"    "SYNPO"     
[355] "SYT5"       "SYTL3"      "TAF15.1"    "TBC1D3"     "TCN2"       "TEKT1"     
[361] "TEKT2"      "TGM2"       "THBS2"      "THSD4"      "TIGD5"      "TIMP3"     
[367] "TIMP4"      "TM4SF4"     "TMEM145"    "TMEM190"    "TMEM47"     "TMPRSS2"   
[373] "TNFSF11"    "TNN"        "TOGARAM2"   "TPPP3"      "TRANK1"     "TREM1"     
[379] "TRIM69"     "TRIM69.1"   "TRPM8"      "TRPV2"      "TRPV4"      "TTR"       
[385] "TUBA4B"     "UBXN10"     "UGT1A1"     "UGT2B7"     "VARS1"      "VARS1.3"   
[391] "VCAN"       "VNN2"       "VSIR"       "VSTM2L"     "VWA7.1"     "VWA7.3"    
[397] "VWA7.4"     "VWA7.5"     "VWDE"       "WDR38"      "WDR4"       "WDR49"     
[403] "WFDC3"      "WNT3A"      "WNT7B"      "ZBBX"       "ZDHHC1"     "ZMYND10"   
[409] "ZNF474"     "ZNF780B"    "ZNHIT3.1"  
> vsd <- vst(dds, blind=FALSE)
> plotPCA(vsd, intgroup=c("condition"))
using ntop=500 top features by variance
> vsd <- vst(dds, blind=FALSE)
> head(assay(vsd), 3)
ACt8      BCt8     ATTT8     BTTT8
A1BG  8.792491  8.764269  8.842188  8.578831
A1CF 11.848209 11.695239 11.701491 11.805529
A2M  10.620470 10.616977 11.150338 10.853859
> normalized_counts<- assay(vsd) %>% 
  +     as.matrix()
> pca_prcomp<- prcomp(t(normalized_counts), center = TRUE, scale. = FALSE)
> names(pca_prcomp)
[1] "sdev"     "rotation" "center"   "scale"    "x"       
> pca_prcomp$x
PC1        PC2       PC3          PC4
ACt8  -14.57936   2.239057  9.004512 1.354252e-13
BCt8  -12.78222  -2.653007 -9.571892 6.898976e-14
ATTT8  13.38313  11.848459 -1.677973 2.324616e-14
BTTT8  13.97845 -11.434509  2.245353 2.402386e-14
> PC1_and_PC2<- data.frame(PC1=pca_prcomp$x[,1], PC2= pca_prcomp$x[,2], 
                           +                          type = rownames(pca_prcomp$x))
> library(ggplot2)
> ggplot(PC1_and_PC2, aes(x=PC1, y=PC2, col=type)) + 
  +     geom_point() + 
  +     geom_text(aes(label = type), hjust=0, vjust=0) +
  +     coord_fixed()
> library(ComplexHeatmap)
Le chargement a nécessité le package : grid
========================================
  ComplexHeatmap version 2.22.0
Bioconductor page: http://bioconductor.org/packages/ComplexHeatmap/
  Github page: https://github.com/jokergoo/ComplexHeatmap
Documentation: http://jokergoo.github.io/ComplexHeatmap-reference

If you use it in published research, please cite either one:
  - Gu, Z. Complex Heatmap Visualization. iMeta 2022.
- Gu, Z. Complex heatmaps reveal patterns and correlations in multidimensional 
genomic data. Bioinformatics 2016.


The new InteractiveComplexHeatmap package can directly export static 
complex heatmaps into an interactive Shiny app with zero effort. Have a try!
  
  This message can be suppressed by:
  suppressPackageStartupMessages(library(ComplexHeatmap))
========================================
  
> significant_mat<- normalized_counts[significant_genes, ] 
> Heatmap(t(scale(t(significant_mat))))
> coldata
condition
ACt8    Control
BCt8    Control
ATTT8       TMZ
BTTT8       TMZ
> col_anno <- HeatmapAnnotation(df = coldata, 
                                +                               col = list( condition = c("TMZ" = "orange", "Control" = "green")))
> Heatmap(t(scale(t(significant_mat))), 
          +         top_annotation = col_anno,
          +         show_row_names = FALSE,
          +         name = "scaled normalized\nexpression")