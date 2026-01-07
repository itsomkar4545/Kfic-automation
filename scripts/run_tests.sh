#!/bin/bash

# KFIC Automation Framework Test Execution Scripts

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
ENVIRONMENT="dev"
BROWSER="chrome"
PARALLEL_PROCESSES=4
OUTPUT_DIR="results"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to run smoke tests
run_smoke_tests() {
    print_status "Running Smoke Tests..."
    robot --variable ENVIRONMENT:${ENVIRONMENT} \
          --variable BROWSER:${BROWSER} \
          --include smoke \
          --outputdir ${OUTPUT_DIR}/smoke \
          tests/
}

# Function to run full test suite
run_full_suite() {
    print_status "Running Full Test Suite..."
    robot --variable ENVIRONMENT:${ENVIRONMENT} \
          --variable BROWSER:${BROWSER} \
          --outputdir ${OUTPUT_DIR}/full \
          tests/
}

# Function to run parallel tests
run_parallel_tests() {
    print_status "Running Tests in Parallel (${PARALLEL_PROCESSES} processes)..."
    pabot --processes ${PARALLEL_PROCESSES} \
          --variable ENVIRONMENT:${ENVIRONMENT} \
          --variable BROWSER:${BROWSER} \
          --outputdir ${OUTPUT_DIR}/parallel \
          tests/
}

# Function to run API tests only
run_api_tests() {
    print_status "Running API Tests..."
    robot --variable ENVIRONMENT:${ENVIRONMENT} \
          --include api \
          --outputdir ${OUTPUT_DIR}/api \
          tests/api/
}

# Function to run LOS tests only
run_los_tests() {
    print_status "Running LOS Tests..."
    robot --variable ENVIRONMENT:${ENVIRONMENT} \
          --variable BROWSER:${BROWSER} \
          --include los \
          --outputdir ${OUTPUT_DIR}/los \
          tests/los/
}

# Function to run specific test by tag
run_tests_by_tag() {
    local tag=$1
    print_status "Running Tests with tag: ${tag}..."
    robot --variable ENVIRONMENT:${ENVIRONMENT} \
          --variable BROWSER:${BROWSER} \
          --include ${tag} \
          --outputdir ${OUTPUT_DIR}/${tag} \
          tests/
}

# Function to generate reports
generate_reports() {
    print_status "Generating Allure Reports..."
    if [ -d "${OUTPUT_DIR}/allure-results" ]; then
        allure generate ${OUTPUT_DIR}/allure-results -o ${OUTPUT_DIR}/allure-report --clean
        print_status "Allure report generated at: ${OUTPUT_DIR}/allure-report/index.html"
    else
        print_warning "No allure-results directory found"
    fi
}

# Function to clean results
clean_results() {
    print_status "Cleaning previous results..."
    rm -rf ${OUTPUT_DIR}/*
    mkdir -p ${OUTPUT_DIR}
}

# Function to setup environment
setup_environment() {
    print_status "Setting up test environment..."
    pip install -r requirements.txt
    print_status "Dependencies installed successfully"
}

# Main execution logic
case "$1" in
    "smoke")
        run_smoke_tests
        ;;
    "full")
        run_full_suite
        ;;
    "parallel")
        run_parallel_tests
        ;;
    "api")
        run_api_tests
        ;;
    "los")
        run_los_tests
        ;;
    "tag")
        if [ -z "$2" ]; then
            print_error "Please provide a tag name"
            exit 1
        fi
        run_tests_by_tag $2
        ;;
    "reports")
        generate_reports
        ;;
    "clean")
        clean_results
        ;;
    "setup")
        setup_environment
        ;;
    *)
        echo "Usage: $0 {smoke|full|parallel|api|los|tag <tag_name>|reports|clean|setup}"
        echo ""
        echo "Commands:"
        echo "  smoke     - Run smoke tests only"
        echo "  full      - Run complete test suite"
        echo "  parallel  - Run tests in parallel"
        echo "  api       - Run API tests only"
        echo "  los       - Run LOS tests only"
        echo "  tag       - Run tests by specific tag"
        echo "  reports   - Generate Allure reports"
        echo "  clean     - Clean previous results"
        echo "  setup     - Setup test environment"
        echo ""
        echo "Environment variables:"
        echo "  ENVIRONMENT=${ENVIRONMENT}"
        echo "  BROWSER=${BROWSER}"
        echo "  PARALLEL_PROCESSES=${PARALLEL_PROCESSES}"
        exit 1
        ;;
esac