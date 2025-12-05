# 01_data_prep_meps.R
# Data preparation for MEPS study:
# Healthcare costs associated with musculoskeletal disorders (MSD)
# among adults with type 2 diabetes (T2D)

# -------------------------------------------------------------------
# Packages
# -------------------------------------------------------------------

library(tidyverse)
library(data.table)
library(janitor)   # for clean_names()
library(haven)     # for reading SAS / XPT files, if needed

# -------------------------------------------------------------------
# Paths
# -------------------------------------------------------------------

path_raw     <- "data/raw"      # local folder for MEPS public-use files
path_derived <- "data/derived"  # folder for cleaned / analysis data

if (!dir.exists(path_derived)) dir.create(path_derived, recursive = TRUE)

# -------------------------------------------------------------------
# Helper function to read and standardize a MEPS full-year file
# (You will adapt file names and variable names to the years you use.)
# -------------------------------------------------------------------

read_meps_fyc <- function(file_path, year_label) {
  message("Reading MEPS file: ", file_path)

  df <- read_sas(file_path) |>
    clean_names()

  # Example: rename commonly used variables.
  # NOTE: You will adjust these to match the exact MEPS year layout.
  df |>
    transmute(
      dupersid = dupersid,
      year     = year_label,
      age      = coalesce(!!sym(paste0("age", substr(year_label, 3, 4), "x")), age16x %||% NA_real_),
      sex      = sex,
      region   = dplyr::coalesce(!!dplyr::sym(paste0("region", substr(year_label, 3, 4))), region16 %||% NA_real_),
      insurance = dplyr::coalesce(!!dplyr::sym(paste0("inscov", substr(year_label, 3, 4), "f")), inscov16 %||% NA_real_),
      total_expenditure = dplyr::coalesce(!!dplyr::sym(paste0("totexp", substr(year_label, 3, 4))), totexp16 %||% NA_real_),
      weight   = dplyr::coalesce(!!dplyr::sym(paste0("perwt", substr(year_label, 3, 4), "f")), perwt16f %||% NA_real_)
    )
}

`%||%` <- function(a, b) if (!is.null(a)) a else b

# -------------------------------------------------------------------
# Read and stack MEPS years
# -------------------------------------------------------------------
# Replace the file names below with the actual MEPS full-year consolidated
# files you have downloaded into data/raw.

# Example placeholder vector – update to your real files:
meps_files <- tibble::tibble(
  year = c(2018),
  file = c("h209.sas7bdat")   # e.g., 2018 full-year consolidated
)

meps_list <- purrr::map2(
  file.path(path_raw, meps_files$file),
  meps_files$year,
  ~ read_meps_fyc(.x, .y)
)

meps_fyc <- bind_rows(meps_list)

# -------------------------------------------------------------------
# Basic cleaning and variable formatting
# -------------------------------------------------------------------

meps_fyc <- meps_fyc |>
  filter(!is.na(dupersid)) |>
  mutate(
    age_group = cut(
      age,
      breaks = c(18, 45, 65, Inf),
      labels = c("18–44", "45–64", "65+"),
      right = FALSE
    ),
    sex = factor(sex,
                 levels = c(1, 2),
                 labels = c("Male", "Female"))
  )

# -------------------------------------------------------------------
# Save derived dataset
# -------------------------------------------------------------------

saveRDS(meps_fyc, file.path(path_derived, "meps_fyc_selected.rds"))

message("Data preparation complete. File written to data/derived/meps_fyc_selected.rds")
