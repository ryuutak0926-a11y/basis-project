# 計算情報学2 第4回 提出課題

# ---------------------------------------------------------
# (1) 飽和の遷移を観察する
# ルール: ウサギ → ウサギ, ウサギ
# ---------------------------------------------------------
cat("=== (1) 飽和の遷移を観察する ===\n")
k <- 5
N <- 2
steps <- 6
df1 <- data.frame(Step = integer(), N = integer(), Match = integer(), App = integer())

for (i in 0:steps) {
    app <- min(k, N)
    df1 <- rbind(df1, data.frame(Step = i, N = N, Match = N, App = app))
    if (i < steps) {
        N <- N + app
    }
}
print(df1)
cat("\n【考察】\nステップ2でN(=8)がk(=5)を超える瞬間が確認できます。\nNがk以下のときは毎ステップNが倍増する指数関数的な増加（非線形）を示しますが、\nNがkを超えると毎ステップk(=5)ずつ一定量増える線形な増加へと質が変わります。\n\n")

# ---------------------------------------------------------
# (2) 質量作用の法則を読む
# ルール: a, b → c
# ---------------------------------------------------------
cat("=== (2-a) 決定論的並列度 k = 1, 4, 8 ===\n")
simulate_2a <- function(k, steps = 10) {
    Na <- 8
    Nb <- 8
    df <- data.frame(Step = integer(), Na = integer(), Nb = integer(), Match = integer(), App = integer())
    for (i in 0:steps) {
        match_cnt <- Na * Nb
        # aとbが1つずつ消費されるため、同時に発火できる最大数はmin(Na, Nb)。並列度kで制限。
        app <- min(k, Na, Nb)
        df <- rbind(df, data.frame(Step = i, Na = Na, Nb = Nb, Match = match_cnt, App = app))
        if (i < steps) {
            Na <- Na - app
            Nb <- Nb - app
        }
    }
    return(df)
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
Na <- 8
Nb <- 8
df2b <- data.frame(Step = integer(), Na = numeric(), Nb = numeric(), ExpApp = numeric())
for (i in 0:8) {
    exp_app <- p * Na * Nb
    df2b <- rbind(df2b, data.frame(Step = i, Na = Na, Nb = Nb, ExpApp = exp_app))
    Na <- Na - exp_app
    Nb <- Nb - exp_app
}
print(df2b)
cat("\n")

cat("=== (2-c) (2-a)と(2-b)の比較表 ===\n")
df2c <- data.frame(
    N_a_b = integer(),
    Match_count = integer(),
    App_det_k1 = numeric(),
    App_det_k4 = numeric(),
    App_det_k8 = numeric(),
    Exp_App_prob = numeric()
)
for (n in c(8, 7, 6, 5, 4, 3, 2, 1)) {
    match_c <- n * n
    df2c <- rbind(df2c, data.frame(
        N_a_b = n,
        Match_count = match_c,
        App_det_k1 = min(1, n, n),
        App_det_k4 = min(4, n, n),
        App_det_k8 = min(8, n, n),
        Exp_App_prob = p * match_c
    ))
}
print(df2c)
cat("\n【考察】\n「速度が反応物の数の積(Match_count)に比例する」のは、期待発火数を持つ「確率的並列度」の方です。\n決定論的並列度では、発火数がkや反応物数(N)で頭打ちになってしまい、積には比例していません。\n\n")

# ---------------------------------------------------------
# (3) 振動の発生を観察する
# ルール: a → b, b と b, b → a
# ---------------------------------------------------------
cat("=== (3-a) 最大並列での系列 ===\n")
Na <- 10
Nb <- 0
df3a <- data.frame(Step = integer(), Na = integer(), Nb = integer())
for (i in 0:6) {
    df3a <- rbind(df3a, data.frame(Step = i, Na = Na, Nb = Nb))
    if (i < 6) {
        next_Na <- floor(Nb / 2)
        next_Nb <- 2 * Na
        Na <- next_Na
        Nb <- next_Nb
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
Na <- 10
Nb <- 0
set.seed(42) # 再現性のためシードを固定
df3c <- data.frame(Step = integer(), Na = integer(), Nb = integer())
df3c <- rbind(df3c, data.frame(Step = 0, Na = Na, Nb = Nb))
for (i in 1:30) {
    match1 <- Na
    match2 <- Nb * (Nb - 1) / 2
    total_match <- match1 + match2

    if (total_match > 0) {
        prob1 <- match1 / total_match
        if (runif(1) < prob1) {
            Na <- Na - 1
            Nb <- Nb + 2
        } else {
            Na <- Na + 1
            Nb <- Nb - 2
        }
    }
    df3c <- rbind(df3c, data.frame(Step = i, Na = Na, Nb = Nb))
}
print(df3c)

cat("\n【考察】\n最大並列では状態が一斉に切り替わるため周期2の決定論的な大きな振動が生じますが、\n逐次では1ステップに1つのルールしか適用されないため、一斉切り替えは起こりません。\nルールの発火頻度がバランスする値の周囲を確率的に揺らぐような、全く異なる質（平衡状態の周りのランダムウォーク）の挙動になります。\n")
