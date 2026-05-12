import time
import winsound
from tqdm import tqdm
from plyer import notification

def run_timer(duration_minutes: int, task_name: str):
    """
    指定された分数のカウントダウンを行い、プログレスバーを表示する。
    終了時にビープ音とデスクトップ通知を行う。
    """
    total_seconds = int(duration_minutes * 60)
    
    print(f"\n[開始] {task_name} - {duration_minutes}分間")
    
    # プログレスバーの表示
    with tqdm(total=total_seconds, desc="Focusing", unit="s", bar_format="{desc}: {percentage:3.0f}%|{bar}| {n_fmt}/{total_fmt}s") as pbar:
        for _ in range(total_seconds):
            time.sleep(1)
            pbar.update(1)
            
    print(f"\n[終了] {task_name} の時間が終了しました！お疲れ様でした。\n")
    
    # 終了時のビープ音 (周波数, ミリ秒)
    winsound.Beep(1000, 500)
    winsound.Beep(1000, 500)
    
    # デスクトップ通知
    try:
        notification.notify(
            title="FocusFlow",
            message=f"{task_name} の時間が終了しました！",
            app_name="FocusFlow",
            timeout=10
        )
    except Exception as e:
        print(f"通知の送信に失敗しました（設定などを確認してください）: {e}")

if __name__ == "__main__":
    # テスト用
    run_timer(0.1, "Test Task")
