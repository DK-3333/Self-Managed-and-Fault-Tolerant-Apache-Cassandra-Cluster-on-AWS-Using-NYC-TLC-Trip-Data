/*
=====================================================================================================
Project Name: Self-Managed and Fault-Tolerant Apache Cassandra Cluster on AWS using NYC TLC Trip Data

File Name: datagrip_cassandra_node2.sql

Purpose of This File:
This file contains the Cassandra Query Language (CQL) statements used to validate Node 2
connectivity and replication behavior in the Apache Cassandra cluster for this project. 
The script is intended to be executed after connecting to the Node 2 environment
from DataGrip or another Cassandra client. Its main purpose is to confirm that Node 2 can
see the project keyspaces, read replicated application data, report the local Cassandra
version, and support the fault-tolerance demonstration through a lower consistency read.

Project Context:
The overall project deploys a distributed and fault-tolerant Apache Cassandra cluster on AWS
EC2 using NYC TLC Yellow Taxi trip data as the operational dataset. Node 2 is used as part
of the multi-node cluster verification process. This script helps demonstrate that data is
available beyond Node 1 and that the cluster continues to serve reads under the selected
consistency settings during fault-tolerance testing.

Primary Inputs:
1. Active connection to Node 2 of the Cassandra cluster
2. Existing keyspace: nyc_tlc
3. Previously loaded and replicated trips_by_pickup table data
4. Sufficient permissions to query system and application metadata

Expected Outputs:
1. List of accessible keyspaces from the Node 2 connection
2. Cassandra release version for the local connected node
3. Sample replicated rows returned from nyc_tlc.trips_by_pickup
4. Partition-based query results from Node 2
5. Successful read verification under CONSISTENCY ONE during fault-tolerance testing

Notes for Submission:
- This is a CQL validation script for the Node 2 environment and is intended for operational
  verification rather than schema creation or bulk loading.
- The statements in this file are written in Cassandra Query Language (CQL) and are executed
  through DataGrip, which acts as the client connection to the Apache Cassandra cluster running
  on AWS EC2.
- The final read is executed after setting consistency to ONE to support the project's
  service-continuity and replication demonstration.
- This script assumes that replication has already been configured correctly and that Node 2 has
  joined the cluster successfully before the fault-tolerance read test is executed.
=====================================================================================================
*/

-- ============================================================================
-- 1. Cluster and Keyspace Visibility Checks
-- ============================================================================

-- Verify that Node 2 can list available keyspaces.
DESCRIBE KEYSPACES;

-- Verify the Cassandra version on the currently connected node.
SELECT release_version
FROM system.local;

-- ============================================================================
-- 2. Replicated Data Verification on Node 2
-- ============================================================================

-- Retrieve a small sample of replicated rows from the application table.
SELECT *
FROM nyc_tlc.trips_by_pickup
LIMIT 10;

-- Verify that Node 2 can query a known partition from the project dataset.
-- Replace the sample partition values below if your local test data uses different values.
SELECT *
FROM nyc_tlc.trips_by_pickup
WHERE pulocationid = 237
  AND pickup_date = '2026-01-01'
LIMIT 10;

-- ============================================================================
-- 3. Fault-Tolerance Read Test
-- ============================================================================

-- Lower read consistency for the fault-tolerance demonstration.
CONSISTENCY ONE;

-- Re-run the same partition-based read to confirm data remains accessible.
SELECT *
FROM nyc_tlc.trips_by_pickup
WHERE pulocationid = 237
  AND pickup_date = '2026-01-01'
LIMIT 10;
