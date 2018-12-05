# sigProposedEtiology,R

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
