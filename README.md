## Workshop
eDNA metabarcoding: From raw data to RDA

## Description

[English]  
With the democratisation of high-throughput sequencing, the use of DNA as an identification method has become standard practice. The marker genes (16S rRNA, 18S rRNA, ITS, etc.) can be compared to databases and give an overview of the communities present in your samples. No more cultivating, isolating and identifying based on morphology and chemical reactions ! However time-gaining DNA sequencing may be, the full process of turning raw DNA reads into exploitable taxonomic units can be tricky. Due to the quick turnover in bioinformatics techniques and the profusion of methods available, it can be hard to decide on a pipeline. In this workshop, we would like to present to you a complete reproducible workflow in R dedicated to the processing of raw DNA sequences using the _DADA2_ package, followed by community analysis and visualisation using the _Phyloseq_ package.

[Español]  
Desde la democratización de la secuenciación de alto rendimiento, el uso del ADN como método de identificación se ha convertido en una práctica habitual. Gracias a los genes marcadores (16S rRNA, 18S rRNA, ITS, etc.) y a las bases de datos taxonómicas, es posible identificar las comunidades presentes en sus muestras. No es necesario cultivar, aislar e identificar basándose en la morfología y las reacciones químicas. Sin embargo, todo el proceso de identificación de las secuencias de ADN en unidades taxonómicas utilizables puede ser difícil debido a la rápida evolución de las técnicas bioinformáticas y a la riqueza de los métodos disponibles. En este taller, presentaremos un flujo operativo accesible y reproducible en lenguaje R dedicado al procesamiento de secuencias de ADN en bruto utilizando la biblioteca _DADA2_. A continuación, se llevará a cabo un análisis de la comunidad y una visualización con la biblioteca _Phyloseq_.

[Français]  
Depuis la démocratisation du séquençage à haut débit, l'utilisation de l'ADN comme méthode d'identification est devenue une pratique courante. Grâce à des gènes marqueurs (ARNr 16S, ARNr 18S, ITS, etc.) et des bases de données taxonomiques, il est possible d’identifier les communautés présentes dans vos échantillons. Plus besoin de cultiver, isoler et identifier en fonction de la morphologie et des réactions chimiques! Cependant, le processus complet de d’identification des séquences d'ADN en unités taxonomiques exploitables peut s’avérer difficile en raison de l’évolution rapide des techniques bioinformatiques et de la profusion de méthodes disponibles. Dans cet atelier, nous vous présenterons un flux opérationnel accessible et reproductible en langage R dédié au traitement de séquences d'ADN brutes à l'aide de la librairie _DADA2_. Cette étape sera suivi d’une analyse et d’une visualisation de la communauté à l'aide de la librairie _Phyloseq_.

## Install packages
```
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("dada2")
BiocManager::install("phyloseq")

install.packages(c('ggplot2', 'vegan', 'gtools')

```

## Tutorials

TD TSE dada + intro metabarcoding [English]  
[https://alexiscarter.github.io/metab/Dada_script_TSE_EN.html](https://alexiscarter.github.io/metab/Dada_script_TSE_EN.html)   

[Bilingual Français-English]  
Dada: [https://alexiscarter.github.io/metab/Dada_script.html](https://alexiscarter.github.io/metab/Dada_script.html)  
Phyloseq: [https://alexiscarter.github.io/metab/Phyloseq_script.html](https://alexiscarter.github.io/metab/Phyloseq_script.html)

[Français]  
Dada: [https://alexiscarter.github.io/metab/Dada_script_FR.html](https://alexiscarter.github.io/metab/Dada_script_FR.html)  

[English]  
Dada: [https://alexiscarter.github.io/metab/Dada_script_EN.html](https://alexiscarter.github.io/metab/Dada_script_EN.html)  

[Español]  
Dada: [https://alexiscarter.github.io/metab/Dada_script_ES.html](https://alexiscarter.github.io/metab/Dada_script_ES.html)  

## To download the repository
[https://github.com/alexiscarter/metab/archive/master.zip](https://github.com/alexiscarter/metab/archive/master.zip)  
It includes data and scripts.
<br>

Set the working directory before starting the tutorials:  
```
setwd("YourPath/metab-master")
```

## Authors
Simon Morvan
Alexis Carteron
Université de Montréal
École d'Ingénieurs de PURPAN  

## Data  
Original data can be found [here](https://doi.org/10.5281/zenodo.3631861), from Carteron A, Beigas M, Joly S, Turner B L, Laliberté E. 2020. Temperate forests dominated by arbuscular or ectomycorrhizal fungi are characterized by strong shifts from saprotrophic to mycorrhizal fungi with increasing soil depth. Microbial Ecology. [DOI](https://doi.org/10.1007/s00248-020-01540-7) [PDF](/article/AAM_MicrobEcol_Carteron_etal_2020.pdf)

Amplicons obtained through DNA amplification targeting the ITS region (fungal specific) and sequenced on an Illumina MiSeq plateform (paired-end 300 bp).

Orignial sequenced data were subsampled, randomly selecting 1,000 pair-end reads per sample (i.e. 128,000 reads in total) to facilite running time in local machine. [_Seqtk_](https://github.com/lh3/seqtk) was used for the subsampling step.

Bioinformatical pipeline for ITS sequences using DADA2 and multivariate analyses of soil fungal communities using R for the article can be found [here](https://doi.org/10.5281/zenodo.3631982)

## Acknowledgements
Largely inspired by the tutorials of [_DADA2_](https://benjjneb.github.io/dada2/index.html) and [_Phyloseq_](https://joey711.github.io/phyloseq/)

Corresponding articles:

* Callahan B. J., McMurdie P. J., Rosen M. J., Han A. W., Johnson A. J. A., & Holmes S. P. (2016) DADA2: high-resolution sample inference from Illumina amplicon data. Nature methods, 13(7), 581-583

* McMurdie P. J. & Holmes S. P. (2013) Phyloseq: An R Package for Reproducible Interactive Analysis and Graphics of Microbiome Census Data. PLoS ONE. 8(4):e61217
