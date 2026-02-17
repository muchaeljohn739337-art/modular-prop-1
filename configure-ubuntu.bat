@echo off
REM Configure Ubuntu VPS - Windows Batch Script
REM This will create a setup script on the VPS and run it

echo ================================================
echo Configuring Ubuntu VPS at 76.13.77.8
echo ================================================
echo.
echo You will be prompted for the password: gXF?5ZPRwVNRTv4
echo.

REM Create the setup commands
set SETUP_CMD=apt-get update -qq ^&^& apt-get install -y curl git wget nano ufw docker.io docker-compose-plugin ^&^& curl -fsSL https://get.docker.com ^| sh ^&^& systemctl enable docker ^&^& systemctl start docker ^&^& ufw --force enable ^&^& ufw allow 22/tcp ^&^& ufw allow 80/tcp ^&^& ufw allow 443/tcp ^&^& ufw allow 3000/tcp ^&^& ufw allow 3001/tcp ^&^& mkdir -p /opt/advancia ^&^& docker --version ^&^& docker compose version ^&^& echo Setup complete!

echo Connecting to VPS...
ssh root@76.13.77.8 "%SETUP_CMD%"

echo.
echo ================================================
echo Configuration Complete!
echo ================================================
pause
