# 03_descriptive_statistics.R
# Descriptive statistics: adults with T2D, with vs without MSD

library(tidyverse)
library(tableone)

path_derived <- "data/derived/"
path_output  <- "output/tables/"

if (!dir.exists(path_output)) dir.create(path_output, recursive = TRUE)

meps_cohort <- readRDS(file.path(path_derived, "meps_t2d_msd_cohort.rds"))

# Create factor versions of some variables
meps_cohort <- meps_cohort |>
  mutate(
    msd_factor = factor(msd, levels = c(0, 1), labels = c("No MSD", "MSD")),
    sex_factor = factor(sex),
    region_factor = factor(region)
  )

vars_desc <- c("age", "sex_factor", "region_factor", "total_expenditure")

tab1 <- CreateTableOne(vars = vars_desc, strata = "msd_factor",
                       data = meps_cohort, test = FALSE)

tab1_df <- print(tab1, quote = FALSE, noSpaces = TRUE, printToggle = FALSE) |>
  as.data.frame()

write.csv(tab1_df,
          file = file.path(path_output, "table1_descriptive_t2d_msd.csv"),
          row.names = FALSE)
