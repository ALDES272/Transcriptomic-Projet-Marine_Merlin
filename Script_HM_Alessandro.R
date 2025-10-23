
library(DESeq2)
library(readxl)
library(tidyverse)
library(ggplot2)
library(ComplexHeatmap)
library(apeglm)
library(pheatmap)
library("RColorBrewer")
# autre video indienne https://www.youtube.com/watch?v=OzNzO8qwwp0

setwd("H:/DRT/PHYSIQUE ET GÉNIE BIOMÉDICAL/10.UTILISATEURS/Alessandro/Etudiants/Bioinformatique_Marine")


raw_counts <- read_excel("./Data/raw_counts.xlsx")

# raw_counts <- read.csv("./Data/full_raw_counts.csv")
# raw_counts <- raw_counts%>% select (c( "symbol",   "ACt8",  "BCt8", "ATTT8", "BTTT8")) #nepas garder dans git
# raw_counts <- raw_counts %>% mutate_if(is.numeric, ~round(., 0)) #round to integers
# raw_counts <- raw_counts%>%unique() #keep unique values

raw_counts_mat<- raw_counts[, -1] %>% as.matrix
head(raw_counts_mat)
str(raw_counts_mat)
rownames(raw_counts_mat)<- raw_counts$symbol
 
coldata<- data.frame(condition = c("Control", "Control", "TMZ", "TMZ"))
rownames(coldata)<- colnames(raw_counts_mat) #absolument nécessaire qu'ordre des lignes de coldata soit
#identique à ordre des colonnes dans raw_counts_mat. Ici pour checker :
print(paste("est-ce que l'ordre de rownames et coldata est similaire :", all(rownames(coldata) == colnames(raw_counts_mat))))




dds <- DESeqDataSetFromMatrix(countData = raw_counts_mat,
                              colData = coldata,
                              design = ~ condition)



# Ajout Aless : filtre  les reads >=10 par groupe. Si au moins 3 groupes ont un n>=10, alors le gene est conservé.
# Voir : https://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#pre-filtering
keep <- rowSums(counts(dds)>= 10) >=3 
print(paste("Avec ce filtre,",sum(keep==T),"genes sont conservées (",round(sum(keep==T)*100/length(keep),2),"%)"))
dds <- dds[keep,]

dds <- DESeq(dds)
res <- results(dds, contrast = c("condition", "TMZ", "Control")) 
res_BY <- results(dds, contrast = c("condition", "TMZ", "Control"),pAdjustMethod='BY') 
res_BH <- results(dds, contrast = c("condition", "TMZ", "Control"),pAdjustMethod='BH') 
res_fdr <- results(dds, contrast = c("condition", "TMZ", "Control"),pAdjustMethod='fdr') 
res_bonferroni <- results(dds, contrast = c("condition", "TMZ", "Control"),pAdjustMethod='bonferroni')
res_holm <- results(dds, contrast = c("condition", "TMZ", "Control"),pAdjustMethod= "holm") 
# on change ici le pAdjustMethod pour BY a la place de BH afin de tester la maniere du padj

resultsNames(dds) 
print(paste('Dans notre dds, ',levels(dds$condition)[1],' est la référence et ',
            levels(dds$condition)[2], ' y est comparée'))

print(head(res))
print(head(res_BY))
cat("Dans head(res):
_ baseMean est la moyenne des coups normalisés pour les échantillons ;
_ log2FoldChange est positif si upregulated dans TMZ vs control ;
_ stat est la valeur du test de Wald pour chaque gene ;
_ pvalue est la pvalue du test stat (duh) ;
_ padj est la pvalue corrigée pour des tests multiples (?). Permet d'enlever les faux positifs.")

print(paste('La méthode de padj de défaut (BH) renvoie',(res@nrows),
            'genes (?) ; tandis que BY en renvoie',(res_BY@nrows)))

# Aless : resLFC est un shrunken log fold changes. Utile pour ranking et visualisation
#voir : https://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#alternative-shrinkage-estimators
resLFC <- lfcShrink(dds, coef="condition_TMZ_vs_Control", type="apeglm") 
resLFC
summary(res)
plotMA(res, ylim=c(-2,2)) # voir https://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#exploring-and-exporting-results
# en bleu sont les genes statistiquement différentiés
plotMA(resLFC, ylim=c(-2,2))

#volcano plot
volcanofunc <- function(ds_res,subtt){
  ds_res$diffexpressed_padj <- "Not significative"
  ds_res$diffexpressed_padj[ds_res$log2FoldChange > 0 & ds_res$padj < 0.05] <- "Up"
  ds_res$diffexpressed_padj[ds_res$log2FoldChange < -0 & ds_res$padj < 0.05] <- "Down"
  nb_up=nrow(ds_res[ds_res$diffexpressed_padj=='Up',])
  nb_dw=nrow(ds_res[ds_res$diffexpressed_padj=='Down',])
   
  print(paste('Dans le res de',subtt, 'il y a', nb_up, 'genes up,',
              round(100*nb_up/nrow(ds_res),2),'%'))
  print(paste('Dans le res de',subtt, 'il y a', nb_dw, 'genes Down,',
              round(100*nb_dw/nrow(ds_res),2),'%'))
  ggplot(data=ds_res, aes(x=log2FoldChange, y=-log10(padj),col=diffexpressed_padj)) + 
    geom_point() + 
    theme_minimal() +
    scale_color_manual(values=c("#4285f4", "grey", "#ea4335"))+
    theme(legend.title=element_blank())+
    ggtitle(paste("Volcano Plot",subtt))
  
}

##volcano plot de BH
volcanofunc(res,'défaut')

##volcano plot des autres 
volcanofunc(res_BH, 'BH') #BH correspond à la correction de défaut
volcanofunc(res_fdr, 'fdr')#fdr correspond à la correction de défaut et bh
volcanofunc(res_BY, 'BY')
volcanofunc(res_bonferroni, 'bonferroni') 
volcanofunc(res_holm, 'holm') 
 
 


#si on le souhaite on peut ajuster la valeur seuil du padj dans summary(res) :
summary(results(dds,alpha=0.01))

# For a particular gene, a log2 fold change of -1 for condition TMZ vs Control means 
# that the TMZ induces a multiplicative change in observed gene expression level of 2−1=0.5
# compared to the Control condition. 


# pour sauvegarder les res dans un fichier :
# write.csv(as.data.frame(res),"./Output_R_Aless/dds_res.csv", row.names = T)



#VST = variance stabilizing transformations 
# transformation du log2 scale. Permet de retirer la dépendance de la variance sur la moyenne
vsd <- vst(dds, blind=FALSE) #Extracting transformed values
head(assay(vsd), 4)
length(assay(vsd))
plotPCA(vsd, intgroup=c("condition")) # par défaut cette ligne ne prend aue les n=500 premiers genes
plotPCA(vsd, intgroup=c("condition"),ntop=length(assay(vsd))) # ici permet d'obtenir le meme graphique que plus bas

normalized_counts<- assay(vsd) %>%  as.matrix()

###les lignes suivantes jusqu'au prochain ### ne proviennent pas du helper de Deseq
pca_prcomp<- prcomp(t(normalized_counts), center = TRUE, scale. = FALSE)
str(pca_prcomp)
pca_prcomp$x
 
PC1_and_PC2<- data.frame(PC1=pca_prcomp$x[,1], PC2= pca_prcomp$x[,2],  type = rownames(pca_prcomp$x))
ggplot(PC1_and_PC2, aes(x=PC1, y=PC2, col=type)) + 
       geom_point() + 
       geom_text(aes(label = type), hjust=0, vjust=0) +
       coord_fixed()


significant_genes<- res %>% as.data.frame() %>%
  filter(padj <=0.05, abs(log2FoldChange) >= 1) %>% 
  rownames()

significant_mat<- normalized_counts[significant_genes, ] 

print(paste("Avec significant_genes, le nombre de genes considérés passe de ", nrow(normalized_counts),
            "à", nrow(significant_mat), "(", round(100*nrow(significant_mat)/nrow(normalized_counts),2), "%)"))

head(normalized_counts)
Heatmap(significant_mat)

Heatmap(t(scale(t(significant_mat))))


col_anno <- HeatmapAnnotation(df = coldata, col = list( condition = c("TMZ" = "orange", "Control" = "green")))

Heatmap(t(scale(t(significant_mat))), 
        top_annotation = col_anno,
        show_row_names = FALSE, name = "scaled normalized\nexpression")
###

# si je suis les instructions du helper de bioconductor : https://bioconductor.org/packages/release/bioc/vignettes/DESeq2/inst/doc/DESeq2.html#heatmap-of-the-count-matrix

# select correspond aux 20 premiers genomes en terme de nombre de "coups mesurés" moyens.
select <- order(rowMeans(counts(dds,normalized=TRUE)),decreasing=TRUE)[1:20]
df <- as.data.frame(colData(dds)[,"condition"])

colnames(df)=c('condition')
rownames(df) <- colnames(assay(vsd))

#ci-dessous est représenté sous forme de heatmap l'information suivante :
assay(vsd)[select,]
pheatmap(assay(vsd)[select,], cluster_rows=FALSE, show_rownames=T,
         cluster_cols=FALSE, annotation_col=df)


# ci-dessous on fait le meme travail qu'au dessus mais on va chercher les genes 
#ayant la moyenne de coups la plus différente entre ctrl et tmz
order_diff <- rownames(as.data.frame(counts(dds))%>%mutate(mean_diff=abs((ACt8+BCt8)/2-(ATTT8+BTTT8)/2))%>%arrange(-mean_diff))
as.data.frame(counts(dds))%>%mutate(mean_diff=abs((ACt8+BCt8)/2-(ATTT8+BTTT8)/2)) %>%arrange(-mean_diff)


#doit aller chercher data de assay(vsd) ou  de counts(dds) ???

select=order_diff[0:20] #prend vingt premieres
assay(vsd)[select,]
pheatmap(assay(vsd)[select,], cluster_rows=FALSE, show_rownames=T,
         cluster_cols=FALSE, annotation_col=df)

# code pour heat map of the sample-to-sample distances :
# heatmap mega pas utile lol

sampleDists <- dist(t(assay(vsd)))
sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- paste(vsd$condition, sep="-")
colnames(sampleDistMatrix) <- NULL
colors <- colorRampPalette( rev(brewer.pal(9, "Blues")) )(255)
pheatmap(sampleDistMatrix,
         clustering_distance_rows=sampleDists,
         clustering_distance_cols=sampleDists,
         col=colors)

# Moyenne et différences des groupes
mydf <- as.data.frame(assay(vsd))
head(mydf)
colnames(mydf)
mydf <- mydf%>%mutate(Ctrl_mean=(ACt8+BCt8)/2,Treat_mean=(ATTT8+BTTT8)/2)%>%
  mutate(diff_abs=Treat_mean-Ctrl_mean)%>%
  mutate(diff_rel=100*diff_abs/Ctrl_mean)

# les 20 genes les plus positifis et negatifs en terme de différence absolue
mydf%>%arrange(-diff_abs)%>%head(30)
mydf%>%arrange(diff_abs)%>%head(30)

# les 20 genes les plus positifis et negatifs en terme de différence relative
# plus pertinent selon moi
mydf%>%arrange(-diff_rel)%>%head(30)
mydf%>%arrange(diff_rel)%>%head(30)

#sauvegarder :
# write.csv(mydf,"./Output_R_Aless/mean_counts_diff.csv", row.names = T)


