const isAgreed = document.getElementById("check");
const btn = document.getElementById("btn");

isAgreed.addEventListener("change", () => {
    btn.disabled = !isAgreed.checked;
});