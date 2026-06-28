const text = document.querySelector('#colorText');
const color = document.querySelector('#colorPicker');
console.log(document.querySelector('#colorPicker').value)
const colorNames = {
    '#ffffff': '(white)',
    '#000000': '(black)',
    '#ff0000': '(red)',
    '#00ff00': '(green)'
};
const colorBg = () => {
    document.body.style.background = color.value;
    const name = colorNames[color.value] || '';
    text.textContent = `カラーコード: ${color.value} ${name}`;
}
color.addEventListener('input', colorBg);


