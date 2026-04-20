import os
from pathlib import Path
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from extract import extract_all

load_dotenv(Path(".env"))

DB_HOST = os.getenv("DB_HOST")
DB_PORT = os.getenv("DB_PORT")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")

CONNECTION_STRING = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"


def load():
    engine = create_engine(CONNECTION_STRING)

    with engine.connect() as conn:
        conn.execute(text("CREATE SCHEMA IF NOT EXISTS raw"))
        conn.commit()

    dataframes = extract_all()

    for table_name, df in dataframes.items():
        df.to_sql(table_name, engine, schema="raw", if_exists="replace", index=False)
        print(f"Loaded {table_name} into Postgres: {len(df)} rows x {len(df.columns)} columns")


if __name__ == "__main__":
    load()
