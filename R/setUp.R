#' \code{importTrackSig} fork TrackSig framework onto local repository from Git Hub.
#' @seealso \url{https://github.com/YuliaRubanova/TrackSig.git}
#' @examples
#' importTrackSig()
#' @export
importTrackSig <- function(){
  download.file("https://github.com/YuliaRubanova/TrackSig/archive/master.zip", "TrackSig.zip")
  unzip("TrackSig.zip")
  file.rename("TrackSig-master", "TrackSig")
}

#' \code{makeVaf} Use command line to convert a vcf file of point mutation to a vaf file of variant 
#' allel frequency.
#' @seealso \url{https://github.com/YuliaRubanova/TrackSig}
#' @examples
#' makeVaf()
#' @export
makeVaf <- function(){
  system("python src/make_corrected_vaf.py --vcf data/example.vcf --output data/example_vaf.txt")
}

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

#' \code{makeMutationCounts}, a commandline from TrackSig framework to generates information 
#' about order of mutation occurence, mutation types, mutation counts and bootstrapping result
#' for signaficance extimation.
#' \code{makeMutationCounts} places all the generated infomation under "TrackSig/data". 
#' Those information will be used to generate plots.
#' @examples
#' makeMutationCounts()
#' @export
makeMutationCounts <- function(){
  system("src/make_counts.sh data/example.vcf data/example_vaf.txt")
}

# [END]

