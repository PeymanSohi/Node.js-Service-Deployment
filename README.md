# 🚀 Node.js CI/CD Deployment Project

This project automates the full lifecycle of a Node.js service deployment using **Terraform**, **Ansible**, and **GitHub Actions**.

You will:
- Provision servers using Terraform 🌎
- Configure them automatically using Ansible ⚙️
- Build and deploy a Node.js application 🚀
- Setup GitHub Actions for automatic deployments on push 🛠️

---

## 📜 Architecture Overview

```plaintext
GitHub Push -> GitHub Actions -> SSH into Server -> Pull Latest Code -> Install Dependencies -> Restart Node App (PM2)
```

**Stack:**
- Terraform (Provision Infrastructure)
- Ansible (Configuration Management)
- Node.js + Express (Backend Service)
- GitHub Actions (CI/CD Pipeline)
- PM2 (Process Manager for Node.js)
- Ubuntu 22.04 Server (Hosted on DigitalOcean or any Cloud)

---

## 📁 Project Structure

```bash
project-root/
├── terraform/
│   └── main.tf
├── ansible/
│   ├── inventory.ini
│   ├── node_service.yml
│   └── roles/
│       ├── base/
│       │   └── tasks/main.yml
│       └── app/
│           └── tasks/main.yml
├── node-app/
│   ├── server.js
│   ├── package.json
│   └── ecosystem.config.js (optional)
├── .github/
│   └── workflows/
│       └── deploy.yml
└── README.md
```

---

## 🛠 Setup Instructions

### 1. Provision Server using Terraform

- Go into `terraform/` directory
- Set your DigitalOcean API token and SSH key
- Apply Terraform:

```bash
terraform init
terraform apply
```

✅ Server will be provisioned automatically.

---

### 2. Configure Server using Ansible

- Update `ansible/inventory.ini` with your server IP:

```ini
[servers]
your_server_ip ansible_user=root
```

- Run Ansible Playbook:

```bash
cd ansible/
ansible-playbook -i inventory.ini node_service.yml --tags base
ansible-playbook -i inventory.ini node_service.yml --tags app
```

✅ Node.js, npm, git installed, app cloned and running.

---

### 3. Setup Node.js App

Inside `node-app/`:

**server.js**:

```javascript
const express = require('express');
const app = express();
const port = 80;

app.get('/', (req, res) => {
  res.send('Hello, world!');
});

app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});
```

**package.json**:

```json
{
  "name": "node-app",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
```

✅ App is a simple "Hello, world!" API running on port 80.

---

### 4. Setup CI/CD using GitHub Actions

**Create GitHub Secrets:**
- `SSH_PRIVATE_KEY` → Your private SSH key
- `SERVER_IP` → Your server's IP address

**Deploy workflow: `.github/workflows/deploy.yml`**

```yaml
name: Deploy Node App

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Install SSH Key
      uses: webfactory/ssh-agent@v0.9.0
      with:
        ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}

    - name: Deploy app
      run: |
        ssh -o StrictHostKeyChecking=no root@${{ secrets.SERVER_IP }} "
          cd /opt/node-app &&
          git pull origin main &&
          npm install --production &&
          pm2 restart node-app
        "
```

✅ Now every `git push` will automatically deploy the new version!

---

### 5. Bonus: PM2 Process Manager

We use PM2 to keep the Node.js app alive even after server restarts.

**Commands**:

```bash
# Install PM2
npm install -g pm2

# Start app
pm2 start server.js --name node-app

# Save processes
pm2 save

# Setup PM2 to auto-start on reboot
pm2 startup systemd
systemctl enable pm2-root
systemctl start pm2-root
```

✅ Application survives reboots without manual intervention.

---

## 📜 Useful Commands

| Command | Description |
|:-------|:------------|
| `terraform apply` | Provision server |
| `ansible-playbook node_service.yml --tags base` | Install Node.js, git |
| `ansible-playbook node_service.yml --tags app` | Deploy Node app |
| `pm2 list` | View running apps |
| `pm2 restart node-app` | Restart app manually |
| `ssh root@SERVER_IP` | SSH into server |

---

## 💬 Conclusion

Congratulations! 🎉  
You now know how to:
- Provision Infrastructure as Code (Terraform)
- Configure servers automatically (Ansible)
- Build a Node.js app
- Setup CI/CD pipelines (GitHub Actions)
- Keep apps running forever (PM2)

---
> Made with 💙 for DevOps Practice!

---

# 📈 Now your Node.js app is production ready!

---

https://roadmap.sh/projects/nodejs-service-deployment