const menu = document.querySelector("#menu");

const pets = [
    {   //1匹目
        link: "../html/sakumatu.html",
        name: "さくちゃんとまっちゃん",
        image: "../img/cat_dog.jpg",
        explain: "二匹仲良し"
    },
    {   //2匹目
        link: "../html/matuko.html",
        name: "まっちゃん",
        image: "../img/cat_ma.jpg",
        explain: "穏やかな性格"
    },
    {   //3匹目
        link: "../html/me_chan.html",
        name: "めーちゃん",
        image: "../img/cat_me.jpg",
        explain: "人んちの猫一号"
    },
    {   //4匹目
        link: "../html/ku_chan.html",
        name: "くーちゃん",
        image: "../img/cat_qu.jpg",
        explain: "人んちの猫二号"
    },
    {   //5匹目
        link: "../html/sakura.html",
        name: "さくちゃん",
        image: "../img/dog_sa.jpg",
        explain: "おてんばガール"
    }
]

for (let pet of pets) {
    menu.insertAdjacentHTML("beforeend", `<div><img src="${pet.image}" alt=""><h2>${pet.name}</h2><p>${pet.explain}</p></div>`)
}


// alert("こんにちは");
// alert(sakumatu.name);

// const pets = [
//     "../img/cat_dog.jpg",
//     "../img/cat_ma.jpg",
//     "../img/cat_me.jpg",
//     "../img/cat_qu.jpg",
//     "../img/dog_sa.jpg"
// ];

// const =[
//     { さくらとまっちゃん }
//     { まっちゃん }
//     { めーちゃん }
//     { くーちゃん }
//     { さくらちゃん }
// ];



// const list1 = `<div><img src="../img/cat_dog.jpg" alt=""></div>`
// const list2 = `<div><img src="../img/cat_ma.img" alt=""></div>`
// const list3 = `<div><img src="../img/cat_me.img" alt=""></div>`
// const list4 = `<div><img src="../img/cat_qu.img" alt=""></div>`
// const list5 = `<div><img src="../img/dog_sa.img" alt=""></div>`
//これでやると定数を大量に定義しなくてはいけない



//menu.textContent = content;
//上のじゃ文字列が出来るだけでうまくいかない

//menu.insertAdjacentHTML("beforeend", pets);

// for (let pet of pets) {
//     menu.insertAdjacentHTML("beforeend", `<div><img src="${pet}" alt=""></div>`);
// }

