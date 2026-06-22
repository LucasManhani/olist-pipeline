import os
from pathlib import Path
from dotenv import load_dotenv
from sqlalchemy import URL, create_engine, text
from extract import extract_all

PROJECT_ROOT = Path(__file__).resolve().parents[1]

load_dotenv(PROJECT_ROOT / ".env")

REQUIRED_DB_VARIABLES = (
    "DB_HOST",
    "DB_PORT",
    "DB_NAME",
    "DB_USER",
    "DB_PASSWORD",
)


def create_database_url() -> URL:
    config = {
        variable: os.getenv(variable)
        for variable in REQUIRED_DB_VARIABLES
    }
    missing_variables = [
        variable
        for variable, value in config.items()
        if not value
    ]

    if missing_variables:
        missing = ", ".join(missing_variables)
        raise ValueError(f"Missing required environment variables: {missing}")

    try:
        port = int(config["DB_PORT"])
    except ValueError as error:
        raise ValueError("DB_PORT must be an integer") from error

    return URL.create(
        drivername="postgresql+psycopg2",
        username=config["DB_USER"],
        password=config["DB_PASSWORD"],
        host=config["DB_HOST"],
        port=port,
        database=config["DB_NAME"],
    )


def load():
    dataframes = extract_all()
    engine = create_engine(create_database_url())

    try:
        with engine.begin() as connection:
            connection.execute(text("CREATE SCHEMA IF NOT EXISTS raw"))

            for table_name, df in dataframes.items():
                df.to_sql(
                    table_name,
                    connection,
                    schema="raw",
                    if_exists="replace",
                    index=False,
                )
                print(
                    f"Loaded {table_name} into Postgres: "
                    f"{len(df)} rows x {len(df.columns)} columns"
                )
    finally:
        engine.dispose()


if __name__ == "__main__":
    load()
