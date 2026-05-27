# 複雑システム系演習１ 第６回 ライフゲーム（後半）
# 演習 6-4 ルール改変シミュレーション

# ---- 共通ヘルパー関数 ----
print.field <- function(A) {
  ht <- nrow(A)
  wd <- ncol(A)
  for (i in 1:ht) {
    row_str <- ""
    for (j in 1:wd) {
      if (A[i, j] >= 1) {
        row_str <- paste0(row_str, "■ ")
      } else {
        row_str <- paste0(row_str, ". ")
      }
    }
    cat(row_str, "\n")
  }
}

rand.field <- function(size, rand) {
  tmp <- matrix(0, nrow=size, ncol=size)
  for (i in 1:(size * size)) {
    if (sample(100, 1) < rand) tmp[i] <- 1
  }
  tmp
}

# 1ステップ更新（任意のルール関数を適用可能に設計）
life.game.1step.custom <- function(A, rule.func) {
  ht         <- nrow(A)
  wd         <- ncol(A)
  cm.tmp     <- rbind(A[ht, ], A, A[1, ])
  cyclic.map <- cbind(cm.tmp[, wd], cm.tmp, cm.tmp[, 1])
  new.A      <- matrix(0, nrow=ht, ncol=wd)
  for (i in 1:ht) {
    for (j in 1:wd) {
      new.A[i, j] <- rule.func(cyclic.map[i:(i+2), j:(j+2)])
    }
  }
  new.A
}

# N回更新してテキスト表示する関数
play.custom <- function(A, rule.func, step=10) {
  for (i in 1:step) {
    cat(paste("--- Step:", i, "---\n"))
    print.field(A)
    cat("\n")
    A <- life.game.1step.custom(A, rule.func)
  }
}

# ===================================================
# ① 生存条件の改変: 「近傍に生が 2 つまたは 4 つのとき生き残る」
# (通常は2または3のとき生き残る)
# ===================================================
rule.surv.2or4 <- function(M) {
  A         <- M
  cur.state <- A[2, 2]
  A[2, 2]   <- 0
  
  neighbors <- sum(A)
  # 誕生条件：周囲に生が3つ
  # 生存条件：周囲に生が2つまたは4つで、かつ自分が生(1)
  if (neighbors == 3 || ((neighbors == 2 || neighbors == 4) && cur.state == 1)) {
    new.state <- 1
  } else {
    new.state <- 0
  }
  new.state
}

# ===================================================
# ② 誕生条件の改変: 「近傍に生が 2 つのとき誕生する」
# (通常は3のとき誕生する)
# ===================================================
rule.birth.2 <- function(M) {
  A         <- M
  cur.state <- A[2, 2]
  A[2, 2]   <- 0
  
  neighbors <- sum(A)
  # 誕生条件：周囲に生が2つで、かつ自分が死(0)
  # 生存条件：周囲に生が2つまたは3つで、かつ自分が生(1)
  if ((neighbors == 2 && cur.state == 0) || ((neighbors == 2 || neighbors == 3) && cur.state == 1)) {
    new.state <- 1
  } else {
    new.state <- 0
  }
  new.state
}

# ---- テスト実行 ----
# 15x15のグリッド、初期密度30%で初期化
set.seed(42)
init.A <- rand.field(15, 30)

cat("=========================================\n")
cat("① 生存条件改変 (生存: 2 or 4, 誕生: 3)\n")
cat("=========================================\n")
play.custom(init.A, rule.surv.2or4, step=8)

cat("=========================================\n")
cat("② 誕生条件改変 (生存: 2 or 3, 誕生: 2)\n")
cat("=========================================\n")
play.custom(init.A, rule.birth.2, step=8)
