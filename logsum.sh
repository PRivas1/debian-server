#!/bin/bash

# Define directories
SOURCE_DIR=~/BMC3_Server_Pack_v22/logs
DEST_DIR=~/logs
SUMMARY_FILE=$DEST_DIR/player_activity_summary.txt

# Create destination directory if it doesn't exist
mkdir -p $DEST_DIR

# Clear previous summary file or create it if it doesn't exist
echo "Minecraft Server Player Activity Summary" > $SUMMARY_FILE
echo "Generated on $(date)" >> $SUMMARY_FILE
echo "----------------------------------------" >> $SUMMARY_FILE
echo "" >> $SUMMARY_FILE

# Process the latest.log file first (already unzipped)
if [ -f "$SOURCE_DIR/latest.log" ]; then
    echo "Processing latest.log..."
    cp "$SOURCE_DIR/latest.log" "$DEST_DIR/"
    
    # Extract join/leave events and append to summary
    echo "Latest Log ($(date -r "$SOURCE_DIR/latest.log" "+%Y-%m-%d %H:%M:%S")):" >> $SUMMARY_FILE
    grep -E "joined the game|left the game" "$DEST_DIR/latest.log" >> $SUMMARY_FILE
    echo "" >> $SUMMARY_FILE
fi

# Process all gzipped log files
for LOG_FILE in "$SOURCE_DIR"/*.log.gz; do
    if [ -f "$LOG_FILE" ]; then
        # Get just the filename
        FILENAME=$(basename "$LOG_FILE")
        echo "Processing $FILENAME..."
        
        # Copy the original gzipped file
        cp "$LOG_FILE" "$DEST_DIR/"
        
        # Unzip the copied file
        gunzip -f "$DEST_DIR/$FILENAME"
        
        # The unzipped file name (without .gz)
        UNZIPPED_FILE="$DEST_DIR/${FILENAME%.gz}"
        
        # Extract the date from the filename for the summary
        LOG_DATE=$(echo "$FILENAME" | grep -oE "^[0-9]{4}-[0-9]{2}-[0-9]{2}")
        
        # Extract join/leave events and append to summary
        echo "Log from $LOG_DATE:" >> $SUMMARY_FILE
        grep -E "joined the game|left the game" "$UNZIPPED_FILE" >> $SUMMARY_FILE
        echo "" >> $SUMMARY_FILE
    fi
done

echo "Log processing complete. Summary saved to $SUMMARY_FILE"
echo "Original logs in $SOURCE_DIR are unchanged."
echo "Processed logs are available in $DEST_DIR"
