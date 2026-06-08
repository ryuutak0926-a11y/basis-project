import numpy as np

from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import r2_score
from keras.models import Sequential
from keras.layers import LSTM , Dropout , Input , Dense
from keras.optimizers import Adam
import matplotlib.pyplot as mpl
import yfinance as yf
# ト ヨ タ 自 動 車 の 株 価 デ ー タ
ticker = yf.Ticker ( '7203.T')
df = ticker.history(start='2016-01-01', end='2026-05-01')
df = df['Close ']. values.reshape (-1,1)
# 正 規 化
scaler = MinMaxScaler(feature_range =(0, 1))
scaled_df = scaler.fit_transform(df)
window_size = 60
# 訓 練 デ ー タ を 説 明 変 数 と 目 的 変 数 に 分 け る
X_train , y_train = [], []
for i in range(window_size , len(scaled_df )):
    X_train.append(scaled_df[i-window_size:i])
    y_train.append(scaled_df[i])
X_train = np.array(X_train)
y_train = np.array(y_train)
# モ デ ル の 定 義
model = Sequential ()
model.add(Input(shape=( X_train.shape[1], X_train.shape [2])))
model.add(LSTM(units=30, return_sequences=True))
model.add(Dropout (0.2))
model.add(LSTM(units=30, return_sequences=True))
model.add(Dropout (0.2))
model.add(LSTM(units =30))
model.add(Dropout (0.2))
model.add(Dense(units =1))
# ハ イ パ ー パ ラ メ ー タ
learning_rate = 0.001 # 学 習 率 を 小 さ く 設 定
loss = "mean_squared_error" # 損 失 関 数
batch_size = 32 # バ ッ チ サ イ ズ
epochs = 10 # 学 習 回 数

 # モ デ ル の コ ン パ イ ル
optimizer = Adam(learning_rate=learning_rate , clipvalue =1.0)
model.compile(optimizer=optimizer , loss=loss) # optimizer を モ デ ル
model.fit(X_train , y_train , batch_size=batch_size , epochs=epochs ,
verbose =1)
#model.save("model.keras")
# 予 測
y_pred = model.predict(X_train)
y_pred = scaler.inverse_transform(y_pred)
# 二 乗 平 均 平 方 根 誤 差 （R M S E）
rmse = np.sqrt(np.mean ((( y_pred - scaler.inverse_transform(y_train
)) ** 2)))
print(f"RMSE: {rmse }")

# 決 定 係 数 (r2)
r2s = r2_score(y_true=scaler.inverse_transform(y_train), y_pred=y_pred)
print(f"R2 Score: {r2s}")
# グ ラ フ プ ロ ッ ト
mpl.figure(figsize =(16 ,6))
mpl.plot(scaler.inverse_transform(y_train))
mpl.plot(y_pred)
mpl.xlabel('Date ', fontsize =14)
mpl.ylabel('Close Price ', fontsize =14)
mpl.show()