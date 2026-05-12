import csv
import os
import sys
from datetime import datetime

if getattr(sys, 'frozen', False):
    base_path = os.path.dirname(sys.executable)
else:
    base_path = os.path.dirname(__file__)

LOGS_FILE = os.path.join(base_path, "logs.csv")

def log_session(category: str, detail: str, duration_minutes: float):
    """
    セッションの結果を logs.csv に記録する。
    ファイルが存在しない場合はヘッダー付きで新規作成する。
    """
    file_exists = os.path.isfile(LOGS_FILE)
    
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    try:
        with open(LOGS_FILE, mode='a', encoding='utf-8', newline='') as f:
            writer = csv.writer(f)
            
            # 初回作成時にヘッダーを書き込む
            if not file_exists:
                writer.writerow(["timestamp", "category", "detail", "duration"])
                
            writer.writerow([timestamp, category, detail, duration_minutes])
    except Exception as e:
        print(f"ログの保存に失敗しました: {e}")

if __name__ == "__main__":
    # テスト用
    log_session("TestCategory", "Test detail", 25)
    print("ログのテスト書き込みが完了しました。")
