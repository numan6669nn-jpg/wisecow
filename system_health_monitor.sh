#!/usr/bin/env bash

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
PROCESS_THRESHOLD=200

LOG_FILE="system_health.log"

echo "===== System Health Report =====" | tee "$LOG_FILE"
echo "Date: $(date)" | tee -a "$LOG_FILE"
echo

CPU_USAGE=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}' | cut -d. -f1)
echo "CPU Usage: ${CPU_USAGE}%" | tee -a "$LOG_FILE"

if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    echo "ALERT: CPU usage exceeds ${CPU_THRESHOLD}%" | tee -a "$LOG_FILE"
else
    echo "CPU status: OK" | tee -a "$LOG_FILE"
fi

MEMORY_USAGE=$(free | awk '/Mem:/ {printf "%.0f", ($3/$2)*100}')
echo "Memory Usage: ${MEMORY_USAGE}%" | tee -a "$LOG_FILE"

if [ "$MEMORY_USAGE" -gt "$MEMORY_THRESHOLD" ]; then
    echo "ALERT: Memory usage exceeds ${MEMORY_THRESHOLD}%" | tee -a "$LOG_FILE"
else
    echo "Memory status: OK" | tee -a "$LOG_FILE"
fi

DISK_USAGE=$(df / | awk 'NR==2 {gsub("%",""); print $5}')
echo "Disk Usage: ${DISK_USAGE}%" | tee -a "$LOG_FILE"

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "ALERT: Disk usage exceeds ${DISK_THRESHOLD}%" | tee -a "$LOG_FILE"
else
    echo "Disk status: OK" | tee -a "$LOG_FILE"
fi

PROCESS_COUNT=$(ps -e --no-headers | wc -l)
echo "Running Processes: ${PROCESS_COUNT}" | tee -a "$LOG_FILE"

if [ "$PROCESS_COUNT" -gt "$PROCESS_THRESHOLD" ]; then
    echo "ALERT: Running processes exceed ${PROCESS_THRESHOLD}" | tee -a "$LOG_FILE"
else
    echo "Process count status: OK" | tee -a "$LOG_FILE"
fi

echo
echo "===== Health Check Complete =====" | tee -a "$LOG_FILE"
