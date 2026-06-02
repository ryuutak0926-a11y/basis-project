import gymnasium as gym

# LunarLander（月着陸船）環境の作成
env = gym.make("LunarLander-v3", render_mode="rgb_array")
trigger = lambda t: t % 10 == 0

# 録画用のラッパーを適用
env = gym.wrappers.RecordVideo(
    env,
    video_folder="./gym_lunar",
    episode_trigger=trigger,
    disable_logger=True
)

# 50回シミュレーションを実行
for i in range(50):
    termination, truncation = False, False
    _ = env.reset(seed=123)
    j = 0
    while not (termination or truncation):
        j = j + 1
        action = env.action_space.sample()  # ランダムに行動を選択
        observation, reward, termination, truncation, info = env.step(action)
        print(i, j, action, observation, reward, termination, truncation)

# 環境を閉じる
env.close()
