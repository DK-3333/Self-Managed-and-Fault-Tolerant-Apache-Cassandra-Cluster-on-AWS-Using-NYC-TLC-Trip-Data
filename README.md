# Self-Managed-and-Fault-Tolerant-Apache-Cassandra-Cluster-on-AWS-Using-NYC-TLC-Trip-Data
This project presents the design, deployment, and administration of a **self-managed Apache Cassandra distributed database cluster on AWS EC2** using the **NYC TLC Yellow Taxi Trip Records** as a realistic event-based workload. It highlights practical DBA work across installation, configuration, secure access control, data loading, backup automation, restore verification, replication, and fault-tolerance testing.

---

## Table of Contents

- [Overview](#overview)
- [Objective](#objective)
- [Repository Structure](#repository-structure)
- [Dataset and Scope](#dataset-and-scope)
- [Cloud Environment](#cloud-environment)
- [Tech Stack](#tech-stack)
- [Cloud Deployment](#cloud-deployment)
- [Security and Least Privilege](#security-and-least-privilege)
- [Load Data on Apache Cassandra](#load-data-on-apache-cassandra)
- [Backup, Restore, and Verification](#backup-restore-and-verification)
- [Distributed Cluster with Service Continuity During Node Failure](#distributed-cluster-with-service-continuity-during-node-failure)
- [Challenges Encountered](#challenges-encountered)
- [Limitations and Future Work](#limitations-and-future-work)
- [Conclusion](#conclusion)
- [Data Sources and References](#data-sources-and-references)
  
---

## Overview

- Built a **self-managed Apache Cassandra environment on AWS EC2** instead of using a managed database service, with full control over OS, networking, storage, and cluster configuration.
- Used **NYC TLC Yellow Taxi trip data** as a realistic time-based dataset that fits Cassandra's distributed and query-driven modeling approach.
- Demonstrated end-to-end DBA tasks including **secure configuration, query validation, backup and restore, monitoring, replication, and node-failure testing**.
- Validated the environment through **cqlsh, DataGrip, nodetool, shell scripts, and AWS infrastructure checks**.

### Project Architecture

The diagram below summarizes the end-to-end data flow, cloud deployment, cassandra cluster structure, and backup/restore workflow used in this project.



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
│   ├──technical_project_report.pdf              # Full project report covering architecture, AWS setup, Cassandra administration, backup/restore, replication, fault tolerance, and cost analysis.
│   └── data_dictionary_trip_records_yellow.pdf   # Field-level data dictionary describing the taxi trip attributes, datatype meanings, and CSV schema reference used for loading
├── notebooks/
│   └── updated_data_preprocessing.ipynb          # Notebook documenting parquet inspection, datatype standardization, csv conversion, and preparation of Cassandra-ready load files
├── sql/
│   ├── updated_datagrip_cassandra_node1.sql      # Node 1 CQL script for schema creation, CRUD validation, query testing, permissions, restore verification, and replication-related checks
│   └── updated_datagrip_cassandra_node2.sql      # Node 2 CQL script for keyspace visibility checks, replicated data validation, and fault-tolerance read testing
└── README.md                                     # GitHub project overview summarizing scope, architecture, workflow, DBA tasks, outcomes, and supporting documentation
```

- The **`docs/`** folder stores the full report and supporting reference material for readers who want the complete technical walkthrough.
- The **`notebooks/`** folder contains the preprocessing notebook used to inspect source files, standardize data types, and prepare Cassandra-ready CSV output.
- The **`sql/`** folder contains the CQL scripts used through DataGrip for **Node 1 validation, restore verification, replication testing, and Node 2 fault-tolerance checks**.
- The **technical project report** is maintained as a private supporting document and can be shared separately on request for a more detailed walkthrough of the implementation, screenshots, and validation steps.
- The public repository intentionally excludes the full raw and processed datasets; the notebook explains how to download the source files locally.

---

## Dataset and Scope

- The project uses the **NYC TLC Yellow Taxi Trip Record Data**, published by the New York City Taxi and Limousine Commission.
- The dataset includes trip-level fields such as **pickup and drop-off timestamps, pickup and drop-off locations, trip distance, fare amounts, rate types, payment types, and passenger counts**.
- The project scope focuses on **Yellow Taxi data**, with **January 2026 records** used as the primary Cassandra loading workload.
- Because the source files are published in **parquet format**, the data was first preprocessed into a **clean cassandra-ready csv format** before loading.

---

## Cloud Environment

- The cluster was hosted on **AWS EC2 virtual machines** to provide direct control over operating system access, storage, networking, and Cassandra administration.
- AWS was selected to support **self-managed deployment**, rather than abstracting operational tasks behind a managed service.
- The environment was used to demonstrate **remote access setup, security group restrictions, backup storage, monitoring, and cost estimation**.
- For clustering, both nodes were kept in the **same AWS account and VPC** to simplify private-network communication and reduce networking risk in the Learner Lab environment.

---

## Tech Stack

- **Apache Cassandra** was used as the primary DBMS because of its wide-column design, replication model, and fit for event-based workloads.
- **AWS EC2** provided the self-managed cloud infrastructure required for installation, cluster setup, and cost analysis.
- **Python with Pandas/PySpark** was used to inspect the source files, convert Parquet to CSV, and prepare the final load-ready data format.
- **cqlsh**, **DataGrip**, and **Shell/Bash scripts** were used for schema creation, query validation, backup automation, and operational administration.

---

## Cloud Deployment

- The primary deployment used an **m5.large EC2 instance**, selected for its stable non-burstable compute profile, sufficient memory and network capacity for a small self-managed Cassandra cluster, and manageable cost for academic benchmarking.
- **Java 11** and **Apache Cassandra 4.1** were installed manually, and a proper Cassandra service configuration was created on Amazon Linux.
- The deployment included **cqlsh dependency setup**, service verification, `nodetool status` checks, and remote CQL connectivity validation.
- Cassandra was configured for remote access by updating **listen, broadcast, RPC, and seed settings**, then validated through **port 9042 checks and DataGrip connectivity**.

---

## Security and Least Privilege

- Authentication and authorization were explicitly enabled using **`PasswordAuthenticator`** and **`CassandraAuthorizer`** in `cassandra.yaml`.
- The project did not rely on a shared unrestricted account, instead, it used **role-based access with user-specific credentials**.
- A dedicated administrative role was created, and the default **`cassandra`** superuser login was later disabled to reduce security risk.
- A separate teammate role was granted **read-only access to the `nyc_tlc` keyspace**, while AWS security group rules restricted access to authorized IP addresses.

---

## Load Data on Apache Cassandra

- The Cassandra table was designed around a **query-first access pattern** using the partition key **`(pulocationid, pickup_date)`** and clustering by **`tpep_pickup_datetime`** and **`trip_id`**.
- The preprocessing workflow added **`trip_id`** and **`pickup_date`** to the CSV so the source dataset matched the Cassandra table design.
- Data was first tested with a **small sample file** before loading the full dataset into Cassandra from the EC2 environment.
- The final full load imported **3,724,889 rows** in about **9 minutes and 10 seconds**, averaging roughly **6,771 rows per second** with **no skipped records**.

---

## Backup, Restore, and Verification

- Native Cassandra snapshots were first tested manually using **`nodetool snapshot`** to confirm that table-level backup worked correctly.
- A custom shell script automated the workflow by creating **timestamped snapshots**, compressing them into **`.tar.gz` archives**, logging execution, cleaning temporary snapshot files, and deleting backups older than seven days.
- Backup execution was scheduled through **cron**, demonstrating recurring operational automation in a self-managed database environment.
- Restore verification was performed by extracting a cron-generated backup archive and using **`sstableloader`** to load the snapshot into a separate **restore keyspace/table**, then validating the restored data with queries and table statistics.

---

## Distributed Cluster with Service Continuity During Node Failure

- A second EC2 instance was launched as **Node 2** in the same VPC, with Cassandra configured to join the same cluster using **private IP-based internode communication**.
- After Node 2 joined successfully, the **`nyc_tlc` keyspace replication factor** was increased from **1 to 2**, and **`system_auth`** replication was also updated because authentication was enabled.
- Since the data had already been loaded before Node 2 joined, **`nodetool repair`** was run to synchronize existing partitions across both nodes.
- Fault tolerance was validated by **stopping Cassandra on Node 1** and successfully serving read queries from **Node 2** using **consistency level `ONE`**, with authentication read consistency adjusted to **`LOCAL_ONE`** for the two-node test setup.

---

## Cost Estimation

- The project estimated the cost of operating the environment as a **production-style two-node self-managed Cassandra deployment** on AWS.
- Compute cost was based on **two `m5.large` EC2 instances**, resulting in an estimated **$138.24/month** or **$1,658.88/year**.
- Storage cost for **two 30 GB gp3 EBS volumes** was estimated at **$4.80/month** or **$57.60/year**, while backup archive storage was approximately **$0.05/month** for the current footprint.
- The total estimated infrastructure cost was approximately **$143.09/month** or **$1,717.08/year**, with **EC2 compute as the dominant cost driver**.

---

## Challenges Encountered

- One of the main challenges was configuring Cassandra for **network-based multi-node communication on AWS EC2**.
- The report documents issues including **port binding problems, Cassandra metadata conflicts, cluster-name mismatch errors, seed-node configuration issues, and authentication behavior during node-failure testing**.
- Troubleshooting required repeated validation through **`system.log`**, **`nodetool status`**, network/port checks, security group updates, and `cassandra.yaml` corrections.
- These issues ultimately strengthened the operational understanding of **private IP configuration, internode communication, and metadata consistency in Cassandra clusters**.

---

## Limitations and Future Work

- The project successfully demonstrated a **two-node Cassandra cluster**, but a production-grade deployment would more typically use **at least three nodes** for stronger availability during failures.
- The work was constrained by the **AWS Learner Lab environment**, where permissions, credits, and networking features such as cross-account VPC peering can be limited.
- Future improvements identified in the report include **expanding to three or more nodes**, **storing backups in Amazon S3**, and **adding stronger infrastructure automation**.
- Additional future work could include **Terraform or CloudFormation provisioning** and **larger-scale benchmarking with controlled read/write stress tests**.

---

## Conclusion

- This project implemented a **self-managed Apache Cassandra database system on AWS EC2** using NYC TLC Yellow Taxi trip data as a realistic operational workload.
- The work covered major DBA functions including **installation, secure role-based access control, preprocessing and loading, query validation, backup automation, restore verification, monitoring, replication, and node-failure testing**.
- It demonstrates how Cassandra can be administered as a **distributed NoSQL database in a cloud environment** while highlighting practical tradeoffs around security, scalability, availability, and operational control.
- The project serves as a portfolio example of **hands-on cloud database administration**, not just schema design or one-time data loading.

---

## Data Sources and References

- **NYC TLC dataset:** [TLC Trip Record Data](https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page)
- **AWS EC2 pricing:** [Amazon EC2 Pricing](https://aws.amazon.com/ec2/pricing/)
- **AWS EBS pricing:** [Amazon EBS Pricing](https://aws.amazon.com/ebs/pricing/)
- **DataGrip:** [JetBrains DataGrip](https://www.jetbrains.com/datagrip/download/)
