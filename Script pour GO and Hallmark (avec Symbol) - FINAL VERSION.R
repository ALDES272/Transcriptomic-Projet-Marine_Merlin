
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

[Workspace loaded from ~/.RData]

> library(dplyr)

Attachement du package : ‘dplyr’

Les objets suivants sont masqués depuis ‘package:stats’:

    filter, lag

Les objets suivants sont masqués depuis ‘package:base’:

    intersect, setdiff, setequal, union

> library(readr)
> library(here)
here() starts at C:/Users/Marine/OneDrive - Université Laval/Documents
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
> raw_counts <- read_excel("Data/raw_counts.xlsx")
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
> library(clusterProfiler)

clusterProfiler v4.14.4 Learn more at https://yulab-smu.top/contribution-knowledge-mining/
  
  Please cite:
  
  T Wu, E Hu, S Xu, M Chen, P Guo, Z Dai, T Feng, L Zhou, W Tang, L Zhan, X Fu, S Liu,
X Bo, and G Yu. clusterProfiler 4.0: A universal enrichment tool for interpreting
omics data. The Innovation. 2021, 2(3):100141

Attachement du package : ‘clusterProfiler’

L'objet suivant est masqué depuis ‘package:IRanges’:

    slice

L'objet suivant est masqué depuis ‘package:S4Vectors’:
  
  rename

L'objet suivant est masqué depuis ‘package:stats’:

    filter

> 
> significant_genes_map<- clusterProfiler::bitr(geneID = significant_genes,
+                                               fromType="SYMBOL", toType="ENTREZID",
+                                               OrgDb="org.Hs.eg.db")

'select()' returned 1:1 mapping between keys and columns
Message d'avis :
  Dans clusterProfiler::bitr(geneID = significant_genes, fromType = "SYMBOL",  :
                               12.17% of input gene IDs are fail to map...
                             > head(significant_genes_map)
                             SYMBOL ENTREZID
                             1  ABCA1       19
                             2  ABCA6    23460
                             3  ABCA8    10351
                             4  ACAT2       39
                             5  ACOX2     8309
                             6   ACP5       54
                             > background_genes<- res %>% 
                               +     as.data.frame() %>% 
                               +     filter(baseMean != 0) %>%
                               +     tibble::rownames_to_column(var = "symbol") %>%
                               +     pull(symbol)
                             > res_df<- res %>% 
                               +     as.data.frame() %>% 
                               +     filter(baseMean != 0) %>%
                               +     tibble::rownames_to_column(var = "symbol")
                             > background_genes_map<- bitr(geneID = background_genes, 
                                                           +                             fromType="SYMBOL", 
                                                           +                             toType="ENTREZID",
                                                           +                             OrgDb="org.Hs.eg.db")
                             'select()' returned 1:many mapping between keys and columns
                             Message d'avis :
Dans bitr(geneID = background_genes, fromType = "SYMBOL", toType = "ENTREZID",  :
  10.32% of input gene IDs are fail to map...
> library(org.Hs.eg.db)
Le chargement a nécessité le package : AnnotationDbi

Attachement du package : ‘AnnotationDbi’

L'objet suivant est masqué depuis ‘package:clusterProfiler’:
                               
                               select
                             
                             L'objet suivant est masqué depuis ‘package:dplyr’:

    select

> ego <- enrichGO(gene          = significant_genes_map$ENTREZID,
+                 universe      = background_genes_map$ENTREZID,
+                 OrgDb         = org.Hs.eg.db,
+                 ont           = "BP",
+                 pAdjustMethod = "BH",
+                 pvalueCutoff  = 0.05,
+                 qvalueCutoff  = 0.05,
+                 readable      = TRUE)
> head(ego)
                   ID                                 Description GeneRatio   BgRatio
GO:0003341 GO:0003341                             cilium movement    28/319 237/16117
GO:0060294 GO:0060294   cilium movement involved in cell motility    25/319 196/16117
GO:0001539 GO:0001539 cilium or flagellum-dependent cell motility    25/319 199/16117
GO:0060285 GO:0060285              cilium-dependent cell motility    25/319 199/16117
GO:0007018 GO:0007018                  microtubule-based movement    35/319 454/16117
GO:0030317 GO:0030317                  flagellated sperm motility    22/319 177/16117
           RichFactor FoldEnrichment    zScore       pvalue     p.adjust       qvalue
GO:0003341 0.11814346       5.969022 10.950723 2.915145e-14 1.100759e-10 9.549403e-11
GO:0060294 0.12755102       6.444325 10.897073 1.268125e-13 1.701310e-10 1.475936e-10
GO:0001539 0.12562814       6.347175 10.785234 1.802235e-13 1.701310e-10 1.475936e-10
GO:0060285 0.12562814       6.347175 10.785234 1.802235e-13 1.701310e-10 1.475936e-10
GO:0007018 0.07709251       3.894984  8.891184 5.888041e-12 3.564707e-09 3.092487e-09
GO:0030317 0.12429379       6.279758 10.036434 6.608303e-12 3.564707e-09 3.092487e-09
                                                                                                                                                                                                                                      geneID
GO:0003341                                            ARMC3/CFAP126/CFAP206/CFAP276/CFAP43/CFAP45/CFAP47/CFAP61/CFAP73/CFAP77/CFAP90/CFAP95/CLXN/DNAH3/DNAI2/DNAI3/DRC1/DRC7/EFHB/EFHC2/ENKUR/IQUB/PIERCE1/ROPN1L/RSPH4A/TEKT1/TEKT2/ZMYND10
GO:0060294                                                                 ARMC3/CFAP126/CFAP206/CFAP276/CFAP43/CFAP45/CFAP47/CFAP61/CFAP77/CFAP90/CFAP95/CLXN/DNAH3/DNAI3/DRC1/DRC7/EFHB/EFHC2/ENKUR/IQUB/PIERCE1/ROPN1L/RSPH4A/TEKT1/TEKT2
GO:0001539                                                                 ARMC3/CFAP126/CFAP206/CFAP276/CFAP43/CFAP45/CFAP47/CFAP61/CFAP77/CFAP90/CFAP95/CLXN/DNAH3/DNAI3/DRC1/DRC7/EFHB/EFHC2/ENKUR/IQUB/PIERCE1/ROPN1L/RSPH4A/TEKT1/TEKT2
GO:0060285                                                                 ARMC3/CFAP126/CFAP206/CFAP276/CFAP43/CFAP45/CFAP47/CFAP61/CFAP77/CFAP90/CFAP95/CLXN/DNAH3/DNAI3/DRC1/DRC7/EFHB/EFHC2/ENKUR/IQUB/PIERCE1/ROPN1L/RSPH4A/TEKT1/TEKT2
GO:0007018 ARMC3/CALY/CFAP126/CFAP206/CFAP276/CFAP43/CFAP45/CFAP47/CFAP61/CFAP73/CFAP77/CFAP90/CFAP95/CLXN/DNAH3/DNAI2/DNAI3/DRC1/DRC7/EFHB/EFHC2/ENKUR/IQUB/KIF14/KIF17/KIF18B/KIF19/KIF20A/MAP1A/PIERCE1/ROPN1L/RSPH4A/TEKT1/TEKT2/ZMYND10
GO:0030317                                                                                    ARMC3/CFAP126/CFAP206/CFAP276/CFAP43/CFAP45/CFAP47/CFAP61/CFAP77/CFAP90/CFAP95/CLXN/DRC1/DRC7/EFHB/EFHC2/ENKUR/IQUB/PIERCE1/ROPN1L/TEKT1/TEKT2
           Count
GO:0003341    28
GO:0060294    25
GO:0001539    25
GO:0060285    25
GO:0007018    35
GO:0030317    22
> library(enrichplot)
enrichplot v1.26.6 Learn more at https://yulab-smu.top/contribution-knowledge-mining/

Please cite:

Guangchuang Yu, Qing-Yu He. ReactomePA: an R/Bioconductor package for reactome
pathway analysis and visualization. Molecular BioSystems. 2016, 12(2):477-479
> barplot(ego, showCategory=50) 
> barplot(ego, showCategory=20) 
> dotplot(ego)
> library(msigdbr)
> m_df <- msigdbr(species = "Homo sapiens")
> head(m_df)
# A tibble: 6 × 15
  gs_cat gs_subcat      gs_name        gene_symbol entrez_gene ensembl_gene   human_gene_symbol
  <chr>  <chr>          <chr>          <chr>             <int> <chr>          <chr>            
1 C3     MIR:MIR_Legacy AAACCAC_MIR140 ABCC4             10257 ENSG000001252… ABCC4            
2 C3     MIR:MIR_Legacy AAACCAC_MIR140 ABRAXAS2          23172 ENSG000001656… ABRAXAS2         
3 C3     MIR:MIR_Legacy AAACCAC_MIR140 ACTN4                81 ENSG000001304… ACTN4            
4 C3     MIR:MIR_Legacy AAACCAC_MIR140 ACTN4                81 ENSG000002828… ACTN4            
5 C3     MIR:MIR_Legacy AAACCAC_MIR140 ACVR1                90 ENSG000001151… ACVR1            
6 C3     MIR:MIR_Legacy AAACCAC_MIR140 ADAM9              8754 ENSG000001686… ADAM9            
# ℹ 8 more variables: human_entrez_gene <int>, human_ensembl_gene <chr>, gs_id <chr>,
#   gs_pmid <chr>, gs_geoid <chr>, gs_exact_source <chr>, gs_url <chr>, gs_description <chr>
> m_t2g <- msigdbr(species = "Homo sapiens", category = "H") %>% 
+     dplyr::select(gs_name, entrez_gene)
> table(m_t2g$gs_name)

                     HALLMARK_ADIPOGENESIS               HALLMARK_ALLOGRAFT_REJECTION 
                                       210                                        335 
                HALLMARK_ANDROGEN_RESPONSE                      HALLMARK_ANGIOGENESIS 
                                       102                                         36 
                  HALLMARK_APICAL_JUNCTION                    HALLMARK_APICAL_SURFACE 
                                       231                                         46 
                        HALLMARK_APOPTOSIS              HALLMARK_BILE_ACID_METABOLISM 
                                       183                                        114 
          HALLMARK_CHOLESTEROL_HOMEOSTASIS                       HALLMARK_COAGULATION 
                                        77                                        162 
                       HALLMARK_COMPLEMENT                        HALLMARK_DNA_REPAIR 
                                       237                                        170 
                      HALLMARK_E2F_TARGETS HALLMARK_EPITHELIAL_MESENCHYMAL_TRANSITION 
                                       218                                        204 
          HALLMARK_ESTROGEN_RESPONSE_EARLY            HALLMARK_ESTROGEN_RESPONSE_LATE 
                                       216                                        218 
            HALLMARK_FATTY_ACID_METABOLISM                    HALLMARK_G2M_CHECKPOINT 
                                       165                                        204 
                       HALLMARK_GLYCOLYSIS                HALLMARK_HEDGEHOG_SIGNALING 
                                       215                                         36 
                  HALLMARK_HEME_METABOLISM                           HALLMARK_HYPOXIA 
                                       214                                        215 
              HALLMARK_IL2_STAT5_SIGNALING           HALLMARK_IL6_JAK_STAT3_SIGNALING 
                                       216                                        103 
            HALLMARK_INFLAMMATORY_RESPONSE         HALLMARK_INTERFERON_ALPHA_RESPONSE 
                                       222                                        140 
        HALLMARK_INTERFERON_GAMMA_RESPONSE                 HALLMARK_KRAS_SIGNALING_DN 
                                       286                                        220 
                HALLMARK_KRAS_SIGNALING_UP                   HALLMARK_MITOTIC_SPINDLE 
                                       220                                        215 
                 HALLMARK_MTORC1_SIGNALING                    HALLMARK_MYC_TARGETS_V1 
                                       211                                        236 
                   HALLMARK_MYC_TARGETS_V2                        HALLMARK_MYOGENESIS 
                                        60                                        212 
                  HALLMARK_NOTCH_SIGNALING         HALLMARK_OXIDATIVE_PHOSPHORYLATION 
                                        34                                        220 
                      HALLMARK_P53_PATHWAY               HALLMARK_PANCREAS_BETA_CELLS 
                                       215                                         44 
                       HALLMARK_PEROXISOME           HALLMARK_PI3K_AKT_MTOR_SIGNALING 
                                       110                                        118 
                HALLMARK_PROTEIN_SECRETION   HALLMARK_REACTIVE_OXYGEN_SPECIES_PATHWAY 
                                        98                                         58 
                  HALLMARK_SPERMATOGENESIS                HALLMARK_TGF_BETA_SIGNALING 
                                       144                                         59 
          HALLMARK_TNFA_SIGNALING_VIA_NFKB         HALLMARK_UNFOLDED_PROTEIN_RESPONSE 
                                       228                                        115 
                   HALLMARK_UV_RESPONSE_DN                    HALLMARK_UV_RESPONSE_UP 
                                       152                                        191 
       HALLMARK_WNT_BETA_CATENIN_SIGNALING             HALLMARK_XENOBIOTIC_METABOLISM 
                                        50                                        224 
> head(m_t2g)
# A tibble: 6 × 2
  gs_name               entrez_gene
  <chr>                       <int>
1 HALLMARK_ADIPOGENESIS          19
2 HALLMARK_ADIPOGENESIS       11194
3 HALLMARK_ADIPOGENESIS       10449
4 HALLMARK_ADIPOGENESIS          33
5 HALLMARK_ADIPOGENESIS          34
6 HALLMARK_ADIPOGENESIS          35
> em <- enricher(significant_genes_map$ENTREZID, TERM2GENE=m_t2g, 
+                universe = background_genes_map$ENTREZID )
> head(em)
                                                                                   ID
HALLMARK_EPITHELIAL_MESENCHYMAL_TRANSITION HALLMARK_EPITHELIAL_MESENCHYMAL_TRANSITION
HALLMARK_COAGULATION                                             HALLMARK_COAGULATION
HALLMARK_COMPLEMENT                                               HALLMARK_COMPLEMENT
HALLMARK_KRAS_SIGNALING_UP                                 HALLMARK_KRAS_SIGNALING_UP
HALLMARK_XENOBIOTIC_METABOLISM                         HALLMARK_XENOBIOTIC_METABOLISM
                                                                          Description
HALLMARK_EPITHELIAL_MESENCHYMAL_TRANSITION HALLMARK_EPITHELIAL_MESENCHYMAL_TRANSITION
HALLMARK_COAGULATION                                             HALLMARK_COAGULATION
HALLMARK_COMPLEMENT                                               HALLMARK_COMPLEMENT
HALLMARK_KRAS_SIGNALING_UP                                 HALLMARK_KRAS_SIGNALING_UP
HALLMARK_XENOBIOTIC_METABOLISM                         HALLMARK_XENOBIOTIC_METABOLISM
                                           GeneRatio  BgRatio RichFactor FoldEnrichment
HALLMARK_EPITHELIAL_MESENCHYMAL_TRANSITION    21/120 200/4282 0.10500000       3.746750
HALLMARK_COAGULATION                          13/120 132/4282 0.09848485       3.514268
HALLMARK_COMPLEMENT                           15/120 192/4282 0.07812500       2.787760
HALLMARK_KRAS_SIGNALING_UP                    14/120 194/4282 0.07216495       2.575086
HALLMARK_XENOBIOTIC_METABOLISM                13/120 193/4282 0.06735751       2.403541
                                             zScore       pvalue     p.adjust       qvalue
HALLMARK_EPITHELIAL_MESENCHYMAL_TRANSITION 6.754759 9.600512e-08 4.224225e-06 3.739147e-06
HALLMARK_COAGULATION                       4.981804 6.584928e-05 1.448684e-03 1.282328e-03
HALLMARK_COMPLEMENT                        4.303388 2.541518e-04 3.727560e-03 3.299515e-03
HALLMARK_KRAS_SIGNALING_UP                 3.812079 9.208672e-04 1.012954e-02 8.966338e-03
HALLMARK_XENOBIOTIC_METABOLISM             3.387718 2.629077e-03 2.313587e-02 2.047912e-02
                                                                                                                                            geneID
HALLMARK_EPITHELIAL_MESENCHYMAL_TRANSITION 290/1490/966/1292/9244/6387/2191/4616/2697/5654/3398/3909/4147/22795/5021/6424/6695/7052/7058/7078/1462
HALLMARK_COAGULATION                                                               8309/301/733/1191/1515/2159/5654/4224/4319/5328/11098/6271/7078
HALLMARK_COMPLEMENT                                                        948/966/978/1191/1356/1368/1509/1520/1515/2159/2155/3717/3958/4321/4322
HALLMARK_KRAS_SIGNALING_UP                                                  347/383/1520/51704/3398/3394/7805/3936/23643/4319/27344/5328/5950/6480
HALLMARK_XENOBIOTIC_METABOLISM                                                      8309/348/383/948/978/23564/2159/3398/3484/3394/57447/5950/6539
                                           Count
HALLMARK_EPITHELIAL_MESENCHYMAL_TRANSITION    21
HALLMARK_COAGULATION                          13
HALLMARK_COMPLEMENT                           15
HALLMARK_KRAS_SIGNALING_UP                    14
HALLMARK_XENOBIOTIC_METABOLISM                13
> res_df<- res_df %>% 
+     mutate(signed_rank_stats = sign(log2FoldChange) * -log10(pvalue)) %>%
+     left_join(background_genes_map, by= c("symbol" = "SYMBOL")) %>%
+     arrange(desc(signed_rank_stats))
> gene_list<- res_df$signed_rank_stats
> names(gene_list)<- res_df$ENTREZID
> em2 <- GSEA(gene_list, TERM2GENE=m_t2g)
using 'fgsea' for GSEA analysis, please cite Korotkevich et al (2019).

preparing geneSet collections...
GSEA analysis...
Erreur dans .stopf("NAs in %s are not allowed", universeArg) : 
  NAs in names(stats) are not allowed
De plus : Message d'avis :
                               Dans preparePathwaysAndStats(pathways, stats, minSize, maxSize, gseaParam,  :
                                                              There are ties in the preranked stats (12.61% of the list).
                                                            The order of those tied genes will be arbitrary, which may produce unexpected results.