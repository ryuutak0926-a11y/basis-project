# ---------------------------------------------------------
# 演習 4-5 発展：BZ 反応（Belousov-Zhabotinskii 反応）
# ---------------------------------------------------------

cat("=== (4-5) BZ反応の確率的ARMS ===\n")

# ---- pow 関数 ----
pow <- function(x, a) {
  if (a == 0) 1 else x^a
}

# ---- 確率を計算する ----
prob_ls <- function(ms, lhs, rconst) {
  n <- nrow(lhs)
  nume <- numeric(n)
  for (i in 1:n) {
    nume[i] <- prod(mapply(pow, ms, lhs[i, ])) * rconst[i]
  }
  if (sum(nume) == 0) {
    return(rep(0, n))
  }
  nume / sum(nume)
}

# ---- ルーレット選択 ----
btw <- function(rnum, p_ls) {
  for (i in seq_along(p_ls)) {
    if (rnum <= p_ls[i]) {
      return(i)
    }
  }
  length(p_ls)
}

roulet <- function(prob) {
  btw(runif(1), cumsum(prob))
}

# ---- 1 ステップの書き換え ----
arms_1step <- function(ms, lhs, rhs, rconst) {
  prob <- prob_ls(ms, lhs, rconst)
  if (sum(prob) == 0) {
    return(ms)
  }
  r <- roulet(prob)
  ms - lhs[r, ] + rhs[r, ]
}

# ---- 複数ステップ実行して履歴を返す ----
stochastic_arms_history <- function(ms, lhs, rhs, rconst, steps) {
  history <- data.frame(Step = 0:steps, A = 0, B = 0, X = 0, Y = 0)
  history[1, 2:5] <- ms
  for (t in 1:steps) {
    ms <- arms_1step(ms, lhs, rhs, rconst)
    history[t + 1, 2:5] <- ms
  }
  history
}

# 分子種: A, B, X, Y の順で考える
# 規則 1: A, X → X, X       k1
# 規則 2: B, X → Y          k2
# 規則 3: X, X, Y → X, X, X k3
# 規則 4: X →               k4

lhs_bz <- matrix(c(
  1, 0, 1, 0,
  0, 1, 1, 0,
  0, 0, 2, 1,
  0, 0, 1, 0
), nrow = 4, ncol = 4, byrow = TRUE)

rhs_bz <- matrix(c(
  0, 0, 2, 0,
  0, 0, 0, 1,
  0, 0, 3, 0,
  0, 0, 0, 0
), nrow = 4, ncol = 4, byrow = TRUE)

simulate_bz <- function(k1, k2, k3, k4, steps = 2000) {
  # A, Bがすぐに枯渇しないよう初期値を大きく設定
  ms_init <- c(1000, 1000, 10, 10)
  rconst_bz <- c(k1, k2, k3, k4)
  set.seed(42)
  hist <- stochastic_arms_history(ms_init, lhs_bz, rhs_bz, rconst_bz, steps)

  cat(sprintf("k2 = %.2f, k3 = %.2f\n", k2, k3))
  print(summary(hist[, c("X", "Y")]))
}

cat("--- パターン1: 基準 (k2=0.1, k3=0.1) ---\n")
simulate_bz(0.1, 0.1, 0.1, 0.1)

cat("\n--- パターン2: k2を大きくする (k2=0.5, k3=0.1) ---\n")
simulate_bz(0.1, 0.5, 0.1, 0.1)

cat("\n--- パターン3: k3を大きくする (k2=0.1, k3=0.5) ---\n")
simulate_bz(0.1, 0.1, 0.5, 0.1)

cat("\n【考察】\n")
cat("k2は規則2 (B, X → Y) の速度定数であり、これが大きいとYが生成されやすくなり、Xが減衰しやすくなります。\n")
cat("k3は規則3 (X, X, Y → X, X, X) の速度定数であり、これが大きいとYを消費してXを自己触媒的に増幅する反応が促進されます。\n")
cat("k2とk3のバランスによって、XとYの濃度が交互に増減する周期的な振動の振る舞いが現れたり、\n")
cat("いずれかが優勢になって発散・収束するなどの変化が生じます。\n")


# ---- pow 関数 ----
pow <- function(x, a) {
  if (a == 0) 1 else x^a
}

# ---- 確率を計算 ----
prob_ls <- function(ms, lhs, rconst) {
  n <- nrow(lhs)
  nume <- numeric(n)

  for (i in 1:n) {
    nume[i] <- prod(mapply(pow, ms, lhs[i, ])) * rconst[i]
  }

  if (sum(nume) == 0) {
    return(rep(0, n))
  }
  nume / sum(nume)
}

# ---- ルーレット選択 ----
btw <- function(rnum, p_ls) {
  for (i in seq_along(p_ls)) {
    if (rnum <= p_ls[i]) {
      return(i)
    }
  }
  length(p_ls)
}

roulet <- function(prob) {
  btw(runif(1), cumsum(prob))
}

# ---- 1ステップ ----
arms_1step <- function(ms, lhs, rhs, rconst) {
  prob <- prob_ls(ms, lhs, rconst)

  if (sum(prob) == 0) {
    return(ms)
  }

  r <- roulet(prob)

  ms - lhs[r, ] + rhs[r, ]
}

# ---- シミュレーション ----
stochastic_arms <- function(ms, lhs, rhs, rconst, steps) {
  history <- matrix(0, steps + 1, length(ms))
  history[1, ] <- ms

  for (t in 1:steps) {
    ms <- arms_1step(ms, lhs, rhs, rconst)
    history[t + 1, ] <- ms
  }

  colnames(history) <- c("A", "B", "X", "Y")
  history
}

# ==============================
# BZ反応設定
# ==============================

# 分子順: A, B, X, Y

lhs <- matrix(c(
  1, 0, 1, 0,
  0, 1, 1, 0,
  0, 0, 2, 1,
  0, 0, 1, 0 # X
), byrow = TRUE, ncol = 4)

rhs <- matrix(c(
  0, 0, 2, 0,
  0, 0, 0, 1, # Y
  0, 0, 3, 0,
  0, 0, 0, 0 # 消滅
), byrow = TRUE, ncol = 4)

# 初期値
ms0 <- c(100, 100, 20, 5)

# 速度定数
rconst <- c(
  0.01, # k1
  0.02, # k2
  0.005, # k3
  0.01 # k4
)

# 実行
result <- stochastic_arms(ms0, lhs, rhs, rconst, 5000)

# X,Y の時間変化
plot(result[, 3],
  type = "l", ylim = range(result[, 3:4]),
  xlab = "step", ylab = "molecule count",
  main = "BZ Reaction"
)

lines(result[, 4])

legend("topright", legend = c("X", "Y"), lty = 1)
