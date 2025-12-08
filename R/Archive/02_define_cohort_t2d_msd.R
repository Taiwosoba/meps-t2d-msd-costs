# 02_define_cohort_t2d_msd.R
# Define adults with type 2 diabetes, with and without musculoskeletal disorder

library(tidyverse)
library(data.table)

path_derived <- "data/derived/"
if (!dir.exists(path_derived)) dir.create(path_derived, recursive = TRUE)

meps_selected <- readRDS(file.path(path_derived, "meps_selected.rds"))

# Placeholder: flags for T2D and MSD
# In a real script, you would merge in condition files and create indicators
# based on ICD codes or MEPS condition codes. Here we create dummy flags
# to illustrate the structure.

set.seed(123)
meps_cohort <- meps_selected |>
  mutate(
    t2d = rbinom(n(), 1, 0.1),           # fake: 10% with T2D
    msd = if_else(t2d == 1,
                  rbinom(n(), 1, 0.4),   # among T2D, 40% with MSD (illustrative)
                  0L),
    age_group = cut(age,
                    breaks = c(18, 44, 64, Inf),
                    labels = c("18-44", "45-64", "65+"),
                    right = FALSE)
  ) |>
  filter(age >= 18, t2d == 1)            # keep adults with T2D only

saveRDS(meps_cohort, file.path(path_derived, "meps_t2d_msd_cohort.rds"))
