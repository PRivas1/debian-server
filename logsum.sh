#!/bin/bash

SOURCE_DIR=~/BMC3_Server_Pack_v22/logs
DEST_DIR=~/logs
SUMMARY_FILE=$DEST_DIR/player_activity_summary.txt

# make file
mkdir -p $DEST_DIR

# initial file text
echo "Minecraft Server Player Activity Summary" > $SUMMARY_FILE
echo "Generated on $(date)" >> $SUMMARY_FILE
echo "----------------------------------------" >> $SUMMARY_FILE
echo "" >> $SUMMARY_FILE

# process recent log file
if [ -f "$SOURCE_DIR/latest.log" ]; then
    echo "Processing latest.log..."
    cp "$SOURCE_DIR/latest.log" "$DEST_DIR/"
    
    echo "Latest Log ($(date -r "$SOURCE_DIR/latest.log" "+%Y-%m-%d %H:%M:%S")):" >> $SUMMARY_FILE
    grep -E "joined the game|left the game" "$DEST_DIR/latest.log" >> $SUMMARY_FILE
    echo "" >> $SUMMARY_FILE
fi

# process rest of log files
for LOG_FILE in "$SOURCE_DIR"/*.log.gz; do
    if [ -f "$LOG_FILE" ]; then
        FILENAME=$(basename "$LOG_FILE")
        echo "Processing $FILENAME..."
    
        cp "$LOG_FILE" "$DEST_DIR/"
        gunzip -f "$DEST_DIR/$FILENAME"
        UNZIPPED_FILE="$DEST_DIR/${FILENAME%.gz}"

        LOG_DATE=$(echo "$FILENAME" | grep -oE "^[0-9]{4}-[0-9]{2}-[0-9]{2}")
        
        echo "Log from $LOG_DATE:" >> $SUMMARY_FILE
        grep -E "joined the game|left the game" "$UNZIPPED_FILE" >> $SUMMARY_FILE
        echo "" >> $SUMMARY_FILE
    fi
done

echo "Log processing complete. Summary saved to $SUMMARY_FILE"
echo "Original logs in $SOURCE_DIR are unchanged."
echo "Processed logs are available in $DEST_DIR"
