# ==============================================================================
# 自己組織的金融市場シミュレーター（草案）
# 計算情報学4 最終課題用ひな形
# ==============================================================================

# --- パラメータ設定 ---
# 1. 空間モデル（セルオートマトン）のパラメータ
GRID_SIZE <- 20 # 格子サイズ（20x20のグリッド）
STEPS <- 200 # シミュレーションを実行する総ステップ数

# 2. ARMS（確率的反応系）のパラメータ
INIT_M <- 1000 # 初期マネー（市場の流動性資金）
INIT_S <- 500 # 初期株価（株式の総価値）
INIT_B <- 500 # 初期債券（安全資産・銀行預金）
k0 <- 0.05 # 取引定数の基本速度
alpha <- 0.8 # 市場心理が株取引に与える影響の感度
beta <- 0.05 # 金利が安全資産への資金移動に与える影響の感度
theta <- 0.6 # 同調感度（他人の意見に同調する確率）
dt <- 0.1 # 微小時間変化量（シミュレーションの刻み幅）

# 3. 中央銀行のパラメータ
INIT_R <- 0.0 # 初期政策金利（基準値を0.0とする）
S_TARGET <- 500 # 目標株価水準（この値を基準に利上げ・利下げを判断）
gamma1 <- 0.0002 # 株価の目標乖離に対する金利の調整感度（株価連動）
gamma2 <- 0.02 # 市場心理の偏りに対する金利の調整感度

# --- 状態の定義 ---
# 楽観: 1, 中立: 0, 悲観: -1
STATE_OPTIMISTIC <- 1
STATE_NEUTRAL <- 0
STATE_PESSIMISTIC <- -1

# ==============================================================================
# 補助関数群
# ==============================================================================

# 1. 周期境界条件（パディング）を適用する関数（演習5のライフゲームコードを応用）
# 格子の外側にはみ出たセルが、反対側の端に繋がっているとみなす処理です。
cyclic_padding <- function(grid) {
    ht <- nrow(grid)
    wd <- ncol(grid)
    # 上下に端の行を追加
    tmp <- rbind(grid[ht, ], grid, grid[1, ])
    # 左右に端の列を追加して(ht+2)x(wd+2)の拡張グリッドを作る
    extended_grid <- cbind(tmp[, wd], tmp, tmp[, 1])
    extended_grid
}

# 2. 空間心理モデル（セルオートマトン）の1ステップ更新関数
# 周囲の意見に流される効果（同調効果）と、金利が心理に及ぼす影響を計算します。
update_agent_grid <- function(grid, interest_rate) {
    ht <- nrow(grid)
    wd <- ncol(grid)
    extended_grid <- cyclic_padding(grid)
    new_grid <- matrix(0, nrow = ht, ncol = wd)

    # 金利 r に基づく基本確率 (p_base) の算出
    # 金利が高い(r > 0)ほど悲観のベース確率が上がり、楽観が下がる
    p1_raw <- 0.33 - 0.2 * interest_rate # 楽観のベース確率
    p2_raw <- 0.34 - 0.1 * interest_rate # 中立のベース確率
    p3_raw <- 0.33 + 0.3 * interest_rate # 悲観のベース確率

    # 確率が 0 未満にならないようにクリッピング（最小値を 0 に制限）
    p1_raw <- max(0, p1_raw)
    p2_raw <- max(0, p2_raw)
    p3_raw <- max(0, p3_raw)

    # 三つの確率の総和が 1 になるよう正規化して基本確率ベクトルとする
    total <- p1_raw + p2_raw + p3_raw
    p_base <- c(p1_raw / total, p2_raw / total, p3_raw / total)

    # 全セルをループで順次更新
    for (i in 1:ht) {
        for (j in 1:wd) {
            # 3x3の近傍（周囲8マスと自分自身）を切り出す
            neighborhood <- extended_grid[i:(i + 2), j:(j + 2)]

            # 近傍からランダムに1つのエージェントの状態を参照する
            referenced_state <- sample(as.vector(neighborhood), 1)

            # 確率 theta で参照した相手と同調し、(1 - theta) で金利ベースの確率に従う
            probs <- (1.0 - theta) * p_base
            if (referenced_state == STATE_OPTIMISTIC) {
                probs[1] <- probs[1] + theta
            } else if (referenced_state == STATE_NEUTRAL) {
                probs[2] <- probs[2] + theta
            } else {
                probs[3] <- probs[3] + theta
            }

            # 確率ベクトルに従って、次世代の自身の状態を決定
            new_grid[i, j] <- sample(
                c(STATE_OPTIMISTIC, STATE_NEUTRAL, STATE_PESSIMISTIC),
                size = 1,
                prob = probs
            )
        }
    }
    new_grid
}

# 3. 確率的反応系（ARMS）の市場更新関数（差分方程式による離散化モデル）
# マネー M、株価 S、債券 B の間で取引・資金移動が行われるルールを定義します。
update_arms_market <- function(M, S, B, sentiment_index, interest_rate, dt) {
    # 市場心理指数に基づく取引速度定数の決定
    k_buy <- k0 * (1.0 + alpha * sentiment_index) # 楽観的なほど買いが加速
    k_sell <- k0 * (1.0 - alpha * sentiment_index) # 悲観的なほど売りが加速

    # 金利に基づく安全資産への資金流出入の決定（利上げで債券へ、利下げでマネーへ）
    k_bond_in <- beta * max(0, interest_rate)
    k_bond_out <- beta * max(0, -interest_rate)

    # 各資産の増減（変化量）の計算
    # dM（マネーの変化）: 株売却額 + 債券からの戻り - 株購入額 - 債券への移動
    dM <- (k_sell * S + k_bond_out * B - k_buy * M - k_bond_in * M) * dt
    # dS（株価の変化）  : 株購入額 - 株売却額
    dS <- (k_buy * M - k_sell * S) * dt
    # dB（債券の変化）  : 債券への移動 - 債券からの戻り
    dB <- (k_bond_in * M - k_bond_out * B) * dt

    # 次のステップの値（資産がマイナスにならないよう max(0, ...) で保護）
    new_M <- max(0, M + dM)
    new_S <- max(0, S + dS)
    new_B <- max(0, B + dB)

    list(M = new_M, S = new_S, B = new_B)
}

# 4. 中央銀行の政策金利更新関数（株価・市場心理に基づくフィードバック）
# 株価がターゲットより高ければ利上げ、低ければ利下げを行います。
update_policy_rate <- function(current_r, S, S_target, sentiment_index) {
    # 金利の更新計算（株価偏差 ＋ 市場心理の偏り）
    new_r <- current_r + gamma1 * (S - S_target) + gamma2 * sentiment_index

    # 金利の許容範囲を [-1.0, 1.0] に制限（-100%から+100%の変動範囲）
    new_r <- max(-1.0, min(1.0, new_r))
    new_r
}

# ==============================================================================
# メインシミュレーション実行部
# ==============================================================================

# 1. 状態変数の初期化
# エージェント格子（心理グリッド）の初期化（楽観・中立・悲観をランダムに均等配置）
agent_grid <- matrix(
    sample(c(STATE_OPTIMISTIC, STATE_NEUTRAL, STATE_PESSIMISTIC), GRID_SIZE * GRID_SIZE, replace = TRUE),
    nrow = GRID_SIZE,
    ncol = GRID_SIZE
)

M <- INIT_M
S <- INIT_S
B <- INIT_B
interest_rate <- INIT_R

# 各種指標の履歴を記録するベクトル
history_M <- numeric(STEPS)
history_S <- numeric(STEPS)
history_B <- numeric(STEPS)
history_R <- numeric(STEPS)
history_I <- numeric(STEPS)

# 2. シミュレーションのメインループ
for (t in 1:STEPS) {
    # (1) 心理グリッドの更新（金利に依存）
    agent_grid <- update_agent_grid(agent_grid, interest_rate)

    # (2) 市場心理指数 I の計算（楽観比率 - 悲観比率）
    opt_count <- sum(agent_grid == STATE_OPTIMISTIC)
    pess_count <- sum(agent_grid == STATE_PESSIMISTIC)
    sentiment_index <- (opt_count - pess_count) / (GRID_SIZE * GRID_SIZE)

    # (3) ARMS取引による市場資産（M, S, B）の更新
    market_next <- update_arms_market(M, S, B, sentiment_index, interest_rate, dt)
    M <- market_next$M
    S <- market_next$S
    B <- market_next$B

    # (4) 中央銀行による金利調整（株価・市場心理に基づくフィードバック）
    interest_rate <- update_policy_rate(interest_rate, S, S_TARGET, sentiment_index)

    # (5) 現在の値を履歴に記録
    history_M[t] <- M
    history_S[t] <- S
    history_B[t] <- B
    history_R[t] <- interest_rate
    history_I[t] <- sentiment_index
}

# ==============================================================================
# 結果のグラフ描画
# ==============================================================================

# 画面を2行2列の計4分割にしてプロットを表示します
par(mfrow = c(2, 2))

# グラフ1: 市場全体の資産推移（株価・マネー・債券）
max_val <- max(c(history_S, history_M, history_B))
plot(history_S,
    type = "l", col = "blue", ylim = c(0, max_val),
    xlab = "時間ステップ", ylab = "資産価値 / 資金量", main = "市場資産 (M, S, B) の時系列推移"
)
lines(history_M, col = "green")
lines(history_B, col = "red")
legend("topleft", legend = c("株価 (S)", "マネー (M)", "債券 (B)"), col = c("blue", "green", "red"), lty = 1)

# グラフ2: 政策金利の推移
plot(history_R,
    type = "l", col = "purple",
    xlab = "時間ステップ", ylab = "政策金利 (r)", main = "政策金利の推移 (金利介入フィードバック)"
)
abline(h = 0, lty = 2, col = "gray") # 0基準線

# グラフ3: 市場心理指数 (I) の推移
plot(history_I,
    type = "l", col = "orange", ylim = c(-1, 1),
    xlab = "時間ステップ", ylab = "市場心理指数 (I)", main = "市場心理の推移 (楽観 - 悲観)"
)
abline(h = 0, lty = 2, col = "gray") # 0基準線（ニュートラル）

# グラフ4: シミュレーション終了時点のエージェント心理空間パターン
# 最小値-1(悲観)が赤、0(中立)が灰、最大値1(楽観)が青になります。
image(agent_grid,
    col = c("tomato", "lightgray", "royalblue"), axes = FALSE,
    main = "最終ステップの投資家心理分布\n(赤: 悲観, 灰: 中立, 青: 楽観)"
)
