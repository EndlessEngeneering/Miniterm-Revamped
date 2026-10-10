# Miniterm Revamped

An interactive command-line terminal selection menu framework built with **Bash** and **Ruby**. It leverages the `tty-prompt` library to allow seamless arrow-key navigation for system automations, local tools, and network diagnostics.

## 🚀 Features
- 🎹 Interactive arrow-key navigation.
- 🔗 Clean state bridging between Ruby UI layers and Bash system executions.
- 🌐 Network diagnostics panel (Local & Public IP discovery).

## 📋 Prerequisites
Before running the script, ensure you have a modern version of Ruby installed (Ruby 3.x is highly recommended). If you are on macOS:
```bash
brew install ruby
```

## 🛠️ Installation & Setup
1. Clone the repository:
   ```bash
   git clone https://github.com
   cd miniterm-revamped
   ```
2. Install the required text navigation gem:
   ```bash
   gem install tty-prompt --no-document
   ```
3. Give execution permissions to the scripts:
   ```bash
   chmod +x INIT.sh 1.rb
   ```
4. Launch the application:
   ```bash
   ./INIT.sh
   ```
