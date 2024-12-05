from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

DBT_PROJECT_DIR = "/opt/airflow/eq_dbt"

# Default arguments for the DAG
default_args = {
    'owner': 'user',
    'depends_on_past': False,
    'retries': 1,
}

# Define the DAG
with DAG(
    'earthquake_dbt_dag',
    default_args=default_args,
    description='Run dbt run and test tasks for earthquake data',
    schedule_interval='@daily',
    start_date=datetime(2024, 12, 1),
    catchup=False,
) as dag:

    # Run dbt models (dbt run)
    dbt_run = BashOperator(
        task_id='dbt_run',
        bash_command=f"/home/airflow/.local/bin/dbt run --profiles-dir {DBT_PROJECT_DIR} --project-dir {DBT_PROJECT_DIR}",
    )

    # Run dbt tests (dbt test)
    dbt_test = BashOperator(
        task_id='dbt_test',
        bash_command=f"/home/airflow/.local/bin/dbt test --profiles-dir {DBT_PROJECT_DIR} --project-dir {DBT_PROJECT_DIR}",
    )

    # Task dependencies
    dbt_run >> dbt_test
