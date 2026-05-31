import torch
import torch.nn as nn
import torch.nn.functional as f
import torchvision
import torchvision.transforms as transforms
import matplotlib.pyplot as plt

def load_MNISTtrain(batch):
    transform = transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize((0.1307,), (0.3081,))
    ])
    train_set = torchvision.datasets.MNIST(
        root="./data", train=True, download=True, transform=transform
    )
    train_loader = torch.utils.data.DataLoader(
        train_set, batch_size=batch, shuffle=True, num_workers=2
    )
    return train_loader

def load_MNISTtest(batch):
    transform = transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize((0.1307,), (0.3081,))
    ])
    test_set = torchvision.datasets.MNIST(
        root="./data", train=False, download=True, transform=transform
    )
    test_loader = torch.utils.data.DataLoader(
        test_set, batch_size=batch, shuffle=True, num_workers=2
    )
    return test_loader

class NNet(nn.Module):
    def __init__(self):
        super(NNet, self).__init__()
        self.conv1 = nn.Conv2d(1, 32, 3, 1)
        self.conv2 = nn.Conv2d(32, 64, 3, 1)
        self.pool = nn.MaxPool2d(2, 2)
        self.dropout = nn.Dropout2d(0.25)
        self.fc = nn.Linear(12*12*64, 128)

    def forward(self, x):
        x = self.conv1(x)
        x = f.relu(x)
        x = self.conv2(x)
        x = f.relu(x)
        x = self.pool(x)
        x = self.dropout(x)
        x = x.view(-1, 12*12*64)
        x = self.fc(x)
        return f.log_softmax(x, dim=1)

def main():
    epoch = 3
    batch_size = 64

    data_train = load_MNISTtrain(batch=batch_size)
    data_test = load_MNISTtest(batch=batch_size)

    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    print("Device:", device)
    
    model = NNet().to(device)
    print(model)
    
    criterion = nn.CrossEntropyLoss()
    print(criterion)
    
    optimizer = torch.optim.Adam(params=model.parameters(), lr=0.001)
    print(optimizer)

    train_loss_history = []
    test_loss_history = []

    for e in range(epoch):
        model.train()
        loss_val = None
        train_loss = 0.0
        count = 0
        
        for i, (data, label) in enumerate(data_train):
            data, label = data.to(device), label.to(device)
            optimizer.zero_grad()
            output = model(data)
            loss_val = criterion(output, label)
            train_loss += loss_val.item()
            count += 1
            loss_val.backward()
            optimizer.step()

            if i % 100 == 99:
                print("Training: {} epoch. {} iteration. Loss: {:.4f}".format(e+1, i+1, loss_val.item()))
        
        train_loss /= count
        
        model.eval()
        test_loss = 0.0
        count_test = 0
        with torch.no_grad():
            for data, label in data_test:
                data, label = data.to(device), label.to(device)
                output = model(data)
                loss_val = criterion(output, label)
                test_loss += loss_val.item()
                count_test += 1
                predict = output.argmax(dim=1, keepdim=True)
                
        test_loss /= count_test
        
        print("Training loss (ave.): {:.4f}  Test loss: {:.4f} \n".format(train_loss, test_loss))
        
        train_loss_history.append(train_loss)
        test_loss_history.append(test_loss)

    try:
        plt.figure()
        plt.plot(range(1, epoch+1), train_loss_history, label='Train Loss', marker='o')
        plt.plot(range(1, epoch+1), test_loss_history, label='Test Loss', marker='o')
        plt.xlabel('Epoch')
        plt.ylabel('Loss')
        plt.title('Loss Convergence Curve (Dropout)')
        plt.legend()
        plt.grid(True)
        plt.savefig('loss_curve_dropout.png') 
        plt.show()
    except Exception as ex:
        print("グラフの描画・保存に失敗しました:", ex)

if __name__ == "__main__":
    main()
