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

# ③ 大きさの確認
cat("\n--- ③ dim(cyclic.map) ---\n")
print(dim(cyclic.map))
