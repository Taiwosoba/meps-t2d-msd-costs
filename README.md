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

This project demonstrates an end-to-end HEOR/RWE workflow using the Medical Expenditure Panel Survey (MEPS) to estimate healthcare utilization and costs associated with musculoskeletal disorders (MSD) among adults with type 2 diabetes (T2D). The analysis follows a structured pipeline commonly used in observational research.

---

### **1. Data Preparation (`01_data_prep_meps.R`)**
- Imports MEPS full-year consolidated files and related public-use datasets.  
- Harmonizes variable names across years and selects relevant demographic and expenditure variables.  
- Creates a combined dataset with survey weights for nationally representative estimates.  
- Saves a cleaned, analysis-ready file to `data/derived/`.

---

### **2. Cohort Definition (`02_define_cohort_t2d_msd.R`)**
- Identifies adults aged ≥18 years with type 2 diabetes.  
- Flags musculoskeletal disorders (MSD) using MEPS condition indicators or ICD-based markers (illustrated with synthetic flags in this demo).  
- Derives covariates such as age groups, sex, geographic region, and insurance.  
- Filters the dataset to retain the final analysis cohort: adults with T2D, with and without MSD.

---

### **3. Descriptive Statistics (`03_descriptive_statistics.R`)**
- Computes weighted descriptive statistics for sociodemographics, comorbidities, and healthcare expenditure variables.  
- Generates comparison tables between T2D adults with and without MSD (e.g., Table 1 baseline characteristics).  
- Outputs tables in CSV format to `output/tables/`.

---

### **4. Cost Modeling (`04_cost_models_glm.R`)**
- Estimates incremental annual healthcare costs associated with MSD among adults with T2D.  
- Fits generalized linear models (GLMs) appropriate for skewed cost distributions (e.g., Gamma with log link).  
- Adjusts for key demographic and clinical covariates.  
- Produces exponentiated model coefficients and confidence intervals.  
- Saves model outputs to `output/tables/`.

---

### **5. Tables, Figures, and Visualization (`05_tables_figures.R`)**
- Creates visual summaries of expenditure differences or utilization rates.  
- Generates plots (e.g., boxplots, bar charts) comparing MSD vs non-MSD groups.  
- Saves figures to `output/figures/`.

---

### **6. Reporting (`docs/report.Rmd`)**
- Assembles an R Markdown report summarizing:
  - Background and study rationale  
  - Cohort derivation steps  
  - Descriptive statistics  
  - Cost model results  
  - Tables and visualizations  
- Produces a reproducible HTML or PDF report suitable for internal review or scientific communication.

---

## Methods & Tools

### Methods Used
- Cohort identification (Type 2 diabetes, musculoskeletal disorders)
- Descriptive statistics (survey-weighted)
- Healthcare expenditure estimation
- Generalized Linear Models (GLMs) for cost modeling
- Adjustment for confounders (age, sex, region, etc.)
- Creation of analysis-ready datasets from MEPS public-use files
- Reproducible reporting with R Markdown

### R Packages
- `tidyverse` – data wrangling and visualization  
- `data.table` – efficient data manipulation  
- `survey` / `srvyr` – survey-weighted analyses  
- `tableone` – descriptive statistics tables  
- `broom` – model tidying  
- `ggplot2` – plots  
- `janitor` – variable cleaning  
- `haven` – import MEPS SAS transport files  

### Tools & Workflow
- R (Posit Workbench-compatible code structure)
- Clearly separated scripts for data prep, cohort creation, analysis, modeling, and reporting
- GitHub version control for reproducible workflow
- Modular project structure aligned with HEOR/RWE best practices

## Disclaimer

This repository is for **demonstration and educational purposes only**

