import random
import math

def is_prime(n):
    if n <= 1:
        return False
    for i in range(2, int(math.sqrt(n)) + 1):
        if n % i == 0:
            return False
    return True

def guess_the_number():
    print("========================")
    print("   スーパー数当てゲーム   ")
    print("========================")
    
    while True:
        print("\n難易度を選択してください:")
        print("1: 初級 (1〜50、回数制限なし)")
        print("2: 中級 (1〜100、回数制限 10回)")
        print("3: 上級 (1〜500、回数制限 12回)")
        print("0: 終了")
        
        choice = input("選択: ")
        
        if choice == "0":
            print("ゲームを終了します。お疲れ様でした！")
            break
        
        if choice == "1":
            max_num, max_attempts = 50, float('inf')
        elif choice == "2":
            max_num, max_attempts = 100, 10
        elif choice == "3":
            max_num, max_attempts = 500, 12
        else:
            print("無効な選択です。")
            continue
            
        target = random.randint(1, max_num)
        attempts = 0
        hint_used = False
        
        print(f"\n【ゲームスタート】 1から{max_num}までの数字を当ててください！")
        if max_attempts != float('inf'):
            print(f"※制限回数は {max_attempts} 回です。")
        print("※「h」と入力するとヒントがもらえます（1回のみ）。")
        
        while attempts < max_attempts:
            # 残り回数の表示処理（無限の場合は表示を変える）
            if max_attempts == float('inf'):
                prompt_msg = f"\n予想した数字を入力 (現在 {attempts + 1} 回目): "
            else:
                prompt_msg = f"\n予想した数字を入力 (残り {max_attempts - attempts} 回): "
                
            user_input = input(prompt_msg)
            
            if user_input.lower() == 'h':
                if not hint_used:
                    hint_used = True
                    print("\n--- ヒント ---")
                    if target % 2 == 0:
                        print("・偶数です。")
                    else:
                        print("・奇数です。")
                    
                    if is_prime(target):
                        print("・素数です。")
                    else:
                        print("・素数ではありません。")
                    print("--------------")
                else:
                    print("ヒントはすでに使用しました！")
                continue
                
            try:
                guess = int(user_input)
            except ValueError:
                print("有効な数字を入力するか、'h'でヒントを見てください。")
                continue
                
            attempts += 1
            
            if guess < target:
                print("もっと大きい数字です！ 📈")
            elif guess > target:
                print("もっと小さい数字です！ 📉")
            else:
                # スコア計算
                score = max(0, 100 - (attempts - 1) * 10)
                if hint_used:
                    score -= 20
                print(f"\n🎉 大正解！ 🎉")
                print(f"{attempts}回目で当てました！")
                print(f"獲得スコア: {max(0, score)}点")
                break
        else:
            print(f"\nゲームオーバー... 😭 正解は {target} でした。")

if __name__ == "__main__":
    guess_the_number()