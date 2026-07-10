# javascript

- defer属性とはHTML要素 `<script src="..." defer></script>` に追加すると、scriptの実行を HTML読み込み後に実行する
基本的にやっといたほうがいい

- textContent->document.getElementById("要素名").textContent
               document.querySelector(".クラス名").textContent
               document.querySelector("#id名").textContent
                これによって、("")の中身の文字列を抽出できる。代入式にすれば、代入結果が返却される。
                = "新しい文字列" で中身の文字列を変更できる。

- innerHTML->textContentと同様に使えるが、HTMLタグも認識する。
                <h1>見出し</h1>
                のように文字列の中にHTMLタグを入れることができ、コード記号として解釈される。
                textContentだと無視される。

- 関数表示方法
    - アロー関数 ()=> 関数名 () {
        処理
    }  と書く。また、関数を呼び出すには関数名の後に()をつける。
        例： colorBg()
    
    - function 関数名 () {
        処理
    }
    二種類あるが、違いはまだ分からん！！
