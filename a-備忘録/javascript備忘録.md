# javascript

- textContent->document.getElementById("要素名").textContent
               document.querySelector(".クラス名").textContent
               document.querySelector("#id名").textContent
                これによって、("")の中身の文字列を抽出できる。代入式にすれば、代入結果が返却される。
                = "新しい文字列" で中身の文字列を変更できる。

- innerHTML->textContentと同様に使えるが、HTMLタグも認識する。
                <h1>見出し</h1>
                のように文字列の中にHTMLタグを入れることができ、<h1>が<h1>として解釈される。
                textContentだと無視される。

- style-> 