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


