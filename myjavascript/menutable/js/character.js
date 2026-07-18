const body = document.querySelector('body');
const btn = document.querySelector('.toggle_btn');
const mask = document.querySelector('#mask');
const open = 'open';

// ボタンをクリックしたら、openクラスを「トグル（交互に切り替え）」する
btn.addEventListener('click', () => {
    body.classList.toggle(open);
});

// マスク（背景）をクリックしたら、openクラスを確実に消す
mask.addEventListener('click', () => {
    body.classList.remove(open);
});