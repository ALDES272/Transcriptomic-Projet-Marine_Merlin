library(clusterProfiler)
library(readr)
library(dplyr)
library(readr)
library(here)
library(DESeq2)
library(readxl)
library(tidyverse)
library(ggplot2)
library(ComplexHeatmap)
library(apeglm)
library(pheatmap)
library("RColorBrewer")
library(enrichplot)
library(ggupset)
library(DOSE)
library(BiocManager)

#DEG = differentially xpressed genes
#squid tutos :
# https://www.youtube.com/watch?v=H1cUs6pql9s
# https://www.youtube.com/watch?v=4MZ2fEvTj0c
# https://www.youtube.com/watch?v=TWiN_qNmYX0




#code de https://www.rdocumentation.org/packages/clusterProfiler/versions/3.0.4/topics/enrichKEGG
#hsa organism : https://www.genome.jp/kegg-bin/show_organism?org=hsa 
# library of clusterprofile  https://yulab-smu.top/biomedical-knowledge-mining-book/clusterprofiler-kegg.html


### Import des données
#changer les noms selon ta disposition de dossiers
setwd("H:/DRT/PHYSIQUE ET GÉNIE BIOMÉDICAL/10.UTILISATEURS/Alessandro/Etudiants/Bioinformatique_Marine")
 
raw_counts_kegg <- read.csv("./Data/full_raw_counts.csv") %>% select (-c('CCt8','CTTT8'))
dds_res <- read.csv("./Output_R_Aless/dds_res.csv") #liste de genes différentiés


head(dds_res)
head(raw_counts_kegg)

# Kegg_Pathways <- read.csv("./Data/KEGGPathwayGeneAnnotation.csv",sep = ';')
# head(Kegg_Pathways)


### Preparation des baackground genes


# necessaire sinon par rapport a hsa on aura une sur-expression de genes en rapport avec chais pas quoi
# ou completement inutile et donc ne changerait rien au resultat final ?
# revoir encore comment correctement setter un genes_in_data pour clusterprofiler

genes_in_data <- unique(gsub("\\.[0-9]$","",dds_res$X))

### Nettoyage du dds_res

print(paste('Des',nrow(dds_res),' genes de dds,',
            sum(dds_res$X%in% raw_counts_kegg$symbol),'sont dans le raw_counts_kegg (', 
            round(sum(dds_res$X%in% raw_counts_kegg$symbol)*100/nrow(dds_res),2),'%)'))
print(paste('Ces genes qui ne sont pas présents correspondent notamment a :',
dds_res%>%filter(! X %in% raw_counts_kegg$symbol )%>% select(X) %>%head()%>%as.vector))
#il s'agit la de genes duppliqués dans dds qui étaient présents en double dans les raw_counts initiaux

length(unique(raw_counts_kegg$symbol))
length(raw_counts_kegg$symbol)

#on ajoute une colonne symbol qui peut avoir des genes duppliqués :
dds_res <- dds_res%>%mutate(symbol=gsub("\\.[0-9]$","",X))

# A partir de https://www.youtube.com/watch?v=4MZ2fEvTj0c
# on precise la diffexpressed de dds_res :
dds_res <- dds_res%>%mutate(diffexpressed=case_when(
  log2FoldChange >0 &padj < 0.05 ~ 'UP',
  log2FoldChange <0 & padj < 0.05 ~ 'DOWN',
  padj > 0.05 ~ 'NO',
  is.na(padj) ~ NA
))
initnrow <- nrow(dds_res) 

#on ne conserve que les genes qui sont differentially expressed :
dds_res <- dds_res%>%filter(diffexpressed %in% c('UP','DOWN'))
print(paste('En ne conservant que les genes differentially expressed , on passe de',
            initnrow,'à',nrow(dds_res),'(',round(100*nrow(dds_res)/initnrow,2),'%)'))
rm(initnrow)

# on rajoute le entrez_id a notre dds_res
head(raw_counts_kegg)
symbo_ezid <- raw_counts_kegg%>%select(c('symbol','entrez_id'))%>%unique()
dds_res <- left_join(x=dds_res,y=symbo_ezid)
 


# on prepare une liste de deux DFs : les UP regulated et DOWN regulated

def_results_list <- split(dds_res,dds_res$diffexpressed)


 



### clusterProfiler et KEGG 

# ?enrichKEGG
#
#We tried to set the universe (background genes) with the genes_in_data variable, but the enrichKEGG cannot run... We can't find an explanation to this (see https://bioconductor.org/packages/release/data/experiment/manuals/scRNAseq/man/scRNAseq.pdf).


DOWN_res = enrichKEGG(gene=def_results_list[[1]]$entrez_id,
                      organism     = 'hsa', pvalueCutoff=0.05 )
UP_res = enrichKEGG(gene=def_results_list[[2]]$entrez_id,
                      organism     = 'hsa', pvalueCutoff=0.05 )

res <- lapply(names(def_results_list) , 
              function(x) enrichKEGG(gene=def_results_list[[x]]$entrez_id,
                                organism     = 'hsa', pvalueCutoff=0.05 ))
names(res) <- names(def_results_list)

res_df <- rbind(res[[1]]@result%>%mutate(UP_DOWN=names(res)[1]),res[[2]]@result%>%mutate(UP_DOWN=names(res)[2]))

head(res_df)

#pour sauvegarder donnees:
# write.csv(res_df,"./Output_R_Aless/kegg_res.csv", row.names = T)


### Analyse des resultats
head(res_df,2)
print("GeneRatio indique le nb de genes de chaque pathaway trouves dans nos deg. Son denom indique le ???")
print("voir https://www.youtube.com/watch?v=TWiN_qNmYX0")


# attention | ci-dessous, up et down regulated se rapportent au Log2Fold de la deg analysis

barplot(UP_res,showCategory = 20,title='Up regulated')
barplot(DOWN_res,showCategory = 20,title='Down regulated')

dotplot(UP_res,showCategory = 20,title='Up regulated')
dotplot(DOWN_res,showCategory = 20,title='Down regulated')


cnetplot(UP_res ,title='Up regulated')
cnetplot(DOWN_res ,title='Down regulated')

heatplot(UP_res)# ,title='Up regulated')
heatplot(DOWN_res)# ,title='Down regulated')


treeplot(pairwise_termsim(UP_res))# ,title='Up regulated')
treeplot(pairwise_termsim(DOWN_res))# ,title='DOWN_res regulated')

emapplot(pairwise_termsim(UP_res))# ,title='Up regulated')
emapplot(pairwise_termsim(DOWN_res))# ,title='DOWN_res regulated')




### clusterProfiler et GO 
# organismes GO  : https://bioconductor.org/packages/release/BiocViews.html#___OrgDb 
# eventuellement necessaire de faire tourner la ligne suivante dans la console R
# BiocManager::install("org.Hs.eg.db")

ont_val=c('BP','MF','CC','ALL')[4] #sélectionne une des ont

DOWN_res_go = enrichGO(gene=def_results_list[[1]]$entrez_id,
                       OrgDb     = 'org.Hs.eg.db',   ont=ont_val,pvalueCutoff=0.05 )
UP_res_go = enrichGO(gene=def_results_list[[2]]$entrez_id,
                     OrgDb     = 'org.Hs.eg.db',   ont=ont_val, pvalueCutoff=0.05 )


#pour sauvegarder donnees:
write.csv(DOWN_res_go,paste0("./Output_R_Aless/GO_results/DOWN_res_go_",ont_val,".csv"), row.names = T)
write.csv(UP_res_go,paste0("./Output_R_Aless/GO_results/UP_res_go_",ont_val,".csv"), row.names = T)

 
# pdf(paste0("./Output_R_Aless/GO-DotPlots/GO_Up_",ont_val,".pdf"))
dotplot(UP_res_go,showCategory = 20,title=paste('GO - Up regulated - ont:',ont_val))
# dev.off() 
# pdf(paste0("./Output_R_Aless/GO-DotPlots/GO_Down_",ont_val,".pdf"))
dotplot(DOWN_res_go,showCategory = 20,title=paste('GO - Down regulated - ont:',ont_val))
# dev.off() 


res_go <- lapply(names(def_results_list) , 
              function(x) enrichGO(gene=def_results_list[[x]]$entrez_id,
                                   OrgDb     = 'org.Hs.eg.db', pvalueCutoff=0.05 ))

names(res_go) <- names(def_results_list)

res_df_go <- rbind(res_go[[1]]@result%>%mutate(UP_DOWN=names(res_go)[1]),res_go[[2]]@result%>%mutate(UP_DOWN=names(res_go)[2]))

head(res_df_go)

#pour sauvegarder donnees:
# write.csv(res_df_go,"./Output_R_Aless/go_res.csv", row.names = T)


### Analyse des resultats


# attention | ci-dessous, up et down regulated se rapportent au Log2Fold de la deg analysis

barplot(UP_res_go,showCategory = 20,title=paste('GO - Up regulated - ont:',ont_val))
barplot(DOWN_res_go,showCategory = 20,title=paste('GO - Down regulated - ont:',ont_val))



cnetplot(UP_res_go ,title=paste('GO - Up regulated - ont:',ont_val))
cnetplot(DOWN_res_go ,title=paste('GO - Down regulated - ont:',ont_val))

heatplot(UP_res_go)# ,title=paste('GO - Up regulated - ont:',ont_val))
heatplot(DOWN_res_go)# ,title=paste('GO - Down regulated - ont:',ont_val))


treeplot(pairwise_termsim(UP_res_go))# ,title='paste(GO - Up regulated - ont:',ont_val))
treeplot(pairwise_termsim(DOWN_res_go))# ,title=paste('GO - DOWN_res regulated - ont:',ont_val))

emapplot(pairwise_termsim(UP_res_go))# ,title=paste('GO - Up regulated - ont:',ont_val))
emapplot(pairwise_termsim(DOWN_res_go))# ,title=paste('GO - DOWN_res regulated - ont:',ont_val))



 