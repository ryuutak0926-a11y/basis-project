import sys
import os
from PIL import Image

def compress_image(input_path, max_size_kb=100):
    output_path = "compressed_" + os.path.basename(input_path)
    
    # Try opening the image
    try:
        img = Image.open(input_path)
    except Exception as e:
        print(f"画像を開けませんでした: {e}")
        return
    
    # Convert to RGB if it's RGBA or P (to save as JPEG)
    if img.mode in ("RGBA", "P"):
        img = img.convert("RGB")
        
    # We will save as JPEG to control quality and size
    if not output_path.lower().endswith('.jpg') and not output_path.lower().endswith('.jpeg'):
        output_path = os.path.splitext(output_path)[0] + '.jpg'

    quality = 95
    step = 5
    
    # Save first to see the size
    img.save(output_path, "JPEG", quality=quality)
    
    # Decrease quality until the file size is under max_size_kb
    while os.path.getsize(output_path) > max_size_kb * 1024 and quality > 10:
        quality -= step
        img.save(output_path, "JPEG", quality=quality)
        
    # If still too large, we need to resize the image dimensions
    while os.path.getsize(output_path) > max_size_kb * 1024:
        width, height = img.size
        new_width = int(width * 0.9)
        new_height = int(height * 0.9)
        if new_width < 10 or new_height < 10:
            break
        img = img.resize((new_width, new_height), Image.Resampling.LANCZOS)
        img.save(output_path, "JPEG", quality=quality)

    final_size = os.path.getsize(output_path) / 1024
    print(f"圧縮完了: {output_path} (サイズ: {final_size:.2f} KB)")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("使い方: python compress_image.py <画像ファイル名>")
    else:
        compress_image(sys.argv[1])
