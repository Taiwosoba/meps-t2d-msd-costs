# Timandi Evidence Engine (TEE) — Demo Layer for MEPS T2D+MSD Project

This folder demonstrates how the **Timandi Evidence Engine (TEE)** can accelerate
HEOR/RWE workflows via:

1) **RAG Evidence Briefs**: Retrieve + summarize public/synthetic references into a structured brief.
2) **Study Design Automation (Assistive)**: Generate a draft study design outline from a template.
3) **Multi-language Code Generation (Assistive)**: Generate analysis code skeletons for R / Python / SAS / Stata.

## Important Notes
- This is a **demo** showcasing AI/ML capabilities and workflow acceleration.
- No proprietary data or MEPS raw files are included.

## Quickstart
```bash
cd tee
pip install -r requirements.txt

# (Optional) Build a simple local index (TF-IDF demo)
python rag/build_index.py

# Retrieve top documents for a query
python rag/retrieve.py --query "musculoskeletal disorders type 2 diabetes costs"

# Generate a structured evidence brief (stubbed LLM call)
python rag/generate_brief.py --query "MSD among T2D: utilization and cost outcomes"
