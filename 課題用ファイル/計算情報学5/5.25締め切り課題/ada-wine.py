import pandas as pd
# AdaBoostClassifier に変更
from sklearn.ensemble import AdaBoostClassifier as ABC
import matplotlib.pyplot as mpl

url = "http://pythondatascience.plavox.info/wp-content/uploads/2016/07/winequality-red.csv"
df = pd.read_csv(url , sep=';')
df.to_csv('winequality-red.csv')

# 7つの説明変数
x = df[['fixed acidity', 'volatile acidity', 'citric acid', 'residual sugar', 'chlorides', 'free sulfur dioxide', 'total sulfur dioxide']]
# 目的変数を品質(quality)に変更
y = df['quality']

model = ABC(random_state=0)
model.fit(x, y)
scr = model.score(x, y)

yres = model.predict(x)

print(" Prediction accuracy =", scr)
print(yres)

# 分類問題用の評価レポートと混同行列に変更
from sklearn.metrics import classification_report
print(classification_report(y,yres))

from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y,yres)
print(cm)

import seaborn as sns
sns.heatmap(cm, annot=True , cmap='Blues')
mpl.show()
