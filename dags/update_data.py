from airflow import DAG
from airflow.decorators import task
from airflow.providers.snowflake.hooks.snowflake import SnowflakeHook
from datetime import datetime, timedelta
import requests
import csv
from io import StringIO

def return_snowflake_conn():
    hook = SnowflakeHook(snowflake_conn_id='snowflake_conn')
    conn = hook.get_conn()
    return conn.cursor()

@task
def fetch_earthquake_data(start_date, end_date):
    url = f'https://earthquake.usgs.gov/fdsnws/event/1/query?format=csv&starttime={start_date}&endtime={end_date}'
    try:
        response = requests.get(url)
        response.raise_for_status() 
        data = response.text
        return data
    except Exception as e:
        print(f"Error fetching earthquake data: {e}")
        raise

@task
def transform_earthquake_data(csv_data):
    try:
        # Parse the csv data
        csv_reader = csv.DictReader(StringIO(csv_data))
        transformed_data = []

        for row in csv_reader:
            # Convert empty strings to None for numeric columns
            for key in ['latitude', 'longitude', 'depth', 'mag', 'nst', 'gap', 'dmin', 'rms', 
                        'horizontalError', 'depthError', 'magError', 'magNst']:
                row[key] = float(row[key]) if row[key] not in (None, '', 'NULL') else None

            # Ensure timestamps are valid
            for key in ['time', 'updated']:
                row[key] = row[key] if row[key] not in (None, '', 'NULL') else None

            # Strings remain as-is; handle empty strings as needed
            for key in ['magType', 'net', 'id', 'place', 'type', 'status', 'locationSource', 'magSource']:
                row[key] = row[key] if row[key] not in (None, '', 'NULL') else None

            transformed_data.append(row)

        return transformed_data
    except Exception as e:
        print(f"Error transforming data: {e}")
        raise

@task
def load_to_snowflake(data):
    cursor = return_snowflake_conn()
    target_table = "dev.raw_data.earthquake_data"
    try:
        cursor.execute("BEGIN;")

        # insert the real time data to the table
        for record in data:
            cursor.execute(f"""
            INSERT INTO {target_table} (
                time, latitude, longitude, depth, mag, magType, nst, gap, dmin, rms, 
                net, id, updated, place, type, horizontalError, depthError, magError, 
                magNst, status, locationSource, magSource
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 
                    %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                record['time'], record['latitude'], record['longitude'], record['depth'], 
                record['mag'], record['magType'], record.get('nst'), record.get('gap'), 
                record.get('dmin'), record.get('rms'), record['net'], record['id'], 
                record['updated'], record['place'], record['type'], record.get('horizontalError'), 
                record.get('depthError'), record.get('magError'), record.get('magNst'), 
                record['status'], record['locationSource'], record['magSource']
            ))        
        
        cursor.execute("COMMIT;")
    except Exception as e:
        cursor.execute("ROLLBACK;")
        print(f"Error loading data to Snowflake: {e}")
        raise

with DAG(
    dag_id='update_earthquake_data',
    default_args={
        'retries': 3,
        'retry_delay': timedelta(minutes=5)
    },
    description='ETL DAG for earthquake data',
    schedule_interval='@daily',
    start_date=datetime(2024, 1, 1),
    catchup=False
) as dag:

    start_date = "{{ (execution_date - macros.timedelta(days=1)).strftime('%Y-%m-%d') }}"
    end_date = "{{ execution_date.strftime('%Y-%m-%d') }}"

    # start_date = '2024-11-30'
    # end_date = '2024-12-01'

    cursor = return_snowflake_conn()

    csv_data = fetch_earthquake_data(start_date, end_date)
    transformed_data = transform_earthquake_data(csv_data)
    load_to_snowflake(transformed_data)
