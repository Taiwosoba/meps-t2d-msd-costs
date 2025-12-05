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
