#test_lseq.R

context("setUp")

# ==== BEGIN SETUP AND PREPARE =================================================
#
data_path <- system.file("extdata", "mutational_signatures.txt", package = "SigAct")

#
# ==== END SETUP AND PREPARE ===================================================
# 
test_that("Mutational signature infomation  ",{
  mutationalSig <- readSignatures(data_path)
  actual_info <- sigProposedEtiology("SBS36", mutationalSig)
  expected_info <- "Defective base excision repair, including DNA damage due to reactive oxygen species, due to biallelic germline or somatic MUTYH mutations."
  expect_equal(actual_info, expected_info)
})

test_that("Mutational signature infomation  ",{
  mutationalSig <- readSignatures(data_path)
  actual_info <- sigProposedEtiology("36", mutationalSig)
  expected_info <- "Invalid Signature name"
  expect_equal(actual_info, expected_info)
})



# [END]
  
