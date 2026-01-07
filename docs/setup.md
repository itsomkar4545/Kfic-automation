# KFIC Automation Framework - Setup Guide

## Prerequisites

### System Requirements
- **Python**: 3.9 or higher
- **Operating System**: Windows 10+, macOS 10.15+, or Ubuntu 18.04+
- **Memory**: Minimum 8GB RAM (16GB recommended for parallel execution)
- **Storage**: At least 2GB free space

### Required Software
1. **Python 3.9+** - [Download](https://www.python.org/downloads/)
2. **Git** - [Download](https://git-scm.com/downloads)
3. **Chrome Browser** - [Download](https://www.google.com/chrome/)
4. **Firefox Browser** (Optional) - [Download](https://www.mozilla.org/firefox/)

## Installation Steps

### 1. Clone Repository
```bash
git clone <repository-url>
cd kfic-automation-framework
```

### 2. Create Virtual Environment
```bash
# Windows
python -m venv venv
venv\Scripts\activate

# macOS/Linux
python3 -m venv venv
source venv/bin/activate
```

### 3. Install Dependencies
```bash
pip install -r requirements.txt
```

### 4. Install WebDrivers
```bash
# Automatic installation (recommended)
python -c "from webdriver_manager.chrome import ChromeDriverManager; ChromeDriverManager().install()"
python -c "from webdriver_manager.firefox import GeckoDriverManager; GeckoDriverManager().install()"
```

### 5. Configure Environment
1. Copy `config/environment.robot` and update URLs and credentials
2. Update `data/users.json` with actual user credentials
3. Update `data/leads.json` with test data

## Configuration

### Environment Configuration
Edit `config/environment.robot`:
```robot
*** Variables ***
${ENVIRONMENT}    dev  # Change to: dev, uat, prod

&{URLS}
...    dev=http://your-dev-url.com
...    uat=http://your-uat-url.com
...    prod=http://your-prod-url.com
```

### Browser Configuration
```robot
${BROWSER}        chrome    # Options: chrome, firefox, edge
${HEADLESS}       False     # Set to True for headless execution
```

### Database Configuration
```robot
&{DB_CONFIG}
...    dev_host=your-db-host
...    dev_port=3306
...    dev_name=your-database
```

## Verification

### Test Installation
```bash
# Run a simple test
robot --variable ENVIRONMENT:dev tests/los/lead_creation.robot

# Check if all dependencies are installed
python -c "import robot, selenium, requests; print('All dependencies installed successfully')"
```

### Verify WebDriver Setup
```bash
# Test Chrome WebDriver
python -c "from selenium import webdriver; from webdriver_manager.chrome import ChromeDriverManager; driver = webdriver.Chrome(ChromeDriverManager().install()); driver.quit(); print('Chrome WebDriver working')"
```

## Troubleshooting

### Common Issues

#### 1. WebDriver Issues
**Problem**: WebDriver not found or version mismatch
**Solution**:
```bash
pip install --upgrade webdriver-manager
python -c "from webdriver_manager.chrome import ChromeDriverManager; ChromeDriverManager().install()"
```

#### 2. Permission Issues (Windows)
**Problem**: Permission denied when installing packages
**Solution**: Run command prompt as Administrator

#### 3. SSL Certificate Issues
**Problem**: SSL certificate verification failed
**Solution**:
```bash
pip install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org -r requirements.txt
```

#### 4. Import Errors
**Problem**: Module not found errors
**Solution**:
```bash
# Ensure virtual environment is activated
# Windows
venv\Scripts\activate

# macOS/Linux
source venv/bin/activate

# Reinstall requirements
pip install -r requirements.txt
```

### Environment-Specific Setup

#### Windows Setup
```batch
# Install Chocolatey (optional, for easier package management)
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install Python via Chocolatey
choco install python

# Install Git
choco install git
```

#### macOS Setup
```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Python
brew install python@3.11

# Install Git
brew install git
```

#### Ubuntu Setup
```bash
# Update package list
sudo apt update

# Install Python and pip
sudo apt install python3.11 python3.11-venv python3-pip

# Install Git
sudo apt install git

# Install Chrome
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install google-chrome-stable
```

## Docker Setup (Optional)

### Build Docker Image
```bash
cd docker
docker build -t kfic-automation .
```

### Run Tests in Docker
```bash
# Run single container
docker run --rm -v $(pwd)/results:/app/results kfic-automation

# Run with Docker Compose (includes Selenium Grid)
docker-compose up --build
```

## IDE Setup

### Visual Studio Code
1. Install Python extension
2. Install Robot Framework Language Server extension
3. Configure Python interpreter to use virtual environment

### PyCharm
1. Configure Python interpreter to use virtual environment
2. Install Robot Framework Support plugin
3. Configure run configurations for Robot Framework

## Next Steps
- [Writing Tests Guide](writing-tests.md)
- [CI/CD Integration](cicd.md)
- [Best Practices](best-practices.md)