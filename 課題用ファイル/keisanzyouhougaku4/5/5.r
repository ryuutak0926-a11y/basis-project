life_game_rule <- function(m) {
  a <- m
  cur_state <- a[2, 2]
  a[2, 2] <- 0
  if (sum(a) == 3 || (cur_state == 1 && sum(a) == 2)) {
    new_state <- 1
  } else {
    new_state <- 0
  }
  new_state
}

# --- 動作確認（演習 5-1） ---
# ① の確認（中心が0で周囲が3 -> 誕生により 1 になるはず）
m1 <- matrix(c(1, 0, 0, 0, 0, 0, 0, 1, 1), nrow = 3, ncol = 3, byrow = TRUE)
life_game_rule(m1)

# ② の確認（中心が1で周囲が2 -> 生存により 1 になるはず）
m2 <- matrix(c(0, 0, 0, 0, 1, 0, 1, 0, 1), nrow = 3, ncol = 3, byrow = TRUE)
life_game_rule(m2)

# ③ の確認（中心が1で周囲が4 -> 過密で死亡により 0 になるはず）
m3 <- matrix(c(1, 1, 0, 1, 1, 1, 1, 1, 0), nrow = 3, ncol = 3, byrow = TRUE)
life_game_rule(m3)



# --- 演習（周期境界条件のためのパディング） ---
a <- matrix(c(1:9), nrow = 3, ncol = 3, byrow = TRUE)

# ① cm_tmp の作成と表示
cat("\n--- ① cm_tmp ---\n")
cm_tmp <- rbind(a[nrow(a), ], a, a[1, ])
print(cm_tmp)

# ② cyclic_map の作成と表示
cat("\n--- ② cyclic_map ---\n")
cyclic_map <- cbind(cm_tmp[, ncol(cm_tmp)], cm_tmp, cm_tmp[, 1])
print(cyclic_map)

# ③ 大きさの確認（5×5になっているはず）
cat("\n--- ③ dim(cyclic_map) ---\n")
print(dim(cyclic_map))

# ④ cyclic_map[1:3, 1:3] の表示と、a[3,3]近傍の確認
cat("\n--- ④ cyclic_map[1:3, 1:3] の表示 ---\n")
print(cyclic_map[1:3, 1:3])
cat("※ 注意: 演習の指示では「9が中央に来ていれば正しい」とありますが、\n",
    "指定されたパディング方法ではここ(2行2列目)には「1」(a[1,1])が来ます。\n",
    sep = "")

cat("\n--- 補足: a[3,3]の近傍(中央が9)を正しく表示するには",
    " cyclic_map[3:5, 3:5] を使います ---\n", sep = "")
print(cyclic_map[3:5, 3:5])

# --- 演習（1ステップ更新関数の完成） ---
life_game_1step <- function(a) {
  ht <- nrow(a)
  wd <- ncol(a)
  cm_tmp <- rbind(a[ht, ], a, a[1, ]) # 上下に追加
  cyclic_map <- cbind(cm_tmp[, wd], cm_tmp, cm_tmp[, 1]) # 左右に追加
  new_a <- matrix(0, nrow = ht, ncol = wd)
  for (i in 1:ht) {
    for (j in 1:wd) {
      new_a[i, j] <- life_game_rule(cyclic_map[i:(i + 2), j:(j + 2)])
    }
  }
  new_a
}

# --- 動作確認 ---
a <- matrix(c(
  0, 0, 0, 0, 0,
  0, 1, 1, 0, 0,
  0, 1, 0, 0, 0,
  0, 1, 1, 0, 0,
  0, 0, 0, 0, 0
), nrow = 5, ncol = 5, byrow = TRUE)

# 初期状態の表示（RStudioのPlotsペインに表示されます）
image(a, axes = FALSE, main = "初期状態")

a2 <- life_game_1step(a) # 1回更新

# 更新後の表示
image(a2, axes = FALSE, main = "1回更新後")
