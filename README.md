# Miniterm Revamped

An interactive command-line terminal selection menu framework built with **Ruby** and a platform-specific launcher: **Bash** on macOS/Linux and **Windows Batch** on Windows. It uses the `tty-prompt` library for arrow-key navigation through system tools and network diagnostics.

## 🚀 Features
- 🎹 Interactive arrow-key navigation.
- 🔗 State bridging between the Ruby UI and the platform-specific launcher.
- 🌐 Network diagnostics panel (Local & Public IP discovery).
- 💻 Disk and memory summaries on macOS/Linux and Windows.

## 📋 Prerequisites
Install Ruby 3.x or later and ensure `ruby` and `gem` are available on your `PATH`. On macOS, you can install Ruby with:
```bash
brew install ruby
```

On Windows, install Ruby (for example, using [RubyInstaller](https://rubyinstaller.org/)) and select the option to add Ruby to your `PATH`.

## 🛠️ Installation & Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/EndlessEngeneering/Miniterm-Revamped.git
   cd Miniterm-Revamped
   ```
2. Install the required text navigation gem:
   ```bash
   gem install tty-prompt --no-document
   ```
3. On macOS/Linux, make the launcher executable:
   ```bash
   chmod +x INIT.sh
   ```
4. Launch the platform-specific script:
   - macOS/Linux:
   ```bash
   ./INIT.sh
   ```
   - Windows Command Prompt:
   ```bat
   INIT.bat
   ```
