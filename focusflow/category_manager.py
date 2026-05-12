import json
import os
import sys

if getattr(sys, 'frozen', False):
    base_path = os.path.dirname(sys.executable)
else:
    base_path = os.path.dirname(__file__)

CATEGORIES_FILE = os.path.join(base_path, "categories.json")

def load_categories():
    """categories.jsonからカテゴリーリストを読み込む"""
    if not os.path.exists(CATEGORIES_FILE):
        return ["Coding", "Study", "Report"]
    try:
        with open(CATEGORIES_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    except Exception:
        return ["Coding", "Study", "Report"]

def save_categories(categories):
    """categories.jsonへカテゴリーリストを保存する"""
    with open(CATEGORIES_FILE, "w", encoding="utf-8") as f:
        json.dump(categories, f, indent=4, ensure_ascii=False)

def select_category():
    """
    ユーザーに対話形式でカテゴリーを選択させ、
    選択されたカテゴリー名と詳細（任意）を返す。
    """
    categories = load_categories()
    
    while True:
        print("\n=== カテゴリー選択 ===")
        for i, cat in enumerate(categories, 1):
            print(f"{i}. {cat}")
        print(f"{len(categories) + 1}. その他 (Other)")
        
        try:
            choice = input(f"カテゴリー番号を選択してください (1-{len(categories) + 1}): ")
            choice_idx = int(choice) - 1
            
            if 0 <= choice_idx < len(categories):
                selected_cat = categories[choice_idx]
                break
            elif choice_idx == len(categories):
                # その他を選択
                print("\n[その他] 新しいカテゴリーを設定します。")
                print("A. 恒久的追加 (リストに保存し、次回以降も表示)")
                print("B. 単発利用 (今回のみ使用し、リストには保存しない)")
                
                while True:
                    sub_choice = input("選択してください (A/B): ").strip().upper()
                    if sub_choice == 'A':
                        new_cat = input("新しいカテゴリー名を入力: ").strip()
                        if new_cat:
                            categories.append(new_cat)
                            save_categories(categories)
                            selected_cat = new_cat
                            break
                        else:
                            print("カテゴリー名が空です。もう一度入力してください。")
                    elif sub_choice == 'B':
                        new_cat = input("一時的なカテゴリー名を入力: ").strip()
                        if new_cat:
                            selected_cat = new_cat
                            break
                        else:
                            print("カテゴリー名が空です。もう一度入力してください。")
                    else:
                        print("A または B を入力してください。")
                break
            else:
                print("無効な番号です。正しい番号を選択してください。")
        except ValueError:
            print("数字を入力してください。")
            
    detail = input(f"\n[{selected_cat}] に対する詳細な作業内容を入力 (任意): ").strip()
    return selected_cat, detail

if __name__ == "__main__":
    # テスト用
    cat, detail = select_category()
    print(f"\n結果 -> カテゴリー: {cat}, 詳細: {detail}")
