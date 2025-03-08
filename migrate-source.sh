#!/bin/bash
# Script to migrate source files from the original Ant structure to Maven structure
# This script uses git mv to maintain file history

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Path settings
SOURCE_DIR="freemind"
TARGET_DIR="freemind-core/src/main/java"
TEST_TARGET_DIR="freemind-core/src/test/java"

# Make sure target directories exist
mkdir -p $TARGET_DIR $TEST_TARGET_DIR

# Source directories to migrate
SOURCE_DIRS=(
    "freemind/main"
    "freemind/common"
    "freemind/controller"
    "freemind/extensions"
    "freemind/modes"
    "freemind/preferences"
    "freemind/swing"
    "freemind/view"
    "de/foltin"
)

# Test source directory
TEST_SOURCE_DIR="freemind/tests/freemind"

# Function to move files with git mv
move_files() {
    local source=$1
    local target=$2
    
    echo -e "${YELLOW}Moving files from ${source} to ${target}...${NC}"
    
    # Create target directory
    mkdir -p $target
    
    # Find all Java files and move them with git mv
    find $source -name "*.java" | while read file; do
        # Create the target directory structure
        rel_path=$(dirname "${file#$SOURCE_DIR/}")
        target_dir="$target/$rel_path"
        mkdir -p "$target_dir"
        
        # Move the file with git mv
        git mv "$file" "$target_dir/"
    done
    
    echo -e "${GREEN}Moved files to $target${NC}"
}

# Move main source files
for dir in "${SOURCE_DIRS[@]}"; do
    # Extract the last part of the path
    target_path="$TARGET_DIR/$(echo $dir | sed 's|/|.|g')"
    
    # Create the directory
    mkdir -p $target_path
    
    # Move files from the directory
    move_files "$dir" "$target_path"
done

# Move test files
echo -e "${YELLOW}Moving test files...${NC}"
mkdir -p $TEST_TARGET_DIR/freemind
move_files "$TEST_SOURCE_DIR" "$TEST_TARGET_DIR/freemind"

echo -e "${GREEN}Source code migration completed!${NC}"
echo -e "${YELLOW}Note: You'll need to adjust package declarations in the source files.${NC}"