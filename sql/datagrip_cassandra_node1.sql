/*
=================================================================================================
Project Name: Self-Managed and Fault-Tolerant Apache Cassandra Cluster on AWS using NYC TLC Trip Data

File Name:
datagrip_cassandra_node1.sql

Purpose of This File:
This file contains the primary Cassandra Query Language (CQL) statements used to validate,
manage, and demonstrate the Node 1 dataset environment for this project. The script
is intended to be executed from DataGrip after connecting to the Apache Cassandra cluster hosted
on AWS EC2. It supports schema verification, sample data validation, CRUD testing, permission
review, restore-table verification, and replication updates used during the project demo.

Project Context:
The overall project builds a fault-tolerant Apache Cassandra environment on AWS using NYC TLC
Yellow Taxi trip data. This script focuses on the operational and query-testing side of the
project for the trips_by_pickup table, which is modeled around Cassandra's query-first design.
The table partitions data by pickup location and pickup date, then orders rows within each
partition by pickup timestamp and trip identifier.

Primary Inputs:
1. Existing keyspace: nyc_tlc
2. Existing table or permission to create table: nyc_tlc.trips_by_pickup
3. Cluster connection from DataGrip to Node 1 / cluster coordinator
4. Previously loaded NYC TLC Yellow Taxi trip data (January 2026 records)
5. Valid Cassandra roles for access control testing

Expected Outputs:
1. trips_by_pickup table created if it does not already exist
2. Sample query results confirming loaded data is accessible
3. Row counts and filtered query results for validation
4. Successful insert, update, select, and delete test cycle on one controlled test record
5. Permission inspection output for project users
6. Restore keyspace/table created for backup verification
7. Replication settings updated for the two-node cluster phase

Notes for Submission:
- This is a CQL script intended for Apache Cassandra, even though it is stored in a .sql file
  for execution from DataGrip.
- The statements in this file are written in Cassandra Query Language (CQL) and are executed
  through DataGrip, which acts as the client connection to the Apache Cassandra cluster running
  on AWS EC2.
- The test-record section uses a fixed UUID so that the insert, update, verification, and
  delete operations all reference the same row consistently.
- This script is designed for project demonstration and operational verification, not for bulk
  data loading.
- For a repository, replace the example role names shown in the permissions section with
  the role names used in your own Cassandra environment before running those statements.
======================================================================================================
*/

USE nyc_tlc;

-- ============================================================================
-- 1. Main Node 1 Table Definition
-- ============================================================================

CREATE TABLE IF NOT EXISTS nyc_tlc.trips_by_pickup (
    pulocationid int,
    pickup_date date,
    tpep_pickup_datetime timestamp,
    trip_id uuid,
    vendorid int,
    tpep_dropoff_datetime timestamp,
    passenger_count double,
    trip_distance double,
    ratecodeid double,
    store_and_fwd_flag text,
    dolocationid int,
    payment_type int,
    fare_amount double,
    extra double,
    mta_tax double,
    tip_amount double,
    tolls_amount double,
    improvement_surcharge double,
    total_amount double,
    congestion_surcharge double,
    airport_fee double,
    cbd_congestion_fee double,
    PRIMARY KEY ((pulocationid, pickup_date), tpep_pickup_datetime, trip_id)
) WITH CLUSTERING ORDER BY (tpep_pickup_datetime DESC);

-- ============================================================================
-- 2. Initial Data Verification
-- ============================================================================

-- Display a small sample of loaded rows.
SELECT *
FROM nyc_tlc.trips_by_pickup
LIMIT 10;

-- Count total rows currently available in the table.
SELECT COUNT(*)
FROM nyc_tlc.trips_by_pickup;

-- Optional reset statement for controlled reload demonstrations. Use with caution.
TRUNCATE nyc_tlc.trips_by_pickup;

-- Confirm row count after truncate when used.
SELECT COUNT(*)
FROM nyc_tlc.trips_by_pickup;

-- ============================================================================
-- 3. Query Testing for Partition-Based Access Pattern
-- ============================================================================

-- Retrieve sample trips for one pickup zone on one date.
SELECT *
FROM nyc_tlc.trips_by_pickup
WHERE pulocationid = 237
  AND pickup_date = '2026-01-01'
LIMIT 20;

-- Count trips in a single partition.
SELECT COUNT(*)
FROM nyc_tlc.trips_by_pickup
WHERE pulocationid = 237
  AND pickup_date = '2026-01-01';

-- Retrieve trips in a time range within one partition.
SELECT pulocationid, pickup_date, tpep_pickup_datetime, trip_distance, fare_amount, total_amount
FROM nyc_tlc.trips_by_pickup
WHERE pulocationid = 237
  AND pickup_date = '2026-01-01'
  AND tpep_pickup_datetime >= '2026-01-01 08:00:00'
  AND tpep_pickup_datetime <= '2026-01-01 10:00:00';

-- Aggregate values within a single partition.
SELECT AVG(total_amount) AS avg_amount,
       MIN(total_amount) AS minimum_amount,
       MAX(total_amount) AS maximum_amount,
       SUM(total_amount) AS total_amount
FROM nyc_tlc.trips_by_pickup
WHERE pulocationid = 237
  AND pickup_date = '2026-01-01';

-- ============================================================================
-- 4. CRUD Demonstration Using a Controlled Test Record
-- ============================================================================

-- Insert one test trip row with a fixed UUID for repeatable verification.
INSERT INTO nyc_tlc.trips_by_pickup (
    pulocationid,
    pickup_date,
    tpep_pickup_datetime,
    trip_id,
    vendorid,
    tpep_dropoff_datetime,
    passenger_count,
    trip_distance,
    ratecodeid,
    store_and_fwd_flag,
    dolocationid,
    payment_type,
    fare_amount,
    extra,
    mta_tax,
    tip_amount,
    tolls_amount,
    improvement_surcharge,
    total_amount,
    congestion_surcharge,
    airport_fee,
    cbd_congestion_fee
)
VALUES (
    237,
    '2026-01-01',
    '2026-01-01 12:30:00',
    be27769d-2b52-4c7e-b9c4-99358e9120c8,
    1,
    '2026-01-01 12:50:00',
    1.0,
    3.25,
    1.0,
    'N',
    161,
    1,
    18.50,
    2.50,
    0.50,
    4.00,
    0.00,
    1.00,
    26.50,
    2.50,
    0.00,
    0.00
);

-- Verify the inserted test row.
SELECT *
FROM nyc_tlc.trips_by_pickup
WHERE pulocationid = 237
  AND pickup_date = '2026-01-01'
  AND tpep_pickup_datetime = '2026-01-01 12:30:00'
  AND trip_id = be27769d-2b52-4c7e-b9c4-99358e9120c8;

-- Update the same controlled test row.
UPDATE nyc_tlc.trips_by_pickup
SET tip_amount = 5.00,
    total_amount = 27.50
WHERE pulocationid = 237
  AND pickup_date = '2026-01-01'
  AND tpep_pickup_datetime = '2026-01-01 12:30:00'
  AND trip_id = be27769d-2b52-4c7e-b9c4-99358e9120c8;

-- Confirm the update.
SELECT pulocationid, pickup_date, tpep_pickup_datetime, trip_id, tip_amount, total_amount
FROM nyc_tlc.trips_by_pickup
WHERE pulocationid = 237
  AND pickup_date = '2026-01-01'
  AND tpep_pickup_datetime = '2026-01-01 12:30:00'
  AND trip_id = be27769d-2b52-4c7e-b9c4-99358e9120c8;

-- Delete the controlled test row.
DELETE FROM nyc_tlc.trips_by_pickup
WHERE pulocationid = 237
  AND pickup_date = '2026-01-01'
  AND tpep_pickup_datetime = '2026-01-01 12:30:00'
  AND trip_id = be27769d-2b52-4c7e-b9c4-99358e9120c8;

-- Confirm the deletion.
SELECT *
FROM nyc_tlc.trips_by_pickup
WHERE pulocationid = 237
  AND pickup_date = '2026-01-01'
  AND tpep_pickup_datetime = '2026-01-01 12:30:00'
  AND trip_id = be27769d-2b52-4c7e-b9c4-99358e9120c8;

-- ============================================================================
-- 5. User Permission Verification
-- ============================================================================

LIST ALL PERMISSIONS OF primary_admin_role;
LIST ALL PERMISSIONS OF teammate_readonly_role;

-- Grant teammate access for collaboration and testing.
GRANT MODIFY ON KEYSPACE nyc_tlc TO teammate_readonly_role;
GRANT ALL PERMISSIONS ON KEYSPACE nyc_tlc TO teammate_readonly_role;

-- ============================================================================
-- 6. Backup / Restore Verification Support
-- ============================================================================

CREATE KEYSPACE IF NOT EXISTS nyc_tlc_restore
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

CREATE TABLE IF NOT EXISTS nyc_tlc_restore.trips_by_pickup (
    pulocationid int,
    pickup_date date,
    tpep_pickup_datetime timestamp,
    trip_id uuid,
    vendorid int,
    tpep_dropoff_datetime timestamp,
    passenger_count double,
    trip_distance double,
    ratecodeid double,
    store_and_fwd_flag text,
    dolocationid int,
    payment_type int,
    fare_amount double,
    extra double,
    mta_tax double,
    tip_amount double,
    tolls_amount double,
    improvement_surcharge double,
    total_amount double,
    congestion_surcharge double,
    airport_fee double,
    cbd_congestion_fee double,
    PRIMARY KEY ((pulocationid, pickup_date), tpep_pickup_datetime, trip_id)
) WITH CLUSTERING ORDER BY (tpep_pickup_datetime DESC);

-- Confirm restored rows are queryable.
SELECT *
FROM nyc_tlc_restore.trips_by_pickup
LIMIT 10;

-- ============================================================================
-- 7. Node and Replication Verification
-- ============================================================================

-- Show the Cassandra version on the current node connection.
SELECT release_version
FROM system.local;

-- Update application keyspace replication for the two-node configuration.
ALTER KEYSPACE nyc_tlc
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 2};

-- Administrative cluster step: update system_auth replication for multi-node authentication consistency.
ALTER KEYSPACE system_auth
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 2};
