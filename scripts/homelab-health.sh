#!/bin/bash

# Overall health status
# 0 = healthy
# 1 = one or more problems found
STATUS=0

echo "======================================"
echo "        HOMELAB HEALTH CHECK"
echo "======================================"
echo "Date: $(date)"
echo "Host: $(hostname)"
echo

echo "----- DISK USAGE -----"
DISK_USAGE=$(df -P / | awk 'NR==2 {gsub("%","",$5); print $5}')

echo "Root filesystem usage: ${DISK_USAGE}%"

if [ "$DISK_USAGE" -ge 80 ]; then
    echo "WARNING: Disk usage is above 80%"
    STATUS=1
else
    echo "OK: Disk usage is normal"
fi

echo

echo "----- MEMORY -----"
MEMORY_USAGE=$(free | awk '/Mem:/ {printf("%.0f", $3/$2 * 100)}')

echo "Memory usage: ${MEMORY_USAGE}%"

if [ "$MEMORY_USAGE" -ge 80 ]; then
    echo "WARNING: Memory usage is above 80%"
    STATUS=1
else
    echo "OK: Memory usage is normal"
fi

echo

echo "----- TEMPERATURE -----"
sensors

echo

echo "----- FAILED SYSTEMD SERVICES -----"

FAILED_SERVICES=$(systemctl --failed --no-legend | grep -v "homelab-health.service")

if [ -z "$FAILED_SERVICES" ]; then
    echo "OK: No failed services"
else
    echo "WARNING: Failed services found:"
    echo "$FAILED_SERVICES"
    STATUS=1
fi

echo

echo "----- DOCKER CONTAINERS -----"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo

echo "----- DISK SMART HEALTH -----"
SMART_STATUS=$(smartctl -H /dev/sda 2>&1)

if echo "$SMART_STATUS" | grep -q "PASSED"; then
    echo "OK: SMART health passed"
else
    echo "WARNING: SMART health check did not pass"
    echo "$SMART_STATUS"
    STATUS=1
fi

echo

echo "----- NETWORK -----"

if ping -c 1 -W 2 192.168.178.1 > /dev/null 2>&1; then
    echo "OK: Router reachable"
else
    echo "WARNING: Router unreachable"
    STATUS=1
fi

if ping -c 1 -W 2 1.1.1.1 > /dev/null 2>&1; then
    echo "OK: Internet reachable"
else
    echo "WARNING: Internet unreachable"
    STATUS=1
fi

echo
echo "======================================"

if [ "$STATUS" -eq 0 ]; then
    echo "OVERALL STATUS: HEALTHY"
else
    echo "OVERALL STATUS: WARNING"
fi

echo "======================================"

exit "$STATUS"
