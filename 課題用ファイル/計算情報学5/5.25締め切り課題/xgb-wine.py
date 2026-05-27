import pandas as pd
from xgboost import XGBClassifier as XGBC

url = "http://pythondatascience.plavox.info/wp-content/uploads/2016/07/winequality-red.csv"
df = pd.read_csv(url , sep=';')
df.to_csv('winequality-red.csv')

x = df[['fixed acidity', 'volatile acidity', 'citric acid', 'residual sugar', 'chlorides', 'free sulfur dioxide', 'total sulfur dioxide']]
# XGBoost用にクラスラベルを 0〜5 に調整（最小値である 3 を引く）
y = df['quality'] - df['quality'].min()

model = XGBC(random_state =0)
model.fit(x, y)
scr = model.score(x, y)

yres = model.predict(x)

print(" Prediction accuracy =", scr)
print(yres)

from sklearn.metrics import mean_absolute_error
print(mean_absolute_error(y,yres))
