import sys
from category_manager import select_category
from timer_utils import run_timer
from logger import log_session

def main():
    print("==============================")
    print("       FocusFlow CLI          ")
    print("==============================\n")
    
    try:
        # 基本のタイマー時間 (要件では標準的なポモドーロ)
        # 今回は25分とする
        duration_minutes = 25
        
        # 1. カテゴリー選択
        category, detail = select_category()
        
        print(f"\n[確認] カテゴリー: {category}")
        if detail:
            print(f"[確認] 詳細: {detail}")
        
        # 2. タイマー実行
        run_timer(duration_minutes, category)
        
        # 3. ログ記録
        log_session(category, detail, duration_minutes)
        print("セッションの記録が完了しました。")
        
    except KeyboardInterrupt:
        print("\n\n[キャンセル] FocusFlow を終了します。")
        sys.exit(0)
    except Exception as e:
        print(f"\nエラーが発生しました: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
