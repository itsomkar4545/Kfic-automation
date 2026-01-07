# KFIC LOS & LMS Automation Framework

A modern, scalable test automation framework for KFIC Loan Origination System (LOS) and Loan Management System (LMS) built with Robot Framework, Python, and CI/CD integration.

## 🚀 Features

- **Modular Architecture**: Page Object Model with reusable components
- **Multi-Environment Support**: Dev, UAT, Production configurations
- **Parallel Execution**: Run tests in parallel for faster execution
- **CI/CD Integration**: Jenkins, GitHub Actions, Azure DevOps support
- **Advanced Reporting**: Allure reports with screenshots and videos
- **Data-Driven Testing**: Excel, JSON, and database integration
- **Cross-Browser Testing**: Chrome, Firefox, Edge, Safari support
- **API Testing**: REST API automation integrated
- **Docker Support**: Containerized execution
- **Real-time Monitoring**: Test execution dashboards

## 📁 Project Structure

```
kfic-automation-framework/
├── config/                 # Configuration files
├── data/                   # Test data files
├── keywords/               # Reusable keywords
├── pages/                  # Page objects
├── resources/              # Resource files
├── results/                # Test results and reports
├── scripts/                # Utility scripts
├── tests/                  # Test suites
├── utils/                  # Utility functions
├── docker/                 # Docker configurations
├── .github/                # GitHub Actions workflows
└── requirements.txt        # Python dependencies
```

## 🛠️ Quick Start

1. **Clone Repository**
   ```bash
   git clone <repository-url>
   cd kfic-automation-framework
   ```

2. **Install Dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Run Tests**
   ```bash
   # Single test
   robot tests/los/lead_creation.robot
   
   # Full suite
   robot tests/
   
   # Parallel execution
   pabot --processes 4 tests/
   ```

## 📖 Documentation

- [Framework Setup Guide](docs/setup.md)
- [Writing Tests Guide](docs/writing-tests.md)
- [CI/CD Integration](docs/cicd.md)
- [Best Practices](docs/best-practices.md)

## 🔧 Technology Stack

- **Robot Framework 6.1+**
- **Python 3.9+**
- **Selenium 4.0+**
- **Playwright** (Alternative)
- **Docker**
- **Allure Reporting**
- **Jenkins/GitHub Actions**