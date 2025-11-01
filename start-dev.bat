@echo off
REM FlowVault Development Launcher for Windows PowerShell

title FlowVault - Development Environment

echo.
echo ==========================================
echo    FlowVault - AI Context Preservation
echo ==========================================
echo.

REM Check if node_modules exists
if not exist "node_modules" (
    echo Installing dependencies...
    call npm install
    if %errorlevel% neq 0 (
        echo Failed to install dependencies
        pause
        exit /b 1
    )
)

echo.
echo Starting development server...
echo.
echo The application will launch shortly at http://localhost:5173
echo.
echo Press Ctrl+C to stop the development server
echo.

call npm run start:dev

pause
