@echo off
setlocal enabledelayedexpansion

REM Build script for Paginatrix package (Windows)
REM Handles code generation, analysis, and testing

echo 🚀 Starting Paginatrix build process...

REM Parse command line arguments
set CLEAN=false
set GENERATE_ONLY=false
set WATCH=false
set ANALYZE=true
set TEST=true
set ENVIRONMENT=dev

:parse_args
if "%~1"=="" goto :args_done
if "%~1"=="--clean" (
    set CLEAN=true
    shift
    goto :parse_args
)
if "%~1"=="--generate-only" (
    set GENERATE_ONLY=true
    set ANALYZE=false
    set TEST=false
    shift
    goto :parse_args
)
if "%~1"=="--watch" (
    set WATCH=true
    set ANALYZE=false
    set TEST=false
    shift
    goto :parse_args
)
if "%~1"=="--no-analyze" (
    set ANALYZE=false
    shift
    goto :parse_args
)
if "%~1"=="--no-test" (
    set TEST=false
    shift
    goto :parse_args
)
if "%~1"=="--env" (
    set ENVIRONMENT=%~2
    shift
    shift
    goto :parse_args
)
if "%~1"=="--help" (
    echo Usage: %0 [OPTIONS]
    echo.
    echo Options:
    echo   --clean          Clean build artifacts before building
    echo   --generate-only  Only run code generation
    echo   --watch          Run build runner in watch mode
    echo   --no-analyze     Skip static analysis
    echo   --no-test        Skip tests
    echo   --env ENV        Set environment (dev, prod, test)
    echo   --help           Show this help message
    exit /b 0
)
echo [ERROR] Unknown option: %~1
exit /b 1

:args_done

echo [INFO] Environment: %ENVIRONMENT%
echo [INFO] Clean: %CLEAN%
echo [INFO] Generate only: %GENERATE_ONLY%
echo [INFO] Watch mode: %WATCH%
echo [INFO] Analyze: %ANALYZE%
echo [INFO] Test: %TEST%

REM Check if we're in the right directory
if not exist "pubspec.yaml" (
    echo [ERROR] pubspec.yaml not found. Please run this script from the project root.
    exit /b 1
)

REM Step 1: Clean if requested
if "%CLEAN%"=="true" (
    echo [INFO] Cleaning build artifacts...
    flutter clean
    if exist ".dart_tool" rmdir /s /q ".dart_tool"
    if exist "build" rmdir /s /q "build"
    echo [SUCCESS] Clean completed
)

REM Step 2: Get dependencies
echo [INFO] Getting dependencies...
flutter pub get
if errorlevel 1 (
    echo [ERROR] Failed to get dependencies
    exit /b 1
)
echo [SUCCESS] Dependencies resolved

REM Step 3: Code generation
echo [INFO] Running code generation...

if "%WATCH%"=="true" (
    echo [INFO] Starting build runner in watch mode...
    flutter packages pub run build_runner watch --delete-conflicting-outputs
) else (
    echo [INFO] Running build runner...
    flutter packages pub run build_runner build --delete-conflicting-outputs
    if errorlevel 1 (
        echo [ERROR] Code generation failed
        exit /b 1
    )
    echo [SUCCESS] Code generation completed
)

REM Exit early if only generating
if "%GENERATE_ONLY%"=="true" goto :generate_done
if "%WATCH%"=="true" goto :generate_done

REM Step 4: Format code
echo [INFO] Formatting code...
flutter format .
if errorlevel 1 (
    echo [ERROR] Code formatting failed
    exit /b 1
)
echo [SUCCESS] Code formatting completed

REM Step 5: Static analysis
if "%ANALYZE%"=="true" (
    echo [INFO] Running static analysis...
    flutter analyze
    if errorlevel 1 (
        echo [ERROR] Static analysis failed
        exit /b 1
    )
    echo [SUCCESS] Static analysis completed
)

REM Step 6: Run tests
if "%TEST%"=="true" (
    echo [INFO] Running tests...
    flutter test
    if errorlevel 1 (
        echo [ERROR] Tests failed
        exit /b 1
    )
    echo [SUCCESS] Tests completed
)

:generate_done
echo [SUCCESS] 🎉 Build process completed successfully!

REM Show summary
echo.
echo 📊 Build Summary:
echo   Environment: %ENVIRONMENT%
echo   Code generation: ✅
if "%ANALYZE%"=="true" echo   Static analysis: ✅
if "%TEST%"=="true" echo   Tests: ✅
echo.
echo 🚀 Ready for development!

endlocal
