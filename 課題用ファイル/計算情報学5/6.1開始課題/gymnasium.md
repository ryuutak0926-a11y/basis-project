# gymnasium
## ページ 1
Gymnasium

---
## ページ 2
1 はじめに
• ロボット制御等で用いられる強化学習について
実習するためにシミュレーション環境としてよ
く用いられるのはGymnasium である．
• 最初，Open AI Gym として開発されていたも
のが，のちにGymnasium として開発継続さ
れた．
• 代表的なシミュレーションとして CarPole，
LunarLander, BipedalWalker, CarRacing など
がある．

---
## ページ 3
2 強化学習
• 状態から受ける情報に応じて，とるべき行動を
決定する．
• 行動が良い結果を与えれば利益(reward)を得
る一方で，悪い結果であれば損失をうける．
• 強化学習では，状態に対する行動によって得ら
れる利得を大きくするように行動を学習する．

---
## ページ 4
3 Cart Pole
• Cart Pole 問題は，倒立振子問題と呼ばれる．
• カートの上に棒を逆に立てておき，棒が倒れな
いようにカートを左右に動かす．
• 行動はカートを左に動かす，または，カートを
右に動かすの２つである．
• 状態はカートの位置，カートの速度，ポールの
角度，ポールの角速度の４つである．

---
## ページ 5
4 ライブラリの準備
Gymnasium の利用整備するためにまず基本ライ
ブラリをインストールする．
1 pip install gymnasium
つづいて，問題毎に追加でライブラリをインス
トールするのであるが，全てインストールする場
合は以下のように入力する．
1 pip install " gymnasium [all ]"
CartPoleだけならば次のように入力する．
1 pip install " gymnasium [ cartpole ]"

---
## ページ 6
5 CartPole のプログラム例
1 import gymnasium as gym
2
3 env = gym.make (" CartPole -v1", render_mode =" rgb_array ")
4 trigger = lambda t: t % 10 == 0
5 env = gym. wrappers . RecordVideo (env , video_folder ="./ gym",
episode_trigger =trigger , disable_logger =True)
6
7 for i in range (50):
8 termination , truncation = False , False
9 _ = env.reset(seed =123)
10 j = 0
11 while not ( termination or truncation ):
12 j = j+1
13 action = env. action_space .sample ()
14 observation , reward , termination , truncation , info = env.step(
action)
15 print(i, j, action , observation , reward , termination ,
truncation )
16 env.close ()

---
## ページ 7
6 プログラム例の説明
• gymnasium を gym としてインポートする．
• 3 行目：CartPole問題の状態 env を定義する．
• 5 行目：env にビデオ出力を追加する，
• 7 行目：50 回シミュレーションを行う．
• 9 行目：env を初期化(reset) する．
• 13 行目：行動action を出力する．
• 14 行目：行動による状態，報酬，成功・失敗な
どの情報を出力する．
• 16 行目：env を閉じる．

---
## ページ 8
7 CartPole プログラムの実行結
果例
実行結果例を以下に示す．
1 0 1 1 [ 0.01734283 0.15089367 -0.02859527 -0.33293587] 1.0 False
False
2 0 2 0 [ 0.0203607 -0.04380985 -0.03525399 -0.04940585] 1.0 False
False
3 0 3 1 [ 0.01948451 0.15179941 -0.03624211 -0.35299996] 1.0 False
False
4 ..........
また，ソースファイルが存在するフォルダ内にサ
ブフォルダgym ができており，そこに実験の動画
ファイルが格納されている．

---
## ページ 9
8 CartPole プログラムの結果
説明
実行結果の数値は左から左から，i, j, action,
observation, reward, termination, truncation を
示す．
• i,j：状態の回数と試行回数を示す．
• action：行動 (左に動かしたか，右に動かした
か) を示す．
• observation：行動による状態の変化（棒の状態

---
## ページ 10
変化）を示す．
• reward：報酬を示す．棒が立っている場
合+1.0 となる．
• termination：終了を示す．棒が倒れる，カート
が範囲外に出るとTrue．
• truncation：最大ステップ数（v1 では 500）に
到達すると True．

---
## ページ 11
9 演習問題１
• Gymnasium の含まれる他の例題のうち，以下
の３件についてシミュレーションを実施しな
さい．
• これらのシミュレーションにおける状態，行動
がどのように定義されているかをまとめて報告
しなさい．
– LunarLander
– BipedalWalker
– CarRacing

---
## ページ 12
10 参考文献
• Gymnasium Documentation,
https://gymnasium.farama.org/index.html.

---
