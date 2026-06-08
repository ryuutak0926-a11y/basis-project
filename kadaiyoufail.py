import numpy as np
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import r2_score
from keras.models import Sequential
from keras.layers import LSTM, Dropout, Input, Dense
from keras.optimizers import Adam
import matplotlib.pyplot as mpl
import yfinance as yf

# トヨタ自動車の株価データ取得
ticker = yf.Ticker('^N225')
df = ticker.history(start='2016-01-01', end='2026-05-01')
# 列名 'Close ' の不要なスペースを修正
df = df['Close'].values.reshape(-1, 1)

# 正規化
scaler = MinMaxScaler(feature_range=(0, 1))
scaled_df = scaler.fit_transform(df)
window_size = 60

# 訓練データを説明変数と目的変数に分ける
X_train, y_train = [], []
for i in range(window_size, len(scaled_df)):
    X_train.append(scaled_df[i-window_size:i])
    y_train.append(scaled_df[i])
X_train = np.array(X_train)
y_train = np.array(y_train)

# モデルの定義
model = Sequential()
model.add(Input(shape=(X_train.shape[1], X_train.shape[2])))
model.add(LSTM(units=30, return_sequences=True))
model.add(Dropout(0.2))
model.add(LSTM(units=30, return_sequences=True))
model.add(Dropout(0.2))
model.add(LSTM(units=30))
model.add(Dropout(0.2))
model.add(Dense(units=1))

# ハイパーパラメータ
learning_rate = 0.001       # 学習率
loss = "mean_squared_error" # 損失関数
batch_size = 32             # バッチサイズ
epochs = 10                 # 学習回数

# モデルのコンパイル
optimizer = Adam(learning_rate=learning_rate, clipvalue=1.0)
model.compile(optimizer=optimizer, loss=loss)

# モデルの学習
model.fit(X_train, y_train, batch_size=batch_size, epochs=epochs, verbose=1)

# 予測
y_pred = model.predict(X_train)
y_pred = scaler.inverse_transform(y_pred)

# 二乗平均平方根誤差 (RMSE)
rmse = np.sqrt(np.mean(((y_pred - scaler.inverse_transform(y_train)) ** 2)))
print(f"RMSE: {rmse}")

# 決定係数 (R2)
r2s = r2_score(y_true=scaler.inverse_transform(y_train), y_pred=y_pred)
print(f"R2 Score: {r2s}")

# グラフ描画
mpl.figure(figsize=(16, 6))
mpl.plot(scaler.inverse_transform(y_train), label='Actual Price')
mpl.plot(y_pred, label='Predicted Price')
mpl.xlabel('Date', fontsize=14)
mpl.ylabel('Close Price', fontsize=14)
mpl.legend()
mpl.show()
