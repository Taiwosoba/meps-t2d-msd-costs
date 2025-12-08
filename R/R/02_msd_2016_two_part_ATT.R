############################################################
# 02_msd_2016_two_part_ATT.R
# MEPS 2016 T2D + MSD study:
#   - Cohort derivation from t2dstudy16.csv
#   - Complex survey design
#   - ATT-IPTW
#   - Two-part model for total expenditures
#   - Marginal effects (expected costs by MSD status)
############################################################

###############################################
# 1) Import packages
###############################################

# install.packages(c("tidyverse", "survey", "tableone")) # if needed

library(tidyverse)
library(survey)
library(tableone)

options(survey.lonely.psu = "adjust")

###############################################
# 2) Paths and load dataset(s)
###############################################

path_raw      <- "data/raw"
path_derived  <- "data/derived"
path_out_tab  <- "output/tables"
path_out_mod  <- "output/models"

dir.create(path_raw,     showWarnings = FALSE, recursive = TRUE)
dir.create(path_derived, showWarnings = FALSE, recursive = TRUE)
dir.create(path_out_tab, showWarnings = FALSE, recursive = TRUE)
dir.create(path_out_mod, showWarnings = FALSE, recursive = TRUE)

# Expected file: data/raw/t2dstudy16.csv
# (you can copy your existing t2dstudy16.csv here)
data_path <- file.path(path_raw, "t2dstudy16.csv")

meps_raw <- readr::read_csv(data_path)

###############################################
# 3) Build final cohort per the design
#    - source population (age >= 18)
#    - keep only relevant variables
###############################################

meps_cohort <- meps_raw %>%
  filter(age2 >= 18) %>%
  mutate(
    total_exp = exp_tot2,          # primary outcome
    age       = age2,              # age
    insurance = Inscover,          # insurance coverage
    income    = Income,            # income
    employed  = Employed,          # employment
    marital_status = Marital_Status
  )

final_cohort <- meps_cohort %>%
  select(
    DUPERSID,
    msdx,                 # exposure (0/1 MSD)
    total_exp,            # outcome
    age,
    female,
    ethnicity,
    insurance,
    income,
    employed,
    marital_status,
    region_grp,
    bmi_cat,
    wght,
    VARSTR,
    VARPSU
  )

# Save analytic cohort (RDS + CSV) to data/derived
saveRDS(final_cohort,
        file.path(path_derived, "meps_t2d_msd_cohort_2016.rds"))
write_csv(final_cohort,
          file.path(path_derived, "final_cohort_2016.csv"))

###############################################
# 4) Create exposure variable(s)
###############################################

final_cohort <- final_cohort %>%
  mutate(
    msdx       = as.integer(msdx),
    msdx_factor = factor(
      msdx,
      levels = c(0, 1),
      labels = c("No MSD", "MSD")
    )
  )

###############################################
# 5) Create outcome variable(s)
###############################################

final_cohort <- final_cohort %>%
  mutate(
    any_exp = if_else(total_exp > 0, 1L, 0L),
    any_exp_factor = factor(
      any_exp,
      levels = c(0, 1),
      labels = c("No expenditure", "Any expenditure")
    )
  )

###############################################
# 6) Create covariates
###############################################

final_cohort <- final_cohort %>%
  mutate(
    female = factor(female,
                    levels = c(0, 1),
                    labels = c("Male", "Female")),
    ethnicity = factor(ethnicity),        # TODO: recode with labels
    insurance = factor(insurance),        # TODO: label coverage types
    income    = factor(income),           # TODO: label income categories
    employed  = factor(employed),         # TODO: employed vs not
    marital_status = factor(marital_status),
    region_grp = factor(region_grp),
    bmi_cat    = factor(bmi_cat)
  )

covariate_vars <- c(
  "age",
  "female",
  "ethnicity",
  "insurance",
  "income",
  "employed",
  "marital_status",
  "region_grp",
  "bmi_cat"
)

###############################################
# 7) Baseline table (Table 1, survey-weighted)
###############################################

design_table1 <- svydesign(
  ids    = ~VARPSU,
  strata = ~VARSTR,
  weights = ~wght,
  nest   = TRUE,
  data   = final_cohort
)

cat_vars <- setdiff(covariate_vars, "age")

table1 <- svyCreateTableOne(
  vars    = covariate_vars,
  strata  = "msdx_factor",
  data    = design_table1,
  includeNA = TRUE,
  test    = FALSE
)

cat("===== TABLE 1: Baseline characteristics by MSD status (survey-weighted) =====\n")
print(
  table1,
  showAllLevels = TRUE,
  missing       = TRUE,
  smd           = TRUE
)

table1_df <- print(
  table1,
  showAllLevels = TRUE,
  missing       = TRUE,
  smd           = TRUE,
  printToggle   = FALSE
) |> as.data.frame()

write_csv(table1_df,
          file.path(path_out_tab, "table1_msdx_baseline.csv"))

###############################################
# Also: prevalence of MSD (svy: tab msdx)
###############################################

tab_msdx  <- svytable(~msdx_factor, design_table1)
prop_msdx <- prop.table(tab_msdx)

write_csv(
  as.data.frame(tab_msdx),
  file.path(path_out_tab, "msdx_weighted_counts.csv")
)

write_csv(
  as.data.frame(prop_msdx),
  file.path(path_out_tab, "msdx_weighted_proportions.csv")
)

###############################################
# 8) Primary analysis models
#    - ATT-IPTW
#    - Two-part model for total_exp
###############################################

analysis_data <- final_cohort %>%
  drop_na(msdx, total_exp, all_of(covariate_vars))

design_base <- svydesign(
  ids    = ~VARPSU,
  strata = ~VARSTR,
  weights = ~wght,
  nest   = TRUE,
  data   = analysis_data
)

ps_formula <- as.formula(
  paste("msdx ~", paste(covariate_vars, collapse = " + "))
)

ps_model <- svyglm(
  ps_formula,
  design = design_base,
  family = quasibinomial()
)

###############################################
# 8.1 Propensity scores and ATT weights
###############################################

analysis_data$ps <- fitted(ps_model)

analysis_data <- analysis_data %>%
  mutate(
    iptw_att = case_when(
      msdx == 1L ~ 1,
      msdx == 0L ~ ps / (1 - ps),
      TRUE       ~ NA_real_
    ),
    w_att = wght * iptw_att
  ) %>%
  drop_na(w_att)

design_att <- svydesign(
  ids    = ~VARPSU,
  strata = ~VARSTR,
  weights = ~w_att,
  nest   = TRUE,
  data   = analysis_data
)

cat("===== Summary of ATT-IPTW survey design =====\n")
print(summary(design_att))

###############################################
# 8.2 Two-part model
###############################################

# Part 1: any expenditure
part1_model <- svyglm(
  any_exp ~ msdx,
  design = design_att,
  family = quasibinomial()
)

cat("===== Part 1: Logistic model for any expenditure (ATT-IPTW) =====\n")
print(summary(part1_model))

# Part 2: positive expenditures (Gamma log-link)
design_att_pos <- subset(design_att, total_exp > 0)

part2_model <- svyglm(
  total_exp ~ msdx,
  design = design_att_pos,
  family = Gamma(link = "log")
)

cat("===== Part 2: Gamma log-link model for positive expenditures (ATT-IPTW) =====\n")
print(summary(part2_model))

###############################################
# 8.3 Marginal effects from the two-part model
###############################################

new_m0 <- data.frame(msdx = 0L)
new_m1 <- data.frame(msdx = 1L)

p_any_0 <- predict(part1_model, newdata = new_m0, type = "response")
p_any_1 <- predict(part1_model, newdata = new_m1, type = "response")

mu_pos_0 <- predict(part2_model, newdata = new_m0, type = "response")
mu_pos_1 <- predict(part2_model, newdata = new_m1, type = "response")

E_cost_0 <- as.numeric(p_any_0 * mu_pos_0)
E_cost_1 <- as.numeric(p_any_1 * mu_pos_1)

marginal_effects <- tibble(
  msdx = c("No MSD", "MSD"),
  prob_any_expenditure         = c(p_any_0, p_any_1),
  mean_expenditure_given_positive = c(mu_pos_0, mu_pos_1),
  expected_total_expenditure   = c(E_cost_0, E_cost_1)
) %>%
  mutate(
    diff_vs_no_msdx  = expected_total_expenditure -
      expected_total_expenditure[msdx == "No MSD"],
    ratio_vs_no_msdx = expected_total_expenditure /
      expected_total_expenditure[msdx == "No MSD"]
  )

cat("===== Two-part marginal effects: expected total expenditures by MSD status =====\n")
print(marginal_effects)

write_csv(marginal_effects,
          file.path(path_out_tab, "two_part_marginal_effects.csv"))

###############################################
# 9) Sensitivity analyses (placeholder)
###############################################

# TODO: Add sensitivity analyses (e.g., different link/distribution,
#       trimming extreme weights) as needed.

###############################################
# 10) Export model summaries and analysis data
###############################################

capture.output(
  summary(ps_model),
  file = file.path(path_out_mod, "ps_model_summary.txt")
)

capture.output(
  summary(part1_model),
  file = file.path(path_out_mod, "two_part_part1_logistic_summary.txt")
)

capture.output(
  summary(part2_model),
  file = file.path(path_out_mod, "two_part_part2_gamma_summary.txt")
)

write_csv(
  analysis_data,
  file.path(path_derived, "analysis_data_with_ps_iptw_2016.csv")
)

cat("===== PIPELINE COMPLETE =====\n")
cat("Key outputs created:\n",
    "- data/derived/meps_t2d_msd_cohort_2016.rds\n",
    "- data/derived/final_cohort_2016.csv\n",
    "- data/derived/analysis_data_with_ps_iptw_2016.csv\n",
    "- output/tables/table1_msdx_baseline.csv\n",
    "- output/tables/msdx_weighted_counts.csv\n",
    "- output/tables/msdx_weighted_proportions.csv\n",
    "- output/tables/two_part_marginal_effects.csv\n",
    "- output/models/ps_model_summary.txt\n",
    "- output/models/two_part_part1_logistic_summary.txt\n",
    "- output/models/two_part_part2_gamma_summary.txt\n")
