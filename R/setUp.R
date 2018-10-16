## 1. Download & configure TrackSig
# importTrackSig()

## 2. Download human reference genome
# downloadhg19()

## 3. Crate VAF files
# makeVaf()

## 4. Obtain mutatioan counts
# makeMutationCounts()

## 5. Extract Mutational Signatures & plot them
# source("compute_mutational_signatures_multiple.R")
# setUpCompute("./src/header.R")
# save_data_for_samples()
# suppressMessages(compute_signatures_for_all_examples())
# ==============================================================================================

#' \code{importTrackSig} fork TrackSig framework onto local repository from Git Hub.
#' \code{importTrackSig} @seealso \url{https://github.com/YuliaRubanova/TrackSig.git}. 
#' Set up the sample data and place the R script for computing signature activities into
#' the TrackSig src folder. Thank Mehdi Layeghifard for helping me with the functions and 
#' debug.
#' @param data_path the absolute path of input data
#' @examples
#' importTrackSig()
#' @export
importTrackSig <- function(data_path="./inst/") {
  download.file("https://github.com/YuliaRubanova/TrackSig/archive/master.zip", "TrackSig.zip")
  unzip("TrackSig.zip")
  file.rename("TrackSig-master", "TrackSig")
  # Make sure TrackSig files are executable
  system("chmod -R 755 TrackSig/src")
  
  # Move examples to data folder
  system("rm TrackSig/data/*")
  system("cp data_path TrackSig/data")
  
  # Move plotting codes to TrackSig source folder
  system("cp R/compute_mutational_signatures_multiple.R TrackSig")
  system("cp inst/mutational_signatures.txt TrackSig")
  # Change to TrackSig directory
  setwd("TrackSig")
}

# ==============================================================================================

#' \code{downloadhg19} Download hg 19 reference from the internet
#' \code{downloadhg19} downloads hg 19 reference from the internet 
#' and unzip the fa.gz files to make it ready to use for TrackSig. 
#' For the usage of TrackSig, it is required to place the hg19 reference 
#' in a folder called hg19 in annotation directory of TrackSig. This will 
#' be done by this function.\strong{bold}: This function will take quite 
#' a bit of time. This function is inspired by Rich Scriven on 
#' \url{https://stackoverflow.com/questions/33790052/download-all-files-from-a-folder-on-a-website}
#' @seealso The hg 19 reference can also be downloaded here:
#' \url{http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/}
#' @examples
#' downloadhg19()
#' @export
downloadhg19 <- function(){
  # save the current directory path for later
  wd <- getwd()
  url <- "http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes/"
  # query the url to get all the file names ending in '.fa.gz'
  zips <- XML::getHTMLLinks(
    url,
    xpQuery = "//a/@href['.fa.gz'=substring(., string-length(.) - 5)]"
  )
  # change working directory for the download
  setwd("./annotation/")
  # create a new directory 'hg19' to hold the downloads as required
  dir.create("hg19")
  setwd("./hg19")
  # create all the new files
  file.create(zips)
  # download them all
  lapply(paste0(url, zips), function(x) download.file(x, basename(x)))
  # unzip all the ".fa.gz" files
  lapply(zips, function(x) gunzip(x))
  # reset working directory to original
  setwd(wd)
}

# ==============================================================================================

#' \code{makeVaf} Use command line to convert a vcf file of point mutation to a vaf file of variant 
#' allel frequency.
#' @seealso \url{https://github.com/YuliaRubanova/TrackSig}
#' @examples
#' makeVaf()
#' @export
makeVaf <- function(){
  file.names <- dir("./data", pattern =".vcf")
  for (file in file.names){
    input <- paste0("data/", file)
    vafname <- unlist(strsplit(file, "[.]"))[1]
    output <- paste0("data/", vafname, ".vaf")
    command <- paste0("python src/make_corrected_vaf.py --vcf ", input, " --output ", output)
    system(command)
  }
}
  
# ==============================================================================================

#' \code{makeMutationCounts}, a commandline from TrackSig framework to generates information 
#' about order of mutation occurence, mutation types, mutation counts and bootstrapping result
#' for signaficance extimation.
#' \code{makeMutationCounts} places all the generated infomation under "TrackSig/data". 
#' Those information will be used to generate plots.
#' @examples
#' makeMutationCounts()
#' @export
makeMutationCounts <- function(){
  # files<-list.files("./data", pattern='.vaf', full.names = TRUE)
  file.names <- dir("./data", pattern ="_vaf.txt")
  for (file in file.names){
    input1 <- paste0("data/", file)
    input2 <- paste0("data/", file)
    command <- paste0("src/make_counts.sh ", input1, " ", input2)
    system(command)
  }
}

# ==============================================================================================

#' \code{cleanUp} cleans up TrackSig folder for the next round of usage
#' \code{cleanUp} store results and generated plot (with preferred name, plot_name) 
#' to the given directory, result_path, delete results and saved_data in TrackSig folder.
#' @param result_path the absolute path of where the pdf plot and results will be stored 
#' @param plot_name preffered plot name by user
#' @examples
#' result_path <- "c://User//cindy//Documents//TrackSig_results"
#' cleanUp(result_path, "tumor_31.pdf")
#' @export
cleanUp <- function(result_path, plot_name){
  dir.create(result_path)
  file.copy(from="results_signature_trajectories", to=result_path, 
            overwrite = TRUE, recursive = TRUE, 
            copy.mode = TRUE)
  unlink('results_signature_trajectories', recursive=TRUE)
  unlink('saved_data', recursive=TRUE)
  file.copy(from="./multisample.pdf", to=result_path, 
            overwrite = TRUE, recursive = FALSE, 
            copy.mode = TRUE)
  file.rename("multisample.pdf", plot_name)
  
}
# ==============================================================================================

#' \code{generatePlots} gathers all the function calls and generates plot.
#' \code{generatePlots} generates one pdf plot for patient with multiple sample
#' so that it is easier for intepretation.
#' @examples
#' generatePlots()
#' @export
generatePlots <- function(){
  source("compute_mutational_signatures_multiple.R")
  setUpCompute("./src/header.R")
  save_data_for_samples()
  suppressMessages(compute_signatures_for_all_examples())
}

# [END]

