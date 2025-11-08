#!/bin/bash

# Build script for Paginatrix package
# Handles code generation, analysis, and testing

set -e

echo "🚀 Starting Paginatrix build process..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "pubspec.yaml not found. Please run this script from the project root."
    exit 1
fi

# Parse command line arguments
CLEAN=false
GENERATE_ONLY=false
WATCH=false
ANALYZE=true
TEST=true
ENVIRONMENT="dev"

while [[ $# -gt 0 ]]; do
    case $1 in
        --clean)
            CLEAN=true
            shift
            ;;
        --generate-only)
            GENERATE_ONLY=true
            ANALYZE=false
            TEST=false
            shift
            ;;
        --watch)
            WATCH=true
            ANALYZE=false
            TEST=false
            shift
            ;;
        --no-analyze)
            ANALYZE=false
            shift
            ;;
        --no-test)
            TEST=false
            shift
            ;;
        --env)
            ENVIRONMENT="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --clean          Clean build artifacts before building"
            echo "  --generate-only  Only run code generation"
            echo "  --watch          Run build runner in watch mode"
            echo "  --no-analyze     Skip static analysis"
            echo "  --no-test        Skip tests"
            echo "  --env ENV        Set environment (dev, prod, test)"
            echo "  --help           Show this help message"
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            exit 1
            ;;
    esac
done

print_status "Environment: $ENVIRONMENT"
print_status "Clean: $CLEAN"
print_status "Generate only: $GENERATE_ONLY"
print_status "Watch mode: $WATCH"
print_status "Analyze: $ANALYZE"
print_status "Test: $TEST"

# Step 1: Clean if requested
if [ "$CLEAN" = true ]; then
    print_status "Cleaning build artifacts..."
    flutter clean
    rm -rf .dart_tool/
    rm -rf build/
    print_success "Clean completed"
fi

# Step 2: Get dependencies
print_status "Getting dependencies..."
flutter pub get
print_success "Dependencies resolved"

# Step 3: Code generation
print_status "Running code generation..."

if [ "$WATCH" = true ]; then
    print_status "Starting build runner in watch mode..."
    flutter packages pub run build_runner watch --delete-conflicting-outputs
else
    print_status "Running build runner..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
    print_success "Code generation completed"
fi

# Exit early if only generating
if [ "$GENERATE_ONLY" = true ] || [ "$WATCH" = true ]; then
    print_success "Build process completed (generate only)"
    exit 0
fi

# Step 4: Format code
print_status "Formatting code..."
flutter format .
print_success "Code formatting completed"

# Step 5: Static analysis
if [ "$ANALYZE" = true ]; then
    print_status "Running static analysis..."
    flutter analyze
    print_success "Static analysis completed"
fi

# Step 6: Run tests
if [ "$TEST" = true ]; then
    print_status "Running tests..."
    flutter test
    print_success "Tests completed"
fi

print_success "🎉 Build process completed successfully!"

# Show summary
echo ""
echo "📊 Build Summary:"
echo "  Environment: $ENVIRONMENT"
echo "  Code generation: ✅"
if [ "$ANALYZE" = true ]; then
    echo "  Static analysis: ✅"
fi
if [ "$TEST" = true ]; then
    echo "  Tests: ✅"
fi
echo ""
echo "🚀 Ready for development!"
