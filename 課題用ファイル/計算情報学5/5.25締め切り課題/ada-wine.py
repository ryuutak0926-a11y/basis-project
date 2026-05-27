import pandas as pd
from sklearn.ensemble import AdaBoostClassifier as ABC

url = "http://pythondatascience.plavox.info/wp-content/uploads/2016/07/winequality-red.csv"
df = pd.read_csv(url , sep=';')
df.to_csv('winequality-red.csv')

x = df[['fixed acidity', 'volatile acidity', 'citric acid', 'residual sugar', 'chlorides', 'free sulfur dioxide', 'total sulfur dioxide']]
y = df['quality']

model = ABC(random_state =0)
model.fit(x, y)
scr = model.score(x, y)

yres = model.predict(x)

print(" Prediction accuracy =", scr)
print(yres)

from sklearn.metrics import mean_absolute_error
print(mean_absolute_error(y,yres))
