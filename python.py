import random

def guess_the_number():
    print("=== 数当てゲーム ===")
    target = random.randint(1, 100)
    attempts = 0
    
    print("1から100までの数字を当ててください！")
    
    while True:
        try:
            guess = int(input("予想した数字を入力: "))
            attempts += 1
            
            if guess < target:
                print("もっと大きい数字です！")
            elif guess > target:
                print("もっと小さい数字です！")
            else:
                print(f"正解！ {attempts}回で当てました！")
                break
        except ValueError:
            print("有効な数字を入力してください。")

if __name__ == "__main__":
    guess_the_number()