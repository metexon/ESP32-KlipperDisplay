#!/bin/bash

if [ "$EUID" -eq 0 ]; then
    SERVICE_PATH="/etc/systemd/system/cyd-klipper-serial.service"
else
    echo "Please run this script using sudo"
    exit
fi

set -e

chmod a+x ./run.sh

# Install dependencies
/home/mks/klippy-env/bin/pip3 install -r requirements.txt

# Create systemd unit file

echo "[Unit]" > $SERVICE_PATH
echo "Description=CYD Klipper serial server" >> $SERVICE_PATH
echo "After=network.target" >> $SERVICE_PATH
echo "" >> $SERVICE_PATH
echo "[Service]" >> $SERVICE_PATH
echo "ExecStart=$(pwd)/run_openorangestorm.sh" >> $SERVICE_PATH
echo "WorkingDirectory=$(pwd)" >> $SERVICE_PATH
echo "Restart=always" >> $SERVICE_PATH
echo "" >> $SERVICE_PATH
echo "[Install]" >> $SERVICE_PATH
echo "WantedBy=multi-user.target" >> $SERVICE_PATH

# Start the service
if [ "$EUID" -eq 0 ]; then
    systemctl daemon-reload
    systemctl enable cyd-klipper-serial
    systemctl start cyd-klipper-serial
else
    systemctl --user daemon-reload
    systemctl --user enable cyd-klipper-serial
    systemctl --user start cyd-klipper-serial
fi
