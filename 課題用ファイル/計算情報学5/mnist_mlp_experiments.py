import torch
import torch.nn as nn
import torchvision
import torchvision.transforms as transforms
import time
import os

class NNet(nn.Module):
    def __init__(self, in_size, hidden_sizes, out_size):
        super().__init__()
        self.layers = nn.ModuleList()
        # 入力層から最初の隠れ層へ
        self.layers.append(nn.Linear(in_size, hidden_sizes[0]))
        # 隠れ層から隠れ層へ
        for i in range(len(hidden_sizes) - 1):
            self.layers.append(nn.Linear(hidden_sizes[i], hidden_sizes[i+1]))
        # 最後の隠れ層から出力層へ
        self.output_layer = nn.Linear(hidden_sizes[-1], out_size)
        self.act = nn.Sigmoid()

    def forward(self, x):
        for layer in self.layers:
            x = self.act(layer(x))
        y = self.output_layer(x)
        return y

def train_model(model, train_loader, criterion, optimizer, device):
    train_loss = 0.0
    correct = 0
    total = 0
    model.train()
    for images, labels in train_loader:
        images, labels = images.view(-1, 28*28).to(device), labels.to(device)
        optimizer.zero_grad()
        outputs = model(images)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()
        train_loss += loss.item()
        
        _, predicted = torch.max(outputs.data, 1)
        total += labels.size(0)
        correct += (predicted == labels).sum().item()
        
    return train_loss / len(train_loader), 100 * correct / total

def test_model(model, test_loader, criterion, device):
    test_loss = 0.0
    correct = 0
    total = 0
    model.eval()
    with torch.no_grad():
        for images, labels in test_loader:
            images, labels = images.view(-1, 28*28).to(device), labels.to(device)
            outputs = model(images)
            loss = criterion(outputs, labels)
            test_loss += loss.item()
            
            _, predicted = torch.max(outputs.data, 1)
            total += labels.size(0)
            correct += (predicted == labels).sum().item()
            
    return test_loss / len(test_loader), 100 * correct / total

def run_experiment(num_layers, hidden_nodes):
    device = 'cuda' if torch.cuda.is_available() else 'cpu'
    dataset_root = './data'
    transform = transforms.ToTensor()
    train_data = torchvision.datasets.MNIST(root=dataset_root, train=True, transform=transform, download=True)
    train_loader = torch.utils.data.DataLoader(dataset=train_data, batch_size=256, shuffle=True)
    test_data = torchvision.datasets.MNIST(root=dataset_root, train=False, transform=transform, download=True)
    test_loader = torch.utils.data.DataLoader(dataset=test_data, batch_size=256, shuffle=True)

    in_size = 28*28
    out_size = 10
    hidden_sizes = [hidden_nodes] * num_layers
    
    model = NNet(in_size, hidden_sizes, out_size).to(device)
    criterion = nn.CrossEntropyLoss()
    # 最適化手法: PDFに合わせてSGDを使用
    optimizer = torch.optim.SGD(model.parameters(), lr=0.01)
    
    num_epochs = 10
    print(f"=== Experiment: Layers={num_layers}, Nodes={hidden_nodes} ===")
    start_time = time.time()
    for epoch in range(1, num_epochs + 1):
        train_loss, train_acc = train_model(model, train_loader, criterion, optimizer, device)
        test_loss, test_acc = test_model(model, test_loader, criterion, device)
        print(f"Epoch {epoch}/{num_epochs} - Test Acc: {test_acc:.2f}%")
        
    elapsed_time = time.time() - start_time
    print(f"Time: {elapsed_time:.2f} s\n")
    return test_acc, elapsed_time

if __name__ == "__main__":
    layers_list = [1, 2, 3]
    nodes_list = [512, 1024, 2048]
    results = []
    
    print("実験を開始します...")
    for num_layers in layers_list:
        for num_nodes in nodes_list:
            acc, elapsed = run_experiment(num_layers, num_nodes)
            results.append((num_layers, num_nodes, acc, elapsed))
            
    summary = "=== Summary of Results ===\n"
    summary += f"{'Layers':<8} | {'Nodes':<8} | {'Accuracy (%)':<15} | {'Time (s)':<10}\n"
    summary += "-" * 50 + "\n"
    for res in results:
        summary += f"{res[0]:<8} | {res[1]:<8} | {res[2]:<15.2f} | {res[3]:<10.2f}\n"
        
    print(summary)
    
    with open("experiment_results.txt", "w", encoding="utf-8") as f:
        f.write(summary)
    print("結果を experiment_results.txt に保存しました。")
