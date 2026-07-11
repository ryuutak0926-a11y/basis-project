const hamburger = document.querySelector(`.hamburger`);
const menu = document.querySelector(".menu");

//alert("つながり確認");

hamburger.addEventListener(`click`, () => {
    menu.classList.toggle(`active`);
})