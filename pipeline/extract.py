import pandas as pd
from pathlib import Path

RAW_DATA_PATH = Path("data/raw")


def extract_all() -> dict[str, pd.DataFrame]:
    dataframes = {}
    for csv_file in RAW_DATA_PATH.glob("*.csv"):
        table_name = csv_file.stem
        dataframes[table_name] = pd.read_csv(csv_file)
        df = dataframes[table_name]
        print(f"Loaded {table_name}: {len(df)} rows x {len(df.columns)} columns")
    return dataframes


if __name__ == "__main__":
    extract_all()
