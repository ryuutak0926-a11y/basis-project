library(splines)

f_poly <- function(x) {
    x^3 - x^2 + 2 * x
}
f_runge <- function(x) {
    1 / (1 + 25 * x^2)
}
f_exp <- function(x) {
    exp(x)
}
f_sin <- function(x) {
    sin(pi * x)
}

functions_list <- list(
    "単純多項式" = f_poly,
    "ルンゲ関数" = f_runge,
    "指数関数" = f_exp,
    "三角関数" = f_sin
)

get_sample_points <- function(n, type) {
    if (type == "equal") {
        return(seq(-1, 1, length.out = n))
    } else if (type == "one_side") {
        seq_01 <- seq(0, 1, length.out = n)
        return(-1 + 2 * (seq_01^2))
    } else if (type == "both_sides") {
        seq_scaled <- seq(-pi / 2, pi / 2, length.out = n)
        return(sin(seq_scaled))
    } else if (type == "random") {
        if (n <= 2) {
            return(c(-1, 1))
        }
        mid_points <- runif(n - 2, min = -1, max = 1)
        return(sort(c(-1, mid_points, 1)))
    }
}

run_interpolation_experiment <- function(func_name, f, n_points, node_type) {
    x_nodes <- get_sample_points(n_points, node_type)
    y_nodes <- f(x_nodes)

    x_grid <- seq(-1, 1, length.out = 1000)
    y_true <- f(x_grid)

    true_amplitude <- max(y_true) - min(y_true)

    lagrange_interp <- function(x_eval) {
        sapply(x_eval, function(x) {
            weights <- sapply(1:length(x_nodes), function(i) {
                prod((x - x_nodes[-i]) / (x_nodes[i] - x_nodes[-i]))
            })
            sum(y_nodes * weights)
        })
    }
    y_lagrange <- lagrange_interp(x_grid)

    spline_interp <- spline(x_nodes, y_nodes, xout = x_grid)
    y_spline <- spline_interp$y

    err_lagrange <- abs(y_lagrange - y_true)
    err_spline <- abs(y_spline - y_true)

    max_err_lagrange <- max(err_lagrange)
    max_err_spline <- max(err_spline)

    is_lagrange_zero <- max_err_lagrange < 1e-9

    cond_A <- !is_lagrange_zero && (max_err_lagrange > true_amplitude)

    cond_B <- !is_lagrange_zero && any(err_lagrange > (err_spline * 10))

    cat(sprintf("\n--- 実験条件: %s | 点数: %d | 配置: %s ---\n", func_name, n_points, node_type))
    cat(sprintf("判定(ア) [誤差 > 全振幅]: %s\n", if (cond_A) "発生" else "なし"))
    cat(sprintf("判定(イ) [ラグランジュ > スプライン*10]: %s\n", if (cond_B) "発生" else "なし"))

    ylim_range <- range(c(y_true, y_spline, y_nodes))
    if (max_err_lagrange < true_amplitude * 5) {
        ylim_range <- range(c(ylim_range, y_lagrange))
    } else {
        ylim_range <- c(min(y_true) - true_amplitude, max(y_true) + true_amplitude)
    }

    plot(x_grid, y_true,
        type = "l", col = "black", lwd = 2, ylim = ylim_range,
        main = paste(func_name, "(点数:", n_points, ", 配置:", node_type, ")"),
        xlab = "x", ylab = "y"
    )
    lines(x_grid, y_lagrange, col = "red", lwd = 1.5, lty = 2)
    lines(x_grid, y_spline, col = "blue", lwd = 1.5, lty = 1)
    points(x_nodes, y_nodes, col = "darkgreen", pch = 19, cex = 1.5)

    legend("top",
        legend = c("真の関数", "ラグランジュ補間", "スプライン補間", "サンプリング点"),
        col = c("black", "red", "blue", "darkgreen"), lty = c(1, 2, 1, NA), pch = c(NA, NA, NA, 19), bty = "n"
    )
}

par(mfrow = c(1, 1))

run_interpolation_experiment("三角関数", f_sin, 5, "equal")
run_interpolation_experiment("三角関数", f_sin, 5, "one_side")
run_interpolation_experiment("三角関数", f_sin, 5, "both_sides")
run_interpolation_experiment("三角関数", f_sin, 5, "random")

run_interpolation_experiment("指数関数", f_exp, 5, "equal")
run_interpolation_experiment("指数関数", f_exp, 5, "one_side")
run_interpolation_experiment("指数関数", f_exp, 5, "both_sides")
run_interpolation_experiment("指数関数", f_exp, 5, "random")

run_interpolation_experiment("ルンゲ関数", f_runge, 5, "equal")
run_interpolation_experiment("ルンゲ関数", f_runge, 5, "one_side")
run_interpolation_experiment("ルンゲ関数", f_runge, 5, "both_sides")
run_interpolation_experiment("ルンゲ関数", f_runge, 5, "random")

run_interpolation_experiment("単純多項式", f_poly, 5, "equal")
run_interpolation_experiment("単純多項式", f_poly, 5, "one_side")
run_interpolation_experiment("単純多項式", f_poly, 5, "both_sides")
run_interpolation_experiment("単純多項式", f_poly, 5, "random")
