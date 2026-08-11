FROM apache/airflow:3.3.0-python3.13

ARG AIRFLOW_VERSION=3.3.0

COPY requirements.txt /opt/airflow/requirements.txt

RUN pip install --no-cache-dir \
    "apache-airflow==${AIRFLOW_VERSION}" \
    -r /opt/airflow/requirements.txt
