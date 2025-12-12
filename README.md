# Healthcare Costs Associated with Musculoskeletal Disorders Among Adults with Type 2 Diabetes (MEPS 2016)

This repository contains an example real-world evidence (RWE) and health economics and outcomes research (HEOR) workflow examining healthcare utilization and costs associated with musculoskeletal disorders (MSD) among adults with type 2 diabetes, using data from the **2016** Medical Expenditure Panel Survey (MEPS) Full-Year Consolidated file.

The analysis illustrates:

- Cohort derivation from a nationally representative survey (MEPS)
- Identification of adults with type 2 diabetes, with and without MSD
- Descriptive statistics of patient characteristics and healthcare utilization
- Estimation of annual healthcare costs using generalized linear models (GLMs)
- Generation of tables and figures suitable for manuscript or conference abstracts  

> All scripts are for demonstration and educational purposes only and use publicly available MEPS data.  
> No proprietary or patient-identified data are included in this repository.

---

## Key Study Details

- **Data source:** Medical Expenditure Panel Survey (MEPS), Household Component  
- **Study year:** **2016** full-year consolidated file  
- **Population:** Adults (≥18 years) with type 2 diabetes  
- **Exposure:** Presence of musculoskeletal disorders (MSD) vs no MSD  
- **Outcome:** Total annual healthcare expenditures (USD), survey-weighted and modeled with GLMs  
- **Design:** Cross-sectional analysis using survey-weighted generalized linear models

### Key Finding

In survey-weighted generalized linear models adjusted for key covariates, **adults with MSD had an estimated \$6,485 (approximately 64%) higher annual total healthcare cost compared to adults without MSD**.

This incremental cost represents the **MSD-associated excess cost** among adults with type 2 diabetes in the 2016 MEPS sample.

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
│   └── figures/          # PNG/PDF figures
└── docs/
    └── report.Rmd        # R Markdown report summarizing the analysis

```

## Analysis Overview

This project demonstrates an end-to-end HEOR/RWE workflow using the 2016 Medical Expenditure Panel Survey (MEPS) to estimate healthcare utilization and costs associated with musculoskeletal disorders (MSD) among adults with type 2 diabetes (T2D). The analysis follows a structured pipeline commonly used in observational research.

---

### **1. Data Preparation (`01_data_prep_meps.R`)**
- Imports the 2016 MEPS full-year consolidated files dataset.  
- Selects relevant demographic, clinical, and expenditure variables.  
- Creates a survey design object with MEPS weights, strata, and PSUs.  
- Saves a cleaned, analysis-ready file to `data/derived/`.

---

### **2. Cohort Definition (`02_define_cohort_t2d_msd.R`)**
- Identifies adults aged ≥18 years with type 2 diabetes.  
- Flags musculoskeletal disorders (MSD) using MEPS medical conditions dataset.  
- Derives covariates such as sociodemographic (age, sex, ethnicity, insurance, income, employment, marital status, region) and clinical (BMI) factors.  
- Filters the dataset to retain the final analysis cohort: adults (aged >=18 years) with T2D, with and without MSD.

### 2b. 2016 MEPS T2D + MSD analysis (`R/02_msd_2016_two_part_ATT.R`)
- Uses an analytic file derived from the 2016 MEPS FYC (`t2dstudy16.csv`).
- Builds the adult T2D cohort with and without musculoskeletal disorders (MSD).
- Applies survey-weighted ATT-IPTW based on demographic and clinical covariates.
- Fits a two-part cost model (logistic + Gamma log-link) for total annual expenditures.
- Produces marginal expected annual costs by MSD status and the incremental cost estimate.
- Main result: adults with T2D and MSD have **\$6,450 (64%) higher expected annual costs** than those without MSD.

---

### **3. Descriptive Statistics (`03_descriptive_statistics.R`)**
- Computes survey-weighted descriptive statistics for sociodemographics, clinical, and healthcare expenditure variables.  
- Generates comparison tables between T2D adults with and without MSD.  
- Outputs tables in CSV format to `output/tables/`.

---

### **4. Cost Modeling (`04_cost_models_glm.R`)**
- Defines total annual healthcare expenditures as the primary outcome (e.g., total_exp derived from MEPS expenditure variables).
- Fits survey-weighted generalized linear models (GLMs) appropriate for skewed cost distributions (e.g., Gamma with log link)
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

## Timandi Evidence Engine (TEE) — AI-Enabled Workflow Extension (Conceptual)
### Agentic Workflow Support
TEE is designed around modular, role-based AI agents that assist with:
- Drafting study design outlines
- Scaffolding analysis plans
- Generating multi-language analytic code templates (R, Python, SAS, Stata)
- Producing structured, decision-ready summaries for HEOR, Medical, and Commercial teams

An orchestration layer coordinates these agents into repeatable workflows aligned with HEOR best practices.

### Retrieval-Augmented Generation (RAG) — Design Only
TEE supports retrieval-augmented generation (RAG) to ground AI outputs in trusted evidence sources (e.g., approved literature, internal repositories).

The RAG layer is **described conceptually only** in this public repository.

### Application to the T2D + MSD MEPS Study
In the context of this analysis, TEE was used to:
- Rapidly draft consistent study design documentation
- Generate reusable analytic code skeletons aligned with the existing R pipeline
- Standardize variable definitions and modeling approaches across similar studies

The validated R scripts in this repository remain the source of truth for similar analyses.


