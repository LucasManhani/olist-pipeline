import pandas as pd
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]
RAW_DATA_PATH = PROJECT_ROOT / "data" / "raw"

STRING_COLUMNS_BY_TABLE = {
    "olist_customers_dataset": ["customer_zip_code_prefix"],
    "olist_geolocation_dataset": ["geolocation_zip_code_prefix"],
    "olist_sellers_dataset": ["seller_zip_code_prefix"],
}


def extract_all() -> dict[str, pd.DataFrame]:
    if not RAW_DATA_PATH.is_dir():
        raise FileNotFoundError(
            f"Data directory not found: {RAW_DATA_PATH}"
        )

    csv_files = sorted(RAW_DATA_PATH.glob("*.csv"))
    if not csv_files:
        raise FileNotFoundError(
            f"No CSV files found in: {RAW_DATA_PATH}"
        )

    dataframes: dict[str, pd.DataFrame] = {}
    for csv_file in csv_files:
        table_name = csv_file.stem
        string_columns = STRING_COLUMNS_BY_TABLE.get(table_name, [])
        column_types = {column: "string" for column in string_columns}
        dataframes[table_name] = pd.read_csv(csv_file, dtype=column_types)
        df = dataframes[table_name]
        print(f"Loaded {table_name}: {len(df)} rows x {len(df.columns)} columns")
    return dataframes


if __name__ == "__main__":
    extract_all()
