## 1. Download & configure TrackSig
importTrackSig()

## 2. Download human reference genome
downloadhg19()

## 3. Crate VAF files
makeVaf()

## 4. Obtain mutatioan counts
makeMutationCounts()

## 5. Extract Mutational Signatures & plot them for mutiple samples
generatePlots()

## 6. Extract Mutational Signatures & plot them for single samples
source("compute_mutational_signatures.R")
save_data_for_samples()
suppressMessages(compute_signatures_for_all_examples())

# chcek proposed etiology of mutational signature
path <- "absolute path of mutational_signatures.txt"
mutationalSig <- readSignatures(path)
sigProposedEtiology("SBS1", mutationalSig)
# [END]