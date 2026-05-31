import torch
import torch.nn as nn
import torch.nn.functional as F
import torchvision
import torchvision.transforms as transforms
import matplotlib.pyplot as mpl

class NNet(nn.Module):
    def __init__(self, in_size, h1_size, out_size):
        super().__init__()
        self.l1 = nn.Linear(in_size, h1_size)
        self.l2 = nn.Linear(h1_size, out_size)
        self.act = nn.Sigmoid()

    def forward(self, x):
        h1 = self.act(self.l1(x))
        y = self.l2(h1)
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

    train_loss = train_loss / num_train

    return train_loss


def test_model(model, test_loader, criterion, device):
    test_loss = 0.0
    num_test = 0
    model.eval() # 評価モード

    with torch.no_grad():
        for i, (images, labels) in enumerate(test_loader):
            num_test += len(labels)
            images, labels = images.view(-1, 28*28).to(device), labels.to(device)
            outputs = model(images)
            loss = criterion(outputs, labels)
            test_loss += loss.item()
    test_loss = test_loss / num_test
    return test_loss


def lerning(model, train_loader, test_loader, criterion, optimizer, num_epochs, device):
    train_loss_list = []
    test_loss_list = []

    for epoch in range(1, num_epochs+1, 1):
        train_loss = train_model(model, train_loader, criterion, optimizer, device)
        test_loss = test_model(model, test_loader, criterion, device)
        print("{} train_loss: {:.5f} test_loss: {:.5f}".format(epoch, train_loss, test_loss))
        train_loss_list.append(train_loss)
        test_loss_list.append(test_loss)
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
