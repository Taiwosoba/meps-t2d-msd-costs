# Healthcare Costs Associated with Musculoskeletal Disorders Among Adults with Type 2 Diabetes (MEPS)

This repository contains an example real-world evidence (RWE) and health economics and outcomes research (HEOR) workflow examining **healthcare utilization and costs associated with musculoskeletal disorders (MSD) among adults with type 2 diabetes**, using data from the **Medical Expenditure Panel Survey (MEPS)**.

The analysis illustrates:

- Cohort derivation from a nationally representative survey (MEPS)
- Identification of adults with type 2 diabetes, with and without MSD
- Descriptive statistics of patient characteristics and healthcare utilization
- Estimation of annual healthcare costs using generalized linear models (GLMs)
- Generation of tables and figures suitable for manuscript or conference abstracts

> All scripts are for **demonstration and educational purposes only** and use publicly available MEPS data.  
> No proprietary or patient-identified data are included in this repository.

---

## Project Structure

```text
meps-t2d-msd-costs/
├── data/
│   ├── raw/              # MEPS public-use files (not committed to GitHub)
│   └── derived/          # Cleaned / analysis-ready datasets
├── R/
│   ├── 01_data_prep_meps.R
│   ├── 02_define_cohort_t2d_msd.R
│   ├── 03_descriptive_statistics.R
│   ├── 04_cost_models_glm.R
│   └── 05_tables_figures.R
├── output/
│   ├── tables/           # CSV/HTML tables
│   └── figures/          # PNG/ PDF figures
└── docs/
    └── report.Rmd        # R Markdown report summarizing the analysis

## Analysis Overview
**1. Data Preparation** (01_data_prep_meps.R)

Import MEPS public-use files

Select and clean key variables

Prepare pooled analytic dataset

Save as a derived file for downstream steps

**2. Cohort Definition** (02_define_cohort_t2d_msd.R)

Identify adults (≥18 years) with type 2 diabetes

Flag presence of musculoskeletal disorder (MSD)

Create analytic covariates (e.g., age, sex, region)

Save final study cohort

**3. Descriptive Statistics** (03_descriptive_statistics.R)

Summaries of baseline characteristics

Stratification by MSD status

Weighted descriptive statistics using MEPS survey weights

Export Table 1

**4. Cost Modeling** (04_cost_models_glm.R)

Generalized linear models (Gamma + log link)

Adjust for confounders

Estimate incremental annual costs associated with MSD

Export model results

**5. Reporting** (docs/report.Rmd)

R Markdown report integrating tables, plots, and key findings

Suitable for HEOR deliverables or conference abstracts

Methods & Tools

Data Source: MEPS public-use files

Languages: R

Key Packages: tidyverse, data.table, survey, srvyr, tableone, broom, ggplot2

Analysis Types: Descriptive stats, regression modeling, cost estimation

Disclaimer

This project is for educational and demonstration purposes only.
No proprietary, confidential, or patient-identifiable data are included.
