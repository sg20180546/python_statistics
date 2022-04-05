import pandas as pd

df = pd.read_csv('https://github.com/QuantEcon/QuantEcon.lectures.code/raw/master/pandas/data/test_pwt.csv', index_col=0)
df = df[[],['country', 'POP', 'tcgdp'] ]

print(df)