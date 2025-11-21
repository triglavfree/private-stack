#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function for colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    print_error "Please run as root"
    exit 1
fi

print_status "Starting VPS optimization script for Ubuntu 24.04 Minimal"

# Step 1: System update
print_status "Step 1: Updating system packages..."
apt update && apt full-upgrade -y
if [ $? -eq 0 ]; then
    print_status "System update completed successfully"
else
    print_error "System update failed"
    exit 1
fi

# Step 2: Install essential packages
print_status "Step 2: Installing essential packages..."
apt install -y ufw fail2ban net-tools htop nethogs iotop curl wget git
if [ $? -eq 0 ]; then
    print_status "Packages installed successfully"
else
    print_error "Package installation failed"
    exit 1
fi

# Step 3: Configure UFW firewall
print_status "Step 3: Configuring UFW firewall..."
# Reset UFW to defaults
ufw --force reset

# Deny all incoming, allow all outgoing
ufw default deny incoming
ufw default allow outgoing

# Allow SSH on port 22
ufw allow 22/tcp

# Enable UFW
ufw --force enable

print_status "UFW configured: only SSH (22/tcp) allowed"

# Step 4: Configure Fail2Ban for SSH
print_status "Step 4: Configuring Fail2Ban..."
cat > /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3
backend = auto

[sshd]
enabled = true
port = ssh
logpath = /var/log/auth.log
maxretry = 3
bantime = 86400
EOF

systemctl enable fail2ban
systemctl start fail2ban
print_status "Fail2Ban configured for SSH protection"

# Step 5: Create swap file
print_status "Step 5: Creating 2GB swap file..."

# Check if swap already exists
if swapon --show | grep -q "."; then
    print_warning "Swap already exists. Skipping swap creation."
else
    # Create 2GB swap file
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    
    # Make swap permanent
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
    
    print_status "2GB swap file created and activated"
fi

# Step 6: System optimization
print_status "Step 6: Applying system optimizations..."

# Create sysctl configuration
cat > /etc/sysctl.d/99-optimization.conf << 'EOF'
# Network optimizations
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_fastopen = 3

# Memory and buffer optimizations
net.core.rmem_max = 67108864
net.core.wmem_max = 67108864
net.core.rmem_default = 131072
net.core.wmem_default = 131072
net.ipv4.tcp_rmem = 4096 87380 67108864
net.ipv4.tcp_wmem = 4096 65536 67108864
net.ipv4.tcp_mem = 786432 1048576 1572864

# Connection optimizations
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_max_syn_backlog = 65536
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 3
net.ipv4.tcp_retries2 = 8
net.ipv4.tcp_keepalive_time = 300
net.ipv4.tcp_keepalive_probes = 5
net.ipv4.tcp_keepalive_intvl = 15
net.core.netdev_max_backlog = 65536
net.core.somaxconn = 65535
net.ipv4.tcp_max_tw_buckets = 1440000
net.ipv4.tcp_tw_reuse = 1

# Additional optimizations
net.ipv4.tcp_limit_output_bytes = 262144
net.ipv4.tcp_moderate_rcvbuf = 1

# Memory and swap optimizations
vm.swappiness = 10
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5

# IPv6 disable (optional - remove if you need IPv6)
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF

# Apply sysctl settings
sysctl -p /etc/sysctl.d/99-optimization.conf

print_status "System optimizations applied"

# Step 7: Configure SSH for key authentication only
print_status "Step 7: Configuring SSH for key authentication..."

# Backup original sshd_config
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# Configure SSH for key-only authentication
cat > /etc/ssh/sshd_config.d/99-custom.conf << 'EOF'
# Key authentication only
PasswordAuthentication no
ChallengeResponseAuthentication no
UsePAM no

# Security settings
PermitRootLogin yes
PubkeyAuthentication yes
AuthorizedKeysFile .ssh/authorized_keys

# Performance settings
ClientAliveInterval 300
ClientAliveCountMax 2
MaxAuthTries 3
MaxSessions 10

# Protocol settings
Protocol 2
HostKey /etc/ssh/ssh_host_rsa_key
HostKey /etc/ssh/ssh_host_ed25519_key

# Cipher settings
KexAlgorithms curve25519-sha256@libssh.org
Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com
EOF

# Restart SSH service
systemctl restart ssh

print_warning "SSH configured for key authentication only!"
print_warning "Make sure you have SSH keys configured before disconnecting!"

# Step 8: Final checks
print_status "Step 8: Performing final checks..."

# Check swap
echo "--- Swap Status ---"
swapon --show
free -h

# Check UFW status
echo "--- UFW Status ---"
ufw status

# Check Fail2Ban status
echo "--- Fail2Ban Status ---"
systemctl status fail2ban --no-pager -l

# Check optimization settings
echo "--- Optimization Settings ---"
sysctl net.ipv4.tcp_congestion_control
sysctl vm.swappiness

print_status "VPS setup completed successfully!"
print_warning "IMPORTANT: Ensure SSH keys are configured before next login!"
print_warning "Current SSH session will remain active. Test new connection in another terminal first."

echo "----------------------------------------"
echo "Summary of changes:"
echo "✅ System updated"
echo "✅ UFW configured (SSH only)"
echo "✅ Fail2Ban installed and configured"
echo "✅ 2GB swap file created"
echo "✅ System optimizations applied"
echo "✅ SSH configured for key authentication"
echo "----------------------------------------"
