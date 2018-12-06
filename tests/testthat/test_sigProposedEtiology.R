#test_lseq.R

context("setUp")
#
# ==== END SETUP AND PREPARE ===================================================
# 
test_that("Mutational signature infomation  ",{
  actual_info <- sigProposedEtiology("S36")
  expected_info <- "S36: Defective base excision repair, including DNA damage due to reactive oxygen species, due to biallelic germline or somatic MUTYH mutations."
  expect_equal(actual_info, expected_info)
})

test_that("Mutational signature infomation  ",{
  actual_info <- sigProposedEtiology("36")
  expected_info <- "Invalid Signature name"
  expect_equal(actual_info, expected_info)
})



# [END]
  
