# StableBaselines3-2
## ページ 1
強化学習

---
## ページ 2
1 はじめに
• ロボット制御等で用いられる強化学習について
実習する．
• シミュレーション環境として Gymnasium を利
用し，強化学習環境としてStable Baselines 3
を用いることする．
• 強化学習環境として，このほかにもClean RL ，
PettingZoo などがある．

---
## ページ 3
2 強化学習 (1)
• 状態から受ける情報に応じて，とるべき行動を
決定する．
• 行動が良い結果を与えれば利益(reward)を得
る一方で，悪い結果であれば損失をうける．
• 強化学習では，状態に対する行動によって得ら
れる利得を大きくするように行動を学習する．

---
## ページ 4
3 強化学習 (2)
• 状態と行動の全ての組み合わせからなる表を作
成し，対応する状態と行動の組み合わせに対し
てQ 値を保存する．
• 試行錯誤によってQ 値を更新する．

---
## ページ 5
4 Cart Pole
• Cart Pole 問題は，倒立振子問題と呼ばれる．
• カートの上に棒を逆に立てておき，棒が倒れな
いようにカートを左右に動かす．
• 行動はカートを左に動かす，または，カートを
右に動かすの２つである．
• 状態はカートの位置，カートの速度，ポールの
角度，ポールの角速度の４つである．

---
## ページ 6
5 ライブラリの準備
強化学習の環境として Stable Baselines 3 を利用
するためにライブラリをインストールする．
1 pip install 'stable - baselines3 [extra]'

---
## ページ 7
6 Stable Baselines 3 のプログラ
ム例
1 import gymnasium as gym
2 from stable_baselines3 import PPO
3
4 env = gym.make (" CartPole -v1", render_mode =" rgb_array ")
5
6 model = PPO('MlpPolicy ', env , verbose =1)
7 model.learn( total_timesteps =500)
8 vec_env = model. get_env ()
9 observation = vec_env .reset ()
10 for i in range (1000):
11 action , _state = model. predict(observation , deterministic =True)
12 observation , reward , done , info = vec_env .step(action)
13 vec_env .render (" human ")
14 env.close ()

---
## ページ 8
7 プログラム例の説明
• 2 行目：モデルとしてPPO を採用する．
• 4 行目：モデルを定義し，学習する．
• 6 行目～：学習モデルでシミュレーションを
行う．
• 12 行目の出力がGymnasium と異なっていて
Gym と同じになっていることに注意する．

---
## ページ 9
8 CartPole プログラムの実行結
果例
実行結果例を以下に示す．
1 ---------------------------------
2 | rollout / | |
3 | ep_len_mean | 22 |
4 | ep_rew_mean | 22 |
5 | time/ | |
6 | fps | 1179 |
7 | iterations | 1 |
8 | time_elapsed | 1 |
9 | total_timesteps | 2048 |
10 ---------------------------------

---
## ページ 10
9 演習問題１
• Gymnasium の含まれる以下の３件について強
化学習を実行しなさい．
• 学習モデルをPPO から A2C やDQN に変更し
なさい．これらのモデルについて調査してまと
めなさい．
– LunarLander
– BipedalWalker
– CarRacing
– CartPile問題において，各学習ステップでの

---
## ページ 11
rewardの増加を求め，横軸 i をとって，
rewardの増加をグラフに描きなさい．
–（努力問題）他の問題においても同様のグラ
フを描きなさい．

---
## ページ 12
10 参考文献
• Gymnasium Documentation,
https://gymnasium.farama.org/index.html.
• Stable Baselines 3 Documentation,
https://stable-baselines3.readthedocs.io/en/-
master/index.html

---
