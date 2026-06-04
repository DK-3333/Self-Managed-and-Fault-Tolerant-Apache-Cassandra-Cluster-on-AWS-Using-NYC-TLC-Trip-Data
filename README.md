# Self-Managed-and-Fault-Tolerant-Apache-Cassandra-Cluster-on-AWS-Using-NYC-TLC-Trip-Data
This project presents the design, deployment, and administration of a **self-managed Apache Cassandra distributed database cluster on AWS EC2** using the **NYC TLC Yellow Taxi Trip Records** as a realistic event-based workload. It highlights practical DBA work across installation, configuration, secure access control, data loading, backup automation, restore verification, replication, and fault-tolerance testing.

---

## Table of Contents

- [Overview](#overview)
- [Objective](#objective)
- [Repository Structure](#repository-structure)
- [Data Preparation](#data-preparation)
- [Supply Chain Network Graph](#supply-chain-network-graph)
- [Monte Carlo Simulation Model](#monte-carlo-simulation-model)
- [Hypothesis 1](#hypothesis-1)
- [Hypothesis 2](#hypothesis-2)
- [Hypothesis 3](#hypothesis-3)
- [Limitations](#limitations)
- [Dependencies](#dependencies)
- [Data Sources and References](#data-sources-and-references)
  
---

## Overview

- Built a **self-managed Apache Cassandra environment on AWS EC2** instead of using a managed database service, with full control over OS, networking, storage, and cluster configuration.
- Used **NYC TLC Yellow Taxi trip data** as a realistic time-based dataset that fits Cassandra's distributed and query-driven modeling approach.
- Demonstrated end-to-end DBA tasks including **secure configuration, query validation, backup and restore, monitoring, replication, and node-failure testing**.
- Validated the environment through **cqlsh, DataGrip, nodetool, shell scripts, and AWS infrastructure checks**.

---

## Objective

- Implemented a decentralized cluster to understand real-world distributed database challenges, such as replication strategies and data consistency models, by selecting **Apache Cassandra** as the project database platform.
- Show that a distributed NoSQL database can be **installed, configured, secured, and operated** in a cloud VM environment.
- Build a workload-driven Cassandra schema that supports a realistic access pattern, **fetch trips for a pickup location on a specific date, ordered by pickup time**.
- Demonstrate operational DBA responsibilities beyond loading data, especially **least-privilege access, recurring backups, restore testing, replication, and service continuity**.

---

## Repository Structure
```
├── docs/
│   ├── github_g2_project_report.pdf              # Full project report covering architecture, AWS setup, Cassandra administration, backup/restore, replication, fault tolerance, and cost analysis
│   └── data_dictionary_trip_records_yellow.pdf   # Field-level data dictionary describing the taxi trip attributes, datatype meanings, and CSV schema reference used for loading
├── notebooks/
│   └── updated_data_preprocessing.ipynb          # Notebook documenting Parquet inspection, datatype standardization, CSV conversion, and preparation of Cassandra-ready load files
├── sql/
│   ├── updated_datagrip_cassandra_node1.sql      # Node 1 CQL script for schema creation, CRUD validation, query testing, permissions, restore verification, and replication-related checks
│   └── updated_datagrip_cassandra_node2.sql      # Node 2 CQL script for keyspace visibility checks, replicated data validation, and fault-tolerance read testing
└── README.md                                     # GitHub project overview summarizing scope, architecture, workflow, DBA tasks, outcomes, and supporting documentation
```
---



