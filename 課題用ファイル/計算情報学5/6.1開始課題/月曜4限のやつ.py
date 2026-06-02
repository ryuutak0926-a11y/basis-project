import torch
import torch.nn as nn
import numpy as np
import matplotlib.pyplot as plt

class PINN(nn.Module):
    def __init__(self):
        super(PINN, self).__init__()
        self.net = nn.Sequential(
            nn.Linear(1, 16),
            nn.Tanh(),
            nn.Linear(16, 16),
            nn.Tanh(),
            nn.Linear(16, 1)
        )
    def forward(self, x):
        return self.net(x)

def loss_func(model, x, u0, u1):
    x_bc0 = torch.tensor([[0.0]], requires_grad=True)
    x_bc1 = torch.tensor([[1.0]], requires_grad=True)
    loss_bc0 = torch.mean((model(x_bc0) - u0)**2)
    loss_bc1 = torch.mean((model(x_bc1) - u1)**2)
    x.requires_grad = True
    u = model(x)
    u_x = torch.autograd.grad(u , x, grad_outputs=torch.ones_like(u), create_graph=True)[0]
    u_xx = torch.autograd.grad(u_x, x, grad_outputs=torch.ones_like(u), create_graph=True)[0]
    residual = u_xx - 1.0
    loss_pde = torch.mean(residual**2)
    return loss_bc0 + loss_bc1 + loss_pde

u0 = 0.0
u1 = 1.0
model = PINN()
optimizer = torch.optim.Adam(model.parameters(), lr=0.01)
x_data = torch.linspace(0, 1, 10).view(-1, 1)
epochs = 100
for epoch in range(epochs):
    optimizer.zero_grad()
    loss = loss_func(model, x_data, u0, u1)
    loss.backward()
    optimizer.step()
    if epoch % 10 == 0:
        print(f'Epoch {epoch}, Loss: {loss.item():.6f}')

x_test = torch.linspace(0, 1, 20).view(-1, 1)
u_pred = model(x_test).detach().numpy()
u_analytical = (x_test * x_test + x_test)/2
plt.plot(x_test.numpy(), u_pred, label='PINN Prediction', color='red')
plt.plot(x_test.numpy(), u_analytical, label='Analytical Solution', linestyle='--')
plt.xlabel('x')
plt.ylabel('u')
plt.legend()
plt.show()

def loss_func_cooling(model, t, T_initial, T_env, k):
    # 初期条件（t = 0 における温度が T_initial になるように）の損失
    t_bc = torch.tensor([[0.0]], requires_grad=True)
    loss_bc = torch.mean((model(t_bc) - T_initial)**2)
    
    # 物理法則 (PDE) の損失 (dT/dt + k * (T - T_env) = 0)
    t.requires_grad = True
    T = model(t)
    T_t = torch.autograd.grad(T, t, grad_outputs=torch.ones_like(T), create_graph=True)[0]
    residual = T_t + k * (T - T_env)
    loss_pde = torch.mean(residual**2)
    
    return loss_bc + loss_pde