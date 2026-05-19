life.game.rule <- function(M) {
    A <- M
    cur.state <- A[2, 2]
    A[2, 2] <- 0
    if (sum(A) == 3 || (cur.state == 1 && sum(A) == 2)) {
        new.state <- 1
    } else {
        new.state <- 0
    }
    new.state
}

# --- 動作確認（演習 5-1） ---
# ① の確認（中心が0で周囲が3 -> 誕生により 1 になるはず）
M1 <- matrix(c(1, 0, 0, 0, 0, 0, 0, 1, 1), nrow = 3, ncol = 3, byrow = TRUE)
life.game.rule(M1)

# ② の確認（中心が1で周囲が2 -> 生存により 1 になるはず）
M2 <- matrix(c(0, 0, 0, 0, 1, 0, 1, 0, 1), nrow = 3, ncol = 3, byrow = TRUE)
life.game.rule(M2)

# ③ の確認（中心が1で周囲が4 -> 過密で死亡により 0 になるはず）
M3 <- matrix(c(1, 1, 0, 1, 1, 1, 1, 1, 0), nrow = 3, ncol = 3, byrow = TRUE)
life.game.rule(M3)



# --- 演習（周期境界条件のためのパディング） ---
A <- matrix(c(1:9), nrow = 3, ncol = 3, byrow = TRUE)

# ① cm.tmp の作成と表示
cat("\n--- ① cm.tmp ---\n")
cm.tmp <- rbind(A[nrow(A), ], A, A[1, ])
print(cm.tmp)

# ② cyclic.map の作成と表示
cat("\n--- ② cyclic.map ---\n")
cyclic.map <- cbind(cm.tmp[, ncol(cm.tmp)], cm.tmp, cm.tmp[, 1])
print(cyclic.map)

# ③ 大きさの確認（5×5になっているはず）
cat("\n--- ③ dim(cyclic.map) ---\n")
print(dim(cyclic.map))

# ④ cyclic.map[1:3, 1:3] の表示と、A[3,3]近傍の確認
cat("\n--- ④ cyclic.map[1:3, 1:3] の表示 ---\n")
print(cyclic.map[1:3, 1:3])
cat("※ 注意: 演習の指示では「9が中央に来ていれば正しい」とありますが、指定されたパディング方法ではここ(2行2列目)には「1」(A[1,1])が来ます。\n")

cat("\n--- 補足: A[3,3]の近傍(中央が9)を正しく表示するには cyclic.map[3:5, 3:5] を使います ---\n")
print(cyclic.map[3:5, 3:5])

# --- 演習（1ステップ更新関数の完成） ---
life.game.1step <- function(A) {
    ht <- nrow(A)
    wd <- ncol(A)
    cm.tmp <- rbind(A[ht, ], A, A[1, ]) # 上下に追加
    cyclic.map <- cbind(cm.tmp[, wd], cm.tmp, cm.tmp[, 1]) # 左右に追加
    new.A <- matrix(0, nrow = ht, ncol = wd)
    for (i in 1:ht) {
        for (j in 1:wd) {
            new.A[i, j] <- life.game.rule(cyclic.map[i:(i + 2), j:(j + 2)])
        }
    }
    new.A
}

# --- 動作確認 ---
A <- matrix(c(
    0, 0, 0, 0, 0,
    0, 1, 1, 0, 0,
    0, 1, 0, 0, 0,
    0, 1, 1, 0, 0,
    0, 0, 0, 0, 0
), nrow = 5, ncol = 5, byrow = TRUE)

# 初期状態の表示（RStudioのPlotsペインに表示されます）
image(A, axes = FALSE, main = "初期状態")

A2 <- life.game.1step(A) # 1回更新

# 更新後の表示
image(A2, axes = FALSE, main = "1回更新後")
