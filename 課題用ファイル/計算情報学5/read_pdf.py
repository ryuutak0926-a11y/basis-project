import sys
import subprocess

try:
    import pypdf
except ImportError:
    print("Installing pypdf...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "pypdf"])
    import pypdf

def read_pdf(file_path):
    try:
        reader = pypdf.PdfReader(file_path)
        text = ""
        for i, page in enumerate(reader.pages):
            text += f"--- Page {i+1} ---\n"
            text += page.extract_text() + "\n"
        with open("pdf_output.txt", "w", encoding="utf-8") as f:
            f.write(text)
        print("PDF extracted successfully to pdf_output.txt")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    read_pdf(r"c:\Users\ryuut\myproject\課題用ファイル\計算情報学5\mnist_pytorchMLP.pdf")
