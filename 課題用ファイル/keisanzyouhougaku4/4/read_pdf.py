import sys
import os
import pypdf

pdf_path = sys.argv[1]
reader = pypdf.PdfReader(pdf_path)
num_pages = len(reader.pages)
start_page = max(0, num_pages - 3)

with open('output.txt', 'w', encoding='utf-8') as f:
    for i in range(start_page, num_pages):
        f.write(f'--- Page {i+1} ---\n')
        f.write(reader.pages[i].extract_text() + '\n')
