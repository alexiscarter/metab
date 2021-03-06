## Test to use use ITS specific pipeline
library(dada2); packageVersion("dada2")
library(ShortRead); packageVersion("ShortRead")
library(Biostrings); packageVersion("Biostrings")

path <- "data/ITS_sub"
list.files(path)

fnFs <- sort(list.files(path, pattern = "_R1.fastq", full.names = TRUE)) # /!\ It seems that this workflow with cutadapt need gzip files...
fnRs <- sort(list.files(path, pattern = "_R2.fastq", full.names = TRUE))

FWD <- "GATGAAGAACGYAGYRAA"
REV <- "TCCTCCGCTTATTGATATGC"

FWD <- "ACCTGCGGARGGATCA"
REV <- "GAGATCCRTTGYTRAAAGTT" 

allOrients <- function(primer) {
  # Create all orientations of the input sequence
  require(Biostrings)
  dna <- DNAString(primer)  # The Biostrings works w/ DNAString objects rather than character vectors
  orients <- c(Forward = dna, Complement = complement(dna), Reverse = reverse(dna), 
               RevComp = reverseComplement(dna))
  return(sapply(orients, toString))  # Convert back to character vector
}
FWD.orients <- allOrients(FWD)
REV.orients <- allOrients(REV)
FWD.orients

sample.names <- sapply(strsplit(fnFs, "_"), `[`, 1)

fnFs.filtN <- file.path(path, "filtN", basename(fnFs)) # Put N-filterd files in filtN/ subdirectory
fnRs.filtN <- file.path(path, "filtN", basename(fnRs))
out <- filterAndTrim(fnFs, fnFs.filtN, fnRs, fnRs.filtN, maxN = 0, multithread = TRUE, compress = FALSE)

primerHits <- function(primer, fn) {
  # Counts number of reads in which the primer is found
  nhits <- vcountPattern(primer, sread(readFastq(fn)), fixed = FALSE)
  return(sum(nhits > 0))
}
rbind(FWD.ForwardReads = sapply(FWD.orients, primerHits, fn = fnFs.filtN[[1]]), 
      FWD.ReverseReads = sapply(FWD.orients, primerHits, fn = fnRs.filtN[[1]]), 
      REV.ForwardReads = sapply(REV.orients, primerHits, fn = fnFs.filtN[[1]]), 
      REV.ReverseReads = sapply(REV.orients, primerHits, fn = fnRs.filtN[[1]]))

cutadapt <- "/home/udem/.local/bin/cutadapt" # CHANGE ME to the cutadapt path on your machine
system2(cutadapt, args = "--version") # Run shell commands from R

path.cut <- file.path(path, "cutadapt")
if(!dir.exists(path.cut)) dir.create(path.cut)
fnFs.cut <- file.path(path.cut, basename(fnFs))
fnRs.cut <- file.path(path.cut, basename(fnRs))

FWD.RC <- dada2:::rc(FWD)
REV.RC <- dada2:::rc(REV)
# Trim FWD and the reverse-complement of REV off of R1 (forward reads)
R1.flags <- paste("-g", FWD, "-a", REV.RC) 
# Trim REV and the reverse-complement of FWD off of R2 (reverse reads)
R2.flags <- paste("-G", REV, "-A", FWD.RC) 
# Run Cutadapt
for(i in seq_along(fnFs)) {
  system2(cutadapt, args = c(R1.flags, R2.flags, "-n", 2, # -n 2 required to remove FWD and REV from reads
                             "-o", fnFs.cut[i], "-p", fnRs.cut[i], # output files
                             fnFs.filtN[i], fnRs.filtN[i])) # input files
}

rbind(FWD.ForwardReads = sapply(FWD.orients, primerHits, fn = fnFs.cut[[1]]), 
      FWD.ReverseReads = sapply(FWD.orients, primerHits, fn = fnRs.cut[[1]]), 
      REV.ForwardReads = sapply(REV.orients, primerHits, fn = fnFs.cut[[1]]), 
      REV.ReverseReads = sapply(REV.orients, primerHits, fn = fnRs.cut[[1]]))

# Forward and reverse fastq filenames have the format:
cutFs <- sort(list.files(path.cut, pattern = "_R1.fastq", full.names = TRUE))
cutRs <- sort(list.files(path.cut, pattern = "_R2.fastq", full.names = TRUE))

# Extract sample names, assuming filenames have format:
get.sample.name <- function(fname) strsplit(basename(fname), "_")[[1]][1]
sample.names <- unname(sapply(cutFs, get.sample.name))
head(sample.names)

plotQualityProfile(fnFs[1:2])
plotQualityProfile(cutFs[1:2])

filtFs <- file.path(path.cut, "filtered", basename(cutFs))
filtRs <- file.path(path.cut, "filtered", basename(cutRs))

out <- filterAndTrim(cutFs, filtFs, cutRs, filtRs, maxN = 0, maxEE = c(3, 3), 
                     truncQ = 6, minLen = 50, rm.phix = TRUE, compress = TRUE, multithread = TRUE)  # on windows, set multithread = FALSE
head(out)

errF <- learnErrors(filtFs)
errR <- learnErrors(filtRs)

#plotErrors(errF, nominalQ=TRUE)
#plotErrors(errR, nominalQ=TRUE)

derepFs <- derepFastq(filtFs)
names(derepFs) <- sample.names

derepRs <- derepFastq(filtRs)
names(derepRs) <- sample.names

dadaFs <- dada(derepFs, 
               err = errF, 
               multithread=TRUE,
               pool=TRUE)

dadaRs <- dada(derepRs, 
               err=errR,
               multithread=TRUE,
               pool=TRUE)

mergers <- mergePairs(dadaFs, derepFs, dadaRs, derepRs, 
                      minOverlap = 8, 
                      maxMismatch = 0)

min(mergers[[1]]$nmatch) # Smallest overlap           

seqtab <- makeSequenceTable(mergers)

dim(seqtab)

hist(nchar(getSequences(seqtab)),xlab="Size", ylab="Frequency", main = "ASVs length") #, xlim=c(280,500), ylim=c(0,250))

seqtab.nochim <- removeBimeraDenovo(seqtab, 
                                    method = "pooled", 
                                    #multithread = TRUE,
                                    verbose = TRUE) 
round((sum(seqtab.nochim)/sum(seqtab)*100),2)
sort(nchar(getSequences(seqtab.nochim)))
hist(nchar(getSequences(seqtab.nochim)),xlab="Size", ylab="Frequency", main = "Non-chimeric ASVs length") #, xlim=c(250,450), ylim=c(0,250)) # Lenght of the non-chimeric sequences

#taxotab <- assignTaxonomy(seqtab.nochim,
#                          refFasta = "reference_database/sh_general_release_dynamic_01.12.2017.fasta",
#                          minBoot = 50, #Default 50. The minimum bootstrap #confidence for # assigning a taxonomic level.
#                          multithread=TRUE)




corr <- as.data.frame(cor(seqtab.nochim, method = "spearman"))
indices <- as.data.frame(which(corr > .8 & corr <1, arr.ind = TRUE))
corr.sel <- corr[sort(unique(indices$row)),sort(unique(indices$col))]
heatmap(as.matrix(corr.sel), col = cm.colors(256), scale = "column")
