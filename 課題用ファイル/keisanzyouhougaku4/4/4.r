# 計算情報学2 第4回 提出課題

# ---------------------------------------------------------
# (1) 飽和の遷移を観察する
# ルール: ウサギ → ウサギ, ウサギ
# ---------------------------------------------------------
cat("=== (1) 飽和の遷移を観察する ===\n")
k <- 5
n <- 2
steps <- 6
df1 <- data.frame(
  Step = integer(), n = integer(),
  Match = integer(), App = integer()
)

for (i in 0:steps) {
  app <- min(k, n)
  df1 <- rbind(df1, data.frame(Step = i, n = n, Match = n, App = app))
  if (i < steps) {
    n <- n + app
  }
}
print(df1)
cat("\n【考察】\nステップ2でn(=8)がk(=5)を超える瞬間が確認できます。\n")
cat("nがk以下のときは毎ステップnが倍増する指数関数的な増加を示しますが、\n")
cat("nがkを超えると毎ステップk(=5)ずつ一定量増える線形な増加へ変わります。\n\n")

# ---------------------------------------------------------
# (2) 質量作用の法則を読む
# ルール: a, b → c
# ---------------------------------------------------------
cat("=== (2-a) 決定論的並列度 k = 1, 4, 8 ===\n")
simulate_2a <- function(k, steps = 10) {
  n_a <- 8
  n_b <- 8
  df <- data.frame(
    Step = integer(), n_a = integer(), n_b = integer(),
    Match = integer(), App = integer()
  )
  for (i in 0:steps) {
    match_cnt <- n_a * n_b
    app <- min(k, n_a, n_b)
    df <- rbind(df, data.frame(
      Step = i, n_a = n_a, n_b = n_b, Match = match_cnt, App = app
    ))
    if (i < steps) {
      n_a <- n_a - app
      n_b <- n_b - app
    }
  }
  df
}
cat("--- k = 1 ---\n")
print(simulate_2a(1, 8))
cat("--- k = 4 ---\n")
print(simulate_2a(4, 8))
cat("--- k = 8 ---\n")
print(simulate_2a(8, 8))
cat("\n")

cat("=== (2-b) 確率的並列度 p = 0.05 ===\n")
p <- 0.05
n_a <- 8
n_b <- 8
df2b <- data.frame(
  Step = integer(), n_a = numeric(), n_b = numeric(), ExpApp = numeric()
)
for (i in 0:8) {
  exp_app <- p * n_a * n_b
  df2b <- rbind(df2b, data.frame(
    Step = i, n_a = n_a, n_b = n_b, ExpApp = exp_app
  ))
  n_a <- n_a - exp_app
  n_b <- n_b - exp_app
}
print(df2b)
cat("\n")

cat("=== (2-c) (2-a)と(2-b)の比較表 ===\n")
df2c <- data.frame(
  n_a_b = integer(),
  match_count = integer(),
  app_det_k1 = numeric(),
  app_det_k4 = numeric(),
  app_det_k8 = numeric(),
  exp_app_prob = numeric()
)
for (n_val in c(8, 7, 6, 5, 4, 3, 2, 1)) {
  match_c <- n_val * n_val
  df2c <- rbind(df2c, data.frame(
    n_a_b = n_val,
    match_count = match_c,
    app_det_k1 = min(1, n_val, n_val),
    app_det_k4 = min(4, n_val, n_val),
    app_det_k8 = min(8, n_val, n_val),
    exp_app_prob = p * match_c
  ))
}
print(df2c)
cat("\n【考察】\n「速度が反応物の数の積(Match_count)に比例する」のは、")
cat("期待発火数を持つ「確率的並列度」の方です。\n")
cat("決定論的並列度では、発火数がkや反応物数(n)で頭打ちになってしまい、")
cat("積には比例していません。\n\n")

# ---------------------------------------------------------
# (3) 振動の発生を観察する
# ルール: a → b, b と b, b → a
# ---------------------------------------------------------
cat("=== (3-a) 最大並列での系列 ===\n")
n_a <- 10
n_b <- 0
df3a <- data.frame(Step = integer(), n_a = integer(), n_b = integer())
for (i in 0:6) {
  df3a <- rbind(df3a, data.frame(Step = i, n_a = n_a, n_b = n_b))
  if (i < 6) {
    next_n_a <- floor(n_b / 2)
    next_n_b <- 2 * n_a
    n_a <- next_n_a
    n_b <- next_n_b
  }
}
print(df3a)
cat("\n周期は 2 です。\n\n")

cat("=== (3-b) 2回適用で元に戻ることの確認 ===\n")
check_mapping <- function(a, b) {
  cat(sprintf("初期: (a, b) = (%d, %d)\n", a, b))
  a1 <- floor(b / 2)
  b1 <- 2 * a
  cat(sprintf("1回適用: (a, b) = (%d, %d)\n", a1, b1))
  a2 <- floor(b1 / 2)
  b2 <- 2 * a1
  cat(sprintf("2回適用: (a, b) = (%d, %d)\n", a2, b2))
  if (a == a2 && b == b2) cat("-> 元に戻ることを確認しました。\n\n")
}
check_mapping(10, 0)
check_mapping(6, 8)

cat("=== (3-c) 逐次(k=1)での軌跡 (30ステップ) ===\n")
n_a <- 10
n_b <- 0
set.seed(42) # 再現性のためシードを固定
df3c <- data.frame(Step = integer(), n_a = integer(), n_b = integer())
df3c <- rbind(df3c, data.frame(Step = 0, n_a = n_a, n_b = n_b))
for (i in 1:30) {
  match1 <- n_a
  match2 <- n_b * (n_b - 1) / 2
  total_match <- match1 + match2

  if (total_match > 0) {
    prob1 <- match1 / total_match
    if (runif(1) < prob1) {
      n_a <- n_a - 1
      n_b <- n_b + 2
    } else {
      n_a <- n_a + 1
      n_b <- n_b - 2
    }
  }
  df3c <- rbind(df3c, data.frame(Step = i, n_a = n_a, n_b = n_b))
}
print(df3c)

cat("\n【考察】\n最大並列では状態が一斉に切り替わるため周期2の決定論的な大きな振動が生じますが、\n")
cat("逐次では1ステップに1つのルールしか適用されないため、一斉切り替えは起こりません。\n")
cat("ルールの発火頻度がバランスする値の周囲を確率的に揺らぐような、")
cat("全く異なる質（平衡状態の周りのランダムウォーク）の挙動になります。\n")
