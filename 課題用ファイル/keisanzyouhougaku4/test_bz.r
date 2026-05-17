# --- 1. 基本関数の定義 ---

pow <- function(a, b) a^b

btw <- function(rnum, p_ls) {
  for (i in 1:length(p_ls)) {
    if (rnum <= p_ls[i]) {
      return(i)
    }
  }
  length(p_ls)
}

roulet <- function(prob) {
  p_ls <- cumsum(prob)
  rand <- runif(1)
  btw(rand, p_ls)
}

prob_ls <- function(ms, LHS, rconst) {
  n <- nrow(LHS)
  nume <- numeric(n)
  for (i in 1:n) {
    # 各反応規則の速度計算
    nume[i] <- prod(mapply(pow, ms, LHS[i, ])) * rconst[i]
  }
  if (sum(nume) == 0) {
    return(rep(0, n))
  }
  nume / sum(nume)
}

# --- 2. BZ 反応の設定 ---

# 反応物リスト: [A, B, X, Y]
# 規則 1: A + X -> 2X
# 規則 2: B + X -> Y
# 規則 3: 2X + Y -> 3X
# 規則 4: X -> 消滅
LHS_BZ <- matrix(c(
  1, 0, 1, 0, # 規則 1
  0, 1, 1, 0, # 規則 2
  0, 0, 2, 1, # 規則 3
  0, 0, 1, 0 # 規則 4
), nrow = 4, ncol = 4, byrow = TRUE)

# 反応による増減量
changes_BZ <- list(
  c(-1, 0, 1, 0), # 規則 1: A減, X増
  c(0, -1, -1, 1), # 規則 2: B減, X減, Y増
  c(0, 0, 1, -1), # 規則 3: X増, Y減
  c(0, 0, -1, 0) # 規則 4: X減
)

# --- 3. シミュレーション実行 ---

set.seed(42)
steps <- 1000
ms <- c(1000, 1000, 50, 50) # 初期値 [A, B, X, Y]
rconst <- c(0.01, 0.1, 0.01, 0.2) # 速度定数 [k1, k2, k3, k4]

# 結果格納用
history <- matrix(0, nrow = steps + 1, ncol = 4)
colnames(history) <- c("A", "B", "X", "Y")
history[1, ] <- ms

for (t in 1:steps) {
  prob <- prob_ls(ms, LHS_BZ, rconst)
  if (sum(prob) == 0) break

  idx <- roulet(prob)
  ms <- ms + changes_BZ[[idx]]
  ms[ms < 0] <- 0 # 負の値を防止
  history[t + 1, ] <- ms
}

# --- 4. 数値出力 (最初の 100 ステップを 10 刻みで表示) ---

print("BZ Reaction Simulation Results (Selected Steps):")
display_indices <- seq(1, 20, by = 1)
print(history[display_indices, ])
