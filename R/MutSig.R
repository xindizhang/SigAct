# MutSig.R
# Note that The code in this file is modified based on TrackSig.
# Particular of the following scripts with function names in parethese:
# plotting.R (plot_signatures):
# https://github.com/YuliaRubanova/TrackSig/blob/master/src/plotting.R
# helper_functions.R (read_mixtures):
# https://github.com/YuliaRubanova/TrackSig/blob/master/src/helper_functions.R
# compute_mutational_signatures.R(compute_signatures_for_all_examples):
# https://github.com/YuliaRubanova/TrackSig/blob/master/src/compute_mutational_signatures.R
# Please follow the link to the github and the paper:
# Github: https://github.com/YuliaRubanova/TrackSig
# Literature: https://www.biorxiv.org/content/early/2018/11/15/260471
# Authors: Yulia Rubanova, Ruian Shi, Roujia Li, Jeff Wintersinger, Nil Sahin, Amit Deshwar, Quaid Morris
# PCAWG Evolution and Heterogeneity Working Group, PCAWG network
# Posted: Posted November 15, 2018
# Access data: Octomber and December, 2018

# Handle the check 
globalVariables(c("variable", "value", "Signatures"))

#' \code{MutSig} plot mutational signature activity of given simple(s)
#'
#' \code{MutSig} takes three input file (a .csv file of signature activities 
#' corrdinate where x is the esudotime and y is the signature activity, 
#' a .txt file of signaficant signature activity change point, and a .txt 
#' file for the pesudo-timeline) and generates a plot of a pesudotime 
#' (extimated by mutant allel per cell) vs. signature activities for single 
#' sample. For two two chronological samples, it takes six input file 
#' and generate the plot. This function is inspired by TrackSig. 
#' Please see reference at the top of this file
#'  
#' @param sigActPoints absolute path of a CSV file of signature activities 
#' across pesudotime for each signature
#' @param changepoints absolute path of a txt file containing the significant 
#' changepoints of signature activities
#' @param phis absolute path of txt containing the pesudo-timeline 
#' @param sigActPoints2 an optional file for two seamples plot. See 
#' sigActPoints for the formate 
#' @param changepoints2 an optional file for two seamples plot. See 
#' changepoint for the formate
#' @param phis2 an optional file for two seamples plot. See phis for the 
#' formate
#' 
#' @return a list containg a pesudotime (estimated by number of mutants per 
#' cancer cell) vs.signature activity plot and signatures. For two chronological 
#' samples, it returns list containg above information for each sample
#'  
#' @examples
#' # For single sample
#' sigActPoints <- system.file("extdata", "sigActPoints.csv", package = "SigAct")
#' changepoints <- system.file("extdata", "changepoints.txt", package = "SigAct")
#' phis <- system.file("extdata", "phis.txt", package = "SigAct")
#' MutSig(sigActPoints, changepoints, phis)
#' # For two samples
#' sigActPoints2 <- system.file("extdata", "sigActPoints2.csv", package = "SigAct")
#' changepoints2 <- system.file("extdata", "changepoints2.txt", package = "SigAct")
#' phis2 <- system.file("extdata", "phis2.txt", package = "SigAct")
#' MutSig(sigActPoints, changepoints, phis, sigActPoints2, changepoints2, phis2)
#' @export
MutSig <- function(sigActPoints, changepoints, phis, 
                   sigActPoints2 = NULL, changepoints2 = NULL, phis2 = NULL){ 
  
  # Read files for first smple
  fileSet1 <- list()
  fileSet1 <- readFiles(sigActPoints, changepoints, phis)
  # generate the plot of signature activities
  g1 <- plotSignatures(fileSet1[[1]], phis = fileSet1[[3]], 
                        changepoints = fileSet1[[2]])
  
  # If the files for second sample is given 
  if (!is.null(sigActPoints2) & !is.null(changepoints2) & !is.null(phis2) ){
    # read the second set of files
    fileSet2 <- list()
    fileSet2 <- readFiles(sigActPoints2, changepoints2, phis2)
    # generate plot of second file
    g2 <- plotSignatures(fileSet2[[1]], phis = fileSet2[[3]], 
                          changepoints = fileSet2[[2]])
    
    # added a list to store the plots for multiple samples
    # visulize the two plots in R viewer
    
    plots <- list()
    plots[[1]] <- g1[[1]]
    plots[[2]] <- g2[[1]]
    gridExtra::arrangeGrob(plots[[1]], plots[[2]], nrow = 1)
    # Return a list of list containg plot and signatures for both samples
    return(list(sample1 = g1, sample2 = g2))
    
  }else{            # If the files for the second sample is not given 
    return(g1)      # Return the plot and signatures for the first sample
  }
}

#' \code{readFiles} Read and Process MutSig files for plotting
#'
#' \code{readFiles} This helper function for MutSig reads and processes files 
#' for plotting. Helper Function for MutSig.This function is based on 
#' the compute_signatures_for_all_examples function in compute_mutational_signatures.R 
#' and the read_mistures function from helper_functions.R. 
#' Please see reference at the top of this file
#'  
#' @param sigActPoints absolute path of a CSV file of signature activities 
#' across pesudotime for each signature
#' @param changepoints absolute path of a txt file containing the significant 
#' changepoints of signature activities
#' @param phis absolute path of txt containing the pesudo-timeline 
#' 
#' @return A list constining data frame for signature activity points for plotting, 
#' a character vector with timepoint where signature activities changed significantly, 
#' and a vector of character indicated the number of mutant in each cancer cell for 
#' this simple, which will be use as the pesudo-timeline
readFiles <- function(sigActPoints, changepoints, phis){
  # read the phis file
  phis <- scan(phis)
  # read and process the sigActPoints
  sigActPoints <- utils::read.csv(sigActPoints)
  # name each row by their signatures
  rownames(sigActPoints) <- sigActPoints[ , 1]
  # delete the first row since it contains unrelated information
  sigActPoints <- sigActPoints[ , -1]
  # process the column names
  # The column names are numbers for the pesudo-timeline, 
  # which has the same value with phis
  colnames(sigActPoints) <- as.numeric(gsub("X(.*)", "\\1", 
                                            colnames(sigActPoints)))
  # Get the changepoints
  if (file.info(changepoints)$size == 1) {
    changepoints <- c()
  } else {
    changepoints <- unlist(utils::read.table(changepoints, header = F))
  }
  return(list(sigActPoints = sigActPoints, changepoints = changepoints, 
              phis = phis))
}

#' \code{plotSignatures} Plot signatre activity plot
#'
#' \code{plotSignatures} This function take processed information and generate 
#' a plot with pesudo-timeline as the x-axis and signative activities (in 
#' percentage) as the y-axis. Helper Function for MutSig. This function is 
#' modified from plot_signatures function of plotting.R TrackSig 
#' Please see reference at the top of this file
#' 
#' @param sigActPoints data frame of signature activities across pesudotime for all signatures 
#' in the sample
#' @param phis character verctor representing the pesudo-timeline 
#' @param changepoints character vector for significant changepoints of signature 
#' activities
#' @param ytitle title of y-axis
#' @param xtitle title for x-axis
#' @param removeSigsBelow threshold of signature activities. Only signature activity above this
#' threshold will be plotted
#' @param sig_colors customized colour set for signatures
#' 
#' @return A list containg a plot with pesudo-timeline as the x-axis and 
#' signative activities (in percentage) as the y-axis and the mutational 
#' signatures


plotSignatures <- function (sigActPoints, phis = NULL, changepoints = NULL, 
                            ytitle = "Signature exposure (%)",
                            xtitle = "Avg number of mutant alleles per cancer cell",
                            removeSigsBelow = 0, sig_colors = NULL) {
  
  # scale sigActPoints for numbers on the x-axis
  dd <- sigActPoints * 100
  # remove any signature that is lower than the threshold
  sigs_to_remove <- apply(dd, 1, mean) < removeSigsBelow
  dd <- dd[!sigs_to_remove, ]
  
  # get the signatures in the sample, colloect all the 
  # information for plotting in a dataframe
  signatures <- rownames(dd)
  df <- data.frame(signatures, dd)
  colNames <- c("Signatures")
  n_timepoints = ncol(dd)
  
  # generate x axis label
  decrement <- as.integer(150/ncol(dd))
  for (n in 1:ncol(dd)) {
    colNames <- append(colNames, 150 - decrement*(n-1))
  }
  colnames(df) <- colNames
  
  # Plotting the change of mutational signature weights during evolution specified as the order of phi
  # The signature with the maximum change is printed in the plot with the annotate function on ggplot 

  
  # converting the signature activity in percentage of total activity and 
  # group data cross signatures at each timepoint together
  df.m <- reshape2::melt(df, id.vars = "Signatures")
  maxx <- apply(dd, 2, which.max)
  maxy <- apply(dd ,2,max)
  
  # Generate the plot
  alpha <- 1
  size = 1
  g <- ggplot2::ggplot(data = df.m, ggplot2::aes(x = variable, y = value , group = Signatures, color = Signatures)) + 
    ggplot2::geom_line(alpha=alpha, size=size) + ggplot2::xlab(xtitle) + ggplot2::ylab(ytitle) + 
    ggplot2::geom_point(alpha=alpha, size=size) + 
    ggplot2::theme_bw() + ggplot2::theme(text = ggplot2::element_text(size = 20)) +
    ggplot2::theme(axis.title = ggplot2::element_text(size = 20)) + 
    ggplot2::theme(axis.text = ggplot2::element_text(size = 15)) 
  
  # customize colour
  if (!is.null(sig_colors)) {
    g <- g + ggplot2::scale_colour_manual(values = sig_colors)
  }
  
  # adjust numbers at the timeline
  if (!is.null(phis))
  {
    breaks = as.numeric(colNames[-1])
    labels=paste(round(phis,2),sep = "\n")
    
    # if there are too many time sigActPoints, display only every other value
    if (length(colNames) > 50) {
      # Display every forth label
      labels[seq(2,length(labels),4)] <- ""
      labels[seq(3,length(labels),4)] <- ""
      labels[seq(4,length(labels),4)] <- ""
    } else if (length(colNames) > 25) {
      # Display every third label
      labels[seq(2,length(labels),3)] <- ""
      labels[seq(3,length(labels),3)] <- ""
    }
    g <- g + ggplot2::scale_x_discrete(breaks = breaks, labels=labels)
  }

  # indicate the significant change points on the plot
  if (is.null(changepoints))
    stop("Please provide change sigActPoints to mark in the plot")
  
  if (length(changepoints) > 0) {
    for (i in 1:length(changepoints)) {
      g <- g +  ggplot2::annotate("rect", xmax=changepoints[i]-1, 
                         xmin=changepoints[i], ymin=-Inf, ymax=Inf, alpha=0.3) 
    }
  }
  # return the plot and signatures in one list
  return(list(plot = g, signatures = signatures))
}


# [END]

























