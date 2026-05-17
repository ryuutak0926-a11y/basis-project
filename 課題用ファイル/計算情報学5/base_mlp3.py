import torch
import torch.nn as nn
import torch.nn.functional as F
import torchvision
import torchvision.transforms as transforms
import matplotlib.pyplot as mpl
import time

class NNet(nn.Module):
    def __init__(self, in_size, h1_size, out_size):
        super().__init__()
        self.l1 = nn.Linear(in_size, h1_size)
        self.l2 = nn.Linear(h1_size, h1_size)
        self.l3 = nn.Linear(h1_size, out_size)
        self.act = nn.Sigmoid()

    def forward(self, x):
        h1 = self.act(self.l1(x))
        h2 = self.act(self.l2(h1))
        y = self.l3(h2)
        return y


train_data = torchvision.datasets.MNIST(root='./data',
                                        train=True,
                                        transform=transforms.ToTensor(),
                                        download=True)
train_loader = torch.utils.data.DataLoader(dataset=train_data,
                                           batch_size=256,
                                           shuffle=True)

test_data = torchvision.datasets.MNIST(root='./data',
                                       train=False,
                                       transform=transforms.ToTensor(),
                                       download=True)
test_loader = torch.utils.data.DataLoader(dataset=test_data,
                                          batch_size=256,
                                          shuffle=True)

in_size = 28*28
h1_size = 1024
out_size = 10
device = 'cpu' # 'cuda' if torch.cuda.is_available() else 'cpu'
model = NNet(in_size, h1_size, out_size).to(device)
print(model)

# 損失関数：交差エントロピー誤差関数
criterion = nn.CrossEntropyLoss()

# 最適化法：SGD（確率的勾配降下法）
optimizer = torch.optim.SGD(model.parameters(), lr=0.01)


def train_model(model, train_loader, criterion, optimizer, device):
    train_loss = 0.0
    num_train = 0
    correct = 0
    model.train() # 学習モード

    for i, (images, labels) in enumerate(train_loader):
        num_train += len(labels)
        images, labels = images.view(-1, 28*28).to(device), labels.to(device)

        optimizer.zero_grad()
        outputs = model(images)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()
        train_loss += loss.item()
        
        _, predicted = torch.max(outputs.data, 1)
        correct += (predicted == labels).sum().item()

    train_loss = train_loss / num_train
    accuracy = 100.0 * correct / num_train
    return train_loss, accuracy


def test_model(model, test_loader, criterion, device):
    test_loss = 0.0
    num_test = 0
    correct = 0
    model.eval() # 評価モード

    with torch.no_grad():
        for i, (images, labels) in enumerate(test_loader):
            num_test += len(labels)
            images, labels = images.view(-1, 28*28).to(device), labels.to(device)
            outputs = model(images)
            loss = criterion(outputs, labels)
            test_loss += loss.item()
            
            _, predicted = torch.max(outputs.data, 1)
            correct += (predicted == labels).sum().item()
            
    test_loss = test_loss / num_test
    accuracy = 100.0 * correct / num_test
    return test_loss, accuracy


def lerning(model, train_loader, test_loader, criterion, optimizer, num_epochs, device):
    train_loss_list = []
    test_loss_list = []
    
    start_time = time.time()

    for epoch in range(1, num_epochs+1, 1):
        train_loss, train_acc = train_model(model, train_loader, criterion, optimizer, device)
        test_loss, test_acc = test_model(model, test_loader, criterion, device)
        print("Epoch {} - train_loss: {:.5f}, train_acc: {:.2f}% | test_loss: {:.5f}, test_acc: {:.2f}%".format(
            epoch, train_loss, train_acc, test_loss, test_acc))
        train_loss_list.append(train_loss)
        test_loss_list.append(test_loss)
        
    elapsed_time = time.time() - start_time
    print(f"\n計算時間: {elapsed_time:.2f} 秒")
    
    return train_loss_list, test_loss_list


num_epochs = 10
train_loss_list, test_loss_list = lerning(model, train_loader, test_loader, criterion, optimizer, num_epochs, device=device)

mpl.plot(range(len(train_loss_list)), train_loss_list, c='b', label='train loss')
mpl.plot(range(len(test_loss_list)), test_loss_list, c='r', label='test loss')
mpl.xlabel("epoch")
mpl.ylabel("loss")
mpl.legend()
mpl.grid()
mpl.show()
