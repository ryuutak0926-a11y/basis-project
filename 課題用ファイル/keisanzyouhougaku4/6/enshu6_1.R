# ---- ルール関数 ----
life.game.rule <- function(M) {
  A <- M
  cur.state <- A[2, 2]
  A[2, 2] <- 0
  if (sum(A) == 3 || (sum(A) == 2 && cur.state == 1)) {
    new.state <- 1
  } else {
    new.state <- 0
  }
  new.state
}

# ---- 1 ステップ更新 ----
life.game.1step <- function(A) {
  ht <- nrow(A)
  wd <- ncol(A)
  cm.tmp <- rbind(A[ht, ], A, A[1, ])
  cyclic.map <- cbind(cm.tmp[, wd], cm.tmp, cm.tmp[, 1])
  new.A <- matrix(0, nrow = ht, ncol = wd)
  for (i in 1:ht) {
    for (j in 1:wd) {
      new.A[i, j] <- life.game.rule(cyclic.map[i:(i + 2), j:(j + 2)])
    }
  }
  new.A
}

play.life.game <- function(A, step = 20, pause = TRUE) {
  for (i in 1:step) {
    image(A, axes = FALSE)
    title(main = paste("Step:", i))
    if (pause) readline(prompt = "Press <Return> to continue.")
    A <- life.game.1step(A)
  }
}

A <- matrix(0, nrow = 10, ncol = 10)
A[2, 3] <- 1
A[3, 2] <- 1
A[4, 2] <- 1
A[4, 3] <- 1
A[4, 4] <- 1
play.life.game(A, step = 20)


# size×size のセルを作り、rand% の確率でセルを生にする
rand.field <- function(size, rand) {
  tmp <- matrix(0, nrow = size, ncol = size)
  for (i in 1:(size * size)) {
    if (sample(100, 1) < rand) {
      tmp[i] <- 1
    }
  }
  tmp
}

# 使い方：40×40、全体の 10%が生の状態でスタート
A <- rand.field(40, 10)
play.life.game(A, step = 100, pause = FALSE)

set.seed(42)
play.life.game(rand.field(40, 50), step = 200, pause = FALSE)


A <- rand.field(40, 20)
system.time(play.life.game(A, step = 100, pause = FALSE))
life.game.1step.fast <- function(A) {
  ht <- nrow(A)
  wd <- ncol(A)
  cm.tmp <- rbind(A[ht, ], A, A[1, ])
  cyclic.map <- cbind(cm.tmp[, wd], cm.tmp, cm.tmp[, 1])
  new.A <- matrix(0, nrow = ht, ncol = wd)
  # 各セルの座標リストを作る
  idx <- expand.grid(i = 1:ht, j = 1:wd)
  # apply で全セルに一気にルールを適用する
  new.A[] <- apply(idx, 1, function(x) {
    life.game.rule(cyclic.map[x[1]:(x[1] + 2), x[2]:(x[2] + 2)])
  })
  new.A
}

play.life.game.fast <- function(A, step = 20, pause = TRUE) {
  for (i in 1:step) {
    image(A, axes = FALSE)
    title(main = paste("Step:", i))
    if (pause) readline(prompt = "Press <Return> to continue.")
    A <- life.game.1step.fast(A)
  }
}

system.time(play.life.game(A, step = 100, pause = FALSE))

A <- rand.field(40, 20)
system.time(play.life.game.fast(A, step = 100, pause = FALSE))



# ---- ルール関数 ----
life.game.rule <- function(M) {
  A <- M
  cur.state <- A[2, 2]
  A[2, 2] <- 0
  if (sum(A) == 3 || (sum(A) == 2 && cur.state == 1)) {
    new.state <- 1
  } else {
    new.state <- 0
  }
  new.state
}
# ---- 1 ステップ更新（通常版）----
life.game.1step <- function(A) {
  ht <- nrow(A)
  wd <- ncol(A)
  cm.tmp <- rbind(A[ht, ], A, A[1, ])
  cyclic.map <- cbind(cm.tmp[, wd], cm.tmp, cm.tmp[, 1])
  new.A <- matrix(0, nrow = ht, ncol = wd)
  for (i in 1:ht) {
    for (j in 1:wd) {
      new.A[i, j] <- life.game.rule(cyclic.map[i:(i + 2), j:(j + 2)])
    }
  }
  new.A
}
# ---- 1 ステップ更新（高速版）----
life.game.1step.fast <- function(A) {
  ht <- nrow(A)
  wd <- ncol(A)
  cm.tmp <- rbind(A[ht, ], A, A[1, ])
  cyclic.map <- cbind(cm.tmp[, wd], cm.tmp, cm.tmp[, 1])
  new.A <- matrix(0, nrow = ht, ncol = wd)
  idx <- expand.grid(i = 1:ht, j = 1:wd)
  new.A[] <- apply(idx, 1, function(x) {
    life.game.rule(cyclic.map[x[1]:(x[1] + 2), x[2]:(x[2] + 2)])
  })
  new.A
}
# ---- ランダム初期状態 ----
rand.field <- function(size, rand) {
  tmp <- matrix(0, nrow = size, ncol = size)
  for (i in 1:(size * size)) {
    if (sample(100, 1) < rand) tmp[i] <- 1
  }
  tmp
}
# ---- N 回更新して表示 ----
play.life.game <- function(A, step = 20, pause = TRUE) {
  for (i in 1:step) {
    image(A, axes = FALSE)
    title(main = paste("Step:", i))
    if (pause) readline(prompt = "Press <Return> to continue.")
    A <- life.game.1step(A)
  }
}
# ---- 実行例 ----
# グライダー
A <- matrix(0, nrow = 10, ncol = 10)
A[2, 3] <- 1
A[3, 2] <- 1
A[4, 2] <- 1
A[4, 3] <- 1
A[4, 4] <- 1
play.life.game(A)
# ランダム
set.seed(42)
play.life.game(rand.field(40, 10), step = 200, pause = FALSE)
