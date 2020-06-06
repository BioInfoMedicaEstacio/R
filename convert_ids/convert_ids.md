R Notebook
================
Joao Ortigao

Importar lista com nome de genes e limpar espaços em braco.

``` r
FILE="genestabela1.txt"
GeneNames = read.table(FILE)
GeneNames = gsub(" ","",GeneNames$V1)
```

Instalar o pacote mygene, se necessário.

``` r
if (!requireNamespace("mygene", quietly = TRUE))
    BiocManager::install("mygene")
```

Converter IDs usando a ferramenta mygene

``` r
suppressPackageStartupMessages(library(mygene))

DF1 = as.data.frame(queryMany(GeneNames, 
                              scopes="symbol", 
                              fields="ensembl.gene", 
                              species="human"))
```

    ## Finished
    ## Pass returnall=TRUE to return lists of duplicate or missing query terms.

``` r
LIST1 = queryMany(GeneNames, 
                 scopes="symbol", 
                 fields="ensembl.gene", 
                 species="human")
```

    ## Finished
    ## Pass returnall=TRUE to return lists of duplicate or missing query terms.

``` r
head(DF1)
```

    ##   query X_id  X_score      ensembl notfound
    ## 1 IL2RG 3561 90.80325 ENSG0000....       NA
    ## 2  IL7R 3575 88.16647 ENSG0000....       NA
    ## 3   ADA  100 84.38552 ENSG0000....       NA
    ## 4  JAK3 3718 88.37411 ENSG0000....       NA
    ## 5  CD3D  915 92.73531 ENSG0000....       NA
    ## 6   AK2  204 86.79592 ENSG0000....       NA

Instalar ensembldb, se necessário.

``` r
if (!requireNamespace("ensembldb", quietly = TRUE))
    BiocManager::install("ensembldb")
```

Instalar EnsDb.Hsapiens.v86, se necessário.

``` r
if (!requireNamespace("BiocManager", quietly = TRUE))
    BiocManager::install("EnsDb.Hsapiens.v86")
```

Converter IDs usando os pacotes ensembldb e EnsDb.Hsapiens.v86

``` r
library(ensembldb)
```

    ## Loading required package: AnnotationFilter

    ## 
    ## Attaching package: 'ensembldb'

    ## The following object is masked from 'package:stats':
    ## 
    ##     filter

``` r
library(EnsDb.Hsapiens.v86)

DF2 = genes(EnsDb.Hsapiens.v86, 
            filter=list(GeneNameFilter(GeneNames),
                        GeneIdFilter("ENSG", "startsWith")), 
            return.type="data.frame", columns=c("gene_name","gene_id"))

head(DF2)
```

    ##   gene_name         gene_id
    ## 1       ADA ENSG00000196839
    ## 2       AK2 ENSG00000004455
    ## 3    ARPC1B ENSG00000130429
    ## 4       ATM ENSG00000149311
    ## 5       B2M ENSG00000166710
    ## 6       B2M ENSG00000273686
