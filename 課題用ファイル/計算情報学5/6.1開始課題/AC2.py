import gymnasium as gym
import matplotlib.pyplot as plt
from stable_baselines3 import A2C


def run_a2c_experiment(env_name, policy_type="MlpPolicy", total_timesteps=5000, test_steps=300):
    print(f"\n=== Running {env_name} with A2C ===")

    # 1. 環境の生成
    env = gym.make(env_name, render_mode="rgb_array")

    # 2. A2Cモデルの定義と学習
    # (CarRacingなどの画像入力環境には CnnPolicy を使用します)
    model = A2C(policy_type, env, verbose=1)
    model.learn(total_timesteps=total_timesteps)

    # 3. テスト実行と報酬の記録
    vec_env = model.get_env()
    observation = vec_env.reset()

    rewards_history = []          # 各ステップでの即時報酬（増加分）
    cumulative_rewards_history = []  # エピソード内の累積報酬
    cumulative_reward = 0

    for i in range(test_steps):
        action, _state = model.predict(observation, deterministic=True)
        observation, reward, done, info = vec_env.step(action)

        # Vector Environmentのため、配列の先頭要素を取得
        step_reward = reward[0]
        rewards_history.append(step_reward)

        cumulative_reward += step_reward
        cumulative_rewards_history.append(cumulative_reward)

        # エピソードが終了（ゲームオーバーやゴール）したら累積報酬をリセット
        if done[0]:
            cumulative_reward = 0

    env.close()

    # 4. 各ステップでの報酬推移をグラフに描画
    plt.figure(figsize=(10, 4))
    # 各ステップでの報酬の増加分を棒グラフで表示
    plt.bar(range(test_steps), rewards_history, label="Step Reward (Increase)", alpha=0.4, color="orange")
    # 累積報酬の推移を折れ線グラフで表示
    plt.plot(range(test_steps), cumulative_rewards_history, label="Cumulative Reward", color="teal", linewidth=1.5)
    
    plt.xlabel("Step (i)")
    plt.ylabel("Reward")
    plt.title(f"A2C Execution on {env_name}")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.show()

# ==========================================
# 各環境での実行
# ==========================================

# 1. CartPole (状態ベクトル入力)
run_a2c_experiment("CartPole-v1", policy_type="MlpPolicy", total_timesteps=5000, test_steps=150)

# 2. LunarLander (状態ベクトル入力)
run_a2c_experiment("LunarLander-v2", policy_type="MlpPolicy", total_timesteps=10000, test_steps=300)

# 3. BipedalWalker (状態ベクトル入力 / 連続値アクション)
run_a2c_experiment("BipedalWalker-v3", policy_type="MlpPolicy", total_timesteps=10000, test_steps=300)

# 4. CarRacing (画面画像入力のため 'CnnPolicy' を指定)
run_a2c_experiment("CarRacing-v2", policy_type="CnnPolicy", total_timesteps=5000, test_steps=200)