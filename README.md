# Ansible Sandbox

Welcome to the **Ansible Sandbox** repository. This repository contains various Ansible playbooks and configurations for learning and testing purposes.

## Overview

The Ansible Sandbox repository is designed to help you get hands-on experience with Ansible by providing a variety of playbooks for different scenarios. It includes examples of common tasks such as setting up monitoring stack, databases, pinging servers, and more.

## Getting Started

### Prerequisites

Before you start, ensure you have the following installed:

- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) (v2.15 or higher recommended)
- [Python](https://www.python.org/downloads/) (v3.11 or higher recommended)

### **Run Playbook**

### **Clone the Repository:**

   ```bash
   git clone git@github.com:ftmfauzi/ansible-sandbox.git
   cd ansible-sandbox
   ```

#### **Install the Entire Stack**

```bash
ansible-playbook -i inventory.yml playbook/<playbook-name>.yml
```

#### **Example: Install Node Exporter**
```bash
ansible-playbook -i inventory.yml playbook/install_node_exporter.yml
```

---
## 📌 Troubleshooting
### **1.Ensure SSH Connectivity**
Try checking SSH connection manually:
```bash
ssh myuser@ip_host
```
If it fails, make sure your **SSH key or password is correct**.

### **2. Check Service Status**
If issues arise after installation, run:
```bash
systemctl status prometheus
systemctl status alertmanager
systemctl status node_exporter
```

### **3. Remove Configuration Manually**
If necessary, manual uninstall try removing it manually::
```bash
sudo systemctl stop prometheus alertmanager node_exporter
sudo systemctl disable prometheus alertmanager node_exporter
sudo rm -rf /etc/prometheus /var/lib/prometheus /usr/local/bin/prometheus
sudo rm -rf /usr/local/bin/node_exporter
```
### **4. Check Logs with journalctl**

- View all logs from the current boot session for historical debugging:
```bash
sudo journalctl -u alertmanager.service -b --no-pager
```
- View logs live (real-time monitoring):
```bash
sudo journalctl -u alertmanager -f
```

### **5. Check Firewall Status**
- Check the firewall configuration on the target VM
- Ensure no ports are being blocked, especially for:

  - Prometheus: 9090

  - Alertmanager: 9093

  - Node Exporter: 9100
---

## 🛠 Maintainer
- **DevOps Engineer** - @ftmfauzi
- **Email**: ftmusyafa@gmail.com

Happy Monitoring! 🚀