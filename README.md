# CrypQ
### 1. Extracting data from Big Query

Data should be extracted from this dataset:

bigquery-public-data.crypto_ethereum

In order to interact with Big Query through the command line, install gcloud CLI here:

https://cloud.google.com/sdk/docs/install

https://cloud.google.com/bigquery/docs/reference/libraries#client-libraries-install-python

Downloads can also be made through their web interface.

### 2. Post-processing to clean up the extracted data

Create a database called **fix_data** in Postgres, run the following command in psql

```
\i /File_Path/Database-Benchmark/fix_data.sql
```
Within the fix_data.sql file, ensure that all paths to the downloaded JSON files have been set correctly

After completing this step, ***fix_data*** database can be deleted

Then run fix_json.py

### 4. Import data, ready to be queried 

Create a database called ***CrypQ*** in Postgres, run the following command in psql
```
\i /File_Path/Database-Benchmark/create_db.sql
```
Within the create_db.sql file, ensure that all paths to JSON files are correct

### 5. Update workload


