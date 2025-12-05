# 04_cost_models_glm.R
# GLM cost models: incremental cost associated with MSD among adults with T2D

library(tidyverse)
library(broom)

path_derived <- "data/derived/"
path_output  <- "output/tables/"

if (!dir.exists(path_output)) dir.create(path_output, recursive = TRUE)

meps_cohort <- readRDS(file.path(path_derived, "meps_t2d_msd_cohort.rds"))

# Simple GLM example (not survey-weighted; you can extend with `survey` package)

model_glm <- glm(total_expenditure ~ msd + age + sex + region,
                 data = meps_cohort,
                 family = Gamma(link = "log"))

model_tidy <- broom::tidy(model_glm, exponentiate = TRUE, conf.int = TRUE)

write.csv(model_tidy,
          file = file.path(path_output, "glm_cost_model_msd_t2d.csv"),
          row.names = FALSE)
