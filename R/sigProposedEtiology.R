#' \code{readSignatures} provide information about signatures
#'
#' \code{readSignatures} takes external file of signature information and 
#' convert it to R data frame
#' @param path absolute path external file of mutational signature information
#' @return a data frame of mutational signatures with conlums: signatures, 
#' Proposed_etiology and detailed information of signature etiology
#' @examples
#' path <- "./mutational_signatures.txt"
#' mutationalSig <- readSignatures(path)
#' @export
readSignatures <- function(path="./mutational_signatures.txt"){
  mutationalSig <- read.table(path, sep = '\t', header=T, stringsAsFactors=FALSE, quote='\"',colClasses=c("character","character","character","character"))
  return(mutationalSig)
}


#' \code{setUpCompute} source the TrackSig/src/header.R code as required for TrackSig
#'
#' \code{setUpCompute} The framework of TrackSig requires to header.R to be sourced
#' to run the following functions.
#' @param path absolute path of header.R in your TrackSig/src folder
#' @examples
#' path <- "c://User//cindy//Documents//BCB410//TrackSig//src//header.R"
#' setUpCompute(path)
#' @export
sigProposedEtiology <- function(sigName, mutationalSig){
  sigNames <- mutationalSig$Mutational_Signature
  if (sigName %in% sigNames)
  {
    sigIndex <- which(mutationalSig$Mutational_Signature == sigName)
    etiology <- mutationalSig$Details[sigIndex]
    return(etiology)
  }else{print("Invalid Signature name")}
  
  
}