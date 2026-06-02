import os
import sys
import subprocess

# 必要なライブラリ pypdf がインストールされているか確認し、なければインストールします
try:
    import pypdf
except ImportError:
    print("pypdf をインストールしています...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "pypdf"])
    import pypdf

def convert_pdf_to_markdown(pdf_path, md_path):
    """
    PDFファイルを読み込み、テキストを抽出してMarkdownファイルとして保存します。
    """
    try:
        print(f"変換中: {os.path.basename(pdf_path)} -> {os.path.basename(md_path)}")
        reader = pypdf.PdfReader(pdf_path)
        
        markdown_content = []
        # PDFのファイル名を大見出しとして追加
        title = os.path.splitext(os.path.basename(pdf_path))[0]
        markdown_content.append(f"# {title}\n")
        
        for i, page in enumerate(reader.pages):
            markdown_content.append(f"## ページ {i + 1}\n")
            text = page.extract_text()
            if text:
                markdown_content.append(text + "\n")
            else:
                markdown_content.append("*(このページからはテキストを抽出できませんでした)*\n")
            markdown_content.append("\n---\n")
            
        # 最後の改行・区切り線を調整して書き出し
        with open(md_path, "w", encoding="utf-8") as f:
            f.write("".join(markdown_content))
            
        print(f"変換成功: {md_path}")
    except Exception as e:
        print(f"エラーが発生しました ({pdf_path}): {e}")

def main():
    # 対象のディレクトリを設定します
    target_dir = r"c:\Users\ryuut\fundmental-project\課題用ファイル\計算情報学5\6.1開始課題"
    
    # 変換対象のファイルリスト
    files_to_convert = [
        ("gymnasium.pdf", "gymnasium.md"),
        ("StableBaselines3-2.pdf", "StableBaselines3-2.md")
    ]
    
    for pdf_name, md_name in files_to_convert:
        pdf_path = os.path.join(target_dir, pdf_name)
        md_path = os.path.join(target_dir, md_name)
        
        if os.path.exists(pdf_path):
            convert_pdf_to_markdown(pdf_path, md_path)
        else:
            print(f"ファイルが見つかりません: {pdf_path}")

if __name__ == "__main__":
    main()
