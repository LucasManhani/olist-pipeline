from datetime import timedelta

import pendulum
from airflow.providers.standard.operators.bash import BashOperator
from airflow.sdk import DAG

with DAG(
    dag_id="olist_pipeline",
    description="Executa o carregamento de dados e os modelos de cada camada",
    default_args={
        "retries": 1,
        "retry_delay": timedelta(minutes=1),
    },
    schedule=None,
    start_date=pendulum.datetime(2026, 8, 10, tz="America/Sao_Paulo"),
    catchup=False,
    tags=["Load", "Bronze", "Silver", "Gold"],
) as dag:

    load_raw = BashOperator(
        task_id="load_raw",
        bash_command="python /opt/airflow/project/pipeline/load.py",
        do_xcom_push=False,
    )

    dbt_source_tests = BashOperator(
        task_id="dbt_source_tests",
        bash_command=(
            "dbt test "
            "--select 'source:*' "
            "--profiles-dir ."
        ),
        cwd="/opt/airflow/project/dbt_olist",
        do_xcom_push=False,
    )

    dbt_bronze = BashOperator(
        task_id="dbt_bronze",
        bash_command=(
            "dbt build "
            "--select path:models/bronze "
            "--profiles-dir ."
        ),
        cwd="/opt/airflow/project/dbt_olist",
        do_xcom_push=False,
    )

    dbt_silver = BashOperator(
        task_id="dbt_silver",
        bash_command=(
            "dbt build "
            "--select path:models/silver "
            "--profiles-dir ."
        ),
        cwd="/opt/airflow/project/dbt_olist",
        do_xcom_push=False,
    )

    dbt_gold = BashOperator(
        task_id="dbt_gold",
        bash_command=(
            "dbt build "
            "--select path:models/gold "
            "--profiles-dir ."
        ),
        cwd="/opt/airflow/project/dbt_olist",
        do_xcom_push=False,
    )

    load_raw >> dbt_source_tests >> dbt_bronze >> dbt_silver >> dbt_gold
