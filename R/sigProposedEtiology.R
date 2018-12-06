# sigProposedEtiology.R
# Infomation of the proposed etiology is based on Mutalisk, a wbsite tool for somatic genome mutations analysis
# For more infomation:
# Please visit the website: http://mutalisk.org/
# Please see the original paper by: Jongkeun Lee,  Andy Jinseok Lee, June-Koo Lee,  Jongkeun Park, Youngoh Kwon, 
# Seongyeol Park,  Hyonho Chun, Young Seok Ju,  Dongwan Hong. 2018. Mutalisk: a web-based somatic MUTation AnaLyIS 
# toolKit for genomic, transcriptional and epigenomic signatures. Nucleic Acids Research. Vol 46. 
# Website: https://academic.oup.com/nar/article/46/W1/W102/5001159,

#' \code{readSignatures} provide information about signatures' proposed etiology
#'
#' \code{readSignatures} takes external file of signatures' proposed etiology and 
#' convert it to R data frame. Helper function for sigProposedEtiology.
#' 
#' @return a data frame of proposed etiology of mutational signature with conlums: signatures, 
#' Proposed_etiology and detailed information of signature etiology
readSignatures <- function(){
  path <- system.file("extdata", "sigProposedEtiology.txt", package = "SigAct")
  mutationalSig <- utils::read.table(path, sep = '\t', header=T, stringsAsFactors=FALSE, quote='\"',colClasses=c("character","character","character","character"))
  return(mutationalSig)
}


#' \code{sigProposedEtiology} Give proposed etiology of mutational signature
#'
#' \code{sigProposedEtiology} This function takes signature ID and give the 
#' proposed etiology of mutational signature
#' 
#' @param sigName ID of a signature
#' 
#' @examples
#' sigProposedEtiology("S1")
#' @export
sigProposedEtiology <- function(sigName){
  mutationalSig <- readSignatures()
  sigNames <- mutationalSig$Mutational_Signature
  if (sigName %in% sigNames)
  {
    sigIndex <- which(mutationalSig$Mutational_Signature == sigName)
    etiology <- mutationalSig$Details[sigIndex]
    result <- paste(sigName, etiology, sep = ": ")
    return(result)
  }else{print("Invalid Signature name")}
}

# [END]
